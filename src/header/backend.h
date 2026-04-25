#ifndef BACKEND_H
#define BACKEND_H

#include<QObject>
#include<QRegularExpression>

//тут будут все основные функции
class Backend : public QObject{
    Q_OBJECT
public:
    Backend()=default;

    Q_INVOKABLE QStringList splitKey(QString key);
};

#endif // BACKEND_H
