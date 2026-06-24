import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../../../"

Item {
    id: root

    property var menu: null
    readonly property real contentHeight: _col.implicitHeight

    signal menuReady(real height)
    signal submenuRequested(var submenuEntry, real itemY)

    width: 200

    QsMenuOpener {
        id: _opener
        menu: root.menu
    }

    function _emitReady() {
        if (contentHeight > 0)
            menuReady(contentHeight)
    }

    Component.onCompleted: _emitReady()
    onContentHeightChanged: _emitReady()

    Column {
        id: _col
        width: parent.width
        padding: 10
        anchors.top: parent.top
        anchors.topMargin: 10

        Repeater {
            model: _opener.children

            delegate: Item {
                id: _delegate
                required property var modelData
                width: _col.width
                height: modelData.isSeparator ? 20 : 36

                Rectangle {
                    visible: _delegate.modelData.isSeparator
                    color: "transparent"
                }

                Rectangle {
                    visible: !_delegate.modelData.isSeparator
                    anchors.fill: parent
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    anchors.topMargin: 2
                    anchors.bottomMargin: 2
                    radius: 8
                    color: _hov.hovered ? "#22ffffff" : "transparent"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        IconImage {
                            visible: _delegate.modelData.icon !== ""
                            source: _delegate.modelData.icon
                            width: 16
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: _delegate.modelData.text
                            color: _delegate.modelData.enabled ? "#ffffff" : "#66ffffff"
                            font.pixelSize: 13
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideRight
                            width: parent.width
                                   - (parent.children[0].visible ? 24 : 0)
                                   - (_delegate.modelData.hasChildren ? 20 : 0)
                                   - parent.spacing * 2
                        }

                        Text {
                            visible: _delegate.modelData.hasChildren
                            text: "›"
                            color: "#aaffffff"
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HoverHandler { id: _hov }

                    TapHandler {
                        enabled: _delegate.modelData.enabled && !_delegate.modelData.isSeparator
                        onTapped: {
                            if (_delegate.modelData.hasChildren) {
                                root.submenuRequested(_delegate.modelData, _delegate.y)
                            } else {
                                _delegate.modelData.triggered()
                                IslandState.closeAll()
                            }
                        }
                    }
                }
            }
        }
    }
}
