import QtQuick 2.7
import Lomiri.Components 1.3
import QtWebSockets 1.0

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: serverList[currentlySelected]['name']

        trailingActionBar.actions: [
            Action {
                iconName: 'stop'
                text: i18n.tr('Disconnect')

                onTriggered: socket.active = false
            },
            Action {
                iconName: 'reload'
                text: i18n.tr('Reconnect')

                onTriggered: {
                    socket.active = false
                    socket.active = true
                }
            }
        ]
    }

    WebSocket {
        id: socket

        url: serverList[currentlySelected]['url']
        onTextMessageReceived: {
            messageModel.append({
                messageType: 'received',
                messageContents: message
            })
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
                messageModel.append({
                    messageType: 'connected',
                    messageContents: socket.url.toString()
                })
                newMessage.enabled = true
                sendNewMessage.enabled = true
            } else if (socket.status == WebSocket.Closed) {
                newMessage.enabled = false
                sendNewMessage.enabled = false
                messageModel.append({
                    messageType: 'disconnected',
                    messageContents: socket.url.toString()
                })
            }
        }
        active: true
    }

    Component {
        id: messageDelegate

        Row {
            Icon {
                name: 'phone-smartphone-symbolic'
                height: txt.font.pixelSize
            }

            Icon {
                name: switch (messageType) {
                    case 'received':
                        return 'previous';
                        break;
                    case 'sent':
                        return 'next';
                        break;
                    case 'connected':
                        return 'tick';
                        break;
                    case 'disconnected':
                        return 'stop';
                        break;
                    default:
                        // Should never happen, show question mark to indicate unknown icon
                        return 'dialog-question-symbolic';
                        break;
                }
                height: txt.font.pixelSize
            }

            ListItem {
                height: txt.implicitHeight
                width: txt.implicitWidth

                divider {
                    visible: false
                }

                Label {
                    width: root.width
                    wrapMode: Text.Wrap

                    id: txt
                    text: messageContents
                }
            }
        }
    }

    ListView {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: newMessage.top
        }

        id: messageView
        
        model: ListModel {
            id: messageModel
        }
        delegate: messageDelegate

        onCountChanged: positionViewAtEnd()
    }

    TextField {
        anchors {
            bottom: keyboard.top
            left: parent.left
            right: sendNewMessage.left
        }
        id: newMessage
        placeholderText: i18n.tr('Type new message...')

        height: units.gu(4)

        enabled: false
    }

    Button {
        anchors {
            bottom: keyboard.top
            right: parent.right
        }
        id: sendNewMessage

        height: units.gu(4)
        width: height
        color: isDark ? 'Light Green' : 'Green'

        enabled: false

        onClicked: {
            socket.sendTextMessage(newMessage.text)
            messageModel.append({
                messageType: 'sent',
                messageContents: newMessage.text
            })
            newMessage.text = ''
        }
    }

    Icon {
        name: 'send'
        anchors.fill: sendNewMessage
        color: isDark ? 'Jet' : 'White'
    }

    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        id: keyboard
        height: LomiriApplication.inputMethod.keyboardRectangle.height
        color: backgroundColor
    }
}