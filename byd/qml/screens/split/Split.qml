import QtQuick
import QtQuick.Controls
import "../../components/base"
import "../../components/ac"

Item {
    id: splitPage
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

    Component.onCompleted: fadeInAnimation.start()

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

    Row {
        id: splitRow
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 90
        anchors.bottom: acBar.top
        anchors.bottomMargin: 18
        spacing: 24

        Rectangle {
            id: navPanel
            width: 620
            radius: 22
            color: "#1F2736"

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                Row {
                    spacing: 12
                    Label {
                        text: qsTr("导航分屏")
                        color: "#FFFFFF"
                        font.pixelSize: 24
                        font.bold: true
                    }
                    Rectangle {
                        width: 56
                        height: 24
                        radius: 12
                        color: "#2B364B"
                        Label {
                            anchors.centerIn: parent
                            text: qsTr("实时")
                            color: "#7AD9FF"
                            font.pixelSize: 12
                        }
                    }
                }

                Rectangle {
                    id: miniMap
                    width: parent.width
                    height: 320
                    radius: 18
                    color: "#2B3346"
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: "qrc:/Images/Navigation/1_2912.png"
                        fillMode: Image.PreserveAspectCrop
                    }

                    Rectangle {
                        width: 220
                        height: 96
                        radius: 16
                        color: "#1C2534"
                        opacity: 0.9
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 14

                        Column {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6
                            Label {
                                text: qsTr("302m")
                                color: "#FFFFFF"
                                font.pixelSize: 20
                                font.bold: true
                            }
                            Label {
                                text: qsTr("南京东路路口")
                                color: "#9AFFFFFF"
                                font.pixelSize: 14
                            }
                            Label {
                                text: qsTr("稍后直行150m")
                                color: "#7AD9FF"
                                font.pixelSize: 12
                            }
                        }
                    }
                }

                Row {
                    spacing: 14
                    Rectangle {
                        width: 190
                        height: 52
                        radius: 16
                        color: "#2B364B"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: showToast(qsTr("开始导航：回家"))
                        }
                        Row {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 10
                            Image {
                                width: 24
                                height: 24
                                source: "qrc:/Images/Home/map_home.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Label {
                                text: qsTr("回家")
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Rectangle {
                        width: 190
                        height: 52
                        radius: 16
                        color: "#2B364B"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: showToast(qsTr("开始导航：公司"))
                        }
                        Row {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 10
                            Image {
                                width: 24
                                height: 24
                                source: "qrc:/Images/Home/map_company.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Label {
                                text: qsTr("公司")
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rightPanel
            radius: 22
            color: "#1F2736"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width - navPanel.width - splitRow.spacing

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 18

                Rectangle {
                    id: musicCard
                    width: parent.width
                    height: 200
                    radius: 18
                    color: "#243045"

                    Row {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 20

                        Image {
                            width: 140
                            height: 140
                            source: "qrc:/Images/Home/music_album.png"
                            fillMode: Image.PreserveAspectFit
                        }

                        Column {
                            spacing: 10
                            anchors.verticalCenter: parent.verticalCenter
                            Label {
                                text: qsTr("喜欢你")
                                color: "#FFFFFF"
                                font.pixelSize: 22
                                font.bold: true
                            }
                            Label {
                                text: qsTr("G.E.M. 邓紫棋")
                                color: "#9AFFFFFF"
                                font.pixelSize: 16
                            }
                            Row {
                                spacing: 16
                                Button {
                                    width: 46
                                    height: 46
                                    hoverEnabled: false
                                    onClicked: showToast(qsTr("上一曲"))
                                    background: Image {
                                        anchors.fill: parent
                                        source: "qrc:/Images/Home/music_previous.png"
                                        fillMode: Image.PreserveAspectFit
                                        opacity: parent.down ? 0.6 : 1
                                    }
                                }
                                Button {
                                    width: 46
                                    height: 46
                                    hoverEnabled: false
                                    onClicked: showToast(qsTr("播放"))
                                    background: Image {
                                        anchors.fill: parent
                                        source: "qrc:/Images/Home/music_play.png"
                                        fillMode: Image.PreserveAspectFit
                                        opacity: parent.down ? 0.6 : 1
                                    }
                                }
                                Button {
                                    width: 46
                                    height: 46
                                    hoverEnabled: false
                                    onClicked: showToast(qsTr("下一曲"))
                                    background: Image {
                                        anchors.fill: parent
                                        source: "qrc:/Images/Home/music_next.png"
                                        fillMode: Image.PreserveAspectFit
                                        opacity: parent.down ? 0.6 : 1
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: contactCard
                    width: parent.width
                    height: 170
                    radius: 18
                    color: "#243045"

                    Row {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 18

                        Rectangle {
                            width: 64
                            height: 64
                            radius: 32
                            color: "#3874F2"
                            Label {
                                anchors.centerIn: parent
                                text: qsTr("李")
                                color: "#FFFFFF"
                                font.pixelSize: 24
                                font.bold: true
                            }
                        }

                        Column {
                            spacing: 8
                            anchors.verticalCenter: parent.verticalCenter
                            Label {
                                text: qsTr("李娜")
                                color: "#FFFFFF"
                                font.pixelSize: 22
                                font.bold: true
                            }
                            Label {
                                text: qsTr("138 0000 1234")
                                color: "#9AFFFFFF"
                                font.pixelSize: 16
                            }
                            Row {
                                spacing: 12
                                Button {
                                    width: 104
                                    height: 38
                                    onClicked: showToast(qsTr("拨打李娜"))
                                    contentItem: Label {
                                        text: qsTr("拨打")
                                        color: "#FFFFFF"
                                        font.pixelSize: 16
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        color: parent.down ? "#2C333E" : "#3874F2"
                                        radius: 20
                                    }
                                }
                                Button {
                                    width: 104
                                    height: 38
                                    onClicked: showToast(qsTr("发短信"))
                                    contentItem: Label {
                                        text: qsTr("短信")
                                        color: "#FFFFFF"
                                        font.pixelSize: 16
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        color: parent.down ? "#2C333E" : "#2B364B"
                                        radius: 20
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: quickCard
                    width: parent.width
                    height: 96
                    radius: 18
                    color: "#243045"

                    Row {
                        anchors.centerIn: parent
                        spacing: 20

                        Button {
                            width: 90
                            height: 56
                            hoverEnabled: false
                            onClicked: setPage(ui.PAGE_MUSIC_FULL, "")
                            contentItem: Label {
                                text: qsTr("音乐")
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: parent.down ? "#2C333E" : "#2B364B"
                                radius: 18
                            }
                        }

                        Button {
                            width: 90
                            height: 56
                            hoverEnabled: false
                            onClicked: setPage(ui.PAGE_NAVIGATION, qsTr("打开导航"))
                            contentItem: Label {
                                text: qsTr("导航")
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: parent.down ? "#2C333E" : "#2B364B"
                                radius: 18
                            }
                        }

                        Button {
                            width: 90
                            height: 56
                            hoverEnabled: false
                            onClicked: setPage(ui.PAGE_CONTACT, qsTr("打开联系人"))
                            contentItem: Label {
                                text: qsTr("联系人")
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: parent.down ? "#2C333E" : "#2B364B"
                                radius: 18
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
