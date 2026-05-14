import QtQuick

import "../../modules/cluster"

Item {
    id: instrumentPage
    anchors.fill: parent

    function scaleRatio(targetWidth, targetHeight) {
        return Math.min(width / targetWidth, height / targetHeight)
    }

    ClusterDemo {
        id: clusterDemo
        width: 800
        height: 480
        anchors.centerIn: parent
        scale: scaleRatio(width, height)
        transformOrigin: Item.Center
    }
}
