import QtQuick

Item {
    id: root1
    property real value: 0

    width: 300
    height: 300

    function clampValue(value, minValue, maxValue) {
        return Math.min(maxValue, Math.max(minValue, value))
    }

    function needleAngle() {
        return clampValue(value * 2.6 - 130, -130, 133)
    }

    Image {
        id: speedInactive
        x: -9
        y: 8
        opacity: 0.8
        z: 3
        source: "qrc:/Images/Cluster/speed_inactive.png"
    }

    Image {
        id: needle
        x: 136
        y: 86
        clip: true
        opacity: root1.opacity
        z: 3
        smooth: true
        source: "qrc:/Images/Cluster/needle.png"
        transform: Rotation {
            id: needleRotation
            origin.x: 5
            origin.y: 65
            angle: root1.needleAngle()

            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: 0.15
                }
            }
        }
    }
}
