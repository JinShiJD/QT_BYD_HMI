import QtQuick

Item {
    id: root
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
        id: rpmInactive
        x: -10
        y: 0
        opacity: 0.8
        z: 3
        source: "qrc:/Images/Cluster/rpm_inactive.png"
    }

    Image {
        id: needle
        x: 135
        y: 76
        clip: true
        opacity: root.opacity
        z: 3
        smooth: true
        source: "qrc:/Images/Cluster/needle.png"
        transform: Rotation {
            id: needleRotation
            origin.x: 5
            origin.y: 65
            angle: root.needleAngle()

            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: 0.15
                }
            }
        }
    }
}
