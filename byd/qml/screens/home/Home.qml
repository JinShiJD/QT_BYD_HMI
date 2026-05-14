

import QtQuick
import QtQuick.Controls
import "../../components/base"
import "../../components/ac"
import "./parts"

Item {
    id: homePage

    anchors.fill: parent

    function showToast(message) {
        homeToast.show(message)
    }

    function openPlaceholder(title) {
        placeholderPopup.openWithTitle(title)
    }

    function openPlaceholderAndToast(title, message) {
        openPlaceholder(title)
        showToast(message)
    }

    function jumpTo(page, toastMessage) {
        ui.pageIndex = page
        if (toastMessage && toastMessage.length > 0) {
            showToast(toastMessage)
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
    HomeHeader {
        id: homeHeader
        anchors.fill: parent
        onVoiceRequested: openPlaceholderAndToast(qsTr("语音助手"), qsTr("语音助手功能为占位演示"))
        onWeatherRequested: jumpTo(ui.PAGE_WEATHER, qsTr("打开天气"))
    }

    HomeMapCard {
        id: homeMapCard
        onOpenNavigation: jumpTo(ui.PAGE_NAVIGATION, qsTr("打开导航"))
        onOpenHome: jumpTo(ui.PAGE_NAVIGATION, qsTr("开始导航：回家"))
        onOpenCompany: jumpTo(ui.PAGE_NAVIGATION, qsTr("开始导航：公司"))
        onOpenCharging: jumpTo(ui.PAGE_NAVIGATION, qsTr("开始导航：附近充电站"))
    }

    HomeMusicCard {
        id: homeMusicCard
        onOpenMusic: jumpTo(ui.PAGE_MUSIC_FULL, "")
        onPreviousRequested: showToast(qsTr("上一曲（占位）"))
        onPlayToggled: showToast(playing ? qsTr("播放 / Resume（占位）") : qsTr("暂停（占位）"))
        onNextRequested: showToast(qsTr("下一曲（占位）"))
    }

    HomeVehicleCard {
        id: homeVehicleCard
        onOpenInstrument: jumpTo(ui.PAGE_INSTRUMENT, qsTr("打开仪表"))
    }

    HomeRadioCard {
        id: homeRadioCard
        onOpenRadio: openPlaceholderAndToast(qsTr("收音机"), qsTr("收音机界面（占位演示）"))
    }

    HomeAppButton {
        id: homeAppButton
        onOpenApp: jumpTo(ui.PAGE_APP, "")
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
            jumpTo(ui.PAGE_AC, qsTr("进入空调界面"))
        }
        onNavigation: {
            jumpTo(ui.PAGE_NAVIGATION, qsTr("打开导航"))
        }
        onDefrost: {
            showToast(qsTr("除霜功能已切换"))
        }
        onMusic: {
            jumpTo(ui.PAGE_MUSIC_FULL, "")
        }
        onContact: {
            jumpTo(ui.PAGE_CONTACT, qsTr("打开联系人"))
        }
    }

    HomePlaceholderPopup {
        id: placeholderPopup
    }

    HomeToast {
        id: homeToast
    }
}
