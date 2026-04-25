#ifndef HOTKEYDATABASE_H
#define HOTKEYDATABASE_H

#include"database.h"

class HotKeyDatabase : public Database{
public:
    HotKeyDatabase() = default;

    void createTable() override;

    bool requestData(const QVariantList &data)const override;
    bool deleteData(const QVariant &data)const override;
    QVariantMap loadData()const;
private:
    QSqlQuery *query;
};

#endif // HOTKEYDATABASE_H
