import QtQuick
import qs.state
import qs.components

Item {
    id: root

    property bool transitioning: false

    function beginTransition() {
        if (transitioning)
            return

        transitioning = true
        shrinkAnim.restart()
    }

    function finishShrink() {
        contentLoader.sourceComponent = IslandState.currentComponent || Components.defaultComponent
        contentWrapper.scale = 0.0
        contentWrapper.opacity = 0.0
        growAnim.restart()
    }

    function finishGrow() {
        beginTransition()
        transitioning = false
    }

    Connections {
        target: IslandState

        function onOpen() {
            root.beginTransition()
        }

        function onClose() {
            root.beginTransition()
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            if (IslandState.currentComponent === null) {
                IslandState.openComponent(Components.expandedComponent, 380, 100);
            } else {
                IslandState.closeAll();
            }
        }
    }

    Item {
        id: contentWrapper
        anchors.fill: parent
        transformOrigin: Item.Center
        scale: 1.0
        opacity: 1.0

        Loader {
            id: contentLoader
            anchors.fill: parent
            onLoaded: IslandState.handleLoadedItem(item)
        }
    }

    SequentialAnimation {
        id: shrinkAnim

        ParallelAnimation {
            NumberAnimation {
                target: contentWrapper
                property: "scale"
                from: 1.0
                to: 0.0
                duration: 140
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: contentWrapper
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 140
                easing.type: Easing.InCubic
            }
        }

        ScriptAction {
            script: root.finishShrink()
        }
    }

    SequentialAnimation {
        id: growAnim

        ParallelAnimation {
            NumberAnimation {
                target: contentWrapper
                property: "scale"
                from: 0.0
                to: 1.0
                duration: 180
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: contentWrapper
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        ScriptAction {
            script: root.finishGrow()
        }
    }

    Component.onCompleted: {
        contentLoader.sourceComponent = IslandState.currentComponent || Components.defaultComponent
    }
}