
import QtQuick.Templates as PopupTemp
import QtQuick
import QtQuick.Controls

import "../screens/control"
import "../components/navigation"
import "../components/base"

Window {
    id: homePage
    width: 1520
    height: 856
    visible: true
    title: qsTr("BYD")

    function showToast(message) {
        toastText.text = message
        toast.opacity = 1
        toastTimer.restart()
    }

    function openPlaceholder(title) {
        placeholderTitle.text = title
        placeholderPopup.open()
    }

    function setPage(page, message) {
        ui.pageIndex = page
        if (message && message.length > 0) {
            showToast(message)
        }
    }

    property int pageIndex: ui.pageIndex
    property int previousPageIndex: 0

    function resolvePageSource(index) {
        if (index === ui.PAGE_HOME) return "../screens/home/Home.qml"
        if (index === ui.PAGE_AC) return "../screens/ac/AC.qml"
        if (index === ui.PAGE_APP) return "../screens/app/App.qml"
        if (index === ui.PAGE_SETTINGS) return "../screens/settings/Settings.qml"
        if (index === ui.PAGE_MUSIC_FULL) return "../screens/music/MusicFull.qml"
        if (index === ui.PAGE_NAVIGATION) return "../screens/navigation/Navigation.qml"
        if (index === ui.PAGE_INSTRUMENT) return "../screens/instrument/Instrument.qml"
        if (index === ui.PAGE_CONTACT) return "../screens/contact/Contact.qml"
        if (index === ui.PAGE_SPLIT) return "../screens/split/Split.qml"
        if (index === ui.PAGE_WEATHER) return "../screens/weather/Weather.qml"
        return ""
    }

    function loadPage(index) {
        const source = resolvePageSource(index)
        if (source.length > 0) {
            pageLoader.source = source
        }
    }

    function showControlCenter() {
        downMoveAnimation.start()
        downOpacityAnimation.start()
    }

    Component.onCompleted: {
        ui.pageIndex = ui.PAGE_HOME
    }

    // 背景
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/Images/Home/base.png"
        fillMode: Image.PreserveAspectCrop
    }

    // 导航栏
    Navigation {
        id: navigation
        width: 108
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top

        onBack: {
            controlCenterPage.hide()
        }

        onHome: {
            controlCenterPage.hide()
            setPage(ui.PAGE_HOME, "")
        }

        onMenu: {
            setPage(ui.PAGE_APP, qsTr("打开应用列表"))
        }

        onRotation: {
            showToast(qsTr("旋转切换（占位演示）"))
        }

        onSplit: {
            setPage(ui.PAGE_SPLIT, qsTr("打开分屏"))
        }

        onShutdown: {
            openPlaceholder(qsTr("关机"))
            showToast(qsTr("关机功能为占位演示"))
        }
    }

    // 界面加载器
    Loader {
        id: pageLoader
        anchors.left: navigation.right
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    // 控制界面
    ControlCenter {
        id: controlCenterPage
        width: 1414
        height: 856
        x: 108
        y: -controlCenterPage.height
    }

    // 滑动区域
    Rectangle {
        width: 1292
        height: 60
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        color: "transparent"

        SwipeArea {
            id: controlSwipeArea
            anchors.fill: parent
            enabled: ui.pageIndex !== ui.PAGE_MUSIC_FULL

            onSwipeDown: showControlCenter()
        }

        // 向下滑动透明度动画
        NumberAnimation {
            id: downOpacityAnimation
            target: controlCenterPage
            properties: "opacity"
            from: 0
            to: 1
            duration: 700
            easing {type: Easing.OutQuad}
        }

        // 向下显示动画
        NumberAnimation {
            id: downMoveAnimation
            target: controlCenterPage
            properties: "y"
            from: -controlCenterPage.height
            to: 0
            duration: 250
            easing {type: Easing.OutQuad}
        }
    }

    onPageIndexChanged: {
        loadPage(pageIndex)
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
