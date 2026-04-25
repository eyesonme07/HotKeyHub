#ifndef DATABASE_H
#define DATABASE_H

#include<QSqlDatabase>
#include<QSqlQuery>
#include<QSqlError>
#include<QObject>
#include<QDir>
#include<QStandardPaths>

class Database{
public:
    Database() = default;
    virtual ~Database() = default;

    virtual void init(QString databaseName);

    virtual bool requestData(const QVariantList &) const = 0;
    virtual bool deleteData(const QVariant &) const = 0;
protected:
    QSqlDatabase sql;

private:
    virtual void createTable() = 0;
};

#endif // DATABASE_H
