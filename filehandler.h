#ifndef FILEHANDLER_H
#define FILEHANDLER_H

#include <QObject>
#include <QString>

class FileHandler : public QObject
{
    Q_OBJECT
public:
   // explicit FileHandler(QObject *parent = nullptr);

    // Diese Funktion kann direkt aus QML aufgerufen werden
    Q_INVOKABLE void saveJsonToFile(const QString &fileUrl, const QString &jsonString);
    Q_INVOKABLE QString loadJsonFromFile(const QString &fileUrl);
};

#endif // FILEHANDLER_H
