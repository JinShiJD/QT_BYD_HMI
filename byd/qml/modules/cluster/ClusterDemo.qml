import QtQuick

Rectangle {
    id: root
    width: 800
    height: 480
    color: "#0d1522"

    property bool started: true

    property real speedKph: 0
    property real rpm: 0
    property real fuelPercent: 72
    property string gearText: "D"

    property bool leftSignal: false
    property bool rightSignal: false
    property bool leftBlinkPhase: false
    property bool rightBlinkPhase: false

    readonly property color accent: "#35d7ff"
    readonly property color accent2: "#2df2b5"
    readonly property color fg: "#eaf2ff"
    readonly property color fgDim: "#9ab0c6"
    readonly property color danger: "#ff3b55"

    function clampValue(value, minValue, maxValue) {
        return Math.max(minValue, Math.min(maxValue, value))
    }

    function currentTimeString() {
        return Qt.formatTime(new Date(), "hh:mm")
    }

    function setStarted(on) {
        started = on
        if (started) {
            intro.restart()
            speedTimer.running = true
            blinkTimer.running = true
        } else {
            speedTimer.running = false
            blinkTimer.running = false
            leftSignal = false
            rightSignal = false
            leftBlinkPhase = false
            rightBlinkPhase = false
            speedKph = 0
            rpm = 0
        }
    }

    Component.onCompleted: setStarted(true)

    NumberAnimation {
        id: intro
        target: glow
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 450
        easing.type: Easing.OutCubic
    }

    Rectangle {
        id: glow
        anchors.fill: parent
        opacity: started ? 1.0 : 0.25
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#16263b" }
            GradientStop { position: 0.52; color: "#0d1522" }
            GradientStop { position: 1.0; color: "#080d14" }
        }
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    Rectangle {
        anchors.fill: parent
        opacity: started ? 0.6 : 0.18
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(accent.r, accent.g, accent.b, 0.20) }
            GradientStop { position: 0.55; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(accent2.r, accent2.g, accent2.b, 0.12) }
        }
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    Rectangle {
        id: topBar
        x: 24
        y: 18
        width: parent.width - 48
        height: 46
        radius: 12
        color: Qt.rgba(0.07, 0.10, 0.16, 0.72)
        border.color: "#24344a"
        border.width: 1
        opacity: started ? 1.0 : 0.35
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Text {
            id: timeText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16
            color: fg
            font.pixelSize: 18
        text: currentTimeString()

            Timer {
                interval: 1000
                running: true
                repeat: true
            onTriggered: timeText.text = currentTimeString()
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: fgDim
            font.pixelSize: 14
            text: "BYD • Cluster"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 16
            color: started ? accent2 : fgDim
            font.pixelSize: 18
            font.weight: 600
            text: gearText
        }
    }

    Item {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: topBar.bottom
        anchors.bottom: bottomBar.top
        anchors.margins: 18

        readonly property real dialSize: 292

        CircularDial {
            id: rpmDial
            width: layout.dialSize
            height: layout.dialSize
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            label: "RPM"
            unit: "×1000"
            minValue: 0
            maxValue: 8
            value: rpm / 1000.0
            accentColor: accent2
            dangerFrom: 6.6
            active: started
        }

        CircularDial {
            id: speedDial
            width: layout.dialSize
            height: layout.dialSize
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            label: "SPEED"
            unit: "km/h"
            minValue: 0
            maxValue: 240
            value: speedKph
            accentColor: accent
            dangerFrom: 180
            active: started
            majorStep: 20
        }

        Rectangle {
            id: centerCard
            width: 236
            height: 246
            radius: 22
            anchors.centerIn: parent
            color: Qt.rgba(0.06, 0.09, 0.14, 0.78)
            border.color: "#24344a"
            border.width: 1
            opacity: started ? 1.0 : 0.35
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Rectangle {
                id: speedPill
                x: 22
                y: 26
                width: parent.width - 44
                height: 54
                radius: 18
                color: Qt.rgba(0.04, 0.06, 0.10, 0.82)
                border.color: "#2a3f5b"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    color: fg
                    font.pixelSize: 28
                    font.weight: 700
                    text: Math.round(speedKph) + "  km/h"
                }
            }

            Item {
                id: turnRow
                x: 0
                y: 98
                width: parent.width
                height: 36

                Image {
                    id: leftArrow
                    anchors.left: parent.left
                    anchors.leftMargin: 34
                    anchors.verticalCenter: parent.verticalCenter
                    width: 22
                    height: 22
                    source: "qrc:/Images/ClusterSvg/turn_left.svg"
                    smooth: true
                    opacity: leftBlinkPhase ? 1.0 : 0.12
                    Behavior on opacity { NumberAnimation { duration: 120 } }
                }

                Image {
                    id: rightArrow
                    anchors.right: parent.right
                    anchors.rightMargin: 34
                    anchors.verticalCenter: parent.verticalCenter
                    width: 22
                    height: 22
                    source: "qrc:/Images/ClusterSvg/turn_right.svg"
                    smooth: true
                    opacity: rightBlinkPhase ? 1.0 : 0.12
                    Behavior on opacity { NumberAnimation { duration: 120 } }
                }

                MouseArea {
                    anchors.left: parent.left
                    width: parent.width / 2
                    height: parent.height
                    onClicked: leftSignal = !leftSignal
                }

                MouseArea {
                    anchors.right: parent.right
                    width: parent.width / 2
                    height: parent.height
                    onClicked: rightSignal = !rightSignal
                }
            }

            Rectangle {
                id: divider
                x: 22
                y: 144
                width: parent.width - 44
                height: 1
                color: "#22344a"
            }

            Row {
                x: 22
                y: 158
                spacing: 8

                Image {
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/Images/ClusterSvg/fuel.svg"
                    smooth: true
                    opacity: 0.9
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: fgDim
                    font.pixelSize: 14
                    text: "Fuel"
                }
            }

            Rectangle {
                id: fuelBarTrack
                x: 22
                y: 184
                width: parent.width - 44
                height: 14
                radius: 7
                color: Qt.rgba(0.04, 0.06, 0.10, 0.82)
                border.color: "#2a3f5b"
                border.width: 1

                Rectangle {
                    id: fuelBar
                    x: 1
                    y: 1
                    width: clampValue((parent.width - 2) * fuelPercent / 100.0, 0, parent.width - 2)
                    height: parent.height - 2
                    radius: 6
                    color: fuelPercent < 15 ? danger : accent2
                    Behavior on width { NumberAnimation { duration: 200 } }
                }
            }

            Text {
                x: 22
                y: 206
                color: fg
                font.pixelSize: 18
                font.weight: 600
                text: Math.round(fuelPercent) + "%"
            }

            Rectangle {
                id: startButton
                width: 166
                height: 44
                radius: 16
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 18
                color: started ? Qt.rgba(0.07, 0.13, 0.20, 0.85) : Qt.rgba(0.05, 0.08, 0.12, 0.72)
                border.color: started ? "#2d4964" : "#24344a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    color: started ? fg : fgDim
                    font.pixelSize: 14
                    font.weight: 700
                    text: started ? "ENGINE ON" : "ENGINE OFF"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setStarted(!started)
                }
            }
        }
    }

    Rectangle {
        id: bottomBar
        x: 24
        height: 56
        width: parent.width - 48
        y: parent.height - height - 18
        radius: 14
        color: Qt.rgba(0.07, 0.10, 0.16, 0.72)
        border.color: "#24344a"
        border.width: 1
        opacity: started ? 1.0 : 0.35
        Behavior on opacity { NumberAnimation { duration: 200 } }

        Row {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 18

            InfoChip { label: "Odo"; value: "12,450 km" }
            InfoChip { label: "Range"; value: "468 km" }
            Item { width: Math.max(0, parent.width - 476); height: 1 }
            InfoChip { label: "Temp"; value: "23°C" }
        }
    }

    Timer {
        id: blinkTimer
        interval: 380
        running: false
        repeat: true
        onTriggered: {
            leftBlinkPhase = leftSignal ? !leftBlinkPhase : false
            rightBlinkPhase = rightSignal ? !rightBlinkPhase : false
        }
    }

    Timer {
        id: speedTimer
        interval: 120
        running: false
        repeat: true
        onTriggered: {
            var t = Date.now() / 1000.0
            var targetSpeed = 90 + 70 * Math.sin(t * 0.55)
            var targetRpm = 2200 + 1400 * Math.sin(t * 0.72 + 1.2)
            var targetFuel = 72 - (t % 120) * 0.25

            speedKph = clampValue(targetSpeed, 0, 240)
            rpm = clampValue(targetRpm, 0, 8000)
            fuelPercent = clampValue(targetFuel, 3, 100)
        }
    }

    component InfoChip: Rectangle {
        property string label: ""
        property string value: ""
        width: 136
        height: parent.height - 32
        radius: 12
        color: Qt.rgba(0.04, 0.06, 0.10, 0.82)
        border.color: "#2a3f5b"
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 4

            Text {
                color: fgDim
                font.pixelSize: 12
                text: label
            }
            Text {
                color: fg
                font.pixelSize: 16
                font.weight: 600
                text: value
            }
        }
    }

    component CircularDial: Item {
        id: dial
        property string label: ""
        property string unit: ""
        property real minValue: 0
        property real maxValue: 100
        property real value: 0
        property real dangerFrom: 1e9
        property int majorStep: 1
        property color accentColor: "#24d6ff"
        property bool active: true

        readonly property real sweep: 270
        readonly property real startAngle: -225

        function clamp(x, a, b) { return Math.max(a, Math.min(b, x)) }
        function ratio() { return clamp((value - minValue) / (maxValue - minValue), 0, 1) }
        function angle() { return startAngle + ratio() * sweep }

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "#0f1520"
            border.color: "#1f2a3a"
            border.width: 1
            opacity: active ? 1.0 : 0.35
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        Rectangle {
            id: ring
            width: parent.width - 18
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "transparent"
            border.width: 4
            border.color: "#1d2a3a"
            opacity: active ? 1.0 : 0.35
            Behavior on opacity { NumberAnimation { duration: 200 } }

            SequentialAnimation on border.color {
                running: active
                loops: Animation.Infinite
                ColorAnimation { to: accentColor; duration: 1200 }
                ColorAnimation { to: "#1d2a3a"; duration: 1200 }
            }
        }

        Item {
            id: ticks
            anchors.fill: parent

            readonly property int majorCount: Math.floor((maxValue - minValue) / majorStep)

            Repeater {
                model: ticks.majorCount + 1
                delegate: Rectangle {
                    readonly property real a: dial.startAngle + (index / ticks.majorCount) * dial.sweep
                    width: 2
                    height: 12
                    radius: 1
                    color: "#d8e5f4"
                    opacity: dial.active ? 0.8 : 0.25
                    x: dial.width / 2 - width / 2
                    y: 10
                    transform: Rotation {
                        origin.x: width / 2
                        origin.y: dial.height / 2 - 10
                        angle: a
                    }
                }
            }

            Repeater {
                model: ticks.majorCount + 1
                delegate: Text {
                    readonly property real v: dial.minValue + index * dial.majorStep
                    readonly property real a: (dial.startAngle + (index / ticks.majorCount) * dial.sweep) * Math.PI / 180.0
                    readonly property real r: dial.width * 0.36
                    color: "#b9cee2"
                    opacity: dial.active ? 1.0 : 0.25
                    font.pixelSize: 12
                    font.weight: 600
                    text: (Math.round(v) % (dial.majorStep * 2)) === 0 ? Math.round(v).toString() : ""
                    x: dial.width / 2 + Math.cos(a) * r - width / 2
                    y: dial.height / 2 + Math.sin(a) * r - height / 2
                }
            }
        }

        Rectangle {
            id: progressArc
            width: parent.width - 36
            height: width
            radius: width / 2
            anchors.centerIn: parent
            color: "transparent"
            border.width: 6
            border.color: accentColor
            opacity: active ? 0.18 : 0.06
        }

        Rectangle {
            id: needle
            width: 3
            height: parent.height * 0.36
            radius: 1.5
            color: dial.value >= dial.dangerFrom ? danger : dial.accentColor
            antialiasing: true
            opacity: active ? 1.0 : 0.35
            x: dial.width / 2 - width / 2
            y: dial.height / 2 - height + 16
            transform: Rotation {
                id: needleRot
                origin.x: needle.width / 2
                origin.y: needle.height - 16
                angle: dial.angle()

                Behavior on angle { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            }
            Behavior on color { ColorAnimation { duration: 160 } }
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        Rectangle {
            width: 12
            height: 12
            radius: 6
            anchors.centerIn: parent
            color: "#0b0f14"
            border.color: "#2b3d55"
            border.width: 2
            opacity: active ? 1.0 : 0.35
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 26
            spacing: 2

            Text {
                color: fg
                opacity: dial.active ? 1.0 : 0.35
                font.pixelSize: 14
                font.weight: 700
                text: label
                horizontalAlignment: Text.AlignHCenter
                width: dial.width
            }

            Text {
                color: fgDim
                opacity: dial.active ? 1.0 : 0.35
                font.pixelSize: 12
                text: unit
                horizontalAlignment: Text.AlignHCenter
                width: dial.width
            }
        }
    }
}
