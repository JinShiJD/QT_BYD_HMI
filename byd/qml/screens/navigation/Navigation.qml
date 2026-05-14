import QtQuick
import QtQuick.Controls
import "../../components/base"
import "../../components/ac"

Item {
    id: navigationPage
    anchors.fill: parent

    property bool navigationActive: false
    property string guidanceDistance: qsTr("302m")
    property string guidanceRoad: qsTr("武汉东路路口")    //qsTr("南京东路路口")
    property string guidanceNext: qsTr("稍后直行150m")
    property real mapZoom: 1
    property real carBob: 0
    property bool compassActive: false
    property bool energyActive: false
    property bool settingsActive: false

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

    function resolveBackPage() {
        var target = ui.previousPageIndex
        if (target === ui.PAGE_NAVIGATION || target === 0) {
            return ui.PAGE_HOME
        }
        return target
    }

    function updateZoom(step, message) {
        const next = mapZoom + step
        mapZoom = Math.max(0.85, Math.min(1.25, next))
        showToast(message)
    }

    function startGuidance(message) {
        navigationActive = true
        showToast(message)
    }

    Item {
        id: mapLayer
        anchors.fill: parent
        transformOrigin: Item.Center
        scale: mapZoom

        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }

        Image {
            id: mapImage
            anchors.fill: parent
            source: "qrc:/Images/Navigation/1_2912.png"
            fillMode: Image.PreserveAspectCrop
            opacity: 0
            scale: 1
            transformOrigin: Item.Center
        }

        Image {
            id: locationPulse
            width: 120
            height: 120
            anchors.centerIn: carMarker
            source: "qrc:/Images/Navigation/1_2908.png"
            fillMode: Image.PreserveAspectFit
            opacity: 0.4
            scale: 0.6
        }

        Image {
            id: carMarker
            width: 72
            height: 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 40
            source: "qrc:/Images/Navigation/1_3097.png"
            fillMode: Image.PreserveAspectFit
            transform: Translate { y: carBob }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#12000000"
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

    Rectangle {
        id: leftToolbar
        width: 74
        height: 620
        radius: 36
        anchors.left: parent.left
        anchors.leftMargin: 22
        anchors.top: parent.top
        anchors.topMargin: 80
        color: "#1D2433"
        opacity: 0.9

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 18
            spacing: 14

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.94 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: "#263145"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 44
                    height: 44
                    source: "qrc:/Images/Home/portrait.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: showToast(qsTr("个人中心"))
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: parent.down ? "#2B364B" : "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: "qrc:/Images/Home/back.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    ui.pageIndex = resolveBackPage()
                }
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: parent.down ? "#2B364B" : "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    source: "qrc:/Images/Home/home.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: setPage(ui.PAGE_HOME, "")
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: parent.down ? "#2B364B" : "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    source: "qrc:/Images/Home/split.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: setPage(ui.PAGE_SPLIT, qsTr("打开分屏"))
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: parent.down ? "#2B364B" : "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    source: "qrc:/Images/Home/rotation.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: showToast(qsTr("视角"))
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: parent.down ? "#2B364B" : "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    source: "qrc:/Images/Home/menu.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: {
                    setPage(ui.PAGE_APP, qsTr("打开应用列表"))
                }
            }

            Item { width: 1; height: 10 }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle {
                    anchors.fill: parent
                    radius: 26
                    color: parent.down ? "#2B364B" : "transparent"
                }
                contentItem: Image {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    source: "qrc:/Images/Home/shutdown.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: showToast(qsTr("返回"))
            }
        }
    }

    Rectangle {
        id: searchPanel
        width: 330
        height: 196
        radius: 20
        anchors.left: parent.left
        anchors.leftMargin: 120
        anchors.top: parent.top
        anchors.topMargin: 90
        color: "#2B3346"
        opacity: navigationActive ? 0 : 0.95
        scale: navigationActive ? 0.96 : 1
        visible: !navigationActive

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            Rectangle {
                width: parent.width
                height: 52
                radius: 14
                color: "#35415B"
                MouseArea {
                    anchors.fill: parent
                    onClicked: showToast(qsTr("搜索目的地"))
                }
                Row {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    Image {
                        width: 20
                        height: 20
                        source: "qrc:/Images/StatusBar/position.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: qsTr("搜索目的地")
                        color: "#9AFFFFFF"
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 54
                radius: 14
                color: "#303A50"
                Button {
                    anchors.fill: parent
                    hoverEnabled: false
                    scale: down ? 0.98 : 1
                    Behavior on scale { NumberAnimation { duration: 120 } }
                    background: Rectangle { color: "transparent"; radius: 14 }
                    contentItem: Row {
                        spacing: 12
                        anchors.fill: parent
                        anchors.margins: 12
                        Image {
                            width: 22
                            height: 22
                            source: "qrc:/Images/Home/map_home.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            text: qsTr("回家")
                            color: "#FFFFFF"
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Item { width: Math.max(0, parent.width - 190); height: 1 }
                        Label {
                            text: qsTr("点击设置")
                            color: "#7AD9FF"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: {
                        startGuidance(qsTr("开始导航：回家"))
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 54
                radius: 14
                color: "#303A50"
                Button {
                    anchors.fill: parent
                    hoverEnabled: false
                    scale: down ? 0.98 : 1
                    Behavior on scale { NumberAnimation { duration: 120 } }
                    background: Rectangle { color: "transparent"; radius: 14 }
                    contentItem: Row {
                        spacing: 12
                        anchors.fill: parent
                        anchors.margins: 12
                        Image {
                            width: 22
                            height: 22
                            source: "qrc:/Images/Home/map_company.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            text: qsTr("去公司")
                            color: "#FFFFFF"
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Item { width: Math.max(0, parent.width - 190); height: 1 }
                        Label {
                            text: qsTr("点击设置")
                            color: "#7AD9FF"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    onClicked: {
                        startGuidance(qsTr("开始导航：公司"))
                    }
                }
            }
        }
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
    }

    Rectangle {
        id: guidancePanel
        width: 330
        height: 116
        radius: 20
        anchors.left: parent.left
        anchors.leftMargin: 120
        anchors.top: parent.top
        anchors.topMargin: 90
        color: "#2B3346"
        opacity: navigationActive ? 0.95 : 0
        scale: navigationActive ? 1 : 0.96
        visible: navigationActive

        Row {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Rectangle {
                width: 64
                height: 64
                radius: 16
                color: "#36405A"
                Label {
                    anchors.centerIn: parent
                    text: qsTr("↱")
                    color: "#FFFFFF"
                    font.pixelSize: 30
                }
            }

            Column {
                spacing: 6
                Label {
                    text: guidanceDistance
                    color: "#FFFFFF"
                    font.pixelSize: 26
                    font.bold: true
                }
                Label {
                    text: guidanceRoad
                    color: "#9AFFFFFF"
                    font.pixelSize: 16
                }
                Label {
                    text: guidanceNext
                    color: "#7AD9FF"
                    font.pixelSize: 14
                }
            }
        }
        Behavior on opacity { NumberAnimation { duration: 200 } }
        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutQuad } }
    }

    Rectangle {
        id: zoomPanel
        width: 54
        height: 128
        radius: 27
        anchors.left: parent.left
        anchors.leftMargin: 110
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 120
        color: "#2B3346"
        opacity: 0.9

        Column {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 8

            Button {
                width: 42
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle { radius: 20; color: parent.down ? "#3B4760" : "transparent" }
                contentItem: Label {
                    text: "+"
                    color: "#FFFFFF"
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    updateZoom(0.05, qsTr("放大"))
                }
            }
            Button {
                width: 42
                height: 52
                hoverEnabled: false
                scale: down ? 0.92 : 1
                Behavior on scale { NumberAnimation { duration: 120 } }
                background: Rectangle { radius: 20; color: parent.down ? "#3B4760" : "transparent" }
                contentItem: Label {
                    text: "−"
                    color: "#FFFFFF"
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    updateZoom(-0.05, qsTr("缩小"))
                }
            }
        }
    }

    Column {
        id: rightTools
        anchors.right: parent.right
        anchors.rightMargin: 26
        anchors.top: parent.top
        anchors.topMargin: 150
        spacing: 16

        Button {
            width: 48
            height: 48
            hoverEnabled: false
            scale: down ? 0.92 : 1
            Behavior on scale { NumberAnimation { duration: 120 } }
            background: Rectangle { radius: 24; color: compassActive ? "#3B4A66" : "#2B3346" }
            contentItem: Label {
                id: compassLabel
                text: "N"
                color: "#FFFFFF"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                rotation: 0
            }
            onClicked: {
                compassActive = !compassActive
                compassSpin.restart()
                showToast(qsTr("指南针"))
            }
        }
        Button {
            width: 48
            height: 48
            hoverEnabled: false
            scale: down ? 0.92 : 1
            Behavior on scale { NumberAnimation { duration: 120 } }
            background: Rectangle { radius: 24; color: energyActive ? "#3B4A66" : "#2B3346" }
            contentItem: Label {
                text: qsTr("⚡")
                color: "#FFFFFF"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                energyActive = !energyActive
                showToast(qsTr("能量站"))
            }
        }
        Button {
            width: 48
            height: 48
            hoverEnabled: false
            scale: down ? 0.92 : 1
            Behavior on scale { NumberAnimation { duration: 120 } }
            background: Rectangle { radius: 24; color: settingsActive ? "#3B4A66" : "#2B3346" }
            contentItem: Label {
                text: qsTr("⚙")
                color: "#FFFFFF"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                settingsActive = !settingsActive
                showToast(qsTr("导航设置"))
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
        onNavigation: showToast(qsTr("导航"))
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

    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: locationPulse; property: "scale"; from: 0.6; to: 1.2; duration: 1400; easing.type: Easing.OutQuad }
        NumberAnimation { target: locationPulse; property: "opacity"; from: 0.4; to: 0; duration: 1400; easing.type: Easing.OutQuad }
    }

    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: navigationPage; property: "carBob"; from: -4; to: 4; duration: 1600; easing.type: Easing.InOutQuad }
        NumberAnimation { target: navigationPage; property: "carBob"; from: 4; to: -4; duration: 1600; easing.type: Easing.InOutQuad }
    }

    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: mapImage; property: "scale"; from: 1.0; to: 1.02; duration: 6000; easing.type: Easing.InOutQuad }
        NumberAnimation { target: mapImage; property: "scale"; from: 1.02; to: 1.0; duration: 6000; easing.type: Easing.InOutQuad }
    }

    NumberAnimation {
        id: mapFadeAnimation
        target: mapImage
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.OutQuad
        running: true
    }

    NumberAnimation {
        id: compassSpin
        target: compassLabel
        property: "rotation"
        from: 0
        to: 360
        duration: 600
        easing.type: Easing.OutCubic
    }
}
