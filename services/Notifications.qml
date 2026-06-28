pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property alias notifications: server.trackedNotifications
    readonly property int count: notifications.values.length

    signal newNotification(var notification)
    signal empty()

    onCountChanged: {
        if (count < 1) {
            root.empty()
        }
    }

    NotificationServer {
        id: server

        keepOnReload: true

        actionsSupported: true
        imageSupported: true
        bodyMarkupSupported: true

        onNotification: notification => {
            notification.tracked = true
            root.newNotification(notification)
        }
    }

    function dismissAll() {
        for (let i = root.count - 1; i >= 0; --i) {
            notifications.values[i].dismiss()
        }
    }

    function clearExpired() {
        for (let i = root.count - 1; i >= 0; --i) {
            notifications.values[i].expire()
        }
    }
}