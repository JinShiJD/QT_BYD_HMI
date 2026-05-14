import QtQuick
import QtQuick.Controls

Button {
    id: root

    property bool isPlaying: false

    signal openMusic
    signal previousRequested
    signal playToggled(bool playing)
    signal nextRequested

    width: 310
    height: 387
    anchors.left: parent.left
    anchors.leftMargin: 417
    anchors.top: parent.top
    anchors.topMargin: 235
    hoverEnabled: false

    onClicked: openMusic()

    background: Image {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        source: "qrc:/Images/Home/music.png"
        fillMode: Image.PreserveAspectFit
        opacity: parent.down ? 0.6 : 1
        z: parent.z + 1

        Image {
            width: 104
            height: 104
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 74
            source: "qrc:/Images/Home/music_album.png"
            fillMode: Image.PreserveAspectFit
        }

        Label {
            width: parent.width
            height: 26
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 197
            text: qsTr("Something Just Like This")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#FFFFFF"
            font.pixelSize: 18
            font.bold: true
        }

        Label {
            width: parent.width
            height: 26
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 227
            text: qsTr("The Chainsmokers")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#9AFFFFFF"
            font.pixelSize: 16
        }

        Image {
            width: 279 * 1.15
            height: 97 * 1.15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 266 - 15
            source: "qrc:/Images/Home/music_inner.png"
            fillMode: Image.PreserveAspectFit
            z: parent.z + 1

            Button {
                width: 43
                height: 55
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 7
                hoverEnabled: false
                z: parent.z + 1
                onClicked: previousRequested()

                background: Image {
                    width: 19
                    height: 20
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/music_previous.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: parent.down ? 0.6 : 1
                }
            }

            Button {
                width: 43
                height: 55
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 7
                hoverEnabled: false
                z: parent.z + 1
                onClicked: {
                    root.isPlaying = !root.isPlaying
                    playToggled(root.isPlaying)
                }

                background: Image {
                    width: 19
                    height: 20
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/music_play.png"
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
                anchors.verticalCenterOffset: 7
                hoverEnabled: false
                z: parent.z + 1
                onClicked: nextRequested()

                background: Image {
                    width: 19
                    height: 20
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/music_next.png"
                    fillMode: Image.PreserveAspectFit
                    opacity: parent.down ? 0.6 : 1
                }
            }
        }
    }
}
