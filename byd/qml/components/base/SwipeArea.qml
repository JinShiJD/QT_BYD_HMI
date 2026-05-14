import QtQuick


MouseArea {
    property point origin
    property bool ready: false
    property int threshold: 10
    property bool firstClick: false
    property int doubleClickDelay: 200

    signal move(int x, int y)
    signal swipe(string direction)
    signal swipeStarted(int x, int y)

    signal swipeUp()
    signal swipeDown()
    signal swipeLeft()
    signal swipeRight()
    signal doubleTapped()

    function deltaX(mouse) {
        return mouse.x - origin.x
    }

    function deltaY(mouse) {
        return mouse.y - origin.y
    }

    function absDeltaX(mouse) {
        return Math.abs(deltaX(mouse))
    }

    function absDeltaY(mouse) {
        return Math.abs(deltaY(mouse))
    }

    function aboveThreshold(mouse) {
        return absDeltaX(mouse) >= threshold || absDeltaY(mouse) >= threshold
    }

    function updateAxis(mouse) {
        if (absDeltaX(mouse) > threshold) {
            drag.axis = Drag.XAxis
            return
        }
        if (absDeltaY(mouse) > threshold) {
            drag.axis = Drag.YAxis
        }
    }

    function emitDirectionalSignals(mouse) {
        if (deltaY(mouse) < 0 && absDeltaY(mouse) >= threshold) {
            swipeUp()
        }
        if (deltaY(mouse) > 0 && absDeltaY(mouse) >= threshold) {
            swipeDown()
        }
        if (deltaX(mouse) < 0 && absDeltaX(mouse) >= threshold) {
            swipeLeft()
        }
        if (deltaX(mouse) > 0 && absDeltaX(mouse) >= threshold) {
            swipeRight()
        }
    }

    onPressed: function(mouse) {
        drag.axis = Drag.XAndYAxis
        origin = Qt.point(mouse.x, mouse.y)
    }

    onPositionChanged: function(mouse) {
        switch (drag.axis) {
        case Drag.XAndYAxis:
            updateAxis(mouse)

            if(aboveThreshold(mouse))
            {
                swipeStarted(absDeltaX(mouse), absDeltaY(mouse))
                emitDirectionalSignals(mouse)
            }

            break
        case Drag.XAxis:
            move(deltaX(mouse), 0)
            break
        case Drag.YAxis:
            move(0, deltaY(mouse))
            break
        }
    }

    onReleased: function(mouse) {
        switch (drag.axis) {
        case Drag.XAndYAxis:
            break
        case Drag.XAxis:
            swipe(deltaX(mouse) < 0 ? "left" : "right")
            break
        case Drag.YAxis:
            swipe(deltaY(mouse) < 0 ? "up" : "down")
            break
        }
    }


    onClicked: function(mouse) {
        if(!timer.running)
        {
            timer.start(doubleClickDelay)
            firstClick = true
        }
        else
        {
            timer.stop()
            if(firstClick)
            {
                firstClick = false
                doubleTapped()
            }
        }
    }

    Timer {
        id: timer
        interval: doubleClickDelay
        repeat: false
        onTriggered: {
            firstClick = false
        }
    }
}
