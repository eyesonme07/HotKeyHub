#include"../header/HotKeyDatabase.h"

void HotKeyDatabase::createTable(){
    query=new QSqlQuery(sql);

    if(!query->exec(R"(
        CREATE TABLE IF NOT EXISTS "HotKey" (
            "Id"	INTEGER NOT NULL UNIQUE,
            "Name"	TEXT UNIQUE,
            "Key"	TEXT,
            PRIMARY KEY("Id" AUTOINCREMENT)
        );
    )")){
        sql.close();
    }
}

bool HotKeyDatabase::requestData(const QVariantList &data) const
{
    if(!sql.isOpen() || data.size() < 2){return false;}

    return query->exec(QString("INSERT INTO HotKey (Name,Key) VALUES ('%1','%2')").arg(data[0].toString()).arg(data[1].toString()));
}

bool HotKeyDatabase::deleteData(const QVariant &data) const
{
    return query->exec(QString("DELETE FROM HotKey WHERE Name = '%1'").arg(data.toString()));
}

 QVariantMap HotKeyDatabase::loadData() const
{
    QVariantMap result;
    query->exec("SELECT Name,Key FROM HotKey");

    while(query->next()){
        result.insert(query->value(0).toString(),query->value(1).toString());
    }

    return result;
}
