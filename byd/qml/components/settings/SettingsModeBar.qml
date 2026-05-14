import QtQuick
import QtQuick.Controls

// 设置模式栏
Item {
    id: root

    property string background: "#2B364B"

    // 0-DiLink
    // 1-DiPilot
    // 2-新能源
    // 3-车辆设置
    // 3-车辆健康
    property int functionValue: 0
    property int buttonWidth: 204
    property int buttonHeight: 70
    property int baseY: 83
    property int stepY: 122

    function selectedY(value) {
        return baseY + stepY * value
    }

    // 左侧背景
    Image {
        id: leftBackgroundImage
        anchors.fill: parent
        source: "qrc:/Images/Settings/left_background.png"
        fillMode: Image.Stretch
    }

    // 按钮背景
    Rectangle {
        id: selectedRectangle
        width: buttonWidth
        height: buttonHeight
        anchors.left: parent.left
        anchors.leftMargin: 18
        radius: 51
        y: selectedY(functionValue)
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#43FFFF" }
            GradientStop { position: 1.0; color: "#0978E9" }
        }
        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }
    }


    // DiLink按钮
    RadioButton {
        width: buttonWidth
        height: buttonHeight
        checked: true
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 83
        indicator: Rectangle {color: "transparent"}

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("DiLink")
            color: "#FFFFFF"
            font.pixelSize: 24
        }

        onCheckedChanged: checked ? functionValue = 0 : ""
    }

    // DiPilot按钮
    RadioButton {
        width: buttonWidth
        height: buttonHeight
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 205
        indicator: Rectangle {color: "transparent"}

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("DiPilot")
            color: "#FFFFFF"
            font.pixelSize: 24
        }

        onCheckedChanged: checked ? functionValue = 1 : ""
    }

    // 新能源按钮
    RadioButton {
        width: buttonWidth
        height: buttonHeight
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 327
        indicator: Rectangle {color: "transparent"}

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("新能源")
            color: "#FFFFFF"
            font.pixelSize: 24
        }

        onCheckedChanged: checked ? functionValue = 2 : ""
    }

    // 车辆设置按钮
    RadioButton {
        width: buttonWidth
        height: buttonHeight
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 449
        indicator: Rectangle {color: "transparent"}

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("车辆设置")
            color: "#FFFFFF"
            font.pixelSize: 24
        }

        onCheckedChanged: checked ? functionValue = 3 : ""
    }


    // 车辆健康按钮
    RadioButton {
        width: buttonWidth
        height: buttonHeight
        anchors.left: parent.left
        anchors.leftMargin: 18
        anchors.top: parent.top
        anchors.topMargin: 571
        indicator: Rectangle {color: "transparent"}

        Label {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("车辆健康")
            color: "#FFFFFF"
            font.pixelSize: 24
        }

        onCheckedChanged: checked ? functionValue = 4 : ""
    }

}
