import QtQuick
import QtQuick.Controls

Button {
    id: root

    signal openInstrument

    width: 624
    height: 177
    anchors.left: parent.left
    anchors.leftMargin: 756
    anchors.top: parent.top
    anchors.topMargin: 235
    hoverEnabled: false

    onClicked: openInstrument()

    background: Image {
        width: parent.width
        height: parent.height
        source: "qrc:/Images/Home/vehicle_condition.png"
        fillMode: Image.PreserveAspectFit
        opacity: parent.down ? 0.6 : 1
    }

    Label {
        id: daysLabel1
        width: 90
        height: 26
        anchors.left: parent.left
        anchors.leftMargin: 23
        anchors.top: parent.top
        anchors.topMargin: 18
        verticalAlignment: Text.AlignVCenter
        text: qsTr("已安全陪伴您 ")
        color: "#9AFFFFFF"
        font.pixelSize: 16
    }
    Label {
        id: daysLabel
        width: 50
        height: 32
        anchors.left: daysLabel1.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 13
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("267")
        color: "#FFFFFF"
        font.pixelSize: 24
        font.bold: true
    }
    Label {
        id: daysLabel2
        width: 32
        height: 26
        anchors.left: daysLabel.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 18
        verticalAlignment: Text.AlignVCenter
        text: qsTr(" 天")
        color: "#9AFFFFFF"
        font.pixelSize: 16
    }

    Image {
        width: 336
        height: 129
        anchors.left: parent.left
        anchors.leftMargin: 306
        anchors.top: parent.top
        anchors.topMargin: 40
        source: "qrc:/Images/Home/vehicle.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        width: 167
        height: 28
        anchors.left: parent.left
        anchors.leftMargin: 257
        anchors.top: parent.top
        anchors.topMargin: 21
        source: "qrc:/Images/Home/vehicle_condition_good.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        width: 149
        height: 73
        anchors.left: parent.left
        anchors.leftMargin: 23
        anchors.top: parent.top
        anchors.topMargin: 86
        source: "qrc:/Images/Home/vehicle_mileage.png"
        fillMode: Image.PreserveAspectFit
    }
}
