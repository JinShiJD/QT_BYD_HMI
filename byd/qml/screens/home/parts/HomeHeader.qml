import QtQuick
import QtQuick.Controls
import "../../../components/base"

Item {
    id: root

    property string timeText: ""
    property string dateText: ""

    signal voiceRequested
    signal weatherRequested

    anchors.fill: parent

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

    Connections {
        target: ui

        function onUpdateDateTime(date, time) {
            dateText = date
            timeText = time
        }
    }

    Button {
        id: voiceAssistantButton
        onClicked: voiceRequested()
        width: 444
        height: 120
        anchors.left: parent.left
        anchors.leftMargin: 79
        anchors.top: parent.top
        anchors.topMargin: 67
        hoverEnabled: false

        background: Image {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: "qrc:/Images/Home/voice_assistant_background.png"
            fillMode: Image.PreserveAspectFit
            opacity: parent.down ? 0.6 : 1

            Image {
                width: 86
                height: 86
                anchors.left: parent.left
                anchors.leftMargin: 17
                anchors.top: parent.top
                anchors.topMargin: 20
                source: "qrc:/Images/Home/voice_assistant.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Label {
            width: 220
            height: 26
            anchors.left: parent.left
            anchors.leftMargin: 118
            anchors.top: parent.top
            anchors.topMargin: 30
            text: qsTr("你可以这样说：")
            color: "#9AFFFFFF"
            font.pixelSize: 16
        }

        Label {
            width: 220
            height: 26
            anchors.left: parent.left
            anchors.leftMargin: 118
            anchors.top: parent.top
            anchors.topMargin: 63
            text: qsTr("小迪去公司的路况怎么样？")
            color: "#FFFFFF"
            font.pixelSize: 18
        }
    }

    Button {
        id: weatherButton
        onClicked: weatherRequested()
        width: 627
        height: 120
        anchors.left: parent.left
        anchors.leftMargin: 551
        anchors.top: parent.top
        anchors.topMargin: 67
        hoverEnabled: false

        background: Image {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: "qrc:/Images/Home/weather_background.png"
            fillMode: Image.PreserveAspectFit
            opacity: parent.down ? 0.6 : 1

            Image {
                width: 76
                height: 65
                anchors.left: parent.left
                anchors.leftMargin: 44
                anchors.top: parent.top
                anchors.topMargin: 28
                source: "qrc:/Images/Home/Weather/sun_clouds.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Label {
            width: 135
            height: 26
            anchors.left: parent.left
            anchors.leftMargin: 172
            anchors.top: parent.top
            anchors.topMargin: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //text: qsTr("南京市 雨花台区")
            text: qsTr("武汉市 洪山区")
            color: "#FFFFFF"
            font.pixelSize: 18
        }

        Label {
            width: 135
            height: 26
            anchors.left: parent.left
            anchors.leftMargin: 172
            anchors.top: parent.top
            anchors.topMargin: 64
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("晴转多云 32°")
            color: "#9AFFFFFF"
            font.pixelSize: 18
        }

        Rectangle {
            width: 3
            height: 55
            anchors.left: parent.left
            anchors.leftMargin: 356
            anchors.top: parent.top
            anchors.topMargin: 31
            color: "#2C333E"
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: 412
            anchors.top: parent.top
            anchors.topMargin: 30
            text: qsTr("空气质量")
            color: "#FFFFFF"
            font.pixelSize: 18
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: 494
            anchors.top: parent.top
            anchors.topMargin: 30
            text: qsTr("优")
            color: "#2D7B87"
            font.pixelSize: 18
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: 412
            anchors.top: parent.top
            anchors.topMargin: 64
            text: qsTr("车内 20  车外 120")
            color: "#9AFFFFFF"
            font.pixelSize: 18
        }
    }

    Label {
        width: 162
        height: 91
        anchors.left: parent.left
        anchors.leftMargin: 1217
        anchors.top: parent.top
        anchors.topMargin: 61
        text: timeText
        color: "#FFFFFF"
        font.pixelSize: 64
    }

    Label {
        width: 162
        height: 26
        anchors.left: parent.left
        anchors.leftMargin: 1217
        anchors.top: parent.top
        anchors.topMargin: 146
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: dateText
        color: "#9AFFFFFF"
        font.pixelSize: 18
    }
}
