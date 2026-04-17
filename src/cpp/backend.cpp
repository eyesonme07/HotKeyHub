#include"../../src/header/backend.h"
#include"../../src/header/client.h"
#include <qvariant.h>

//конструктор
Backend::Backend()
{
    //инициализация клиента
    client = std::make_shared<Client>();
    //если получили со сервера данные о пк
    connect(client.get(), &Client::load_data, this, &Backend::onDataReceived);
}
//когда получили со сервера данные о пк
void Backend::onDataReceived(deviceInfo info)
{
    m_info = info;
    emit dataChanged();
}

//подключение к сервееру по ip
void Backend::connectClient(QString ip)
{
    client->connect(ip);
}
 //отправка json в сервер
void Backend::command(QString comm)
{
    boost::json::object send;
    send["command"] = comm.toStdString();

    client->writeJson(send);
}
//перегрузка если есть значения
void Backend::command(QString comm, double value)
{
    boost::json::object send;
    send["command"] = comm.toStdString();
    send["value"] = value;

    client->writeJson(send);
}
//подключен ли к серверу?
bool Backend::isConnected()
{
    return client->isConnected();
}
//перемещение курсора
void Backend::moveMouse(double x, double y)
{
    if(!isConnected())return;

    boost::json::object sendObject;
    sendObject["command"]="moveMouse";
    sendObject["x"]=x;
    sendObject["y"]=y;

    client->writeJson(sendObject);
}
//скролл
void Backend::scroll(int value)
{
    if(!isConnected())return;

    command("Scroll",value);
}
