import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import qs.services
import qs.theme

Item {
    id: root

    property var notificationItem: Notifications.notifications.values[0]
    readonly property real autoExpireSeconds: 5

    property real notificationHeight: 60

    readonly property bool hasNotification: notificationItem !== null && notificationItem !== undefined
    readonly property bool hasActions: hasNotification && notificationItem.actions && notificationItem.actions.length > 0
    readonly property bool hasInlineReply: hasNotification && notificationItem.hasInlineReply

    signal notificationHeightRequired(real newHeight)

    anchors.fill: parent

    onNotificationItemChanged: expireTimer.restart()

    Timer {
        id: expireTimer
        interval: root.autoExpireSeconds * 1000
        repeat: false
        running: true

        onTriggered: {
            if (root.hasNotification) {
                root.notificationItem.expire()
            }
        }
    }

    function appInitials(name) {
        if (!name || name.length === 0) {
            return "?"
        }

        var parts = name.trim().split(/\s+/)
        if (parts.length === 1) {
            return parts[0].slice(0, 2).toUpperCase()
        }

        return (parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase()
    }

    function sendReply(text) {
        if (!hasNotification) {
            return
        }

        if (text && text.length > 0) {
            notificationItem.sendInlineReply(text)
        }
    }

    Item {
        id: notification
        anchors.margins: 12

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Column {
            id: contentColumn
            onImplicitHeightChanged: root.notificationHeightRequired(implicitHeight + 24)

            anchors.fill: parent
            spacing: 8

            Item {
                id: headerRow
                width: parent.width
                implicitHeight: Math.max(iconArea.implicitHeight, textColumn.implicitHeight, closeButton.implicitHeight)

                Item {
                    id: iconArea
                    width: 36
                    height: 36
                    anchors.left: parent.left
                    anchors.top: parent.top

                    Image {
                        id: appIcon
                        anchors.fill: parent
                        visible: !!root.notificationItem?.appIcon
                        source: root.notificationItem?.appIcon || ""
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        smooth: true
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2 
                        visible: !appIcon.visible
                        color: Theme.accent


                        Text {
                            anchors.centerIn: parent
                            text: root.hasNotification ? root.appInitials(root.notificationItem.appName || root.notificationItem.summary) : "?"
                            color: Theme.foreground
                            font.pixelSize: 13
                            font.bold: true
                        }
                    }
                }

                Item {
                    id: closeButton
                    width: 24
                    height: 24
                    anchors.right: parent.right
                    anchors.top: parent.top

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: Theme.foreground
                        font.pixelSize: 16
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.notificationItem.dismiss()
                        }
                    }
                }

                Column {
                    id: textColumn
                    anchors.left: iconArea.right
                    anchors.leftMargin: 10
                    anchors.right: closeButton.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Item {
                        id: titleRow 
                        width: parent.width
                        height: 20

                        Text {
                            id: appName
                            text: root.hasNotification ? (root.notificationItem.appName || "Notification") : "Notification"
                            color: Theme.foreground
                            font.pixelSize: 13
                            font.bold: true
                            elide: Text.ElideRight
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Rectangle {
                            id: badge 
                            height: 16
                            width: plus.width + plusCount.width + 14
                            radius: height / 2

                            color: Theme.accent
                            anchors.left: appName.right
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            visible: Notifications.count > 1


                            Text {
                                id: plus 
                                text: ""
                                color: Theme.foreground

                                anchors.right: plusCount.left
                                anchors.rightMargin: 3

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -1

                                font.pixelSize: 10
                            }

                            Text {
                                id: plusCount
                                text: Notifications.count - 1

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                font.pixelSize: 12


                                color: Theme.foreground
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: root.hasNotification ? (root.notificationItem.summary || "") : ""
                        color: Theme.foreground
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }

                    Text {
                        width: parent.width
                        text: root.hasNotification ? (root.notificationItem.body || "") : ""
                        color: Theme.foregroundDim
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                    }
                }
            }

            Item {
                id: actionsArea
                visible: root.hasActions
                width: parent.width
                implicitHeight: visible ? actionsRow.implicitHeight : 0

                Row {
                    id: actionsRow
                    spacing: 12
                    height: visible ? 20 : 0

                    Repeater {
                        model: root.hasNotification ? root.notificationItem.actions : []

                        delegate: Text {
                            text: modelData.text
                            color: Theme.foreground
                            font.pixelSize: 11
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: modelData.invoke()
                            }
                        }
                    }
                }
            }

            Item {
                id: replyArea
                visible: root.hasInlineReply
                width: parent.width
                implicitHeight: visible ? 28 : 0

                TextInput {
                    id: replyInput
                    anchors.left: parent.left
                    anchors.right: sendButton.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    height: 22
                    text: ""
                    color: Theme.foreground
                    font.pixelSize: 11
                    selectByMouse: true
                    clip: true
                    verticalAlignment: TextInput.AlignVCenter
                    onAccepted: {
                        root.sendReply(text)
                        text = ""
                    }
                }

                Text {
                    anchors.left: replyInput.left
                    anchors.verticalCenter: replyInput.verticalCenter
                    visible: replyInput.text.length === 0 && !replyInput.activeFocus
                    text: root.hasNotification ? (root.notificationItem.inlineReplyPlaceholder || "") : ""
                    color: Theme.foregroundDim
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Item {
                    id: sendButton
                    width: 24
                    height: 22
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "➤"
                        color: Theme.foreground
                        font.pixelSize: 10
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.sendReply(replyInput.text)
                            replyInput.text = ""
                        }
                    }
                }
            }
        }
    }
}