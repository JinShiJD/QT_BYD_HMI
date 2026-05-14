

#include "Interface.h"
#include <QDate>
#include <QDateTime>
#include <QStringList>
#include <QTime>
#include <QtGlobal>

Q_GLOBAL_STATIC(Interface, interface)

Interface::Interface(QObject* parent)
    : QObject(parent)
    , m_updateTimer(new QTimer(this))
    , m_pageIndex(kPageHome)
    , m_previousPageIndex(kPageHome)
    , m_acLeftTemperature(26)
    , m_acRightTemperature(26)
    , m_acFanLevel(5)
    , m_settingsFunctionValue(0)
    , m_settingsSteering(1)
    , m_settingsTrafficEnvironment(1)
    , m_settingsParking(true)
    , m_settingsLampHeight(7)
    , m_controlCenterWLANStatus(true)
    , m_controlCenterBluetoothStatus(true)
    , m_controlCenterPositionStatus(true)
    , m_controlCenterMediaVolume(7)
{
    m_updateTimer->start(100);
    connect(m_updateTimer, &QTimer::timeout, this, &Interface::slotUpdateTimer);
}

Interface *Interface::instance()
{
    return interface;
}

int Interface::getControlCenterMediaVolume() const
{
    return m_controlCenterMediaVolume;
}

void Interface::setControlCenterMediaVolume(int value)
{
    if (m_controlCenterMediaVolume == value)
        return;
    m_controlCenterMediaVolume = value;
    emit controlCenterMediaVolumeChanged();
}

bool Interface::getControlCenterPositionStatus() const
{
    return m_controlCenterPositionStatus;
}

void Interface::setControlCenterPositionStatus(bool value)
{
    if (m_controlCenterPositionStatus == value)
        return;
    m_controlCenterPositionStatus = value;
    emit controlCenterPositionStatusChanged();
}

bool Interface::getControlCenterBluetoothStatus() const
{
    return m_controlCenterBluetoothStatus;
}

void Interface::setControlCenterBluetoothStatus(bool value)
{
    if (m_controlCenterBluetoothStatus == value)
        return;
    m_controlCenterBluetoothStatus = value;
    emit controlCenterBluetoothStatusChanged();
}

bool Interface::getControlCenterWLANStatus() const
{
    return m_controlCenterWLANStatus;
}

void Interface::setControlCenterWLANStatus(bool value)
{
    if (m_controlCenterWLANStatus == value)
        return;
    m_controlCenterWLANStatus = value;
    emit controlCenterWLANStatusChanged();
}

int Interface::getSettingsTrafficEnvironment() const
{
    return m_settingsTrafficEnvironment;
}

void Interface::setSettingsTrafficEnvironment(int value)
{
    if (m_settingsTrafficEnvironment == value)
        return;
    m_settingsTrafficEnvironment = value;
    emit settingsTrafficEnvironmentChanged();
}

bool Interface::getSettingsParking() const
{
    return m_settingsParking;
}

void Interface::setSettingsParking(bool value)
{
    if (m_settingsParking == value)
        return;
    m_settingsParking = value;
    emit settingsParkingChanged();
}

int Interface::getSettingsSteering() const
{
    return m_settingsSteering;
}

void Interface::setSettingsSteering(int value)
{
    if (m_settingsSteering == value)
        return;
    m_settingsSteering = value;
    emit settingsSteeringChanged();
}

int Interface::getSettingsLampHeight() const
{
    return m_settingsLampHeight;
}

void Interface::setSettingsLampHeight(int value)
{
    if (m_settingsLampHeight == value)
        return;
    m_settingsLampHeight = value;
    emit settingsLampHeightChanged();
}

int Interface::getSettingsFunctionValue() const
{
    return m_settingsFunctionValue;
}

void Interface::setSettingsFunctionValue(int value)
{
    if (m_settingsFunctionValue == value)
        return;
    m_settingsFunctionValue = value;
    emit settingsFunctionValueChanged();
}


int Interface::getAcFanLevel() const
{
    return m_acFanLevel;
}

void Interface::setAcFanLevel(int value)
{
    if (m_acFanLevel == value)
        return;
    m_acFanLevel = value;
    emit acFanLevelChanged();
}


int Interface::getAcRightTemperature() const
{
    return m_acRightTemperature;
}

void Interface::setAcRightTemperature(int value)
{
    if (m_acRightTemperature == value)
        return;
    m_acRightTemperature = value;
    emit acRightTemperatureChanged();
}

int Interface::getAcLeftTemperature() const
{
    return m_acLeftTemperature;
}

void Interface::setAcLeftTemperature(int value)
{
    if (m_acLeftTemperature == value)
        return;
    m_acLeftTemperature = value;
    emit acLeftTemperatureChanged();
}

void Interface::slotUpdateTimer()
{
    const QDateTime now = QDateTime::currentDateTime();
    const QDate date = now.date();
    const QTime time = now.time();

    static const QStringList weekNames = {
        QStringLiteral(" 星期一"),
        QStringLiteral(" 星期二"),
        QStringLiteral(" 星期三"),
        QStringLiteral(" 星期四"),
        QStringLiteral(" 星期五"),
        QStringLiteral(" 星期六"),
        QStringLiteral(" 星期日")
    };

    const int weekIndex = qBound(1, date.dayOfWeek(), 7) - 1;
    const QString dateText = date.toString(QStringLiteral("M月d日")) + weekNames.at(weekIndex);
    const QString timeText = time.toString(QStringLiteral("HH:mm"));

    emit updateDateTime(dateText, timeText);
}

int Interface::getPreviousPageIndex() const
{
    return m_previousPageIndex;
}

void Interface::setPreviousPageIndex(int value)
{
    if (m_previousPageIndex == value)
        return;
    m_previousPageIndex = value;
    emit previousPageIndexChanged();
}

int Interface::getPageIndex() const
{
    return m_pageIndex;
}

void Interface::setPageIndex(int value)
{
    if (m_previousPageIndex != m_pageIndex) {
        m_previousPageIndex = m_pageIndex;
    }

    if (m_pageIndex == value)
        return;
    m_pageIndex = value;
    emit pageIndexChanged();
}

int Interface::getPAGE_MAIN()
{
    return kPageMain;
}

int Interface::getPAGE_HOME()
{
    return kPageHome;
}

int Interface::getPAGE_AC()
{
    return kPageAc;
}

int Interface::getPAGE_APP()
{
    return kPageApp;
}

int Interface::getPAGE_SETTINGS()
{
    return kPageSettings;
}

int Interface::getPAGE_CONTROL()
{
    return kPageControl;
}

int Interface::getPAGE_MUSIC_FULL()
{
    return kPageMusicFull;
}

int Interface::getPAGE_NAVIGATION()
{
    return kPageNavigation;
}

int Interface::getPAGE_INSTRUMENT()
{
    return kPageInstrument;
}

int Interface::getPAGE_CONTACT()
{
    return kPageContact;
}

int Interface::getPAGE_SPLIT()
{
    return kPageSplit;
}

int Interface::getPAGE_WEATHER()
{
    return kPageWeather;
}

