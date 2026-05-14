import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string color: "#FFFFFF"
    property string backgroundColor: "#80000000"
    property string fontColor: "#FFFFFF"

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
    property int maxValue: 100
    property int value: 50

    property int autoMode: 0    // 0-默认     1-自动    2-手动

    function sliderFillWidth(currentValue) {
        if (slider.to <= 0) {
            return 0
        }
        const step = backroundRectangle.width / slider.to
        if (currentValue >= slider.to) {
            return Math.min(backroundRectangle.width, (currentValue + 1) * step)
        }
        return currentValue * step
    }

    function sliderFillHeight(currentValue) {
        if (root.maxValue <= 80) {
            return backroundRectangle.height
        }
        switch (currentValue) {
            case 1: return backroundRectangle.height * 0.8
            case 2: return backroundRectangle.height * 0.85
            case 3: return backroundRectangle.height * 0.87
            case 4: return backroundRectangle.height * 0.9
            case 5: return backroundRectangle.height * 0.92
            case 6: return backroundRectangle.height * 0.95
            default: return backroundRectangle.height
        }
    }

    Rectangle {
        id: backroundRectangle
        anchors.fill: parent
        color: root.backgroundColor
        radius: 14

        Rectangle {
            id: innerRectangle
            width: root.sliderFillWidth(slider.value)
            height: root.sliderFillHeight(slider.value)
            x: 0
            anchors.verticalCenter: parent.verticalCenter
            color: root.fontColor
            radius: 14
        }

        Slider {
            id: slider
            anchors.fill: parent
            z: image.z + 1
            value: root.value
            from: root.minValue
            to: root.maxValue
            stepSize: 1
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

        Image {
            id: image
            width: sourceWidth
            height: sourceHeight
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            source: (slider.value > 0) ? root.sourceOn : root.sourceOff
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: label1
            width: root.textWidth
            height: root.textHeight
            anchors.left: image.right
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: (autoMode == 0) ? 33 : 24
            verticalAlignment: Text.AlignVCenter
            text: root.text
            color: textColor
            font.pixelSize: fontPixelSize
        }

        Label {
            id: label2
            width: root.textWidth
            height: root.textHeight
            anchors.left: image.right
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 52
            verticalAlignment: Text.AlignVCenter
            text: (autoMode == 1) ? qsTr("自动") : qsTr("手动")
            color: autoTextColor
            font.pixelSize: autoFontPixelSize
            visible: autoMode != 0
        }
    }
}
