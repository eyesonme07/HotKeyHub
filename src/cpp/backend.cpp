#include"../header/backend.h"
#include <qregularexpression.h>

//разбиваем строку в нажатия кнопок (ctrl + M в{ctrl,M})
QStringList Backend::splitKey(QString key)
{
    if(key.isEmpty())return QStringList();

    key.remove(QRegularExpression("[^\\wа-яА-ЯёЁ+]"));
    QStringList result;
    result = key.split("+",Qt::SkipEmptyParts);

    return result;
}
