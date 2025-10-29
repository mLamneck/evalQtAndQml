#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    qDebug() << "enter main";
    QGuiApplication app(argc, argv);
    qDebug() << "app created";

    qDebug() << "-> create qml engine";
    QQmlApplicationEngine engine;
    qDebug() << "<- create qml engine";

    qDebug() << "-> connect";
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    qDebug() << "<- connect";

    qDebug() << "-> load qml module";
    //engine.loadFromModule("ballHunt", "Main");
    engine.load(QUrl("qrc:/ballHunt/Main.qml"));
    qDebug() << "<- load qml module";

    qDebug().noquote() << "run qt eventLoop";
    return app.exec();
}
