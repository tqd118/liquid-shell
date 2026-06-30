pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.state
import qs.components

Item {
    id: root

    property bool expanded: false

    readonly property int iconSize: 28
    readonly property int rowSpacing: 4

    readonly property var iconOverrides: ({
        "materialgram": "root:assets/icons/telegram.svg",
        "steam": "root:assets/icons/steam.svg",
        "nm-applet": "root:assets/icons/nm-applet.svg",
    })

    function resolveIcon(item) {
        return iconOverrides[item.id] ?? item.icon
    }

    readonly property var trayItems: SystemTray.items.values

    readonly property bool compactMode: !expanded && trayItems.length > 2
    readonly property var visibleTrayItems: {
        if (!compactMode) {
            return trayItems
        }

        const items = trayItems;
        const nmApplet = items.find(it => it.id === "nm-applet");

        if (nmApplet) {
            return [nmApplet]
        }

        return items.length > 0 ? [items[0]] : []
    }

    readonly property int hiddenCount: compactMode
        ? trayItems.length - visibleTrayItems.length
        : 0

    readonly property var expandedEntries: visibleTrayItems

    component TrayIconDelegate: Item {
        id: _delegate
        required property SystemTrayItem modelData

        width: root.iconSize
        height: root.iconSize

        Image {
            anchors.centerIn: parent
            width: 20
            height: 20
            source: root.resolveIcon(_delegate.modelData)
            sourceSize.width: 20
            sourceSize.height: 20
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => {
                const item = _delegate.modelData;
                const openMenu = () => {
                    IslandState.openComponent(
                        Components.trayMenuComponent,
                        400, 60,
                        {
                            menu: _delegate.modelData.menu,
                            trayName: _delegate.modelData.title
                        },
                        {
                            menuHeightChanged: function(newHeight) {
                                IslandState.expand(400, newHeight)
                            }
                        }
                    )
                }

                if (mouse.button === Qt.LeftButton) {
                    if (item.onlyMenu && item.hasMenu) {
                        openMenu()
                    } else {
                        item.activate()
                    }
                } else {
                    openMenu()
                }
            }
        }
    }

    implicitWidth: expanded ? _grid.implicitWidth : _row.implicitWidth
    implicitHeight: expanded ? _grid.implicitHeight : _row.implicitHeight

    Row {
        id: _row
        visible: !root.expanded
        spacing: root.rowSpacing
        padding: 4

        Repeater {
            model: root.visibleTrayItems

            delegate: TrayIconDelegate {}
        }

        Battery {
            width: root.iconSize
            height: root.iconSize
        }

        Rectangle {
            visible: root.compactMode && root.hiddenCount > 0
            width: root.iconSize
            height: root.iconSize
            radius: root.iconSize / 2
            color: "#3a3a3a"

            Text {
                anchors.centerIn: parent
                text: "+" + root.hiddenCount
                color: "white"
                font.pixelSize: 12
                font.bold: true
            }
        }
    }

    Column {
        id: _grid
        visible: root.expanded
        spacing: root.rowSpacing
        padding: 4

        readonly property int totalCount: root.expandedEntries.length + 1
        readonly property int firstRowCount: Math.ceil(totalCount / 2)

        Row {
            spacing: root.rowSpacing

            Repeater {
                model: root.expandedEntries.slice(0, _grid.firstRowCount)

                delegate: TrayIconDelegate {}
            }

            Battery {
                visible: _grid.firstRowCount > root.expandedEntries.length
                width: root.iconSize
                height: root.iconSize
            }
        }

        Row {
            spacing: root.rowSpacing

            Repeater {
                model: root.expandedEntries.slice(_grid.firstRowCount)

                delegate: TrayIconDelegate {}
            }

            Battery {
                visible: _grid.firstRowCount <= root.expandedEntries.length
                width: root.iconSize
                height: root.iconSize
            }
        }
    }
}
