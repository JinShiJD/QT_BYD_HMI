import QtQuick
import QtQuick.Controls

Item {
    id: root

    readonly property var temperatureText: ["32°", "31°", "30°", "29°", "28°", "27°", "26°", "25°", "24°",
                                            "23°", "22°", "21°", "20°", "19°", "18°", "17°", "16°"]
    property real temperature: 26
    property string fontFamiliy: "阿里巴巴普惠体 R"
    property int spacing: 70
    property int flickDeceleration: 5000
    property int maximumFlickVelocity: 2500
    property color background: "transparent"
    property color currentIndexTextColor: "#FFFFFF"
    property color otherIndexTextColor: "#DFDFDF"
    property color movingColor: Qt.rgba(currentIndexTextColor.r, currentIndexTextColor.g, currentIndexTextColor.b, 0.5)
    property int fontPixelSize: 38
    property bool fontBold: false

    readonly property int maxTemp: 32
    readonly property int minTemp: 16

    property int direction: 0   // 0-左  1-右

    signal movementStarted()
    signal movementEnded(real temperatureValue)

    function clampIndex(index) {
        return Math.max(0, Math.min(temperatureText.length - 1, index))
    }

    function indexFromTemperature(value) {
        if (value >= maxTemp) {
            return 0
        }
        if (value <= minTemp) {
            return temperatureText.length - 1
        }
        return maxTemp - value
    }

    function temperatureFromIndex(index) {
        const safeIndex = clampIndex(index)
        if (safeIndex <= 0) {
            return maxTemp
        }
        if (safeIndex >= temperatureText.length - 1) {
            return minTemp
        }
        return maxTemp - safeIndex
    }

    function indexOffset(index) {
        return Math.abs(listView.currentIndex - index)
    }

    function opacityForOffset(offset) {
        switch (offset) {
            case 1: return 0.6
            case 2: return 0.5
            case 3: return 0.3
            default: return 0.3
        }
    }

    function paddingForOffset(offset) {
        switch (offset) {
            case 1: return 35
            case 2: return 25
            case 3: return 5
            default: return 5
        }
    }

    function fontForOffset(offset) {
        switch (offset) {
            case 1: return 36
            case 2: return 28
            case 3: return 20
            default: return 20
        }
    }

    function displayTemperature(index) {
        if (listView.moving) {
            return temperatureText[index]
        }
        const delta = listView.currentIndex - index
        return temperatureText[listView.currentIndex - delta]
    }


    Rectangle {
        anchors.fill: parent
        color: background
    }

    onTemperatureChanged: {
        listView.currentIndex = indexFromTemperature(temperature)
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        spacing: root.spacing
        model: 17

        preferredHighlightBegin: height / 2 - 32
        preferredHighlightEnd: height / 2 + 32
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 0    // 关闭高亮滑动动画
        visible: true
        opacity: 1
        flickDeceleration: root.flickDeceleration
        maximumFlickVelocity: root.maximumFlickVelocity
        enabled: true

        Component.onCompleted: {
            var index = indexFromTemperature(temperature)
            listView.positionViewAtIndex(((index < 0) ? 0 : index), ListView.Center)
        }

        delegate: Item {
            id: item
            width: listView.width
            height: 59

            Label {
                id: temperatureLabel
                text: getTemperature()
                color: getColor()
                font.family: fontFamiliy
                font.pixelSize: getFontPixelSieze()
                font.bold: fontBold
                width: parent.width
                height: parent.height
                topPadding: 5
                leftPadding: (direction == 1) ? getPadding() : leftPadding
                rightPadding: (direction == 0) ? getPadding() : rightPadding
                horizontalAlignment: (direction == 0) ? Text.AlignRight : Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                opacity: enabled ? getOpacity() : 0.3

                function getOpacity()
                {
                    return item.ListView.isCurrentItem ? 1 : root.opacityForOffset(root.indexOffset(index))
                }

                function getPadding()
                {
                    return item.ListView.isCurrentItem ? 50 : root.paddingForOffset(root.indexOffset(index))
                }

                function getFontPixelSieze()
                {
                    return item.ListView.isCurrentItem ? fontPixelSize : root.fontForOffset(root.indexOffset(index))
                }

                function getTemperature() {
                    return root.displayTemperature(index)
                }

                function getColor() {
                    return item.ListView.isCurrentItem ? root.currentIndexTextColor :
                            (listView.moving ? root.movingColor : otherIndexTextColor)
                }
            }
        }

        onMovementStarted: {
            root.movementStarted()
        }

        onMovementEnded: {
            root.movementEnded(root.temperatureFromIndex(currentIndex))
        }
    }
}
