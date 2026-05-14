import QtQuick

Item {
    id: root1
    property real value: 0
    property real baseAngle: -60

    width: 150
    height: 70
    transformOrigin: Item.Center

    function needleAngle() {
        return value + baseAngle
    }

    Image {
        id: needle
        x: 72
        y: 29
        width: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -2
        opacity: 1
        clip: true
        z: 4
        smooth: true
        source: "qrc:/Images/Cluster/fuelneedle.png"
        transform: Rotation {
            id: needleRotation
            origin.x: 5
            origin.y: 42
            angle: root1.needleAngle()

            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: 0.15
                }
            }
        }
    }

    Image {
        id: background
        x: 1
        y: 1
        z: 0
        source: "qrc:/Images/Cluster/fuel_gauge.png"
    }
}
