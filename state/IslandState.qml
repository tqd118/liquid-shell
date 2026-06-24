pragma Singleton
import QtQuick

QtObject {
    id: root 

    property bool isExpanded: (islandWidth !== baseWidth || islandHeigh !== baseheight)

    signal open(var Component)

    property int baseWidth: 280
    property int baseheight: 40

    property int islandWidth: baseWidth
    property int islandHeigh: baseheight

    function expand(width, height) {
        root.islandWidth = width;
        root.islandHeigh = height;
    }

    function closeAll() {
        root.islandWidth = root.baseWidth;
        root.islandHeigh = root.baseheight;
    }

    function toggle(width, height) {
        if (isExpanded) {
            root.closeAll();
        } else {
            root.expand(width, height)
        }
    }

    function change(widthDiff, heightDiff) {
        root.islandWidth += widthDiff;
        root.islandHeigh += heightDiff;
    }

    Behavior on islandWidth {
        SpringAnimation {
            spring: 5
            damping: 0.38
        }
        
    }

    Behavior on islandHeigh {
        SpringAnimation {
            spring: 5
            damping: 0.38
        }
    }
}
