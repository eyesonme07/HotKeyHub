#ifndef BACKENDASIO_H
#define BACKENDASIO_H

#include "src/header/client.h"
#include<QObject>
#include <qvariant.h>



//класс переходник с QML и Client
class BackendAsio : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap deviceData READ deviceData NOTIFY dataChanged)

public:
    BackendAsio();

    //переобразование deviceInfo в QVariantMap
    QVariantMap deviceData() const {
        return {
            {"pcName",          m_info.pcName},
            {"currentVolume",   m_info.currentVolume},
            {"currMusicName",   m_info.currMusicName},
            {"currMusicArtist", m_info.currMusicArtist},
            {"isPlayMusic",     m_info.isPlayMusic}
        };
    }
    //подключение к сервееру по ip
    Q_INVOKABLE void connectClient(QString ip);
    //отправка json в сервер
    Q_INVOKABLE void command(QString comm);
    //перегрузка если есть значения
    Q_INVOKABLE void command(QString comm, double value);
    //перегрузка сразу отправка json
    Q_INVOKABLE void command(QVariantMap jsonMap);
    //подключен ли к серверу?
    Q_INVOKABLE bool isConnected();
    //перемещение курсора
    Q_INVOKABLE void moveMouse(double x,double y);
    //скролл
    Q_INVOKABLE void scroll(int value);
public slots:
    void onDataReceived(deviceInfo info);

signals:
    void dataChanged();

private:
    std::shared_ptr<Client> client;
    deviceInfo m_info;
};

#endif // BACKENDASIO_H
