import QtQuick
import qs.state

Item {
    id: root

    property Component pendingComponent: null
    property bool transitioning: false

    function open(component) {
        if (!component)
            return

        pendingComponent = component

        if (!transitioning)
            startTransition()
    }

    function startTransition() {
        if (!pendingComponent)
            return

        transitioning = true

        if (contentLoader.sourceComponent) {
            shrinkAnim.restart()
        } else {
            contentLoader.sourceComponent = pendingComponent
            pendingComponent = null
            contentWrapper.scale = 0
            contentWrapper.opacity = 0
            growAnim.restart()
        }
    }

    function finishShrink() {
        contentLoader.sourceComponent = pendingComponent
        pendingComponent = null
        contentWrapper.scale = 0
        contentWrapper.opacity = 0
        growAnim.restart()
    }

    function finishGrow() {
        transitioning = false
        if (pendingComponent)
            startTransition()
    }

    Connections {
        target: IslandState
        function onOpen(component) {
            root.open(component)
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
}