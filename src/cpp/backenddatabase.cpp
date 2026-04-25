#include"../header/backenddatabase.h"

BackendDatabase::BackendDatabase()
{
    hotKeyDatabase.init("HotKey");
}

bool BackendDatabase::addHotKey(QString name, QString key)
{
    return hotKeyDatabase.requestData(QVariantList({name,key}));
}

bool BackendDatabase::deleteHotKey(QString name)
{
    return hotKeyDatabase.deleteData(QVariant(name));
}

QVariantMap BackendDatabase::loadData()
{
    return hotKeyDatabase.loadData();
}
