#include "WeatherService.h"

#include <QCoreApplication>
#include <QDate>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QRegularExpression>
#include <QUrl>
#include <limits>
#include <map>

namespace {
class WeatherTool
{
public:
    WeatherTool()
    {
        QString fileName = QCoreApplication::applicationDirPath();
        fileName += "/citycode-2019-08-23.json";
        QFile file(fileName);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            file.setFileName(":/citycode-2019-08-23.json");
            if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
                return;
            }
        }
        QByteArray json = file.readAll();
        file.close();
        QJsonParseError err;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(json, &err);
        if (err.error != QJsonParseError::NoError || !jsonDoc.isArray()) {
            return;
        }
        QJsonArray citys = jsonDoc.array();
        for (int i = 0; i < citys.size(); i++) {
            QJsonObject obj = citys.at(i).toObject();
            QString code = obj.value("city_code").toString();
            QString city = obj.value("city_name").toString();
            if (!code.isEmpty()) {
                m_mapCity2Code.insert(std::pair<QString, QString>(city, code));
            }
        }
    }

    QString operator[](const QString &city)
    {
        std::map<QString, QString>::iterator it = m_mapCity2Code.find(city);
        if (it == m_mapCity2Code.end()) {
            it = m_mapCity2Code.find(city + u8"市");
        }
        if (it != m_mapCity2Code.end()) {
            return it->second;
        }
        return "000000000";
    }

private:
    std::map<QString, QString> m_mapCity2Code;
};

int parseIntFromText(const QString &text)
{
    if (text.isEmpty()) {
        return std::numeric_limits<int>::min();
    }
    static const QRegularExpression re("-?\\d+");
    QRegularExpressionMatch match = re.match(text);
    if (!match.hasMatch()) {
        return std::numeric_limits<int>::min();
    }
    bool ok = false;
    int value = match.captured(0).toInt(&ok);
    return ok ? value : std::numeric_limits<int>::min();
}

int parseHumidity(const QString &text)
{
    QString cleaned = text;
    cleaned.replace("%", "");
    bool ok = false;
    int value = cleaned.toInt(&ok);
    return ok ? value : std::numeric_limits<int>::min();
}

WeatherTool &weatherTool()
{
    static WeatherTool tool;
    return tool;
}
}

WeatherService::WeatherService(QObject *parent)
    : QObject(parent)
    , m_manager(new QNetworkAccessManager(this))
    , m_locationName(QStringLiteral("长沙"))
    , m_loading(false)
    , m_currentTemp(std::numeric_limits<int>::min())
    , m_currentHumidity(0)
    , m_currentWind(0)
    , m_todayMax(0)
    , m_todayMin(0)
{
}

void WeatherService::requestWeather(const QString &city)
{
    QString targetCity = city.trimmed();
    if (targetCity.isEmpty()) {
        targetCity = m_locationName;
    }
    setLocationName(targetCity);
    setErrorText(QString());
    setLoading(true);

    QString citycode = weatherTool()[targetCity];
    if (citycode == "000000000") {
        setLoading(false);
        setErrorText(QStringLiteral("天气：指定城市不存在！"));
        return;
    }
    QUrl url(QStringLiteral("http://t.weather.itboy.net/api/weather/city/") + citycode);
    QNetworkRequest request(url);
    QNetworkReply *reply = m_manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() { handleReply(reply); });
}

void WeatherService::handleReply(QNetworkReply *reply)
{
    QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if (reply->error() != QNetworkReply::NoError || statusCode.toInt() != 200) {
        reply->deleteLater();
        setLoading(false);
        setErrorText(QStringLiteral("天气：请求数据错误，检查网络连接！"));
        return;
    }

    QByteArray bytes = reply->readAll();
    reply->deleteLater();

    QJsonParseError err;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(bytes, &err);
    if (err.error != QJsonParseError::NoError || !jsonDoc.isObject()) {
        setLoading(false);
        setErrorText(QStringLiteral("天气数据解析失败"));
        return;
    }

    QJsonObject jsObj = jsonDoc.object();
    QString message = jsObj.value("message").toString();
    if (!message.contains("success")) {
        setLoading(false);
        setErrorText(QStringLiteral("天气：城市错误！"));
        return;
    }

    QString dateStr = jsObj.value("date").toString();
    if (!dateStr.isEmpty()) {
        setUpdatedText(QDate::fromString(dateStr, "yyyyMMdd").toString("yyyy-MM-dd"));
    } else {
        setUpdatedText(QString());
    }
    QJsonObject cityInfo = jsObj.value("cityInfo").toObject();
    QString cityName = cityInfo.value("city").toString();
    if (!cityName.isEmpty()) {
        setLocationName(cityName);
    }

    QJsonObject dataObj = jsObj.value("data").toObject();
    int tempValue = parseIntFromText(dataObj.value("wendu").toString());
    setCurrentTemp(tempValue);
    int humidity = parseHumidity(dataObj.value("shidu").toString());
    if (humidity != std::numeric_limits<int>::min()) {
        setCurrentHumidity(humidity);
    }

    QJsonArray forecastArr = dataObj.value("forecast").toArray();
    QJsonObject todayObj = forecastArr.size() > 0 ? forecastArr.at(0).toObject() : QJsonObject();
    int windLevel = parseIntFromText(todayObj.value("fl").toString());
    if (windLevel != std::numeric_limits<int>::min()) {
        setCurrentWind(windLevel);
    }
    setCurrentCode(todayObj.value("type").toString());

    QVariantList dates;
    QVariantList minTemps;
    QVariantList maxTemps;
    QVariantList codes;
    for (int i = 0; i < forecastArr.size() && i < 5; i++) {
        QJsonObject item = forecastArr.at(i).toObject();
        dates.push_back(item.value("date").toString());
        codes.push_back(item.value("type").toString());
        int high = parseIntFromText(item.value("high").toString());
        int low = parseIntFromText(item.value("low").toString());
        maxTemps.push_back(high == std::numeric_limits<int>::min() ? QVariant() : QVariant(high));
        minTemps.push_back(low == std::numeric_limits<int>::min() ? QVariant() : QVariant(low));
        if (i == 0) {
            if (high != std::numeric_limits<int>::min()) {
                setTodayMax(high);
            }
            if (low != std::numeric_limits<int>::min()) {
                setTodayMin(low);
            }
        }
    }

    setDailyDates(dates);
    setDailyMinTemps(minTemps);
    setDailyMaxTemps(maxTemps);
    setDailyCodes(codes);
    setErrorText(QString());
    setLoading(false);
}

QString WeatherService::locationName() const
{
    return m_locationName;
}

QString WeatherService::errorText() const
{
    return m_errorText;
}

bool WeatherService::loading() const
{
    return m_loading;
}

int WeatherService::currentTemp() const
{
    return m_currentTemp;
}

int WeatherService::currentHumidity() const
{
    return m_currentHumidity;
}

int WeatherService::currentWind() const
{
    return m_currentWind;
}

QString WeatherService::currentCode() const
{
    return m_currentCode;
}

int WeatherService::todayMax() const
{
    return m_todayMax;
}

int WeatherService::todayMin() const
{
    return m_todayMin;
}

QString WeatherService::updatedText() const
{
    return m_updatedText;
}

QVariantList WeatherService::dailyDates() const
{
    return m_dailyDates;
}

QVariantList WeatherService::dailyMinTemps() const
{
    return m_dailyMinTemps;
}

QVariantList WeatherService::dailyMaxTemps() const
{
    return m_dailyMaxTemps;
}

QVariantList WeatherService::dailyCodes() const
{
    return m_dailyCodes;
}

void WeatherService::setLocationName(const QString &name)
{
    if (m_locationName == name) {
        return;
    }
    m_locationName = name;
    emit locationNameChanged();
}

void WeatherService::setErrorText(const QString &text)
{
    if (m_errorText == text) {
        return;
    }
    m_errorText = text;
    emit errorTextChanged();
}

void WeatherService::setLoading(bool value)
{
    if (m_loading == value) {
        return;
    }
    m_loading = value;
    emit loadingChanged();
}

void WeatherService::setCurrentTemp(int value)
{
    if (m_currentTemp == value) {
        return;
    }
    m_currentTemp = value;
    emit currentTempChanged();
}

void WeatherService::setCurrentHumidity(int value)
{
    if (m_currentHumidity == value) {
        return;
    }
    m_currentHumidity = value;
    emit currentHumidityChanged();
}

void WeatherService::setCurrentWind(int value)
{
    if (m_currentWind == value) {
        return;
    }
    m_currentWind = value;
    emit currentWindChanged();
}

void WeatherService::setCurrentCode(const QString &value)
{
    if (m_currentCode == value) {
        return;
    }
    m_currentCode = value;
    emit currentCodeChanged();
}

void WeatherService::setTodayMax(int value)
{
    if (m_todayMax == value) {
        return;
    }
    m_todayMax = value;
    emit todayMaxChanged();
}

void WeatherService::setTodayMin(int value)
{
    if (m_todayMin == value) {
        return;
    }
    m_todayMin = value;
    emit todayMinChanged();
}

void WeatherService::setUpdatedText(const QString &text)
{
    if (m_updatedText == text) {
        return;
    }
    m_updatedText = text;
    emit updatedTextChanged();
}

void WeatherService::setDailyDates(const QVariantList &value)
{
    if (m_dailyDates == value) {
        return;
    }
    m_dailyDates = value;
    emit dailyDatesChanged();
}

void WeatherService::setDailyMinTemps(const QVariantList &value)
{
    if (m_dailyMinTemps == value) {
        return;
    }
    m_dailyMinTemps = value;
    emit dailyMinTempsChanged();
}

void WeatherService::setDailyMaxTemps(const QVariantList &value)
{
    if (m_dailyMaxTemps == value) {
        return;
    }
    m_dailyMaxTemps = value;
    emit dailyMaxTempsChanged();
}

void WeatherService::setDailyCodes(const QVariantList &value)
{
    if (m_dailyCodes == value) {
        return;
    }
    m_dailyCodes = value;
    emit dailyCodesChanged();
}
