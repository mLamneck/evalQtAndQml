#include <QGuiApplication>
#include <QQmlApplicationEngine>
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
    logFile = new QFile("startupLog.txt");

    if (logFile->open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        createDepFile = true;
    }
    /*
    QStringList args = QCoreApplication::arguments();
    if (args.contains("depTest", Qt::CaseInsensitive)) {
    }
*/

    logToFile("-> create app");
    QGuiApplication app(argc, argv);
    logToFile("<- create app");

    logToFile("-> create engine");
    QQmlApplicationEngine engine;
    logToFile("<- create engine");

    logToFile("-> connect to engine");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    logToFile("<- connect to engine");

    logToFile("-> load url");
    //engine.loadFromModule("ballHunt", "Main");
    engine.load(QUrl("qrc:/ballHunt/Main.qml"));
    logToFile("<- load url");

    logToFile("run qt eventLoop");
    auto res = app.exec();
    logToFile("exit program");
    return res;
}
