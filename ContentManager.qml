import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.state
import qs.services
import qs.components 

Scope {
    GlobalShortcut {
        name: "appLauncher"
        onPressed: {
            if (IslandState.isExpanded) {
                IslandState.closeAll()
            } else {
                IslandState.isKbFocusNeeded = true
                IslandState.openComponent(Components.appLauncher, 320, 218, null, {
                    listheightChanged: function(newHeight) {
                        IslandState.expand(320, newHeight)
                    }
                })
            }
        }
    }

    Connections {
        target: Notifications

        function onNewNotification(notificationItem) {
            if (IslandState.currentComponent !== Components.notification) {
                IslandState.openComponent(Components.notification, 340, 80, null, {
                    notificationHeightRequired: function(newHeight) {
                        if (IslandState.currentComponent === Components.notification) {
                            IslandState.expand(340, newHeight)
                        }
                    }
                });
            }
        }

        function onEmpty() {
            IslandState.closeAll();
        }
    }
}