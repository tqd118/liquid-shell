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

    property var trayMenuMenu: null

    property Component trayMenuComponent: Component {
        TrayMenu {
            anchors.fill: parent
            menu: Components.trayMenuMenu
        }
    }
}