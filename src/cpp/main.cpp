#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include"../../src/header/backendasio.h"
#include"../header/backenddatabase.h"
#include"../header/backend.h"


static QObject* backendAsioProvider(QQmlEngine*, QJSEngine*)
{
    return new BackendAsio();
}
static QObject* backendDatabaseProvider(QQmlEngine*, QJSEngine*)
{
    return new BackendDatabase();
}
static QObject* backendProvider(QQmlEngine*, QJSEngine*)
{
    return new Backend();
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType<BackendAsio>("BackendAsio",1,0,"BackendAsio",backendAsioProvider);
    qmlRegisterSingletonType<BackendDatabase>("BackendDatabase",1,0,"BackendDatabase",backendDatabaseProvider);
    qmlRegisterSingletonType<BackendDatabase>("Backend",1,0,"Backend",backendProvider);

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
