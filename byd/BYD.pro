QT += qml quick quickcontrols2 svg network
CONFIG += c++17

TEMPLATE = app
TARGET = appBYD

SOURCES += \
    main.cpp \
    Interface/Interface.cpp \
    WeatherService.cpp

HEADERS += \
    Interface/Interface.h \
    WeatherService.h

RESOURCES += \
    resources.qrc

QML_FILES += \
    qml/app/Main.qml \
    qml/screens/home/Home.qml \
    qml/screens/home/parts/HomeHeader.qml \
    qml/screens/home/parts/HomeMapCard.qml \
    qml/screens/home/parts/HomeMusicCard.qml \
    qml/screens/home/parts/HomeVehicleCard.qml \
    qml/screens/home/parts/HomeRadioCard.qml \
    qml/screens/home/parts/HomeAppButton.qml \
    qml/screens/home/parts/HomePlaceholderPopup.qml \
    qml/screens/home/parts/HomeToast.qml \
    qml/screens/ac/AC.qml \
    qml/screens/app/App.qml \
    qml/screens/contact/Contact.qml \
    qml/screens/control/ControlCenter.qml \
    qml/screens/split/Split.qml \
    qml/screens/weather/Weather.qml \
    qml/screens/settings/Settings.qml \
    qml/screens/navigation/Navigation.qml \
    qml/screens/instrument/Instrument.qml \
    qml/screens/music/MusicFull.qml \
    qml/shared/Theme.qml \
    qml/modules/cluster/ClusterDemo.qml \
    qml/modules/cluster/SpeedDial.qml \
    qml/modules/cluster/RpmDial.qml \
    qml/modules/cluster/FuelMeter.qml \
    qml/components/ac/ACBar.qml \
    qml/components/ac/ACFan.qml \
    qml/components/ac/ACFunctionBar.qml \
    qml/components/base/ColorSlider.qml \
    qml/components/base/IconButton.qml \
    qml/components/base/IconSwitch.qml \
    qml/components/navigation/Navigation.qml \
    qml/components/base/QuickSlider.qml \
    qml/components/base/QuickTemperatureList.qml \
    qml/components/base/StatusBar.qml \
    qml/components/base/SwipeArea.qml \
    qml/components/settings/SettingsFunctionBar.qml \
    qml/components/settings/SettingsModeBar.qml \
    qml/components/settings/SettingsList.qml \
    qml/components/base/QuickWind.qml \
    qml/components/function/FunctionBar2.qml \
    qml/components/function/FunctionBar3.qml
