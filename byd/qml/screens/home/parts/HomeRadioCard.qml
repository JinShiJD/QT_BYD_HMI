import QtQuick
import QtQuick.Controls

Button {
    id: root

    signal openRadio

    width: 414
    height: 177
    anchors.left: parent.left
    anchors.leftMargin: 756
    anchors.top: parent.top
    anchors.topMargin: 446
    hoverEnabled: false

    onClicked: openRadio()

    background: Image {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/Images/Home/radio_background.png"
        fillMode: Image.PreserveAspectFit
        opacity: parent.down ? 0.6 : 1

        Image {
            width: 93
            height: 29
            anchors.left: parent.left
            anchors.leftMargin: 23
            anchors.top: parent.top
            anchors.topMargin: 20
            source: "qrc:/Images/Home/radio_logo.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            width: 131
            height: 59
            anchors.left: parent.left
            anchors.leftMargin: 23
            anchors.top: parent.top
            anchors.topMargin: 92
            source: "qrc:/Images/Home/radio_slogan.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            width: 120
            height: 120
            anchors.left: parent.left
            anchors.leftMargin: 271
            anchors.top: parent.top
            anchors.topMargin: 31
            source: "qrc:/Images/Home/radio.png"
            fillMode: Image.PreserveAspectFit
        }
    }
}
