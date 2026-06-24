pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../"

Item {
    id: root

    readonly property var iconOverrides: ({
        "materialgram": "root:assets/icons/telegram.svg",
        "steam": "root:assets/icons/steam.svg",
        "nm-applet": "root:assets/icons/nm-applet.svg",
    })

    function resolveIcon(item) {
        return iconOverrides[item.id] ?? item.icon
    }

    implicitWidth: _row.implicitWidth
    implicitHeight: 36

    Row {
        id: _row
        spacing: 4
        padding: 4

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: _delegate
                required property SystemTrayItem modelData

                width: 28
                height: 28

                Image {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    source: resolveIcon(_delegate.modelData)
                    sourceSize.width: 20
                    sourceSize.height: 20
                    smooth: true
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        const item = _delegate.modelData
                        if (mouse.button === Qt.LeftButton) {
                            if (item.onlyMenu) {
                                if (item.hasMenu)
                                    item.activate()
                            } else {
                                item.activate()
                            }
                        }
                    }
                }
            }
        }
    }
}
