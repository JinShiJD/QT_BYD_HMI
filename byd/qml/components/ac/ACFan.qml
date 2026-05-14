import QtQuick
import QtQuick.Controls
import "../base"

// 空调风量
Popup {
    id: root

    property string backgroundColor: "#222A3B"
    property int realLevel: 5
    property int fanLevel: fanSlider.value

    property int delay: 3000

    function clampValue(value, minValue, maxValue) {
        return Math.max(minValue, Math.min(maxValue, value))
    }

    function bumpFan(delta) {
        timer.restart()
        fanSlider.value = clampValue(fanSlider.value + delta, fanSlider.from, fanSlider.to)
    }

    onOpened: {
        timer.restart()
    }

    closePolicy: Popup.CloseOnPressOutside
    modal: false
    parent: Overlay.overlay


    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 300
            easing: {type: Easing.OutQuad}
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 300
            easing: {type: Easing.OutQuad}
        }
    }

    Timer {
        id: timer
        interval: root.delay
        repeat: false

        onTriggered: {
            root.close()
        }
    }

    // 风量
    background: Rectangle {
        id: backgroundRectangle
        anchors.fill: parent
        radius: 63
        color: backgroundColor
        opacity: 0.7
    }

    ColorSlider {
        id: fanSlider
        width: 535
        height: 19
        anchors.centerIn: parent
        minValue: 0
        maxValue: 10
        value: ui.acFanLevel

        onValueChanged: {
            timer.restart()
            ui.acFanLevel = value
        }
    }

    // 风量-按钮
    Button {
        id: subButton
        width: 50
        height: 50
        anchors.left: parent.left
        anchors.leftMargin: 39
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: false
        autoRepeat: true
        autoRepeatInterval: 200

        background: Image {
            width: 21
            height: 21
            anchors.centerIn: parent
            source: "qrc:/Images/ACFan/fan_sub.png"
            fillMode: Image.PreserveAspectFit
            opacity: parent.down ? 0.6 : 1
        }

        onPressed: timer.restart()
        onClicked: bumpFan(-1)
        onPressAndHold: bumpFan(-1)
    }

    // 风量+按钮
    Button {
        id: addButton
        width: 50
        height: 50
        anchors.right: parent.right
        anchors.rightMargin: 39
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: false
        autoRepeat: true
        autoRepeatInterval: 200

        background: Image {
            width: 33
            height: 33
            anchors.centerIn: parent
            source: "qrc:/Images/ACFan/fan_add.png"
            fillMode: Image.PreserveAspectFit
            opacity: parent.down ? 0.6 : 1
        }

        onPressed: timer.restart()
        onClicked: bumpFan(1)
        onPressAndHold: bumpFan(1)
    }
}
