import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.state
import qs.theme
import qs.widgets

Item {
    id: root

    required property var menu
    property string trayName: ""

    signal menuHeightChanged(int newHeight)

    property var path: []
    property int headerHeight: 40
    property int rowHeight: 34
    property int separatorHeight: 10

    readonly property int activeDepth: path.length
    readonly property int totalHeight: headerRoot.height + menuContent.implicitHeight

    readonly property var breadcrumbsModel: {
        const items = [{ label: root.trayName, depth: 0 }]
        for (let i = 0; i < path.length; ++i) {
            items.push({ label: path[i].label, depth: i + 1 })
        }
        return items
    }

    function openSubmenu(entry) {
        const next = root.path.slice(0, root.activeDepth)
        next.push({
            entry,
            label: entry.text || "Menu"
        })
        root.path = next
    }

    function goToDepth(depth) {
        const d = Math.max(0, Math.min(depth, path.length))
        path = path.slice(0, d)
    }

    property var openerStack: []

    Component {
        id: openerComponent
        QsMenuOpener {}
    }

    function rebuildOpeners() {
        const currentPath = root.path
        const depth = currentPath.length

        while (openerStack.length > depth + 1) {
            const stale = openerStack.pop()
            stale.destroy()
        }

        for (let i = 0; i <= depth; ++i) {
            const sourceMenu = i === 0 ? root.menu : currentPath[i - 1].entry

            if (openerStack[i] && openerStack[i].menu === sourceMenu) {
                continue
            }

            if (openerStack[i]) {
                openerStack[i].destroy()
            }

            openerStack[i] = openerComponent.createObject(root, { menu: sourceMenu })
        }

        openerStack = openerStack.slice()
    }

    readonly property var activeOpener: openerStack.length > 0 ? openerStack[openerStack.length - 1] : null

    Component.onCompleted: {
        rebuildOpeners()
        menuHeightChanged(totalHeight + 30)
    }
    onPathChanged: {
        rebuildOpeners()
        menuHeightChanged(totalHeight + 30)
    }
    onMenuChanged: path = []

    Item {
        id: headerRoot
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.headerHeight

        anchors.margins: 10

        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 10

            BackButton {
                baseColor: Theme.accent
                hoverColor: Theme.accentDim
                arrowColor: Theme.light0Hard

                onClick: () => IslandState.closeAll()
            }

            RowLayout {
                id: crumbsRow
                spacing: 12
                height: parent.height

                Repeater {
                    model: root.breadcrumbsModel

                    delegate: Item {
                        width: crumb.width + sep.width
                        height: parent.height

                        Text {
                            id: crumb
                            text: modelData.label
                            color: crumbMouse.containsMouse ? Theme.gray : Theme.foreground
                            font.pixelSize: 13
                            font.bold: modelData.depth === root.activeDepth
                            elide: Text.ElideRight

                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }

                        Text {
                            id: sep
                            visible: model.index < root.breadcrumbsModel.length - 1
                            text: ""
                            color: Theme.foregroundDim
                            font.pixelSize: 10

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: crumb.right
                            anchors.leftMargin: 6
                            anchors.verticalCenterOffset: -0.5
                        }

                        MouseArea {
                            id: crumbMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: model.index < root.breadcrumbsModel.length - 1
                            onClicked: root.goToDepth(modelData.depth)
                        }
                    }
                }
            }
        }
    }

    Item {
        id: menuArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerRoot.bottom
        anchors.bottom: parent.bottom
        clip: true

        anchors.margins: 10
        
        Item {
            id: menuContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            implicitHeight: menuList.implicitHeight

            Column {
                id: menuList
                width: parent.width
                spacing: -2

                Repeater {
                    model: root.activeOpener ? root.activeOpener.children : null

                    delegate: Item {
                        id: _delegate
                        required property var modelData

                        width: menuList.width
                        implicitHeight: modelData.isSeparator ? root.separatorHeight : root.rowHeight

                        Rectangle {
                            anchors.fill: parent
                            color: rowMouse.containsMouse && !_delegate.modelData.isSeparator && _delegate.modelData.enabled ? Theme.accent : "transparent"
                            radius: width / 2
                        }

                        Rectangle {
                            visible: _delegate.modelData.isSeparator
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            height: 6
                            color: "transparent"
                        }

                        Row {
                            visible: !_delegate.modelData.isSeparator
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 8

                            Image {
                                visible: _delegate.modelData.icon
                                width: 18
                                height: 18
                                anchors.verticalCenter: parent.verticalCenter
                                source: _delegate.modelData.icon
                                sourceSize.width: width
                                sourceSize.height: height
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                width: parent.width - 40
                                anchors.verticalCenter: parent.verticalCenter
                                text: _delegate.modelData.text || ""
                                color: _delegate.modelData.enabled ? Theme.foreground : Theme.gray
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: _delegate.modelData.hasChildren
                                anchors.verticalCenter: parent.verticalCenter
                                text: ""
                                color: Theme.foregroundDim
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            enabled: !_delegate.separator && enabled
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: () => {
                                if (_delegate.modelData.hasChildren) {
                                    root.openSubmenu(_delegate.modelData)
                                } else {
                                    _delegate.modelData.triggered();
                                    IslandState.closeAll();
                                }
                            }
                        }
                    }
                }
            }

            Connections {
                target: menuContent
                function onImplicitHeightChanged() {
                    root.menuHeightChanged(root.totalHeight + 30)
                }
            }

            Connections {
                target: root.activeOpener
                function onChildrenChanged() {
                    root.menuHeightChanged(root.totalHeight + 30)
                }
            }
        }
    }
}
