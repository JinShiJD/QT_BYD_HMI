import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string color: "#FFFFFF"
    property string backgroundColor: "#80000000"
    property string startColor: "#0532FB"
    property string endColor: "#52E6FB"

    property string sourceOn: ""
    property string sourceOff: ""
    property int sourceWidth: 36
    property int sourceHeight: 30
    property int spacing: 5

    property int textWidth: 10
    property int textHeight: 10
    property string text: ""
    property int fontPixelSize: 20
    property int autoFontPixelSize: 14
    property color textColor: "#FFFFFF"
    property color autoTextColor: "#80FFFFFF"

    property bool switchStatus: false

    property int minValue: 0
    property int maxValue: 10
    property int value: 5
    property int stepSize: 1

    function fillWidth(currentValue) {
        if (slider.to <= 0) {
            return 0
        }
        const step = backroundRectangle.width / slider.to
        if (currentValue >= slider.to) {
            return Math.min(backroundRectangle.width, (currentValue + 1) * step)
        }
        return currentValue * step
    }


    Rectangle {
        id: backroundRectangle
        anchors.fill: parent
        color: root.backgroundColor
        radius: 14

        Rectangle {
            id: innerRectangle
            width: root.fillWidth(slider.value)
            height: parent.height
            x: 0
            anchors.verticalCenter: parent.verticalCenter
            radius: 14

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: startColor }
                GradientStop { position: 1.0; color: endColor }
            }
        }

        Slider {
            id: slider
            anchors.fill: parent
            value: root.value
            from: minValue
            to: maxValue
            stepSize: root.stepSize
            focusPolicy: Qt.NoFocus

            background: Rectangle {
                implicitWidth: 0
                implicitHeight: 0
                color: "transparent"
            }

            handle: Rectangle {
                implicitWidth: 0
                implicitHeight: 0
                color: "transparent"
            }

            onValueChanged: {
                root.value = value
            }
        }
    }
}
