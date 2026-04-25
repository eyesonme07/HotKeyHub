#include"../../src/header/backendasio.h"
#include"../../src/header/client.h"
#include <qvariant.h>

//конструктор
BackendAsio::BackendAsio()
{
    //инициализация клиента
    client = std::make_shared<Client>();
    //если получили со сервера данные о пк
    connect(client.get(), &Client::load_data, this, &BackendAsio::onDataReceived);
}
//когда получили со сервера данные о пк
void BackendAsio::onDataReceived(deviceInfo info)
{
    m_info = info;
    emit dataChanged();
}

//подключение к сервееру по ip
void BackendAsio::connectClient(QString ip)
{
    client->connect(ip);
}
 //отправка json в сервер
void BackendAsio::command(QString comm)
{
    boost::json::object send;
    send["command"] = comm.toStdString();

    client->writeJson(send);
}
//перегрузка если есть значения
void BackendAsio::command(QString comm, double value)
{
    boost::json::object send;
    send["command"] = comm.toStdString();
    send["value"] = value;

    client->writeJson(send);
}
//перегрузка сразу отправка json
void BackendAsio::command(QVariantMap jsonMap)
{
    boost::json::object send;

    for(auto const &[key,value]:jsonMap.toStdMap()){
        send[key.toStdString()] = value.toString().toStdString();
    }

    if(!send.empty()){
        client->writeJson(send);
    }

}

//подключен ли к серверу?
bool BackendAsio::isConnected()
{
    return client->isConnected();
}
//перемещение курсора
void BackendAsio::moveMouse(double x, double y)
{
    if(!isConnected())return;

    boost::json::object sendObject;
    sendObject["command"]="moveMouse";
    sendObject["x"]=x;
    sendObject["y"]=y;

    client->writeJson(sendObject);
}
//скролл
void BackendAsio::scroll(int value)
{
    if(!isConnected())return;

    command("Scroll",value);
}
