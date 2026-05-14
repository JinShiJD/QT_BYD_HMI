

import QtQuick
import QtQuick.Controls
import "../../components/base"
import "../../components/ac"

Item {
    id: acPage
    anchors.fill: parent

    property int leftPercentX: 0
    property int leftPercentY: 100
    property int xStepSize: leftRect.width / 100
    property int yStepSize: leftRect.height / 100
    property var colorArray: ["#5055AAFF", "#5077BBF8", "#5088BBF0",
                              "#5099CCEE", "#5099DDEE", "#50AAEEEE",
                              "#50BBEEEE", "#50CCDDEE", "#50DDDDFF",
                              "#50EEEEFF", "#50FFFFFF", "#50FFEEEE",
                              "#50FFDDDD", "#50FFCCCC", "#50EEBBBB",
                              "#50EEAAAA", "#50EE9999"]
    property bool autoModeEnabled: true
    property bool defrostEnabled: false
    property bool syncTemperatureEnabled: false
    property bool rearAcEnabled: true
    property bool acPowerEnabled: true
    property bool seatVentFrontLeft: false
    property bool seatVentFrontRight: false
    property bool seatHeatRearLeft: false
    property bool seatHeatRearRight: false

    function showToast(message) {
        toastText.text = message
        toast.opacity = 1
        toastTimer.restart()
    }

    function openPlaceholder(title) {
        placeholderTitle.text = title
        placeholderPopup.open()
    }

    function openPlaceholderAndToast(title, message) {
        openPlaceholder(title)
        showToast(message)
    }

    function setPage(page, message) {
        ui.pageIndex = page
        if (message && message.length > 0) {
            showToast(message)
        }
    }

    function notifyToggle(enabled, onMessage, offMessage) {
        showToast(enabled ? onMessage : offMessage)
    }

    function clampPercent(value) {
        return Math.max(0, Math.min(100, value))
    }

    function colorForTemp(temp) {
        const index = Math.max(0, Math.min(colorArray.length - 1, temp - 16))
        return colorArray[index]
    }

    // 背景
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/Images/Home/background.png"
        fillMode: Image.PreserveAspectFit

        // 内饰
        Image {
            id: innerImage
            width: 1414
            height: 707
            x: 0
            y: 0
            source: "qrc:/Images/AC/222_5866.png"
            fillMode: Image.PreserveAspectFit
            // 垂直遮罩
            Image {
                id: maskVImage
                anchors.fill: parent
                source: "qrc:/Images/AC/mask_v.png"
                fillMode: Image.PreserveAspectFit
            }

            // 水平遮罩
            Image {
                id: maskHImage
                anchors.fill: parent
                source: "qrc:/Images/AC/mask_h.png"
                fillMode: Image.PreserveAspectFit
            }

        }
    }

    // 淡入动画效果
    PropertyAnimation {
        id: fadeInAnimation
        target: parent
        properties: "opacity"
        duration: 500
        from: 0
        to: 1
        easing.type: Easing.OutQuad
    }

    Component.onCompleted: fadeInAnimation.start()

    // 状态栏
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

    // 空调功能栏
    ACFunctionBar {
        id: acFunctionBar
        width: 882
        height: 70
        anchors.left: parent.left
        anchors.leftMargin: 213
        anchors.top: parent.top
        anchors.topMargin: 57

        onFunctionValueChanged: {
            if (functionValue === 0) {
                showToast(qsTr("空调模式"))
            } else if (functionValue === 1) {
                showToast(qsTr("通风加热"))
            } else if (functionValue === 2) {
                showToast(qsTr("空气滤净"))
            } else {
                showToast(qsTr("空调设置"))
            }
        }
    }

    Button {
        id: autoModeButton
        width: 60
        height: 60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 134
        hoverEnabled: false

        background: Rectangle {
            anchors.fill: parent
            color: autoModeEnabled ? "#2D79FF" : "#2B364B"
            radius: 30
            opacity: autoModeEnabled ? 1 : 0.6
        }

        Label {
            anchors.centerIn: parent
            text: qsTr("AUTO")
            color: "#FFFFFF"
            font.pixelSize: 14
        }

        onClicked: {
            autoModeEnabled = !autoModeEnabled
            notifyToggle(autoModeEnabled, qsTr("自动模式已开启"), qsTr("自动模式已关闭"))
        }
    }

    // 左温度背景
    Image {
        id: leftTemperatureImage
        width: 270
        height: 511
        anchors.left: parent.left
        anchors.leftMargin: 46
        anchors.top: parent.top
        anchors.topMargin: 158
        source: "qrc:/Images/AC/left_temperatur_background.png"
        fillMode: Image.PreserveAspectFit
    }

    // 左温度列表
    QuickTemperatureList {
        id: leftTemperatureList
        width: 160
        height: 511
        anchors.left: parent.left
        anchors.leftMargin: 46
        anchors.top: parent.top
        anchors.topMargin: 158
        spacing: 10
        background: "transparent"
        currentIndexTextColor: "#04FAFB"
        otherIndexTextColor: "#DFDFDF"
        movingColor: "#DFDFDF"
        fontPixelSize: 38
        fontBold: true
        temperature: ui.acLeftTemperature
        direction: 0

        onMovementStarted: {
            // console.log("onMovementStarted")
        }

        onMovementEnded: (temperatureValue) => {
            // console.log("temperatureValue: " + temperatureValue)
            ui.acLeftTemperature = temperatureValue
        }
    }

    // 右温度背景
    Image {
        id: rightTemperatureImage
        width: 270
        height: 511
        anchors.left: parent.left
        anchors.leftMargin: 1047
        anchors.top: parent.top
        anchors.topMargin: 158
        source: "qrc:/Images/AC/right_temperatur_background.png"
        fillMode: Image.PreserveAspectFit
    }

    // 右温度列表
    QuickTemperatureList {
        id: rightTemperatureList
        width: 160
        height: 511
        anchors.left: parent.left
        anchors.leftMargin: 1157
        anchors.top: parent.top
        anchors.topMargin: 158
        spacing: 10
        background: "transparent"
        currentIndexTextColor: "#04FAFB"
        otherIndexTextColor: "#DFDFDF"
        movingColor: "#DFDFDF"
        fontPixelSize: 38
        fontBold: true
        temperature: ui.acRightTemperature
        direction: 1

        onMovementStarted: {
            // console.log("onMovementStarted")
        }

        onMovementEnded: (temperatureValue) => {
            // console.log("temperatureValue: " + temperatureValue)
            ui.acRightTemperature = temperatureValue
        }
    }

    // 负离子按钮
    Button {
        id: anionButton
        width: 97
        height: 97
        anchors.left: parent.left
        anchors.leftMargin: 266
        anchors.top: parent.top
        anchors.topMargin: 368
        hoverEnabled: false
        visible: acFunctionBar.functionValue === 0 || acFunctionBar.functionValue === 2

        property bool switchStatus: true

        background: Image {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: parent.switchStatus ?
                    "qrc:/Images/AC/function_on.png" :
                    "qrc:/Images/AC/function_off.png"
            fillMode: Image.PreserveAspectFit
            opacity: parent.down ? 0.6 : 1
        }

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("负离子")
            color: "#FFFFFF"
            font.pixelSize: 18
        }

        onClicked: {
            switchStatus = !switchStatus
            notifyToggle(switchStatus, qsTr("负离子已开启"), qsTr("负离子已关闭"))
        }
    }

    // 香薰按钮
    Button {
        id: fragranceButton
        width: 97
        height: 97
        anchors.left: parent.left
        anchors.leftMargin: 1009
        anchors.top: parent.top
        anchors.topMargin: 368
        hoverEnabled: false
        z: leftRect.z + 1
        visible: acFunctionBar.functionValue === 0 || acFunctionBar.functionValue === 2

        property bool switchStatus: true

        background: Image {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: parent.switchStatus ?
                    "qrc:/Images/AC/function_on.png" :
                    "qrc:/Images/AC/function_off.png"
            fillMode: Image.PreserveAspectFit
            opacity: parent.down ? 0.6 : 1
        }

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("香薰")
            color: "#FFFFFF"
            font.pixelSize: 18
        }

        onClicked: {
            switchStatus = !switchStatus
            notifyToggle(switchStatus, qsTr("香薰已开启"), qsTr("香薰已关闭"))
        }
    }

    Item {
        id: ventilationPanel
        width: 620
        height: 180
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 210
        visible: acFunctionBar.functionValue === 1

        Row {
            anchors.centerIn: parent
            spacing: 28

            Button {
                width: 120
                height: 80
                hoverEnabled: false
                background: Image {
                    anchors.fill: parent
                    source: "qrc:/Images/AC/222_6008.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: seatVentFrontLeft ? 1 : 0.45
                }
                onClicked: {
                    seatVentFrontLeft = !seatVentFrontLeft
                    notifyToggle(seatVentFrontLeft, qsTr("主驾通风已开启"), qsTr("主驾通风已关闭"))
                }
            }

            Button {
                width: 120
                height: 80
                hoverEnabled: false
                background: Image {
                    anchors.fill: parent
                    source: "qrc:/Images/AC/222_6011.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: seatVentFrontRight ? 1 : 0.45
                }
                onClicked: {
                    seatVentFrontRight = !seatVentFrontRight
                    notifyToggle(seatVentFrontRight, qsTr("副驾通风已开启"), qsTr("副驾通风已关闭"))
                }
            }

            Button {
                width: 120
                height: 80
                hoverEnabled: false
                background: Image {
                    anchors.fill: parent
                    source: "qrc:/Images/AC/222_6015.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: seatHeatRearLeft ? 1 : 0.45
                }
                onClicked: {
                    seatHeatRearLeft = !seatHeatRearLeft
                    notifyToggle(seatHeatRearLeft, qsTr("后排左座加热已开启"), qsTr("后排左座加热已关闭"))
                }
            }

            Button {
                width: 120
                height: 80
                hoverEnabled: false
                background: Image {
                    anchors.fill: parent
                    source: "qrc:/Images/AC/222_6018.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: seatHeatRearRight ? 1 : 0.45
                }
                onClicked: {
                    seatHeatRearRight = !seatHeatRearRight
                    notifyToggle(seatHeatRearRight, qsTr("后排右座加热已开启"), qsTr("后排右座加热已关闭"))
                }
            }
        }
    }

    Item {
        id: settingsPanel
        width: 560
        height: 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 210
        visible: acFunctionBar.functionValue === 3

        Row {
            anchors.centerIn: parent
            spacing: 24

            Button {
                width: 160
                height: 64
                hoverEnabled: false
                onClicked: {
                    syncTemperatureEnabled = !syncTemperatureEnabled
                    notifyToggle(syncTemperatureEnabled, qsTr("温度同步已开启"), qsTr("温度同步已关闭"))
                }
                contentItem: Label {
                    text: qsTr("同步温度")
                    color: "#FFFFFF"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: syncTemperatureEnabled ? "#2979FF" : "#2B364B"
                    radius: 32
                }
            }

            Button {
                width: 160
                height: 64
                hoverEnabled: false
                onClicked: {
                    rearAcEnabled = !rearAcEnabled
                    notifyToggle(rearAcEnabled, qsTr("后排空调已开启"), qsTr("后排空调已关闭"))
                }
                contentItem: Label {
                    text: qsTr("后排空调")
                    color: "#FFFFFF"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: rearAcEnabled ? "#2979FF" : "#2B364B"
                    radius: 32
                }
            }

            Button {
                width: 160
                height: 64
                hoverEnabled: false
                onClicked: {
                    acPowerEnabled = !acPowerEnabled
                    notifyToggle(acPowerEnabled, qsTr("A/C 已开启"), qsTr("A/C 已关闭"))
                }
                contentItem: Label {
                    text: qsTr("A/C")
                    color: "#FFFFFF"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: acPowerEnabled ? "#2979FF" : "#2B364B"
                    radius: 32
                }
            }
        }
    }


    Rectangle {
        id: leftRect
        width: 340
        height: 300
        x: 800
        y: 200
        z: backgroundImage.z + 1
        // color: "#2011AA11"
        color: "transparent"
        // visible: false

        MouseArea {
            id: leftMouseArea
            anchors.fill: parent

            onPositionChanged: {
                leftPercentX = clampPercent(mouse.x / xStepSize)
                leftPercentY = clampPercent(mouse.y / yStepSize)
            }
        }
    }


    QuickWind {
        id: rightWind
        width: 240
        height: 200
        emitterWidth: 360
        emitterHeight: 30
        source: "qrc:/Images/AC/fog.png"
        x: 890
        y: 210
        z: leftRect.z + 1
        moveX: leftPercentX
        moveY: leftPercentY
        offsetX: 0
        offsetY: 100
        value: ui.acFanLevel
        color: colorForTemp(ui.acRightTemperature)
    }

    // 空调风量
    ACFan {
        id: acFan
        width: 723
        height: 71
        x: 323 + 108
        y: 617
    }

    // 空调控制栏
    ACBar {
        width: 1305
        height: 123
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 707

        onFan: acFan.opened ? acFan.close() : acFan.open()
        onMode: {
            setPage(ui.PAGE_AC, qsTr("空调模式"))
        }
        onNavigation: {
            setPage(ui.PAGE_NAVIGATION, qsTr("打开导航"))
        }
        onDefrost: {
            defrostEnabled = !defrostEnabled
            notifyToggle(defrostEnabled, qsTr("除霜已开启"), qsTr("除霜已关闭"))
        }
        onMusic: {
            setPage(ui.PAGE_MUSIC_FULL, "")
        }
        onContact: {
            setPage(ui.PAGE_CONTACT, qsTr("打开联系人"))
        }
    }

    Popup {
        id: placeholderPopup
        width: 600
        height: 350
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnPressOutside
        enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 } }

        background: Rectangle {
            color: "#EE1A212B"
            radius: 24
            border.color: "#3874F2"
            border.width: 1
        }

        Column {
            anchors.centerIn: parent
            spacing: 30
            Label {
                id: placeholderTitle
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#FFFFFF"
                font.pixelSize: 32
                font.bold: true
            }
            Label {
                text: qsTr("功能模块正在开发中...")
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#9AFFFFFF"
                font.pixelSize: 22
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 160
                height: 54
                onClicked: placeholderPopup.close()
                contentItem: Label {
                    text: qsTr("返回")
                    color: "#FFFFFF"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.down ? "#2C333E" : "#3874F2"
                    radius: 27
                }
            }
        }
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
