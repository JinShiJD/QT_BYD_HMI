#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QGuiApplication>
#include <QIcon>
#include <QQuickStyle>
#include <QUrl>
#include "Interface/Interface.h"
#include "WeatherService.h"

int main(int argc, char* argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));
    QQuickStyle::setStyle(QStringLiteral("Basic"));
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl entryUrl(QStringLiteral("qrc:/qml/app/Main.qml"));
    const QIcon appIcon(QStringLiteral(":/Images/Home/vehicle.png"));

    QObject::connect(&engine,
                     &QQmlApplicationEngine::objectCreationFailed,
                     &app,
                     [] { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);

    app.setWindowIcon(appIcon);
    WeatherService weatherService;
    /*
    *engine.rootContext() ：获取QML引擎的 根上下文
    *setContextProperty("ui", INTERFACE) ：把C++的单例对象注册到QML上下文，取名叫 "ui"
    *在QML中，可以直接用 ui 这个名字访问C++对象的所有属性和方法
    */
    engine.rootContext()->setContextProperty(QStringLiteral("ui"), INTERFACE);
    engine.rootContext()->setContextProperty(QStringLiteral("weatherService"), &weatherService);
    engine.load(entryUrl);


    return QGuiApplication::exec();
}
