#include<boost/json/src.hpp>
#include<QTimer>
#include"../../src/header/client.h"

//конструктор
//тут просто инициализируем переменные и вызоваем подключение
Client::Client():
    socket_(std::make_shared<boost::asio::ip::tcp::socket>(io_)),stopped_(false),isConnect_(false)
{};

//деструктор
Client::~Client()
{
    disconnect();
}

//подключение к серверу
void Client::connectServer(boost::asio::ip::tcp::resolver::results_type endpoints)
{
    qDebug()<<"ПОДКЛЮЧЕНИЕ!";

    stopped_.store(false);

    boost::asio::async_connect(*socket_, endpoints,
    [this, endpoints](const boost::system::error_code& ec, const boost::asio::ip::tcp::endpoint&) {
        if (stopped_.load()) return;

        if (!ec) {
            do_read_header();
        }
        else {
            qDebug() << "Connect failed:" << ec.message();
            isConnect_.store(false);

            //Небольшая задержка перед переподключением
            if (!stopped_.load()) {
                auto timer = std::make_shared<boost::asio::steady_timer>(io_);
                timer->expires_after(std::chrono::seconds(2));
                timer->async_wait([this, endpoints, timer](const boost::system::error_code&) {
                    if (!stopped_.load())
                        connectServer(endpoints);
                });
            }
        }
    });
}

void Client::do_read_header()
{
    //получаем указатель на себя
    auto self = shared_from_this();

    //читаем первые 4 байта, в которых будет размер данных
    boost::asio::async_read(*socket_, boost::asio::buffer(buffer_head_, 4),
    [this,self](const boost::system::error_code& error, const std::size_t bytes){
        //если ошибка
        if (error) {
            qDebug() << "Error reading header (error - " << error.what() << " )" << '\n';
            return;
        }

        //получаем размер данных, который нам нужно прочитать
        uint32_t net_length{};
        std::memcpy(&net_length, buffer_head_, 4);
        uint32_t length = ntohl(net_length);

        //меняем размер вектора под размер полученных данных
        buffer_data_.resize(length);
        //читаем уже готовый ответ

        do_read_body(length);
    });
}

void Client::do_read_body(std::size_t length)
{
    //получаем указатель на себя
    auto self = shared_from_this();

    //читаем данные в буфер
    boost::asio::async_read(*socket_, boost::asio::buffer(buffer_data_.data(), length),
    [this,self](const boost::system::error_code& error, const std::size_t bytes){
        if (error) {
            qDebug() << "Error reading body (error - " << error.what() << " )" << '\n';
            return;
        }
        //получаем строку из буфера
        std::string json_str(buffer_data_.begin(), buffer_data_.end());
        //парсим строку в json
        boost::json::value json_value = boost::json::parse(json_str);
        //обрабатываем json
        jsonParse(json_value);
        //начинаем читать заново
        do_read_header();
    });
}
//парсим json документ
void Client::jsonParse(const boost::json::value &value)
{
    //если ото объект
    if(value.is_object()){
        const boost::json::object &object=value.as_object();
        /////////////////////////////////////////////////////////////////////////////////////
        //если статус ОКЕЙ тогда isConnected=true
        if(object.contains("status")){
            std::string command = object.at("status").as_string().c_str();
            if(command == "connected"){
                isConnect_.store(true);
            }
            return;
        }
        //создаем ообъект deviceInfo где храним текущие данные пк
        deviceInfo devInfo{};
        ////////////////////////////////////////////////////////////////////////////////////
        if(object.contains("mediaInfo")){
            boost::json::object mInfo = object.at("mediaInfo").as_object();

            //С КАКОЙ ПРОГРАММЫ ИГРАЕТ (например chrome.exe)
            if(mInfo.contains("Programm")){
                devInfo.programm = mInfo.at("Programm").as_string().c_str();
            }
            //НАЗВАНИЕ МУЗЫКИ
            if(mInfo.contains("Name")){
                devInfo.currMusicName = mInfo.at("Name").as_string().c_str();
            }
            //АРТИСТ
            if(mInfo.contains("Artist")){
                devInfo.currMusicArtist = mInfo.at("Artist").as_string().c_str();
            }
            //ИГРАЕТ ЛИ ПЕСНЯ
            if(mInfo.contains("Status")){
                std::string status = mInfo.at("Status").as_string().c_str();

                if(status=="Playing"){
                    devInfo.isPlayMusic=true;
                }
                else{
                    devInfo.isPlayMusic=false;
                }
            }
        }
        /////////////////////////////////////////////////////////////////////////////////////
        //УРОВЕНБ ГРОМКОСТИ
        if(object.contains("volume")){
            devInfo.currentVolume=object.at("volume").as_double();
        }
        ////////////////////////////////////////////////////////////////////////////////////
        //НАЗВАНИЕ ПК
        if(object.contains("pcName")){
            devInfo.pcName=object.at("pcName").as_string().c_str();
        }

        //отправляем в QML
        emit load_data(devInfo);
    }
}

//отправка JSON в сервер
void Client::writeJson(const boost::json::value &val)
{
    //получаем в виде строки
    std::string body = boost::json::serialize(val);

    //получаем длину строки
    uint32_t length = static_cast<uint64_t>(body.size());
    uint32_t net_length=htonl(length);

    //создаем буфер
    auto buffer = std::make_shared<std::vector<char>>();
    buffer->reserve(sizeof(net_length)+body.size());

    //собирам свя для отправки
    const char* len_ptr = reinterpret_cast<const char*>(&net_length);
    buffer->insert(buffer->end(), len_ptr, len_ptr + sizeof(net_length));
    buffer->insert(buffer->end(), body.begin(), body.end());

    //отправляем
    boost::asio::async_write(*socket_,boost::asio::buffer(*buffer),[](const boost::system::error_code &error,const std::size_t &bytes){
        if(error)
        {
            qDebug()<<"Error "<<error.what();
        }
    });
}

//очищаем старый сокет а потом снова подключаемся
void Client::connect(QString ip)
{
    //очищаем
    disconnect();

    //создаем новый сокет
    socket_ = std::make_shared<boost::asio::ip::tcp::socket>(io_);

    boost::asio::ip::tcp::resolver resolver(io_);

    auto endpoints = resolver.resolve(ip.toStdString(),"5284");

    //подключаемся
    connectServer(endpoints);

    if(ioThread_.joinable()){
        ioThread_.join();
    }

    auto self = shared_from_this();

    //запускаем в отдельном потоке
    ioThread_=std::thread([this](){
        io_.restart();
        io_.run();
    });
}

//отключаем сокет
void Client::disconnect()
{
    //стоп и отключен
    stopped_.store(true);
    isConnect_.store(false);

    if (reconnectTimer_)
        reconnectTimer_->cancel();

    //очистка сокета
    if (socket_ && socket_->is_open())
    {
        boost::system::error_code ec;
        socket_->cancel(ec);
        socket_->shutdown(boost::asio::ip::tcp::socket::shutdown_both, ec);
        socket_->close(ec);
    }

    //остановка ядра boost
    io_.stop();

    if (ioThread_.joinable())
        ioThread_.join();

    socket_.reset();
}
