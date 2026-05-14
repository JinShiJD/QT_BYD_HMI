import QtQuick
import QtQuick.Controls

Item {
    id: musicFullPage
    width: 1414
    height: 856
    anchors.fill: parent

    property bool isPlaying: false
    property int currentTab: 0
    property int currentTrackIndex: 0
    property int elapsedSeconds: 0
    property bool isShuffle: false
    property bool isLoop: false
    property string timeText: "00:00"
    property bool isDraggingProgress: false
    property int mediaVolume: ui.controlCenterMediaVolume
    property var bannerCovers: [
        "qrc:/Images/Music/1_477.png",
        "qrc:/Images/Music/1_478.png",
        "qrc:/Images/Music/1_479.png"
    ]
    property var stackCovers: [
        "qrc:/Images/Music/1_570.png",
        "qrc:/Images/Music/1_571.png"
    ]
    property var radioCovers: [
        "qrc:/Images/Music/1_554.png",
        "qrc:/Images/Music/1_556.png"
    ]
    property var trackList: [
        {title: "Something Just Like This", artist: "The Chainsmokers", duration: 247, album: "Memories...Do Not Open", cover: "qrc:/Images/Music/1_532.png"},
        {title: "Love The Way You Lie", artist: "Eminem", duration: 200, album: "Recovery", cover: "qrc:/Images/Music/1_537.png"},
        {title: "Havana", artist: "Camila Cabello", duration: 217, album: "Camila", cover: "qrc:/Images/Music/1_542.png"},
        {title: "Shape Of You", artist: "Ed Sheeran", duration: 233, album: "÷", cover: "qrc:/Images/Music/1_547.png"},
        {title: "告白气球", artist: "周杰伦", duration: 214, album: "周杰伦的床边故事", cover: "qrc:/Images/Music/1_554.png"},
        {title: "See You Again", artist: "Wiz Khalifa", duration: 232, album: "Furious 7", cover: "qrc:/Images/Music/1_556.png"},
        {title: "Call Me Maybe", artist: "Carly Rae Jepsen", duration: 201, album: "Kiss", cover: "qrc:/Images/Music/1_561.png"},
        {title: "夜曲", artist: "周杰伦", duration: 230, album: "十一月的萧邦", cover: "qrc:/Images/Music/1_566.png"}
    ]
    property var favoriteIndexes: [0, 3, 4]
    property var downloadIndexes: [1, 2]
    property var currentTrack: trackList.length > 0 ? trackList[0] : ({title: "", artist: "", duration: 0, album: "", cover: ""})

    function clampValue(value, minValue, maxValue) {
        return Math.max(minValue, Math.min(maxValue, value))
    }

    function formatTime(value) {
        var minutes = Math.floor(value / 60)
        var seconds = Math.floor(value % 60)
        return (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds)
    }

    function coverForIndex(index) {
        if (trackList.length === 0)
            return ""
        var safeIndex = ((index % trackList.length) + trackList.length) % trackList.length
        return trackList[safeIndex].cover
    }

    function setCurrentTrackByIndex(index) {
        if (index < 0 || index >= trackList.length)
            return
        currentTrackIndex = index
        currentTrack = trackList[index]
        elapsedSeconds = 0
        if (!isPlaying)
            isPlaying = true
    }

    function setProgressFromRatio(ratio) {
        if (currentTrack.duration <= 0)
            return
        var safeRatio = clampValue(ratio, 0, 1)
        elapsedSeconds = Math.round(safeRatio * currentTrack.duration)
    }

    function setPage(page) {
        ui.pageIndex = page
    }

    function resolveBackPage() {
        var targetPage = ui.previousPageIndex
        if (targetPage === ui.PAGE_MUSIC_FULL || targetPage === ui.PAGE_MAIN || targetPage === 0) {
            return ui.PAGE_HOME
        }
        return targetPage
    }

    function nextTrack() {
        var nextIndex = isShuffle ? Math.floor(Math.random() * trackList.length) : (currentTrackIndex + 1) % trackList.length
        setCurrentTrackByIndex(nextIndex)
    }

    function previousTrack() {
        var prevIndex = isShuffle ? Math.floor(Math.random() * trackList.length) : (currentTrackIndex - 1 + trackList.length) % trackList.length
        setCurrentTrackByIndex(prevIndex)
    }

    function progressRatio() {
        if (currentTrack.duration <= 0) {
            return 0
        }
        return clampValue(elapsedSeconds / currentTrack.duration, 0, 1)
    }

    function volumeRatio() {
        return clampValue(mediaVolume / 10, 0, 1)
    }

    function setMediaVolumeFromRatio(ratio) {
        mediaVolume = Math.round(clampValue(ratio, 0, 1) * 10)
        ui.controlCenterMediaVolume = mediaVolume
    }

    function showToast(message) {
        toastText.text = message
        toast.opacity = 1
        toastTimer.restart()
    }

    Connections {
        target: ui

        function onUpdateDateTime(date, time) {
            timeText = time
        }
    }

    // 1. 背景层：深色底色 + 右侧微亮
    Rectangle {
        anchors.fill: parent
        color: "#05090F"
    }

    Rectangle {
        id: leftSidebar
        width: 88
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#0E1118"

        Column {
            anchors.top: parent.top
            anchors.topMargin: 28
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 22

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                contentItem: Image {
                    width: 44
                    height: 44
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/portrait.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: showToast(qsTr("个人中心（占位）"))
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                contentItem: Image {
                    width: 28
                    height: 28
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/message.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: showToast(qsTr("消息中心（占位）"))
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                contentItem: Image {
                    width: 28
                    height: 28
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/back.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: setPage(resolveBackPage())
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                contentItem: Image {
                    width: 28
                    height: 28
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/home.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: setPage(ui.PAGE_HOME)
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                contentItem: Image {
                    width: 28
                    height: 28
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/app.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: setPage(ui.PAGE_APP)
            }

            Button {
                width: 52
                height: 52
                hoverEnabled: false
                contentItem: Image {
                    width: 28
                    height: 28
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/menu.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: showToast(qsTr("更多功能（占位）"))
            }
        }
    }

    // 2. 左侧播放器面板 (悬浮质感)
    Rectangle {
        id: leftPanel
        width: 440
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: leftSidebar.right
        color: "#111621" // Figma 深色背景
        
        // 顶部对话图标
        Button {
            id: topIconButton
            width: 40
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 28
            anchors.top: parent.top
            anchors.topMargin: 28
            hoverEnabled: false
            contentItem: Image {
                width: 32
                height: 32
                anchors.centerIn: parent
                source: "qrc:/Images/Home/message.png"
                opacity: parent.down ? 0.6 : 0.9
                fillMode: Image.PreserveAspectFit
            }
            background: Rectangle { color: "transparent" }
            onClicked: showToast(qsTr("消息中心（占位）"))
        }

        // 歌曲封面堆叠效果
        Item {
            id: coverStack
            width: parent.width
            height: 300
            anchors.top: topIconButton.bottom
            anchors.topMargin: 40

            // 左侧背景封面
            Rectangle {
                width: 180; height: 180; radius: 20; opacity: 0.3; x: 20; anchors.verticalCenter: parent.verticalCenter
                Image { anchors.fill: parent; source: stackCovers[0]; fillMode: Image.PreserveAspectCrop; clip: true }
            }
            // 右侧背景封面
            Rectangle {
                width: 180; height: 180; radius: 20; opacity: 0.3; anchors.right: parent.right; anchors.rightMargin: 20; anchors.verticalCenter: parent.verticalCenter
                Image { anchors.fill: parent; source: stackCovers[1]; fillMode: Image.PreserveAspectCrop; clip: true }
            }
            // 中间主封面
            Rectangle {
                id: mainCover
                width: 240; height: 240; radius: 24; anchors.centerIn: parent
                color: "#1A212B"; border.color: "#30FFFFFF"; border.width: 1
                clip: true
                Image {
                    id: mainCoverImage
                    anchors.fill: parent
                    source: currentTrack.cover
                    fillMode: Image.PreserveAspectCrop
                }
            }

            MouseArea {
                anchors.fill: parent
                property real startX: 0
                onPressed: function(mouse) { startX = mouse.x }
                onReleased: function(mouse) {
                    var delta = mouse.x - startX
                    if (Math.abs(delta) > 40) {
                        if (delta < 0) {
                            nextTrack()
                        } else {
                            previousTrack()
                        }
                    }
                }
            }
        }

        // 歌曲信息
        Column {
            anchors.top: coverStack.bottom; anchors.topMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Label { text: currentTrack.title; color: "#FFFFFF"; font.pixelSize: 26; font.bold: true }
            Label { text: currentTrack.artist; color: "#6F7685"; font.pixelSize: 16 }
            Label { text: currentTrack.album; color: "#445064"; font.pixelSize: 14 }
        }

        // 进度条
        Item {
            width: 340; height: 40
            anchors.bottom: controls.top; anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                anchors.fill: parent; spacing: 12
                Label { text: formatTime(elapsedSeconds); color: "#6F7685"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
                Rectangle {
                    id: progressTrack
                    height: 4; radius: 2; color: "#273041"; width: 220; anchors.verticalCenter: parent.verticalCenter
                    Rectangle {
                        id: progressFill
                        width: parent.width * progressRatio()
                        height: parent.height
                        radius: 2
                        color: "#FFFFFF"
                        Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                    }
                    Rectangle {
                        id: progressThumb
                        width: 10
                        height: 10
                        radius: 5
                        color: "#FFFFFF"
                        anchors.verticalCenter: parent.verticalCenter
                        x: Math.max(0, Math.min(parent.width - width, parent.width * progressRatio() - width / 2))
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            isDraggingProgress = true
                            setProgressFromRatio(mouse.x / parent.width)
                        }
                        onPositionChanged: {
                            if (pressed) {
                                setProgressFromRatio(mouse.x / parent.width)
                            }
                        }
                        onReleased: isDraggingProgress = false
                    }
                }
                Label { text: formatTime(currentTrack.duration); color: "#6F7685"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
            }
        }

        Row {
            width: 320
            height: 22
            anchors.bottom: controls.top
            anchors.bottomMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Label { text: "🔊"; color: "#6F7685"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
            Rectangle {
                id: volumeTrack
                width: 220
                height: 4
                radius: 2
                color: "#273041"
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                        width: parent.width * volumeRatio()
                    height: parent.height
                    radius: 2
                    color: "#59EBFD"
                    Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
                }
                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: "#59EBFD"
                    anchors.verticalCenter: parent.verticalCenter
                    x: Math.max(0, Math.min(parent.width - width, parent.width * volumeRatio() - width / 2))
                }
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        setMediaVolumeFromRatio(mouse.x / parent.width)
                    }
                    onPositionChanged: {
                        if (pressed) {
                            setMediaVolumeFromRatio(mouse.x / parent.width)
                        }
                    }
                }
            }
            Label { text: Math.round(mediaVolume * 10) + "%"; color: "#6F7685"; font.pixelSize: 14; anchors.verticalCenter: parent.verticalCenter }
        }

        // 控制按钮
        Row {
            id: controls
            anchors.bottom: parent.bottom; anchors.bottomMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 44
            Button {
                width: 40
                height: 40
                hoverEnabled: false
                contentItem: Image {
                    width: 32
                    height: 32
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/music_previous.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: {
                    previousTrack()
                    showToast(qsTr("上一曲"))
                }
            }
            Button {
                width: 64
                height: 64
                hoverEnabled: false
                background: Rectangle {
                    width: 64
                    height: 64
                    radius: 32
                    color: parent.down ? "#222734" : "#2A2F3D"
                }
                contentItem: Item {
                    width: 64
                    height: 64
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/Images/Home/music_play.png"
                        width: 22
                        height: 22
                        visible: !isPlaying
                    }
                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        visible: isPlaying
                        Rectangle { width: 6; height: 22; radius: 3; color: "#FFFFFF" }
                        Rectangle { width: 6; height: 22; radius: 3; color: "#FFFFFF" }
                    }
                }
                onClicked: {
                    isPlaying = !isPlaying
                    showToast(isPlaying ? qsTr("播放") : qsTr("暂停"))
                }
            }
            Button {
                width: 40
                height: 40
                hoverEnabled: false
                contentItem: Image {
                    width: 32
                    height: 32
                    anchors.centerIn: parent
                    source: "qrc:/Images/Home/music_next.png"
                    opacity: parent.down ? 0.6 : 1
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle { color: "transparent" }
                onClicked: {
                    nextTrack()
                    showToast(qsTr("下一曲"))
                }
            }
            Button {
                width: 40
                height: 40
                hoverEnabled: false
                contentItem: Label {
                    text: isShuffle ? "🔀" : "🔀"
                    color: isShuffle ? "#59EBFD" : "#6F7685"
                    font.pixelSize: 22
                    anchors.centerIn: parent
                }
                background: Rectangle { color: "transparent" }
                onClicked: {
                    isShuffle = !isShuffle
                    showToast(isShuffle ? qsTr("随机播放") : qsTr("顺序播放"))
                }
            }
            Button {
                width: 40
                height: 40
                hoverEnabled: false
                contentItem: Label {
                    text: "🔁"
                    color: isLoop ? "#59EBFD" : "#6F7685"
                    font.pixelSize: 22
                    anchors.centerIn: parent
                }
                background: Rectangle { color: "transparent" }
                onClicked: {
                    isLoop = !isLoop
                    showToast(isLoop ? qsTr("单曲循环") : qsTr("列表循环"))
                }
            }
        }
    }

    // 3. 右侧发现音乐区域
    Item {
        anchors.left: leftPanel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        // 顶部标签页
        Item {
            id: tabHeader
            height: 80
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            z: 2
            Row {
                x: 48
                spacing: 48
                Repeater {
                    model: ["发现音乐", "我的收藏", "我的下载"]
                    delegate: Item {
                        width: 120; height: 80
                        Label {
                            text: modelData; color: currentTab === index ? "#FFFFFF" : "#6F7685"
                            font.pixelSize: 20; font.bold: currentTab === index; anchors.centerIn: parent
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                        Rectangle {
                            width: 40; height: 4; radius: 2; color: "#59EBFD"
                            visible: currentTab === index; anchors.bottom: parent.bottom; anchors.bottomMargin: 10; anchors.horizontalCenter: parent.horizontalCenter
                            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: currentTab = index
                        }
                    }
                }
            }
        }

        // 右上角状态信息
        Row {
            anchors.right: parent.right; anchors.rightMargin: 40; anchors.top: parent.top; anchors.topMargin: 24
            spacing: 16
            Label { text: timeText; color: "#FFFFFF"; font.pixelSize: 16; opacity: 0.8 }
            Label { text: "📶"; color: "#FFFFFF"; font.pixelSize: 16; opacity: 0.8 }
        }

        // 滚动发现内容
        Flickable {
            anchors.top: tabHeader.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
            contentHeight: scrollContent.height; clip: true
            Column {
                id: scrollContent
                x: 48; width: parent.width - 96; spacing: 48; topPadding: 20; bottomPadding: 40

                Item {
                    width: parent.width
                    height: discoverContent.implicitHeight
                    opacity: currentTab === 0 ? 1 : 0
                    visible: opacity > 0.01
                    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                    Column {
                        id: discoverContent
                        width: parent.width
                        spacing: 48
                        Row {
                            spacing: 24
                            Repeater {
                                model: bannerCovers
                                delegate: Rectangle {
                                    width: 260
                                    height: 200
                                    radius: 24
                                    clip: true
                                    scale: bannerArea.pressed ? 0.98 : 1
                                    Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                                    Image { anchors.fill: parent; source: modelData; fillMode: Image.PreserveAspectCrop }
                                    Label {
                                        text: index === 0 ? "酷狗音乐\n热门榜单" : (index === 1 ? "专属推荐\n推荐歌曲" : "专属推荐\n精选歌单")
                                        color: "#FFFFFF"
                                        font.pixelSize: 22
                                        font.bold: true
                                        x: 24
                                        y: 34
                                    }
                                    MouseArea {
                                        id: bannerArea
                                        anchors.fill: parent
                                        onClicked: showToast(qsTr("进入榜单（占位）"))
                                    }
                                }
                            }
                        }

                        Column {
                            width: parent.width; spacing: 24
                            Label { text: "能量充电"; color: "#FFFFFF"; font.pixelSize: 22; font.bold: true }
                            Grid {
                                columns: 4; spacing: 32
                                Repeater {
                                    model: trackList
                                    delegate: Column {
                                        spacing: 12
                                        Rectangle {
                                            width: 160; height: 160; radius: 20
                                            property bool isCurrent: index === currentTrackIndex
                                            scale: tileArea.pressed ? 0.96 : (isCurrent ? 1.03 : 1)
                                            color: isCurrent ? "#2A3142" : "#1B2231"
                                            Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                                            Behavior on color { ColorAnimation { duration: 200 } }
                                            Image { anchors.fill: parent; source: modelData.cover; fillMode: Image.PreserveAspectCrop }
                                            MouseArea {
                                                id: tileArea
                                                anchors.fill: parent
                                                onClicked: {
                                                    setCurrentTrackByIndex(index)
                                                    showToast(qsTr("正在播放 ") + modelData.title)
                                                }
                                            }
                                        }
                                        Label { text: modelData.title; color: "#FFFFFF"; font.pixelSize: 16; font.bold: true; width: 160; elide: Text.ElideRight }
                                        Label { text: modelData.artist; color: "#6F7685"; font.pixelSize: 14; width: 160; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }

                        Column {
                            width: parent.width; spacing: 24
                            Label { text: "专属电台"; color: "#FFFFFF"; font.pixelSize: 22; font.bold: true }
                            Row {
                                spacing: 32
                                Repeater {
                                    model: radioCovers
                                    delegate: Rectangle {
                                        width: 160; height: 160; radius: 20; color: "#1B2231"
                                        scale: radioArea.pressed ? 0.96 : 1
                                        Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                                        Image { anchors.fill: parent; source: modelData; fillMode: Image.PreserveAspectCrop }
                                        MouseArea {
                                            id: radioArea
                                            anchors.fill: parent
                                            onClicked: showToast(qsTr("电台播放（占位）"))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: favoriteContent.implicitHeight
                    opacity: currentTab === 1 ? 1 : 0
                    visible: opacity > 0.01
                    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                    Column {
                        id: favoriteContent
                        width: parent.width
                        spacing: 24
                        Label { text: "我的收藏"; color: "#FFFFFF"; font.pixelSize: 22; font.bold: true }
                        Repeater {
                            model: favoriteIndexes
                            delegate: Rectangle {
                                width: parent.width
                                height: 72
                                radius: 16
                                color: trackList[modelData].title === currentTrack.title ? "#1F2634" : "#141A24"
                                Behavior on color { ColorAnimation { duration: 180 } }
                                scale: favoriteArea.pressed ? 0.98 : 1
                                Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                                Image {
                                    width: 48
                                    height: 48
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    source: trackList[modelData].cover
                                    fillMode: Image.PreserveAspectCrop
                                }
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 84
                                    spacing: 4
                                    Label { text: trackList[modelData].title; color: "#FFFFFF"; font.pixelSize: 16; font.bold: true; elide: Text.ElideRight; width: 360 }
                                    Label { text: trackList[modelData].artist; color: "#6F7685"; font.pixelSize: 14; width: 360; elide: Text.ElideRight }
                                }
                                Label {
                                    text: formatTime(trackList[modelData].duration)
                                    color: "#6F7685"
                                    font.pixelSize: 14
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                MouseArea {
                                    id: favoriteArea
                                    anchors.fill: parent
                                    onClicked: {
                                        setCurrentTrackByIndex(modelData)
                                        isPlaying = true
                                        showToast(qsTr("正在播放 ") + trackList[modelData].title)
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: downloadContent.implicitHeight
                    opacity: currentTab === 2 ? 1 : 0
                    visible: opacity > 0.01
                    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                    Column {
                        id: downloadContent
                        width: parent.width
                        spacing: 24
                        Label { text: "我的下载"; color: "#FFFFFF"; font.pixelSize: 22; font.bold: true }
                        Repeater {
                            model: downloadIndexes
                            delegate: Rectangle {
                                width: parent.width
                                height: 72
                                radius: 16
                                color: trackList[modelData].title === currentTrack.title ? "#1F2634" : "#141A24"
                                Behavior on color { ColorAnimation { duration: 180 } }
                                scale: downloadArea.pressed ? 0.98 : 1
                                Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutQuad } }
                                Image {
                                    width: 48
                                    height: 48
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    source: trackList[modelData].cover
                                    fillMode: Image.PreserveAspectCrop
                                }
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 84
                                    spacing: 4
                                    Label { text: trackList[modelData].title; color: "#FFFFFF"; font.pixelSize: 16; font.bold: true; elide: Text.ElideRight; width: 360 }
                                    Label { text: trackList[modelData].artist; color: "#6F7685"; font.pixelSize: 14; width: 360; elide: Text.ElideRight }
                                }
                                Label {
                                    text: qsTr("已缓存")
                                    color: "#59EBFD"
                                    font.pixelSize: 14
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                MouseArea {
                                    id: downloadArea
                                    anchors.fill: parent
                                    onClicked: {
                                        setCurrentTrackByIndex(modelData)
                                        isPlaying = true
                                        showToast(qsTr("正在播放 ") + trackList[modelData].title)
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
    }

    Timer {
        id: playbackTimer
        interval: 1000
        repeat: true
        running: isPlaying && !isDraggingProgress
        onTriggered: {
            if (currentTrack.duration <= 0)
                return
            if (elapsedSeconds + 1 >= currentTrack.duration) {
                if (isLoop) {
                    elapsedSeconds = 0
                } else {
                    nextTrack()
                }
            } else {
                elapsedSeconds = elapsedSeconds + 1
            }
        }
    }

    Rectangle {
        id: toast
        width: toastText.width + 60
        height: 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        color: "#CC000000"
        radius: 32
        opacity: 0
        z: 999
        Label {
            id: toastText
            anchors.centerIn: parent
            color: "#FFFFFF"
            font.pixelSize: 22
        }
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    Timer {
        id: toastTimer
        interval: 2000
        onTriggered: toast.opacity = 0
    }
}
