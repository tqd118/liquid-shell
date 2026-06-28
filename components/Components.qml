pragma Singleton
import QtQuick

Item {
    id: root

    property var defaultComponent: Component {
        id: defaultComponent
        Default { anchors.fill: parent }
    }

    property var expandedComponent: Component {
        id: expandedComponent
        Expanded { anchors.fill: parent }
    }

    property var batteryInfo: Component {
        id: batteryInfo
        BatteryInfo { anchors.fill: parent }
    }

    property var appLauncher: Component {
        id: appLauncher
        AppLauncher { anchors.fill: parent }
    }

    property var notification: Component {
        id: notification
        Notification { anchors.fill: parent }
    } 

    property var trayMenuMenu: null

    property Component trayMenuComponent: Component {
        TrayMenu {
            anchors.fill: parent
            menu: Components.trayMenuMenu
        }
    }
}