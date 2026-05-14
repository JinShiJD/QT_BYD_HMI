import QtQuick
import QtQuick.Controls

// 空调控制栏
Item {
    id: root

    property string background: "#5A364A5E"
    property string textColor: "#FFFFFF"
    property string function1Text: ""
    property string function2Text: ""
    property int fontPixelSize: 16
    property int buttonWidth: width / 2

    property int functionValue: 0
    readonly property var functionLabels: [function1Text, function2Text]

    function clampIndex(value) {
        return Math.max(0, Math.min(1, value))
    }

    function selectedX(value) {
        return clampIndex(value) * buttonWidth
    }


    // 背景
    Rectangle {
        anchors.fill: parent
        color: parent.background
        radius: 43
    }

    // 按钮背景
    Rectangle {
        id: selectedRectangle
        width: buttonWidth
        height: parent.height
        y: 0
        radius: 51
        x: selectedX(functionValue)
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#43FFFF" }
            GradientStop { position: 1.0; color: "#0978E9" }
        }
        Behavior on x {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }
    }


    ButtonGroup { id: buttonGroup }

    Row {
        anchors.fill: parent
        Repeater {
            model: functionLabels.length
            delegate: RadioButton {
                width: buttonWidth
                height: parent.height
                ButtonGroup.group: buttonGroup
                checked: index === functionValue
                indicator: Rectangle { color: "transparent" }
                contentItem: Label {
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: functionLabels[index]
                    color: textColor
                    font.pixelSize: fontPixelSize
                }
                onClicked: functionValue = index
            }
        }
    }

}
