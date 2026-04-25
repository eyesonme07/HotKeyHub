#include"../header/database.h"

void Database::init(QString databaseName)
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(path);
    qDebug()<<path;

    sql=QSqlDatabase::addDatabase("QSQLITE");

    sql.setDatabaseName(path+"/"+databaseName+".db");

    if(!sql.open()){
        qDebug()<<sql.lastError().text();
        return;
    }
    createTable();
}
