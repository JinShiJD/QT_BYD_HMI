import QtQuick
import QtQuick.Controls
import "../../components/base"

Item {
    id: appPage

    anchors.fill: parent

    function showToast(message) {
        toastText.text = message
        toast.opacity = 1
        toastTimer.restart()
    }

    function setPage(page, message) {
        ui.pageIndex = page
        if (message) {
            showToast(message)
        }
    }

    function openPlaceholder(title) {
        placeholderTitle.text = title
        placeholderPopup.open()
    }

    function handleAppClick(appType, appName) {
        if (appType === "music_full") {
            setPage(ui.PAGE_MUSIC_FULL)
            return
        }
        if (appType === "settings") {
            setPage(ui.PAGE_SETTINGS, qsTr("打开设置"))
            return
        }
        if (appType === "contact") {
            setPage(ui.PAGE_CONTACT, qsTr("打开联系人"))
            return
        }
        if (appType === "maps_home") {
            setPage(ui.PAGE_NAVIGATION, qsTr("正在跳转至导航界面..."))
            return
        }
        if (appType === "instrument") {
            setPage(ui.PAGE_INSTRUMENT, qsTr("打开仪表界面"))
            return
        }
        openPlaceholder(appName)
        showToast(qsTr("打开 ") + appName + qsTr("（占位演示）"))
    }

    property var apps: [
        { name: "Mimo", icon: "qrc:/Images/App/Mimo.png", type: "normal" },
        { name: "Messenger", icon: "qrc:/Images/App/Messenger.png", type: "normal" },
        { name: "Duolinguo", icon: "qrc:/Images/App/Duolinguo.png", type: "normal" },
        { name: "Calculator", icon: "qrc:/Images/App/Caltulator.png", type: "normal" },
        { name: "Spotify", icon: "qrc:/Images/App/Spotify.png", type: "music_full" },
        { name: "联系人", icon: "qrc:/Images/ACBar/contact.png", type: "contact" },
        { name: "Swift", icon: "qrc:/Images/App/Swift.png", type: "normal" },
        { name: "Notability", icon: "qrc:/Images/App/Notability.png", type: "normal" },
        { name: "Maps", icon: "qrc:/Images/App/Maps.png", type: "maps_home" },
        { name: "设置", icon: "qrc:/Images/Settings/button.png", type: "settings" },
        { name: "仪表", icon: "qrc:/Images/Home/vehicle.png", type: "instrument" },
        { name: "Picstart", icon: "qrc:/Images/App/Picstart.png", type: "normal" },
        { name: "DayOne", icon: "qrc:/Images/App/DayOne.png", type: "normal" },
        { name: "Podcast", icon: "qrc:/Images/App/Podcast.png", type: "normal" },
        { name: "Vectornator", icon: "qrc:/Images/App/Vectornator.png", type: "normal" },
        { name: "Music", icon: "qrc:/Images/App/Music.png", type: "music_full" },
        { name: "Spark", icon: "qrc:/Images/App/Spark.png", type: "normal" }
    ]

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

    GridView {
        id: appGrid
        anchors.left: parent.left
        anchors.leftMargin: 80
        anchors.right: parent.right
        anchors.rightMargin: 80
        anchors.top: parent.top
        anchors.topMargin: 130
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        cellWidth: 140
        cellHeight: 150
        model: apps
        interactive: true
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        delegate: Item {
            width: appGrid.cellWidth
            height: appGrid.cellHeight
            property var app: modelData

            Column {
                anchors.centerIn: parent
                spacing: 16

                Image {
                    width: 94
                    height: 94
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: app.icon
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Label {
                    width: 110
                    height: 31
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: app.name
                    color: "#FFFFFF"
                    font.pixelSize: 22
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    handleAppClick(app.type, app.name)
                }
            }
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
                text: qsTr("应用正在开发中...")
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
