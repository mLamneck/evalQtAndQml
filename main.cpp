#include <QApplication>
//#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QQuickStyle>
#include <QQmlContext>
#include <QDebug>
#include "filehandler.h"

#include <QFile>
#include <QTextStream>

bool createDepFile = false;
QFile *logFile = nullptr;

void logToFile(const char* _msg)
{
    if (!createDepFile) return;
    logFile->write(_msg);
    logFile->write("\n");
    logFile->flush();
}

int main(int argc, char *argv[])
{
    qDebug() << "check args " << *argv;
    for (auto i = 0; i<argc; i++){
        qDebug() << argv[i];
        if (QString(argv[i]).compare("depTest", Qt::CaseInsensitive) == 0) {
            logFile = new QFile("startupLog.txt");
            if (logFile->open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
                createDepFile = true;
            }

        }
    }

    logToFile("-> create app");
    FileHandler filehandler;
    QApplication app(argc, argv);

    //QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("qtversion", QString(qVersion()));
    engine.rootContext()->setContextProperty("filehandler", &filehandler);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TestVbus", "Main");

    logToFile("run qt eventLoop");
    return app.exec();
}
