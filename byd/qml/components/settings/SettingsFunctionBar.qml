import QtQuick
import QtQuick.Controls

// 设置功能栏
Item {
    id: root

    property string background: "#2B364B"

    // 0-智能底盘
    // 1-灯光氛围
    // 2-抬头显示
    // 3-迎宾
    // 4-智能记忆
    // 5-空调
    // 6-门窗和锁
    // 7-智能提醒
    property int functionValue: 0
    property int buttonWidth: width / 8
    property int xOffset: indicatorRectangle.width / 1.2

    function indicatorX(value) {
        return buttonWidth * value + xOffset
    }


    Image {
        id: functionBackgroundImage
        anchors.fill: parent
        source: "qrc:/Images/Settings/function_background.png"
        fillMode: Image.PreserveAspectFit
    }

    // 按钮背景
    Rectangle {
        id: indicatorRectangle
        width: 52
        height: 9
        anchors.bottom: parent.bottom
        radius: height / 2
        color: "#59EBFD"
        x: indicatorX(functionValue)
        Behavior on x {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 300
            }
        }

    }


    Row {
        anchors.fill: parent

        // 智能底盘按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            checked: true

            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("智能底盘")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 0 : ""
        }

        // 灯光氛围按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("灯光氛围")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 1 : ""
        }

        // 外后视镜按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("抬头显示")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 2 : ""
        }

        // 迎宾按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("迎宾")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 3 : ""
        }

        // 智能记忆按钮
        RadioButton {
            width: buttonWidth
            height: parent.height

            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("智能记忆")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 4 : ""
        }

        // 空调按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("空调")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 5 : ""
        }

        // 门窗和锁按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("门窗和锁")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 6 : ""
        }

        // 智能提醒按钮
        RadioButton {
            width: buttonWidth
            height: parent.height
            indicator: Rectangle {color: "transparent"}

            Label {
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("智能提醒")
                color: "#FFFFFF"
                font.pixelSize: 20
            }

            onCheckedChanged: checked ? ui.settingsFunctionValue = 7 : ""
        }
    }
}
