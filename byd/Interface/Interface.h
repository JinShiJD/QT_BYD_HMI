

#ifndef INTERFACE_H
#define INTERFACE_H

#include <QObject>
#include <QString>
#include <QTimer>

#define INTERFACE (Interface::instance())

class Interface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int PAGE_MAIN READ getPAGE_MAIN CONSTANT FINAL)
    Q_PROPERTY(int PAGE_HOME READ getPAGE_HOME CONSTANT FINAL)
    Q_PROPERTY(int PAGE_AC READ getPAGE_AC CONSTANT FINAL)
    Q_PROPERTY(int PAGE_APP READ getPAGE_APP CONSTANT FINAL)
    Q_PROPERTY(int PAGE_SETTINGS READ getPAGE_SETTINGS CONSTANT FINAL)
    Q_PROPERTY(int PAGE_CONTROL READ getPAGE_CONTROL CONSTANT FINAL)
    Q_PROPERTY(int PAGE_MUSIC_FULL READ getPAGE_MUSIC_FULL CONSTANT FINAL)
    Q_PROPERTY(int PAGE_NAVIGATION READ getPAGE_NAVIGATION CONSTANT FINAL)
    Q_PROPERTY(int PAGE_INSTRUMENT READ getPAGE_INSTRUMENT CONSTANT FINAL)
    Q_PROPERTY(int PAGE_CONTACT READ getPAGE_CONTACT CONSTANT FINAL)
    Q_PROPERTY(int PAGE_SPLIT READ getPAGE_SPLIT CONSTANT FINAL)
    Q_PROPERTY(int PAGE_WEATHER READ getPAGE_WEATHER CONSTANT FINAL)

    Q_PROPERTY(int pageIndex READ getPageIndex WRITE setPageIndex NOTIFY pageIndexChanged FINAL)
    Q_PROPERTY(int previousPageIndex READ getPreviousPageIndex WRITE setPreviousPageIndex NOTIFY previousPageIndexChanged FINAL)

    Q_PROPERTY(int acLeftTemperature READ getAcLeftTemperature WRITE setAcLeftTemperature NOTIFY acLeftTemperatureChanged FINAL)
    Q_PROPERTY(int acRightTemperature READ getAcRightTemperature WRITE setAcRightTemperature NOTIFY acRightTemperatureChanged FINAL)
    Q_PROPERTY(int acFanLevel READ getAcFanLevel WRITE setAcFanLevel NOTIFY acFanLevelChanged FINAL)

    Q_PROPERTY(int settingsFunctionValue READ getSettingsFunctionValue WRITE setSettingsFunctionValue NOTIFY settingsFunctionValueChanged FINAL)
    Q_PROPERTY(int settingsLampHeight READ getSettingsLampHeight WRITE setSettingsLampHeight NOTIFY settingsLampHeightChanged FINAL)
    Q_PROPERTY(int settingsSteering READ getSettingsSteering WRITE setSettingsSteering NOTIFY settingsSteeringChanged FINAL)
    Q_PROPERTY(bool settingsParking READ getSettingsParking WRITE setSettingsParking NOTIFY settingsParkingChanged FINAL)
    Q_PROPERTY(int settingsTrafficEnvironment READ getSettingsTrafficEnvironment WRITE setSettingsTrafficEnvironment NOTIFY settingsTrafficEnvironmentChanged FINAL)

    Q_PROPERTY(bool controlCenterWLANStatus READ getControlCenterWLANStatus WRITE setControlCenterWLANStatus NOTIFY controlCenterWLANStatusChanged FINAL)
    Q_PROPERTY(bool controlCenterBluetoothStatus READ getControlCenterBluetoothStatus WRITE setControlCenterBluetoothStatus NOTIFY controlCenterBluetoothStatusChanged FINAL)
    Q_PROPERTY(bool controlCenterPositionStatus READ getControlCenterPositionStatus WRITE setControlCenterPositionStatus NOTIFY controlCenterPositionStatusChanged FINAL)
    Q_PROPERTY(int controlCenterMediaVolume READ getControlCenterMediaVolume WRITE setControlCenterMediaVolume NOTIFY controlCenterMediaVolumeChanged FINAL)

public:
    explicit Interface(QObject* parent = nullptr);
    static Interface* instance();

    static constexpr int kPageMain = 0;
    static constexpr int kPageHome = 1;
    static constexpr int kPageAc = 2;
    static constexpr int kPageApp = 3;
    static constexpr int kPageSettings = 4;
    static constexpr int kPageControl = 5;
    static constexpr int kPageMusicFull = 6;
    static constexpr int kPageNavigation = 7;
    static constexpr int kPageInstrument = 8;
    static constexpr int kPageContact = 9;
    static constexpr int kPageSplit = 10;
    static constexpr int kPageWeather = 11;

    static int getPAGE_MAIN();
    static int getPAGE_HOME();
    static int getPAGE_AC();
    static int getPAGE_APP();
    static int getPAGE_SETTINGS();
    static int getPAGE_CONTROL();
    static int getPAGE_MUSIC_FULL();
    static int getPAGE_NAVIGATION();
    static int getPAGE_INSTRUMENT();
    static int getPAGE_CONTACT();
    static int getPAGE_SPLIT();
    static int getPAGE_WEATHER();

    int getPageIndex() const;
    void setPageIndex(int value);
    int getPreviousPageIndex() const;
    void setPreviousPageIndex(int value);

    int getAcLeftTemperature() const;
    void setAcLeftTemperature(int value);
    int getAcRightTemperature() const;
    void setAcRightTemperature(int value);
    int getAcFanLevel() const;
    void setAcFanLevel(int value);

    int getSettingsFunctionValue() const;
    void setSettingsFunctionValue(int value);
    int getSettingsLampHeight() const;
    void setSettingsLampHeight(int value);
    int getSettingsSteering() const;
    void setSettingsSteering(int value);
    bool getSettingsParking() const;
    void setSettingsParking(bool value);
    int getSettingsTrafficEnvironment() const;
    void setSettingsTrafficEnvironment(int value);

    bool getControlCenterWLANStatus() const;
    void setControlCenterWLANStatus(bool value);
    bool getControlCenterBluetoothStatus() const;
    void setControlCenterBluetoothStatus(bool value);
    bool getControlCenterPositionStatus() const;
    void setControlCenterPositionStatus(bool value);
    int getControlCenterMediaVolume() const;
    void setControlCenterMediaVolume(int value);

signals:
    void pageIndexChanged();
    void previousPageIndexChanged();
    void updateDateTime(QString date, QString time);

    void acLeftTemperatureChanged();
    void acRightTemperatureChanged();
    void acFanLevelChanged();

    void settingsFunctionValueChanged();
    void settingsLampHeightChanged();
    void settingsSteeringChanged();
    void settingsParkingChanged();
    void settingsTrafficEnvironmentChanged();

    void controlCenterWLANStatusChanged();
    void controlCenterBluetoothStatusChanged();
    void controlCenterPositionStatusChanged();
    void controlCenterMediaVolumeChanged();

public slots:
    void slotUpdateTimer();

private:
    QTimer* m_updateTimer = nullptr;

    int m_pageIndex = kPageHome;
    int m_previousPageIndex = kPageHome;

    int m_acLeftTemperature = 26;
    int m_acRightTemperature = 26;
    int m_acFanLevel = 5;

    int m_settingsFunctionValue = 0;
    int m_settingsSteering = 1;
    int m_settingsTrafficEnvironment = 1;
    bool m_settingsParking = true;
    int m_settingsLampHeight = 7;

    bool m_controlCenterWLANStatus = true;
    bool m_controlCenterBluetoothStatus = true;
    bool m_controlCenterPositionStatus = true;
    int m_controlCenterMediaVolume = 7;
};

#endif // INTERFACE_H
