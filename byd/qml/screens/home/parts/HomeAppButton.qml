import QtQuick
import QtQuick.Controls

Button {
    id: root

    signal openApp

    width: 220
    height: 217
    anchors.left: parent.left
    anchors.leftMargin: 1159
    anchors.top: parent.top
    anchors.topMargin: 439
    hoverEnabled: false

    onClicked: openApp()

    background: Image {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/Images/Home/app.png"
        fillMode: Image.PreserveAspectFit
        opacity: parent.down ? 0.6 : 1
    }
}
