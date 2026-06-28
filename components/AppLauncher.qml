import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

import qs.theme
import qs.state

Item {
    id: root

    signal listheightChanged(real newHeight)

    Component.onCompleted: {
        searchField.forceActiveFocus()
        appList.currentIndex = 0
    }

    Component.onDestruction: searchField.text = ""

    anchors.fill: parent

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Rectangle {
            width: parent.width
            height: 38
            radius: 12
            color: Theme.foreground

            TextInput {
                id: searchField
                anchors.fill: parent
                anchors.margins: 10
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.dark0
                font.pixelSize: 15
                onTextChanged: appList.currentIndex = 0
                Keys.onUpPressed: appList.decrementCurrentIndex()
                Keys.onDownPressed: appList.incrementCurrentIndex()
                Keys.onReturnPressed: {
                    const entry = appList.model.values[appList.currentIndex]
                    if (entry) {
                        entry.execute()
                        IslandState.closeAll()
                    }
                }

                z: 10
            }
        }

        ListView {
            id: appList
            width: parent.width
            height: parent.height - searchField.height - 20
            clip: true
            spacing: 4

            onCountChanged: root.listheightChanged(Math.min(appList.count * 52 + 64, 218))

            model: ScriptModel {
                values: DesktopEntries.applications.values.filter(app =>
                    app.name.toLowerCase().includes(searchField.text.toLowerCase())
                )
            }

            highlightMoveDuration: 150
            cacheBuffer: 0

            populate: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0.0; to: 1.0
                        duration: 320
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        property: "scale"
                        from: 0.88; to: 1.0
                        duration: 320
                        easing.type: Easing.OutBack
                    }
                }
            }

            delegate: Item {
                id: app
                required property var modelData
                width: appList.width
                height: 48

                transformOrigin: Item.Center
                Component.onCompleted: stretchAnimation.start()

                SequentialAnimation {
                    id: stretchAnimation
                    running: false

                    NumberAnimation {
                        target: hStretch
                        property: "xScale"
                        from: 0.5; to: 1.0
                        duration: 340
                        easing.type: Easing.OutBack
                        easing.overshoot: 0.7
                    }
                }

                Rectangle {
                    id: innerRect
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 12
                    color: app.ListView.isCurrentItem ? Theme.accent : Theme.foreground

                    transform: Scale {
                        id: hStretch
                        xScale: 0.0
                        origin.x: innerRect.width  / 2
                        origin.y: innerRect.height / 2
                    }

                    Text {
                        text: modelData.name
                        color: app.ListView.isCurrentItem ? Theme.foreground : Theme.dark0
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 6
                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 120 }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 120; easing.type: Easing.OutBack }
                    }

                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: IslandState.closeAll()
    }
}
