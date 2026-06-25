pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool isExpanded: (islandWidth !== baseWidth || islandHeigh !== baseheight)

    property var currentComponent: null
    property var currentProperties: ({})
    property var currentSignalHandlers: ({})
    property var currentObject: null

    signal componentOpened(var object)
    signal componentClosed()

    signal open(var Component)
    signal close()

    property int baseWidth: 280
    property int baseheight: 40

    property int islandWidth: baseWidth
    property int islandHeigh: baseheight

    function expand(width, height) {
        root.islandWidth = width
        root.islandHeigh = height
    }

    function closeAll() {
        root.islandWidth = root.baseWidth
        root.islandHeigh = root.baseheight

        root.currentObject = null
        root.currentProperties = ({})
        root.currentSignalHandlers = ({})
        root.currentComponent = null

        root.close()
        root.componentClosed()
    }

    function toggle(width, height) {
        if (isExpanded) {
            root.closeAll()
        } else {
            root.expand(width, height)
        }
    }

    function change(widthDiff, heightDiff) {
        root.islandWidth += widthDiff
        root.islandHeigh += heightDiff
    }

    function openComponent(component, width, height, properties, signalHandlers) {
        root.currentComponent = component
        root.currentProperties = properties || ({})
        root.currentSignalHandlers = signalHandlers || ({})
        root.currentObject = null

        root.open(component)

        if (width !== undefined && width !== null)
            root.islandWidth = width
        if (height !== undefined && height !== null)
            root.islandHeigh = height
    }

    function attachSignalHandlers(obj, handlers) {
        if (!obj || !handlers)
            return

        for (const name in handlers) {
            const fn = handlers[name]
            if (typeof fn !== "function")
                continue

            const signalFn = obj[name]
            if (signalFn && typeof signalFn.connect === "function") {
                signalFn.connect(fn)
            }
        }
    }

    function applyProperties(obj, properties) {
        if (!obj || !properties)
            return

        for (const name in properties) {
            try {
                obj[name] = properties[name]
            } catch (e) {
                console.warn("IslandState: cannot set property", name, e)
            }
        }
    }

    function handleLoadedItem(item) {
        root.currentObject = item
        root.applyProperties(item, root.currentProperties)
        root.attachSignalHandlers(item, root.currentSignalHandlers)
        root.componentOpened(item)
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