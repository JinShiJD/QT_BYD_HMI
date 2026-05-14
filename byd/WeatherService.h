#pragma once

#include <QObject>
#include <QVariantList>

class QNetworkAccessManager;
class QNetworkReply;

class WeatherService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString locationName READ locationName NOTIFY locationNameChanged)
    Q_PROPERTY(QString errorText READ errorText NOTIFY errorTextChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(int currentTemp READ currentTemp NOTIFY currentTempChanged)
    Q_PROPERTY(int currentHumidity READ currentHumidity NOTIFY currentHumidityChanged)
    Q_PROPERTY(int currentWind READ currentWind NOTIFY currentWindChanged)
    Q_PROPERTY(QString currentCode READ currentCode NOTIFY currentCodeChanged)
    Q_PROPERTY(int todayMax READ todayMax NOTIFY todayMaxChanged)
    Q_PROPERTY(int todayMin READ todayMin NOTIFY todayMinChanged)
    Q_PROPERTY(QString updatedText READ updatedText NOTIFY updatedTextChanged)
    Q_PROPERTY(QVariantList dailyDates READ dailyDates NOTIFY dailyDatesChanged)
    Q_PROPERTY(QVariantList dailyMinTemps READ dailyMinTemps NOTIFY dailyMinTempsChanged)
    Q_PROPERTY(QVariantList dailyMaxTemps READ dailyMaxTemps NOTIFY dailyMaxTempsChanged)
    Q_PROPERTY(QVariantList dailyCodes READ dailyCodes NOTIFY dailyCodesChanged)

public:
    explicit WeatherService(QObject *parent = nullptr);

    Q_INVOKABLE void requestWeather(const QString &city);

    QString locationName() const;
    QString errorText() const;
    bool loading() const;
    int currentTemp() const;
    int currentHumidity() const;
    int currentWind() const;
    QString currentCode() const;
    int todayMax() const;
    int todayMin() const;
    QString updatedText() const;
    QVariantList dailyDates() const;
    QVariantList dailyMinTemps() const;
    QVariantList dailyMaxTemps() const;
    QVariantList dailyCodes() const;

signals:
    void locationNameChanged();
    void errorTextChanged();
    void loadingChanged();
    void currentTempChanged();
    void currentHumidityChanged();
    void currentWindChanged();
    void currentCodeChanged();
    void todayMaxChanged();
    void todayMinChanged();
    void updatedTextChanged();
    void dailyDatesChanged();
    void dailyMinTempsChanged();
    void dailyMaxTempsChanged();
    void dailyCodesChanged();

private:
    void handleReply(QNetworkReply *reply);
    void setLocationName(const QString &name);
    void setErrorText(const QString &text);
    void setLoading(bool value);
    void setCurrentTemp(int value);
    void setCurrentHumidity(int value);
    void setCurrentWind(int value);
    void setCurrentCode(const QString &value);
    void setTodayMax(int value);
    void setTodayMin(int value);
    void setUpdatedText(const QString &text);
    void setDailyDates(const QVariantList &value);
    void setDailyMinTemps(const QVariantList &value);
    void setDailyMaxTemps(const QVariantList &value);
    void setDailyCodes(const QVariantList &value);

    QNetworkAccessManager *m_manager;
    QString m_locationName;
    QString m_errorText;
    bool m_loading;
    int m_currentTemp;
    int m_currentHumidity;
    int m_currentWind;
    QString m_currentCode;
    int m_todayMax;
    int m_todayMin;
    QString m_updatedText;
    QVariantList m_dailyDates;
    QVariantList m_dailyMinTemps;
    QVariantList m_dailyMaxTemps;
    QVariantList m_dailyCodes;
};
