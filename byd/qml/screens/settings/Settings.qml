
import QtQuick
import QtQuick.Controls
import "../../components/settings"
import "../../components/base"
import "../../components/ac"

Item {
    id: settingsPage
    anchors.fill: parent

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

    // 背景
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/Images/Home/background.png"
        fillMode: Image.PreserveAspectFit
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

    // 设置模式栏
    SettingsModeBar {
        id: leftBackgroundImage
        width: 240
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        onFunctionValueChanged: showToast(qsTr("模式已切换"))
    }

    // 设置功能栏
    SettingsFunctionBar {
        id: settingsFunctionBar
        width: 1099
        height: 69
        anchors.left: parent.left
        anchors.leftMargin: 276
        anchors.top: parent.top
        anchors.topMargin: 81
        functionValue: ui.settingsFunctionValue

        onFunctionValueChanged: {
            ui.settingsFunctionValue = functionValue
            showToast(qsTr("设置项已切换"))
        }
    }

    // 中间背景
    Image {
        id: centerBackgroundImage
        width: 1099
        height: 705
        anchors.left: parent.left
        anchors.leftMargin: 276
        anchors.top: parent.top
        anchors.topMargin: 151
        source: "qrc:/Images/Settings/center_background.png"
        fillMode: Image.PreserveAspectFit
    }

    // 设置列表
    SettingsList {
        id: settingsList
        width: 537
        height: 705
        contentWidth: 405
        contentHeight: 3200
        anchors.left: parent.left
        anchors.leftMargin: 276
        anchors.top: parent.top
        anchors.topMargin: 151

        onMoveStarted: {
            acBar.visible = false
        }

        onMoveEnded: {
            acBar.visible = true
        }
    }

    // 天数
    Label {
        id: daysLabel1
        width: 90
        height: 26
        anchors.left: parent.left
        anchors.leftMargin: 1168
        anchors.top: parent.top
        anchors.topMargin: 235
        verticalAlignment: Text.AlignVCenter
        text: qsTr("已安全陪伴您 ")
        color: "#9AFFFFFF"
        font.pixelSize: 16
    }
    Label {
        id: daysLabel
        width: 50
        height: 32
        anchors.left: daysLabel1.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 230
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("520")   //qsTr("267")
        color: "#FFFFFF"
        font.pixelSize: 24
        font.bold: true
    }
    Label {
        id: daysLabel2
        width: 32
        height: 26
        anchors.left: daysLabel.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 235
        verticalAlignment: Text.AlignVCenter
        text: qsTr(" 天")
        color: "#9AFFFFFF"
        font.pixelSize: 16
    }

    // 车
    Image {
        width: 472
        height: 182
        anchors.left: parent.left
        anchors.leftMargin:870
        anchors.top: parent.top
        anchors.topMargin: 417
        source: "qrc:/Images/Settings/vehicle.png"
        fillMode: Image.PreserveAspectFit
    }

    // 车况
    Image {
        id: vehicleConditionImage
        width: 167
        height: 28
        anchors.left: parent.left
        anchors.leftMargin: 1160
        anchors.top: parent.top
        anchors.topMargin: 637
        source: "qrc:/Images/Settings/vehicle_condition_good.png"
        fillMode: Image.PreserveAspectFit
    }


    // 里程
    Image {
        id: milesImage
        width: 149
        height: 74
        anchors.left: parent.left
        anchors.leftMargin: 1178
        anchors.top: parent.top
        anchors.topMargin: 294
        source: "qrc:/Images/Settings/miles.png"
        fillMode: Image.PreserveAspectFit
    }

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
        id: acBar
        width: 1305
        height: 123
        anchors.left: parent.left
        anchors.leftMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 707

        onFan: acFan.opened ? acFan.close() : acFan.open()
        onMode: {
            setPage(ui.PAGE_AC, qsTr("进入空调界面"))
        }
        onNavigation: {
            setPage(ui.PAGE_NAVIGATION, qsTr("打开导航"))
        }
        onDefrost: {
            showToast(qsTr("除霜功能已切换"))
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
