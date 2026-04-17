#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include"../../src/header/backend.h"

static QObject* backendProvider(QQmlEngine*, QJSEngine*)
{
    return new Backend();
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<Backend>("Backend",1,0,"Backend",backendProvider);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("HotKeyHub", "Main");

    return app.exec();
}
