import QtQuick
import QtQuick.Controls

Popup {
    id: root

    property string titleText: ""

    function openWithTitle(title) {
        titleText = title
        open()
    }

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
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FFFFFF"
            font.pixelSize: 32
            font.bold: true
            text: titleText
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
            onClicked: root.close()
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
