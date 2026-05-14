import QtQuick
import QtQuick.Controls

// 空调控制栏
Item {
    id: root

    property string background: "#2B364B"
    property int buttonWidth: width / 4
    property int fontPixelSize: 24
    readonly property var functionLabels: [qsTr("空调"), qsTr("通风加热"), qsTr("滤净"), qsTr("空调设置")]

    // 0-空调
    // 1-通风加热
    // 2-滤净
    // 3-空调设置
    property int functionValue: 0

    function clampIndex(value) {
        return Math.max(0, Math.min(3, value))
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
                    color: "#FFFFFF"
                    font.pixelSize: fontPixelSize
                }
                onClicked: functionValue = index
            }
        }
    }

}
