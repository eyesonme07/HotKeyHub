#ifndef CLIENT
#define CLIENT

#include<boost/json.hpp>
#include<boost/asio.hpp>
#include<thread>
#include<QDebug>
#include<QObject>

struct deviceInfo
{
    QString pcName="";
    float currentVolume=0.0;
    QString  currMusicArtist="";
    QString programm="";
    QString currMusicName="";
    bool isPlayMusic=false;
};

//основной класс для работы с сетью
class Client :public QObject, public std::enable_shared_from_this<Client>{
    Q_OBJECT
public:
    Client();
    ~Client();
    //отправка в сервер
    void writeJson(const boost::json::value &val);
    //очищаем старый сокет а потом снова подключаемся
    void connect(QString ip);
    //отключаем сокет
    void disconnect();
    //подключен ли?
    bool isConnected()const{return isConnect_.load();}
signals:
    void load_data(deviceInfo info);
private:
    //подключение к серверу
    void connectServer(boost::asio::ip::tcp::resolver::results_type endpoints);
    //тут читаем сколько данных пришло(размер)
    void do_read_header();
    //а тут уже читаем полностью
    void do_read_body(std::size_t length);
    //парсим json документ
    void jsonParse(const boost::json::value &value);

    boost::asio::io_context io_;
    std::shared_ptr<boost::asio::ip::tcp::socket> socket_;
    std::thread ioThread_;

    std::unique_ptr<boost::asio::steady_timer> reconnectTimer_;

    std::atomic<bool> isConnect_{false};
    std::atomic<bool> stopped_{false};

    char buffer_head_[4]{};
    std::vector<char> buffer_data_{};
};

#endif //CLIENT
