

import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../../components/base"

Item {
    id: controlCenterPage
    width: 1414
    height: 856

    function showToast(message) {
        toastText.text = message
        toast.opacity = 1
        toastTimer.restart()
    }

    function toastForSwitch(enabled, onMsg, offMsg) {
        showToast(enabled ? onMsg : offMsg)
    }

    // 背景
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/Images/ControlCenter/background.png"
        fillMode: Image.PreserveAspectFit

        // 向上滑动区域
        SwipeArea {
            id: upSwipeArea
            anchors.fill: parent

            onSwipeUp: {
                hide()
            }
        }
    }

    // 背景高斯模糊
    GaussianBlur {
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: 8
        samples: 16
    }

    // 向上滑动透明度动画
    NumberAnimation {
        id: upOpacityAnimation
        target: controlCenterPage
        properties: "opacity"
        from: 1
        to: 0
        duration: 250
        easing {type: Easing.OutQuad}  //
    }

    // 向上隐藏动画
    NumberAnimation {
        id: upMoveAnimation
        target: controlCenterPage
        properties: "y"
        from: 0
        to: -controlCenterPage.height
        duration: 250
        easing {type: Easing.OutQuad}
    }

    function startHideAnimation() {
        upMoveAnimation.start()
        upOpacityAnimation.start()
    }

    function hide() {
        if(controlCenterPage.y !== -controlCenterPage.height) {
            startHideAnimation()
        }
    }

    //////////////////////////////////////////////////////
    // Dlink快捷
    Label {
        width: 150
        height: 34
        anchors.left: parent.left
        anchors.leftMargin: 282
        anchors.top: parent.top
        anchors.topMargin: 106
        text: qsTr("Dlink快捷")
        color: "#FFFFFF"
        font.pixelSize: 24
    }

    // 无线网络
    IconSwitch {
        id: wlanSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 277
        anchors.top: parent.top
        anchors.topMargin: 155
        switchStatus: ui.controlCenterWLANStatus
        sourceOn: "qrc:/Images/ControlCenter/wlan_on.png"
        sourceOff: "qrc:/Images/ControlCenter/wlan_off.png"
        text: qsTr("无线网络")

        onSwitchStatusChanged: {
            ui.controlCenterWLANStatus = switchStatus
        }
    }

    // 蓝牙
    IconSwitch {
        id: bluetoothSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 425
        anchors.top: parent.top
        anchors.topMargin: 155
        switchStatus: ui.controlCenterBluetoothStatus
        sourceOn: "qrc:/Images/ControlCenter/bluetooth_on.png"
        sourceOff: "qrc:/Images/ControlCenter/bluetooth_off.png"
        text: qsTr("蓝牙")

        onSwitchStatusChanged: {
            ui.controlCenterBluetoothStatus = switchStatus
        }
    }

    // 主题模式
    IconSwitch {
        id: themeModeSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 573
        anchors.top: parent.top
        anchors.topMargin: 155
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/theme_mode_on.png"
        sourceOff: "qrc:/Images/ControlCenter/theme_mode_off.png"
        text: switchStatus ? qsTr("深色主题") : qsTr("浅色主题")

        onSwitchStatusChanged: toastForSwitch(switchStatus, qsTr("深色主题已开启"), qsTr("浅色主题已开启"))
    }

    // 远程位置
    IconSwitch {
        id: remotePostionSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 277
        anchors.top: parent.top
        anchors.topMargin: 302
        switchStatus: ui.controlCenterPositionStatus
        sourceOn: "qrc:/Images/ControlCenter/romote_postion_on.png"
        sourceOff: "qrc:/Images/ControlCenter/romote_postion_off.png"
        text: qsTr("远程位置")

        onSwitchStatusChanged: {
            ui.controlCenterPositionStatus = switchStatus
        }
    }

    // 千里眼
    IconSwitch {
        id: clairvoyanceSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 425
        anchors.top: parent.top
        anchors.topMargin: 302
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/clairvoyance_on.png"
        sourceOff: "qrc:/Images/ControlCenter/clairvoyance_off.png"
        text: qsTr("千里眼")

        onSwitchStatusChanged: toastForSwitch(switchStatus, qsTr("千里眼已开启"), qsTr("千里眼已关闭"))
    }

    // 自动旋转
    IconSwitch {
        id: autoRotationSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 573
        anchors.top: parent.top
        anchors.topMargin: 302
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/auto_rotation_on.png"
        sourceOff: "qrc:/Images/ControlCenter/auto_rotation_off.png"
        text: qsTr("自动旋转")

        onSwitchStatusChanged: toastForSwitch(switchStatus, qsTr("自动旋转已开启"), qsTr("自动旋转已关闭"))
    }


    //////////////////////////////////////////////////////
    // 整车控制
    Label {
        width: 150
        height: 34
        anchors.left: parent.left
        anchors.leftMargin: 733
        anchors.top: parent.top
        anchors.topMargin: 106
        text: qsTr("整车控制")
        color: "#FFFFFF"
        font.pixelSize: 24
    }

    // 抬头显示
    IconSwitch {
        id: hudSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 721
        anchors.top: parent.top
        anchors.topMargin: 155
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/hud_on.png"
        sourceOff: "qrc:/Images/ControlCenter/hud_off.png"
        sourceWidth: 50
        sourceHeight: 40
        text: qsTr("抬头显示")

        onSwitchStatusChanged: {
            showToast(switchStatus ? qsTr("抬头显示已开启") : qsTr("抬头显示已关闭"))
        }
    }

    // 动态悬架
    IconSwitch {
        id: dynamicSuspensionSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 869
        anchors.top: parent.top
        anchors.topMargin: 155
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/dynamic_suspension_on.png"
        sourceOff: "qrc:/Images/ControlCenter/dynamic_suspension_off.png"
        sourceWidth: 40
        sourceHeight: 40
        text: qsTr("动态悬架")

        onSwitchStatusChanged: {
            showToast(switchStatus ? qsTr("动态悬架已开启") : qsTr("动态悬架已关闭"))
        }
    }

    // 通风加热
    IconSwitch {
        id: ventilationSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 1017
        anchors.top: parent.top
        anchors.topMargin: 155
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/ventilation_on.png"
        sourceOff: "qrc:/Images/ControlCenter/ventilation_off.png"
        sourceWidth: 40
        sourceHeight: 40
        text: qsTr("通风加热")

        onSwitchStatusChanged: {
            showToast(switchStatus ? qsTr("通风加热已开启") : qsTr("通风加热已关闭"))
        }
    }

    // 电除霜
    IconSwitch {
        id: defrostSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 721
        anchors.top: parent.top
        anchors.topMargin: 302
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/defrost_on.png"
        sourceOff: "qrc:/Images/ControlCenter/defrost_off.png"
        sourceWidth: 40
        sourceHeight: 40
        text: qsTr("电除霜")

        onSwitchStatusChanged: {
            showToast(switchStatus ? qsTr("电除霜已开启") : qsTr("电除霜已关闭"))
        }
    }

    // 天窗
    IconSwitch {
        id: windowSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 869
        anchors.top: parent.top
        anchors.topMargin: 302
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/window_on.png"
        sourceOff: "qrc:/Images/ControlCenter/window_off.png"
        sourceWidth: 40
        sourceHeight: 40
        text: qsTr("天窗")

        onSwitchStatusChanged: {
            showToast(switchStatus ? qsTr("天窗已开启") : qsTr("天窗已关闭"))
        }
    }

    // ESP
    IconSwitch {
        id: espSwitch
        width: 113
        height: 113
        anchors.left: parent.left
        anchors.leftMargin: 1017
        anchors.top: parent.top
        anchors.topMargin: 302
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/esp_on.png"
        sourceOff: "qrc:/Images/ControlCenter/esp_off.png"
        sourceWidth: 50
        sourceHeight: 40
        text: qsTr("ESP")

        onSwitchStatusChanged: {
            showToast(switchStatus ? qsTr("ESP 已开启") : qsTr("ESP 已关闭"))
        }
    }

    //////////////////////////////////////////////////////
    // 音量
    Label {
        width: 150
        height: 34
        anchors.left: parent.left
        anchors.leftMargin: 282
        anchors.top: parent.top
        anchors.topMargin: 449
        text: qsTr("音量")
        color: "#FFFFFF"
        font.pixelSize: 24
    }

    // 媒体音量
    QuickSlider {
        id: mediaVolumeSlider
        width: 405
        height: 95
        anchors.left: parent.left
        anchors.leftMargin: 279
        anchors.top: parent.top
        anchors.topMargin: 496
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/volume.png"
        sourceOff: "qrc:/Images/ControlCenter/mute.png"
        sourceWidth: 36
        sourceHeight: 31
        textWidth: 100
        textHeight: sourceHeight
        text: qsTr("媒体音量")
        value: ui.controlCenterMediaVolume
        minValue: 0
        maxValue: 10
        fontColor: "#0BC3C4"

        onValueChanged: {
            ui.controlCenterMediaVolume = value
            showToast(qsTr("媒体音量 ") + value)
        }
    }

    // 导航音量
    QuickSlider {
        id: navigationVolumeSlider
        width: 405
        height: 95
        anchors.left: parent.left
        anchors.leftMargin: 279
        anchors.top: parent.top
        anchors.topMargin: 626
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/volume.png"
        sourceOff: "qrc:/Images/ControlCenter/mute.png"
        sourceWidth: 36
        sourceHeight: 31
        textWidth: 100
        textHeight: sourceHeight
        text: qsTr("导航音量")
        value: 5
        minValue: 0
        maxValue: 10
        fontColor: "#0BC3C4"

        onValueChanged: {
            showToast(qsTr("导航音量 ") + value)
        }
    }

    //////////////////////////////////////////////////////
    // 亮度
    Label {
        width: 150
        height: 34
        anchors.left: parent.left
        anchors.leftMargin: 733
        anchors.top: parent.top
        anchors.topMargin: 449
        text: qsTr("亮度")
        color: "#FFFFFF"
        font.pixelSize: 24
    }

    // 中控亮度
    QuickSlider {
        id: centerControlScreenSlider
        width: 405
        height: 95
        anchors.left: parent.left
        anchors.leftMargin: 725
        anchors.top: parent.top
        anchors.topMargin: 496
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/brightness.png"
        sourceOff: "qrc:/Images/ControlCenter/brightness_off.png"
        sourceWidth: 36
        sourceHeight: 31
        textWidth: 100
        textHeight: sourceHeight
        text: qsTr("中控亮度")
        value: 50
        fontColor: "#3874F2"
        autoMode: 1

        onValueChanged: {
            showToast(qsTr("中控亮度 ") + value)
        }
    }

    // 仪表亮度
    QuickSlider {
        id: meterSlider
        width: 405
        height: 95
        anchors.left: parent.left
        anchors.leftMargin: 725
        anchors.top: parent.top
        anchors.topMargin: 626
        switchStatus: false
        sourceOn: "qrc:/Images/ControlCenter/brightness.png"
        sourceOff: "qrc:/Images/ControlCenter/brightness_off.png"
        sourceWidth: 36
        sourceHeight: 31
        textWidth: 100
        textHeight: sourceHeight
        text: qsTr("仪表亮度")
        value: 50
        fontColor: "#3874F2"
        autoMode: 2

        onValueChanged: {
            showToast(qsTr("仪表亮度 ") + value)
        }
    }

    // 指示条
    Rectangle {
        width: 127
        height: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 811
        radius: height / 2
        color: "#CDFFFFFF"
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
