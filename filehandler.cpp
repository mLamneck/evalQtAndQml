#include "filehandler.h"

#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QDebug>
//#include <QStringConverter>  // Qt 6/7 Encoding-Support

void FileHandler::saveJsonToFile(const QString &fileUrl, const QString &jsonString)
{
    QString filePath = QUrl(fileUrl).toLocalFile();

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Couldn't open file for writing:" << filePath;
        return;
    }

    QTextStream out(&file);
    out.setEncoding(QStringConverter::Utf8);
    out << jsonString;
    file.close();

    qDebug() << "JSON saved to" << filePath;
}

QString FileHandler::loadJsonFromFile(const QString &fileUrl)
{
    QString filePath = QUrl(fileUrl).toLocalFile();

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Couldn't open file for reading:" << filePath;
        return QString();
    }

    QTextStream in(&file);
    in.setEncoding(QStringConverter::Utf8);
    QString jsonString = in.readAll();
    file.close();

    qDebug() << "JSON loaded from" << filePath;
    return jsonString;
}
