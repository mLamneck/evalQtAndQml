#include <QApplication>
//#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QQuickStyle>
#include <QQmlContext>
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

    QStringList args = QCoreApplication::arguments();
    if (args.contains("depTest", Qt::CaseInsensitive)) {
        logFile = new QFile("startupLog.txt");
        if (logFile->open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
            createDepFile = true;
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
