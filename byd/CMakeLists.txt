cmake_minimum_required(VERSION 3.16)

project(BYD VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Svg Network)

set(CMAKE_AUTORCC ON)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appBYD
    main.cpp
    WeatherService.cpp
)

qt_add_qml_module(appBYD
    URI BYD
    VERSION 1.0

    QML_FILES
        qml/app/Main.qml
        qml/screens/home/Home.qml
        qml/screens/home/parts/HomeHeader.qml
        qml/screens/home/parts/HomeMapCard.qml
        qml/screens/home/parts/HomeMusicCard.qml
        qml/screens/home/parts/HomeVehicleCard.qml
        qml/screens/home/parts/HomeRadioCard.qml
        qml/screens/home/parts/HomeAppButton.qml
        qml/screens/home/parts/HomePlaceholderPopup.qml
        qml/screens/home/parts/HomeToast.qml
        qml/screens/ac/AC.qml
        qml/screens/app/App.qml
        qml/screens/contact/Contact.qml
        qml/screens/control/ControlCenter.qml
        qml/screens/split/Split.qml
        qml/screens/weather/Weather.qml
        qml/screens/settings/Settings.qml
        qml/screens/navigation/Navigation.qml
        qml/screens/instrument/Instrument.qml
        qml/screens/music/MusicFull.qml
        qml/shared/Theme.qml
        qml/modules/cluster/ClusterDemo.qml
        qml/modules/cluster/SpeedDial.qml
        qml/modules/cluster/RpmDial.qml
        qml/modules/cluster/FuelMeter.qml
        qml/components/ac/ACBar.qml
        qml/components/ac/ACFan.qml
        qml/components/ac/ACFunctionBar.qml
        qml/components/base/ColorSlider.qml
        qml/components/base/IconButton.qml
        qml/components/base/IconSwitch.qml
        qml/components/navigation/Navigation.qml
        qml/components/base/QuickSlider.qml
        qml/components/base/QuickTemperatureList.qml
        qml/components/base/StatusBar.qml
        qml/components/base/SwipeArea.qml
        qml/components/settings/SettingsFunctionBar.qml
        qml/components/settings/SettingsModeBar.qml
        qml/components/settings/SettingsList.qml
        qml/components/base/QuickWind.qml
        qml/components/function/FunctionBar2.qml
        qml/components/function/FunctionBar3.qml

    RESOURCES
        resources.qrc

    SOURCES
        Interface/Interface.cpp
        Interface/Interface.h
)

target_link_libraries(appBYD PRIVATE Qt6::Network)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appBYD PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appBYD
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appBYD
    PRIVATE Qt6::Quick Qt6::Svg
)

include(GNUInstallDirs)
install(TARGETS appBYD
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
