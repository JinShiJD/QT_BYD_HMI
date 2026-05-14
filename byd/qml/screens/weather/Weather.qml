import QtQuick
import QtQuick.Controls
import "../../components/base"
import "../../components/ac"

Item {
    id: weatherPage

    anchors.fill: parent

    function showToast(message) {
        toastText.text = message
        toast.opacity = 1
        toastTimer.restart()
    }

    function setPage(page, message) {
        ui.pageIndex = page
        if (message && message.length > 0) {
            showToast(message)
        }
    }

    property string locationName: weatherService ? weatherService.locationName : qsTr("长沙")
    property bool loading: weatherService ? weatherService.loading : false
    property string errorText: weatherService ? weatherService.errorText : ""
    property bool editingLocation: false
    property bool manualOverride: false
    property string inputCity: ""

    property int currentTemp: weatherService ? weatherService.currentTemp : 0
    property int currentHumidity: weatherService ? weatherService.currentHumidity : 0
    property int currentWind: weatherService ? weatherService.currentWind : 0
    property var currentCode: weatherService ? weatherService.currentCode : ""
    property int todayMax: weatherService ? weatherService.todayMax : 0
    property int todayMin: weatherService ? weatherService.todayMin : 0
    property string updatedText: weatherService ? weatherService.updatedText : ""
    property real introProgress: 0

    property var hourlyTimes: []
    property var hourlyTemps: []
    property var hourlyCodes: []
    property int hourlyStartIndex: 0

    property var dailyDates: weatherService ? weatherService.dailyDates : []
    property var dailyMinTemps: weatherService ? weatherService.dailyMinTemps : []
    property var dailyMaxTemps: weatherService ? weatherService.dailyMaxTemps : []
    property var dailyCodes: weatherService ? weatherService.dailyCodes : []

    function weatherText(code) {
        if (code === undefined || code === null) return qsTr("天气")
        if (typeof code === "string") return code
        if (code === 0) return qsTr("晴")
        if (code === 1 || code === 2) return qsTr("少云")
        if (code === 3) return qsTr("多云")
        if (code === 45 || code === 48) return qsTr("有雾")
        if (code === 51 || code === 53 || code === 55) return qsTr("毛毛雨")
        if (code === 61 || code === 63 || code === 65) return qsTr("小雨")
        if (code === 66 || code === 67) return qsTr("冻雨")
        if (code === 71 || code === 73 || code === 75) return qsTr("小雪")
        if (code === 80 || code === 81 || code === 82) return qsTr("阵雨")
        if (code === 85 || code === 86) return qsTr("阵雪")
        if (code === 95 || code === 96 || code === 99) return qsTr("雷暴")
        return qsTr("天气")
    }

    function iconFromText(text) {
        if (!text) return "qrc:/Images/Weather/cloud.svg"
        if (text.indexOf("雷") >= 0) return "qrc:/Images/Weather/thunder.svg"
        if (text.indexOf("雪") >= 0) return "qrc:/Images/Weather/snow.svg"
        if (text.indexOf("雨") >= 0) return "qrc:/Images/Weather/rain.svg"
        if (text.indexOf("雾") >= 0 || text.indexOf("霾") >= 0) return "qrc:/Images/Weather/fog.svg"
        if (text.indexOf("晴") >= 0) return "qrc:/Images/Weather/sun.svg"
        if (text.indexOf("云") >= 0 || text.indexOf("阴") >= 0) return "qrc:/Images/Weather/cloud.svg"
        return "qrc:/Images/Weather/cloud.svg"
    }

    function weatherIcon(code) {
        if (code === undefined || code === null) return "qrc:/Images/Weather/cloud.svg"
        if (typeof code === "string") return iconFromText(code)
        if (code === 0) return "qrc:/Images/Weather/sun.svg"
        if (code === 1 || code === 2 || code === 3) return "qrc:/Images/Weather/cloud.svg"
        if (code === 45 || code === 48) return "qrc:/Images/Weather/fog.svg"
        if (code === 51 || code === 53 || code === 55) return "qrc:/Images/Weather/rain.svg"
        if (code === 61 || code === 63 || code === 65) return "qrc:/Images/Weather/rain.svg"
        if (code === 66 || code === 67) return "qrc:/Images/Weather/rain.svg"
        if (code === 71 || code === 73 || code === 75) return "qrc:/Images/Weather/snow.svg"
        if (code === 80 || code === 81 || code === 82) return "qrc:/Images/Weather/rain.svg"
        if (code === 85 || code === 86) return "qrc:/Images/Weather/snow.svg"
        if (code === 95 || code === 96 || code === 99) return "qrc:/Images/Weather/thunder.svg"
        return "qrc:/Images/Weather/cloud.svg"
    }

    function normalizeCityName(name) {
        if (!name) return ""
        return name.replace(/(市|区|县|自治州|地区|盟|旗)$/, "")
    }

    function parseNumber(value) {
        var num = parseFloat(value)
        if (isNaN(num) || num >= 9999) return null
        return num
    }

    function parseTempFromText(text) {
        if (!text) return null
        var match = text.toString().match(/-?\d+/)
        if (!match) return null
        return parseNumber(match[0])
    }
    function formatHour(timeStr) {
        if (!timeStr) return "--:--"
        var parts = timeStr.split("T")
        if (parts.length > 1) return parts[1].slice(0, 5)
        return timeStr
    }

    function formatDate(dateStr) {
        if (!dateStr) return "--"
        var parts = dateStr.split("-")
        if (parts.length === 3) return parts[1] + "/" + parts[2]
        return dateStr
    }

    function tempText(value) {
        if (value === undefined || value === null || isNaN(value)) return "--"
        return Math.round(value) + "°"
    }

    function hasWeatherData() {
        return updatedText.length > 0 && errorText.length === 0
    }

    function numberText(value, suffix) {
        if (!hasWeatherData() || value === undefined || value === null || isNaN(value) || value < -9990) return "--"
        return value + (suffix ? suffix : "")
    }

    function updateFromItboy(data) {
        if (!data || !data.message || data.message.toString().indexOf("success") < 0) {
            errorText = qsTr("天气：城市错误！")
            return false
        }
        var payload = data.data || {}
        var cityInfo = data.cityInfo || {}
        if (cityInfo.city) {
            locationName = cityInfo.city
        }
        errorText = ""
        var temp = parseNumber(payload.wendu)
        if (temp !== null) currentTemp = Math.round(temp)
        var humidity = parseNumber(payload.shidu ? payload.shidu.toString().replace("%", "") : null)
        if (humidity !== null) currentHumidity = Math.round(humidity)
        var forecast = payload.forecast || []
        var todayForecast = forecast.length > 0 ? forecast[0] : null
        var windLevel = todayForecast ? parseTempFromText(todayForecast.fl) : null
        if (windLevel !== null) currentWind = Math.round(windLevel)
        currentCode = todayForecast && todayForecast.type ? todayForecast.type : ""
        updatedText = data.time || data.date || ""

        hourlyTimes = []
        hourlyTemps = []
        hourlyCodes = []
        hourlyStartIndex = 0

        dailyDates = []
        dailyMinTemps = []
        dailyMaxTemps = []
        dailyCodes = []
        for (var i = 0; i < forecast.length && dailyDates.length < 5; i++) {
            var item = forecast[i]
            if (!item) continue
            dailyDates.push(item.date || item.week || "")
            dailyCodes.push(item.type || "")
            var maxTemp = parseTempFromText(item.high)
            var minTemp = parseTempFromText(item.low)
            dailyMaxTemps.push(maxTemp)
            dailyMinTemps.push(minTemp)
        }
        if (dailyMaxTemps.length > 0) {
            if (dailyMaxTemps[0] !== null) todayMax = Math.round(dailyMaxTemps[0])
            if (dailyMinTemps[0] !== null) todayMin = Math.round(dailyMinTemps[0])
        }
        return true
    }


    function applyStation(station) {
        if (!station) return
        stationId = station.id
        if (station.city) {
            locationName = station.city
        }
    }

    function loadProvinces(callback) {
        if (provinceList && provinceList.length > 0) {
            callback(provinceList)
            return
        }
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE) {
                return
            }
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                provinceList = data || []
                callback(provinceList)
            } else {
                callback([])
            }
        }
        xhr.open("GET", "https://www.nmc.cn/f/rest/province")
        xhr.send()
    }

    function loadCityCodeList(callback) {
        if (cityCodeList && cityCodeList.length > 0) {
            callback(cityCodeList)
            return
        }
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE) {
                return
            }
            if (xhr.status === 200 || xhr.status === 0) {
                var data = []
                try {
                    data = JSON.parse(xhr.responseText)
                } catch (e) {
                    data = []
                }
                cityCodeList = data || []
                cityCodeMap = ({})
                for (var i = 0; i < cityCodeList.length; i++) {
                    var item = cityCodeList[i]
                    if (!item || !item.city_code) continue
                    var name = normalizeCityName(item.city_name)
                    if (name && !cityCodeMap[name]) {
                        cityCodeMap[name] = item
                    }
                    if (item.city_name && !cityCodeMap[item.city_name]) {
                        cityCodeMap[item.city_name] = item
                    }
                }
                callback(cityCodeList)
            } else {
                callback([])
            }
        }
        xhr.open("GET", "qrc:/citycode-2019-08-23.json")
        xhr.send()
    }

    function loadCities(provinceCode, callback) {
        if (!provinceCode) {
            callback([])
            return
        }
        if (cityCache[provinceCode]) {
            callback(cityCache[provinceCode])
            return
        }
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE) {
                return
            }
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                cityCache[provinceCode] = data || []
                callback(cityCache[provinceCode])
            } else {
                callback([])
            }
        }
        xhr.open("GET", "https://www.nmc.cn/f/rest/province/" + provinceCode)
        xhr.send()
    }

    function resolveStationId(cityName, callback) {
        var target = normalizeCityName(cityName)
        if (!target) {
            callback(null)
            return
        }
        if (stationCache[target]) {
            callback(stationCache[target])
            return
        }
        loadCityCodeList(function(list) {
            var localMatch = cityCodeMap[target]
            if (localMatch && localMatch.city_code) {
                var resolved = { id: localMatch.city_code, city: localMatch.city_name }
                stationCache[target] = resolved
                callback(resolved)
                return
            }
            var fallback = null
            for (var i = 0; i < list.length; i++) {
                var item = list[i]
                if (!item || !item.city_code) continue
                var name = normalizeCityName(item.city_name)
                if (name === target || (name && target && (name.indexOf(target) >= 0 || target.indexOf(name) >= 0))) {
                    fallback = { id: item.city_code, city: item.city_name }
                    break
                }
            }
            if (fallback) {
                stationCache[target] = fallback
                callback(fallback)
            } else {
                callback(null)
            }
        })
    }

    function geocodeCity(city) {
        if (!city || city.length === 0) {
            return
        }
        manualOverride = true
        weatherService.requestWeather(city)
    }

    function autoLocate() {
        if (manualOverride) {
            return
        }
        weatherService.requestWeather(locationName)
    }

    function loadWeather() {
        weatherService.requestWeather(locationName)
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/Images/Home/background.png"
        fillMode: Image.PreserveAspectFit
    }

    PropertyAnimation {
        id: fadeInAnimation
        target: parent
        properties: "opacity"
        duration: 500
        from: 0
        to: 1
        easing.type: Easing.OutQuad
    }

    NumberAnimation {
        id: introAnimation
        target: weatherPage
        property: "introProgress"
        from: 0
        to: 1
        duration: 500
        easing.type: Easing.OutQuad
    }

    Component.onCompleted: {
        fadeInAnimation.start()
        introAnimation.start()
        inputCity = locationName
        autoLocate()
    }

    Timer {
        id: refreshTimer
        interval: 900000
        repeat: true
        running: true
        onTriggered: loadWeather()
    }

    StatusBar {
        id: statusBar
        width: parent.width
        height: 46
        anchors.left: parent.left
        anchors.top: parent.top
        positionStatus: ui.controlCenterPositionStatus
        bluetoothStatus: ui.controlCenterBluetoothStatus
        signalStatus: ui.controlCenterWLANStatus

        onPositionStatusChanged: ui.controlCenterPositionStatus = positionStatus
        onBluetoothStatusChanged: ui.controlCenterBluetoothStatus = bluetoothStatus
        onSignalStatusChanged: ui.controlCenterWLANStatus = signalStatus
    }

    Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.leftMargin: 60
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.top: parent.top
        anchors.topMargin: 90
        anchors.bottom: acBar.top
        anchors.bottomMargin: 18
        spacing: 24

        Rectangle {
            id: heroCard
            width: parent.width
            height: 260
            radius: 24
            color: "#1B2332"
            opacity: 0.6 + introProgress * 0.4
            y: (1 - introProgress) * 12

            Rectangle {
                anchors.fill: parent
                radius: 24
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#2B3A59" }
                    GradientStop { position: 0.6; color: "#1D2A43" }
                    GradientStop { position: 1.0; color: "#151E2C" }
                }
                opacity: 0.9
            }

            Rectangle {
                id: glow
                width: 220
                height: 220
                radius: 110
                color: "#3874F2"
                opacity: 0.12
                x: heroCard.width - 260
                y: -40
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.18; duration: 1400; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 0.08; duration: 1400; easing.type: Easing.InOutQuad }
                }
                SequentialAnimation on y {
                    loops: Animation.Infinite
                    NumberAnimation { to: -30; duration: 1400; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: -50; duration: 1400; easing.type: Easing.InOutQuad }
                }
            }

            Item {
                anchors.fill: parent
                anchors.margins: 28

                Column {
                    id: leftPanel
                    width: heroCard.width - 360
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    spacing: 12

                    Item {
                        width: leftPanel.width
                        height: 36

                        Row {
                            id: locationRow
                            spacing: 12
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            Label {
                                text: locationName
                                color: "#FFFFFF"
                                font.pixelSize: 26
                                font.bold: true
                            }
                            Rectangle {
                                width: 1
                                height: 20
                                color: "#3B4C6B"
                                opacity: 0.7
                            }
                            Label {
                                text: weatherText(currentCode)
                                color: "#9AFFFFFF"
                                font.pixelSize: 18
                            }
                        }

                        Row {
                            spacing: 8
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Button {
                                width: 84
                                height: 30
                                hoverEnabled: false
                                onClicked: {
                                    manualOverride = false
                                    autoLocate()
                                }
                                contentItem: Label {
                                    text: qsTr("定位")
                                    color: "#FFFFFF"
                                    font.pixelSize: 14
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    color: parent.down ? "#2C333E" : "#2B364B"
                                    radius: 15
                                }
                            }
                            Button {
                                width: 84
                                height: 30
                                hoverEnabled: false
                                onClicked: {
                                    editingLocation = !editingLocation
                                    if (editingLocation) {
                                        inputCity = locationName
                                    }
                                }
                                contentItem: Label {
                                    text: editingLocation ? qsTr("取消") : qsTr("修改")
                                    color: "#FFFFFF"
                                    font.pixelSize: 14
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    color: parent.down ? "#2C333E" : "#2B364B"
                                    radius: 15
                                }
                            }
                            Button {
                                width: 84
                                height: 30
                                hoverEnabled: false
                                visible: editingLocation
                                onClicked: {
                                    editingLocation = false
                                    geocodeCity(inputCity)
                                }
                                contentItem: Label {
                                    text: qsTr("搜索")
                                    color: "#FFFFFF"
                                    font.pixelSize: 14
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    color: parent.down ? "#2C333E" : "#3874F2"
                                    radius: 15
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 360
                        height: editingLocation ? 40 : 0
                        radius: 12
                        color: "#23324A"
                        opacity: editingLocation ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        Behavior on height { NumberAnimation { duration: 200 } }
                        TextField {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            text: inputCity
                            color: "#FFFFFF"
                            font.pixelSize: 16
                            placeholderText: qsTr("输入城市名")
                            background: Rectangle { color: "transparent" }
                            onTextChanged: inputCity = text
                            onAccepted: {
                                editingLocation = false
                                geocodeCity(inputCity)
                            }
                        }
                    }

                    Label {
                        text: updatedText.length > 0 ? qsTr("更新于 ") + updatedText : qsTr("正在获取实时天气")
                        color: "#9AFFFFFF"
                        font.pixelSize: 14
                    }

                    Row {
                        spacing: 18
                        Image {
                            width: 72
                            height: 72
                            source: weatherIcon(currentCode)
                            fillMode: Image.PreserveAspectFit
                        }
                        Label {
                            text: numberText(currentTemp, "°")
                            color: "#FFFFFF"
                            font.pixelSize: 86
                            font.bold: true
                        }
                        Column {
                            spacing: 10
                            Rectangle {
                                width: 200
                                height: 44
                                radius: 14
                                color: "#243045"
                                Row {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    Label {
                                        text: qsTr("最高")
                                        color: "#9AFFFFFF"
                                        font.pixelSize: 14
                                    }
                                    Label {
                                        text: hasWeatherData() ? tempText(todayMax) : "--"
                                        color: "#FFFFFF"
                                        font.pixelSize: 18
                                        font.bold: true
                                    }
                                    Label {
                                        text: qsTr("最低")
                                        color: "#9AFFFFFF"
                                        font.pixelSize: 14
                                    }
                                    Label {
                                        text: hasWeatherData() ? tempText(todayMin) : "--"
                                        color: "#FFFFFF"
                                        font.pixelSize: 18
                                        font.bold: true
                                    }
                                }
                            }
                            Row {
                                spacing: 12
                                Rectangle {
                                    width: 140
                                    height: 40
                                    radius: 12
                                    color: "#243045"
                                    Row {
                                        anchors.centerIn: parent
                                        spacing: 6
                                        Image {
                                            width: 18
                                            height: 18
                                            source: "qrc:/Images/Weather/humidity.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                        Label {
                                            text: numberText(currentHumidity, "%")
                                            color: "#FFFFFF"
                                            font.pixelSize: 15
                                            font.bold: true
                                        }
                                    }
                                }
                                Rectangle {
                                    width: 140
                                    height: 40
                                    radius: 12
                                    color: "#243045"
                                    Row {
                                        anchors.centerIn: parent
                                        spacing: 6
                                        Image {
                                            width: 18
                                            height: 18
                                            source: "qrc:/Images/Weather/wind.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                        Label {
                                            text: numberText(currentWind, qsTr(" km/h"))
                                            color: "#FFFFFF"
                                            font.pixelSize: 15
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 420
                        height: 40
                        radius: 12
                        color: "#243045"
                        opacity: errorText.length > 0 ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        Row {
                            anchors.centerIn: parent
                            spacing: 10
                            Label {
                                text: qsTr("提示")
                                color: "#9AFFFFFF"
                                font.pixelSize: 14
                            }
                            Label {
                                text: errorText
                                color: "#FFFFFF"
                                font.pixelSize: 14
                            }
                        }
                    }
                }

                Rectangle {
                    width: 300
                    height: 170
                    radius: 18
                    color: "#23324A"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.9
                    Column {
                        anchors.centerIn: parent
                        spacing: 10
                        Label {
                            text: qsTr("今日概况")
                            color: "#9AFFFFFF"
                            font.pixelSize: 14
                        }
                        Row {
                            spacing: 10
                            Image {
                                width: 36
                                height: 36
                                source: weatherIcon(currentCode)
                                fillMode: Image.PreserveAspectFit
                            }
                            Label {
                                text: weatherText(currentCode)
                                color: "#FFFFFF"
                                font.pixelSize: 20
                                font.bold: true
                            }
                        }
                        Label {
                            text: qsTr("最高 ") + (hasWeatherData() ? tempText(todayMax) : "--") + qsTr(" / 最低 ") + (hasWeatherData() ? tempText(todayMin) : "--")
                            color: "#9AFFFFFF"
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }

        Column {
            id: cardsArea
            width: parent.width
            spacing: 24

            Rectangle {
                id: hourlyCard
                width: parent.width
                height: 220
                radius: 22
                color: "#1F2736"
                opacity: 0.6 + introProgress * 0.4
                y: (1 - introProgress) * 10
                Behavior on opacity { NumberAnimation { duration: 220 } }

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    Row {
                        spacing: 12
                        Label {
                            text: qsTr("小时预报")
                            color: "#FFFFFF"
                            font.pixelSize: 20
                            font.bold: true
                        }
                        Label {
                            text: qsTr("未来 8 小时")
                            color: "#9AFFFFFF"
                            font.pixelSize: 14
                        }
                        Item { width: 12; height: 1 }
                        Button {
                            width: 86
                            height: 30
                            hoverEnabled: false
                            onClicked: loadWeather()
                            contentItem: Label {
                                text: loading ? qsTr("刷新中") : qsTr("刷新")
                                color: "#FFFFFF"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: parent.down ? "#2C333E" : "#2B364B"
                                radius: 15
                            }
                        }
                    }

                    ListView {
                        id: hourlyList
                        width: parent.width
                        height: 140
                        orientation: ListView.Horizontal
                        spacing: 12
                        clip: true
                        model: 8
                        delegate: Rectangle {
                            width: 100
                            height: 130
                            radius: 16
                            color: "#2B364B"
                            opacity: 0.95
                            Behavior on opacity { NumberAnimation { duration: 220 } }
                            Column {
                                anchors.centerIn: parent
                                spacing: 8
                                Label {
                                    text: formatHour(hourlyTimes[hourlyStartIndex + index])
                                    color: "#9AFFFFFF"
                                    font.pixelSize: 14
                                }
                                Image {
                                    width: 22
                                    height: 22
                                    source: weatherIcon(hourlyCodes[hourlyStartIndex + index])
                                    fillMode: Image.PreserveAspectFit
                                }
                                Label {
                                    text: tempText(hourlyTemps[hourlyStartIndex + index])
                                    color: "#FFFFFF"
                                    font.pixelSize: 22
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: dailyCard
                width: parent.width
                height: 220
                radius: 22
                color: "#1F2736"
                opacity: 0.6 + introProgress * 0.4
                y: (1 - introProgress) * 10

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 10

                    Item {
                        id: dailyHeaderRow
                        width: parent.width
                        height: 24
                        Row {
                            id: dailyLeftGroup
                            spacing: 12
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            Label {
                                id: dailyTitleLabel
                                text: qsTr("未来 5 天")
                                color: "#FFFFFF"
                                font.pixelSize: 20
                                font.bold: true
                                verticalAlignment: Text.AlignVCenter
                            }
                            Label {
                                id: dailyTempLabel
                                text: hasWeatherData()
                                      ? tempText(dailyMaxTemps.length > 0 ? dailyMaxTemps[0] : todayMax) + " / " + tempText(dailyMinTemps.length > 0 ? dailyMinTemps[0] : todayMin)
                                      : "-- / --"
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }
                        }
                        Label {
                            id: dailyHighLowLabel
                            text: qsTr("高 / 低")
                            color: "#9AFFFFFF"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#2B364B"
                        opacity: 0.6
                    }

                    Column {
                        id: dailyList
                        width: parent.width
                        spacing: 8
                        Repeater {
                            model: 5
                            delegate: Rectangle {
                                width: dailyList.width
                                height: 34
                                radius: 12
                                color: "#2B364B"
                                Item {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    Row {
                                        spacing: 8
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        Label {
                                            width: 60
                                            text: formatDate(dailyDates[index])
                                            color: "#9AFFFFFF"
                                            font.pixelSize: 14
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Image {
                                            width: 18
                                            height: 18
                                            source: weatherIcon(dailyCodes[index])
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                    Row {
                                        spacing: 10
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        Label {
                                            text: tempText(dailyMaxTemps[index])
                                            color: "#FFFFFF"
                                            font.pixelSize: 14
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Label {
                                            text: tempText(dailyMinTemps[index])
                                            color: "#9AFFFFFF"
                                            font.pixelSize: 14
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ACFan {
        id: acFan
        width: 723
        height: 71
        x: 323 + 108
        y: 617
    }

    ACBar {
        id: acBar
        width: 1305
        height: 123
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 707

        onFan: acFan.opened ? acFan.close() : acFan.open()
        onMode: setPage(ui.PAGE_AC, qsTr("进入空调界面"))
        onNavigation: setPage(ui.PAGE_NAVIGATION, qsTr("打开导航"))
        onDefrost: showToast(qsTr("除霜功能已切换"))
        onMusic: setPage(ui.PAGE_MUSIC_FULL, "")
        onContact: setPage(ui.PAGE_CONTACT, qsTr("打开联系人"))
    }

    Rectangle {
        id: toast
        width: toastText.width + 60
        height: 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 140
        color: "#CC000000"
        radius: 32
        opacity: 0
        z: 999
        Label {
            id: toastText
            anchors.centerIn: parent
            color: "#FFFFFF"
            font.pixelSize: 22
        }
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    Timer {
        id: toastTimer
        interval: 2000
        onTriggered: toast.opacity = 0
    }
}
