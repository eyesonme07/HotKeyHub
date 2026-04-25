#ifndef BACKENDDATABASE_H
#define BACKENDDATABASE_H

#include"HotKeyDatabase.h"
#include<QString>
#include<QObject>

class BackendDatabase : public QObject{
    Q_OBJECT
public:
    BackendDatabase();

    Q_INVOKABLE bool addHotKey(QString name,QString key);
    Q_INVOKABLE bool deleteHotKey(QString name);
    Q_INVOKABLE QVariantMap loadData();

private:
    HotKeyDatabase hotKeyDatabase;
};

#endif // BACKENDDATABASE_H
