import QtQuick
import QtQuick.Controls
import "../../components/base"
import "../../components/ac"

Item {
    id: contactPage

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

    property var contacts: [
        { name: "李娜", phone: "138 0000 1234", company: "比亚迪 · 研发中心", city: "深圳", tag: "常用", color: "#3874F2" },
        { name: "王刚", phone: "139 1122 3344", company: "BYD · 供应链", city: "上海", tag: "最近", color: "#2BC3A7" },
        { name: "刘诗", phone: "137 2233 4455", company: "BYD · 设计中心", city: "西安", tag: "常用", color: "#FF9F4D" },
        { name: "陈昊", phone: "186 7788 9900", company: "BYD · 智能座舱", city: "广州", tag: "最近", color: "#8A7BFF" },
        { name: "张宁", phone: "185 6677 8899", company: "BYD · 软件平台", city: "北京", tag: "常用", color: "#5DC2FF" },
        { name: "周静", phone: "181 5566 7788", company: "BYD · 运营中心", city: "杭州", tag: "最近", color: "#FF7AA2" }
    ]

    property int selectedIndex: 0
    property var currentContact: ({ name: "", phone: "", company: "", city: "", tag: "", color: "#3874F2" })

    function contactAt(index) {
        if (index < 0 || index >= contacts.length) {
            return { name: "", phone: "", company: "", city: "", tag: "", color: "#3874F2" }
        }
        return contacts[index]
    }

    onSelectedIndexChanged: currentContact = contactAt(selectedIndex)

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

    Component.onCompleted: {
        currentContact = contactAt(selectedIndex)
        fadeInAnimation.start()
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

    Row {
        id: contentRow
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
            id: listPanel
            width: 480
            radius: 22
            color: "#1F2736"

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 18

                Row {
                    id: headerRow
                    spacing: 12
                    Label {
                        text: qsTr("联系人")
                        color: "#FFFFFF"
                        font.pixelSize: 28
                        font.bold: true
                    }
                    Label {
                        text: qsTr("共 ") + contacts.length + qsTr(" 位")
                        color: "#9AFFFFFF"
                        font.pixelSize: 16
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    id: searchBar
                    height: 44
                    radius: 22
                    color: "#2B364B"
                    anchors.left: parent.left
                    anchors.right: parent.right

                    TextField {
                        anchors.fill: parent
                        anchors.margins: 10
                        placeholderText: qsTr("搜索联系人")
                        color: "#FFFFFF"
                        font.pixelSize: 16
                        background: Rectangle { color: "transparent" }
                    }
                }

                ListView {
                    id: contactList
                    width: parent.width
                    height: parent.height - headerRow.height - searchBar.height - 36
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: contacts
                    currentIndex: selectedIndex
                    onCurrentIndexChanged: selectedIndex = currentIndex

                    delegate: Rectangle {
                        width: contactList.width
                        height: 68
                        radius: 16
                        color: ListView.isCurrentItem ? "#2E3A52" : "transparent"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: contactList.currentIndex = index
                        }

                        Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            color: modelData.color
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter

                            Label {
                                anchors.centerIn: parent
                                text: modelData.name.length > 0 ? modelData.name[0] : ""
                                color: "#FFFFFF"
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.leftMargin: 68
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4
                            Label {
                                text: modelData.name
                                color: "#FFFFFF"
                                font.pixelSize: 18
                            }
                            Label {
                                text: modelData.phone
                                color: "#9AFFFFFF"
                                font.pixelSize: 14
                            }
                        }

                        Rectangle {
                            width: 56
                            height: 24
                            radius: 12
                            color: "#2B364B"
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            Label {
                                anchors.centerIn: parent
                                text: modelData.tag
                                color: "#7AD9FF"
                                font.pixelSize: 12
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: detailPanel
            radius: 22
            color: "#1F2736"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: parent.width - listPanel.width - contentRow.spacing

            Column {
                anchors.fill: parent
                anchors.margins: 28
                spacing: 20

                Row {
                    spacing: 18
                    Rectangle {
                        width: 88
                        height: 88
                        radius: 44
                        color: currentContact.color
                        Label {
                            anchors.centerIn: parent
                            text: currentContact.name.length > 0 ? currentContact.name[0] : ""
                            color: "#FFFFFF"
                            font.pixelSize: 30
                            font.bold: true
                        }
                    }

                    Column {
                        spacing: 6
                        Label {
                            text: currentContact.name
                            color: "#FFFFFF"
                            font.pixelSize: 28
                            font.bold: true
                        }
                        Label {
                            text: currentContact.company
                            color: "#9AFFFFFF"
                            font.pixelSize: 16
                        }
                        Label {
                            text: currentContact.city
                            color: "#7AD9FF"
                            font.pixelSize: 14
                        }
                    }
                }

                Row {
                    spacing: 12
                    Button {
                        width: 120
                        height: 44
                        onClicked: showToast(qsTr("拨打 ") + currentContact.name)
                        contentItem: Label {
                            text: qsTr("拨打")
                            color: "#FFFFFF"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.down ? "#2C333E" : "#3874F2"
                            radius: 22
                        }
                    }
                    Button {
                        width: 120
                        height: 44
                        onClicked: showToast(qsTr("发短信给 ") + currentContact.name)
                        contentItem: Label {
                            text: qsTr("短信")
                            color: "#FFFFFF"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.down ? "#2C333E" : "#2B364B"
                            radius: 22
                        }
                    }
                    Button {
                        width: 120
                        height: 44
                        onClicked: showToast(qsTr("已收藏 ") + currentContact.name)
                        contentItem: Label {
                            text: qsTr("收藏")
                            color: "#FFFFFF"
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.down ? "#2C333E" : "#2B364B"
                            radius: 22
                        }
                    }
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    color: "#2C333E"
                }

                Column {
                    spacing: 16
                    Row {
                        spacing: 12
                        Label {
                            width: 80
                            text: qsTr("手机号")
                            color: "#9AFFFFFF"
                            font.pixelSize: 16
                        }
                        Label {
                            text: currentContact.phone
                            color: "#FFFFFF"
                            font.pixelSize: 18
                        }
                    }
                    Row {
                        spacing: 12
                        Label {
                            width: 80
                            text: qsTr("公司")
                            color: "#9AFFFFFF"
                            font.pixelSize: 16
                        }
                        Label {
                            text: currentContact.company
                            color: "#FFFFFF"
                            font.pixelSize: 18
                        }
                    }
                    Row {
                        spacing: 12
                        Label {
                            width: 80
                            text: qsTr("地区")
                            color: "#9AFFFFFF"
                            font.pixelSize: 16
                        }
                        Label {
                            text: currentContact.city
                            color: "#FFFFFF"
                            font.pixelSize: 18
                        }
                    }
                    Row {
                        spacing: 12
                        Label {
                            width: 80
                            text: qsTr("标签")
                            color: "#9AFFFFFF"
                            font.pixelSize: 16
                        }
                        Label {
                            text: currentContact.tag
                            color: "#7AD9FF"
                            font.pixelSize: 18
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
        onContact: showToast(qsTr("联系人"))
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
