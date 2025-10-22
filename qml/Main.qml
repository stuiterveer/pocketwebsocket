/*
 * Copyright (C) 2025  stuiterveer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * pocketwebsocket is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtWebSockets 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'pocketwebsocket.stuiterveer'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    readonly property bool isDark: theme.name === 'Lomiri.Components.Themes.SuruDark'

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Pocket WebSocket')
        }

        TextField {
            anchors {
                top: header.bottom
                left: parent.left
                right: websocketConnect.left
            }
            id: websocketUrl
            placeholderText: i18n.tr('Enter WebSocket URL...')
            text: 'wss://echo.websocket.org'

            height: units.gu(4)
        }

        Button {
            anchors {
                top: header.bottom
                right: parent.right
            }
            id: websocketConnect
 
            height: units.gu(4)
            width: height
            color: isDark ? 'Light Green' : 'Green'
 
            onClicked: {
                socket.active = false
                socket.url = websocketUrl.text
                socket.active = true
            }
        }

        Icon {
            name: 'tick'
            anchors.fill: websocketConnect
            color: isDark ? 'Jet' : 'White'
        }

        WebSocket {
            id: socket
            onTextMessageReceived: {
                messageModel.append({
                    messageType: 'received',
                    messageContents: message
                })
            }
            onStatusChanged: if (socket.status == WebSocket.Error) {
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
            active: false
        }

        Component {
            id: messageDelegate

            Row {
                Icon {
                    name: 'phone-smartphone-symbolic'
                    height: txt.implicitHeight
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
                    height: txt.implicitHeight
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
                top: websocketUrl.bottom
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
}
