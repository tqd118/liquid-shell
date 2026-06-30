import QtQuick

import qs.theme
import qs.state

import "launcher"

Item {
    id: root

    signal listheightChanged(real newHeight)

    property int selectedIndex: 0

    readonly property bool mathHasResult: mathResult.hasResult
    readonly property int appCount: appResults.matches.length
    readonly property int totalSlots: (mathHasResult ? 1 : 0) + appCount + 1

    readonly property bool mathSelected: mathHasResult && selectedIndex === 0
    readonly property bool webSelected: selectedIndex === totalSlots - 1
    readonly property int appSelectedIndex: selectedIndex - (mathHasResult ? 1 : 0)

    readonly property int margin: 12

    readonly property color colorBg: Theme.foreground
    readonly property color colorText: Theme.light3
    readonly property color colorTextMuted: Theme.gray
    readonly property color colorAccent: Theme.accent
    readonly property real selectedTintOpacity: 0.22
    readonly property real mathTintOpacity: 0.12
    readonly property int rowHeight: 34
    readonly property int rowRadius: 8
    readonly property int rowItemSpacing: 4
    readonly property int fontSize: 13

    Component.onCompleted: {
        searchField.forceActiveFocus()
        root.recalcHeight()
        entrance.start()
    }

    Component.onDestruction: searchField.text = ""

    anchors.fill: parent

    function recalcHeight() {
        root.listheightChanged(content.implicitHeight + root.margin * 2)
    }

    function clampSelection() {
        if (selectedIndex > totalSlots - 1)
            selectedIndex = Math.max(0, totalSlots - 1)
    }

    opacity: 0
    scale: 0.97
    transformOrigin: Item.Top

    ParallelAnimation {
        id: entrance
        NumberAnimation { target: root; property: "opacity"; to: 1; duration: 160; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "scale"; to: 1; duration: 220; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
    }

    Column {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: root.margin
        anchors.leftMargin: root.margin
        anchors.rightMargin: root.margin
        spacing: 6

        onImplicitHeightChanged: root.recalcHeight()

        Rectangle {
            width: parent.width
            height: 34
            radius: 10
            color: root.colorBg
            clip: true

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 1.2
                border.color: root.colorAccent
                opacity: searchField.activeFocus ? 0.45 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
            }

            TextInput {
                id: searchField
                anchors.fill: parent
                anchors.margins: 9
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.dark2
                font.pixelSize: 14

                onTextChanged: {
                    root.selectedIndex = 0
                    root.recalcHeight()
                    root.clampSelection()
                }

                Keys.onUpPressed: {
                    root.selectedIndex = Math.max(0, root.selectedIndex - 1)
                }
                Keys.onDownPressed: {
                    root.selectedIndex = Math.min(root.totalSlots - 1, root.selectedIndex + 1)
                }
                Keys.onReturnPressed: {
                    if (root.mathSelected) {
                        mathResult.execute()
                    } else if (root.webSelected) {
                        webSearch.execute()
                    } else {
                        appResults.currentIndex = root.appSelectedIndex
                        appResults.activateCurrent()
                    }
                }

                z: 10
            }
        }

        MathResult {
            id: mathResult
            query: searchField.text
            current: root.mathSelected
            onHasResultChanged: root.clampSelection()

            rowHeight: root.rowHeight
            rowRadius: root.rowRadius
            fontSize: root.fontSize
            colorText: root.colorText
            colorTextMuted: root.colorTextMuted
            colorAccent: root.colorAccent
            tintOpacity: root.mathTintOpacity
            selectedTintOpacity: root.selectedTintOpacity
        }

        AppResults {
            id: appResults
            query: searchField.text
            currentIndex: root.mathSelected || root.webSelected ? -1 : root.appSelectedIndex
            onActivated: (app) => {
                app.execute()
                IslandState.closeAll()
            }
            onMatchesChanged: root.clampSelection()

            rowHeight: root.rowHeight
            rowRadius: root.rowRadius
            rowItemSpacing: root.rowItemSpacing
            fontSize: root.fontSize
            colorText: root.colorText
            colorAccent: root.colorAccent
            selectedTintOpacity: root.selectedTintOpacity
        }

        WebSearchSuggestion {
            id: webSearch
            query: searchField.text
            current: root.webSelected
            onActivated: (query) => {
                Qt.openUrlExternally("https://www.google.com/search?q=" + encodeURIComponent(query))
                IslandState.closeAll()
            }

            rowHeight: root.rowHeight
            rowRadius: root.rowRadius
            fontSize: root.fontSize
            colorTextMuted: root.colorTextMuted
            colorAccent: root.colorAccent
            selectedTintOpacity: root.selectedTintOpacity
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: IslandState.closeAll()
    }
}
