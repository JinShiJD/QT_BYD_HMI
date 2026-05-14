import QtQuick
import QtQuick.Controls

Button {
    id: root

    signal openNavigation
    signal openHome
    signal openCompany
    signal openCharging

    width: 310
    height: 387
    anchors.left: parent.left
    anchors.leftMargin: 79
    anchors.top: parent.top
    anchors.topMargin: 235
    hoverEnabled: false

    onClicked: openNavigation()

    background: Image {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/Images/Home/map.png"
        fillMode: Image.PreserveAspectFit
        opacity: parent.down ? 0.6 : 1
        z: parent.z + 1

        Image {
            width: 279
            height: 97
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 266
            source: "qrc:/Images/Home/map_inner.png"
            fillMode: Image.PreserveAspectFit
            z: parent.z + 1

            Button {
                width: 43
                height: 55
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: false
                z: parent.z + 1
                onClicked: openHome()

                background: Image {
                    width: 29
                    height: 54
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/map_home.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: parent.down ? 0.6 : 1
                }
            }

            Button {
                width: 43
                height: 55
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: false
                z: parent.z + 1
                onClicked: openCompany()

                background: Image {
                    width: 43
                    height: 55
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/map_company.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: parent.down ? 0.6 : 1
                }
            }

            Button {
                width: 43
                height: 55
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                hoverEnabled: false
                z: parent.z + 1
                onClicked: openCharging()

                background: Image {
                    width: 43
                    height: 55
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/map_charging_station.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: parent.down ? 0.6 : 1
                }
            }
        }
    }
}
