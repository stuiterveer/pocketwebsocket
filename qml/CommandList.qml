import QtQuick 2.7
import Lomiri.Components 1.3

Page {
    property var pingPongList: []

    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr('Manage commands')

        trailingActionBar.actions: [
            Action {
                iconName: 'ok'
                text: i18n.tr('Save commands')

                onTriggered: {
                    serverList[currentlySelected]['commandList']['onConnect']['active'] = enableSendOnConnect.checked
                    serverList[currentlySelected]['commandList']['onConnect']['message'] = toSendOnConnect.text
                    serverList[currentlySelected]['commandList']['onConnect']['suppress'] = hideSendOnConnect.checked
                    serverList[currentlySelected]['commandList']['pingPong'] = pingPongList
                    serverListChanged()
                    pageStack.pop('CommandList.qml')
                }
            },
            Action {
                iconName: 'list-add'
                text: i18n.tr('Add command')

                onTriggered: {
                    var newPingPong = {
                        'ping': '',
                        'pong': '',
                        'active': false,
                        'suppressPing': false,
                        'suppressPong': false
                    }
                    pingPongList.push(newPingPong)
                    newPingPong['pingPongIndex'] = pingPongList.length - 1
                    commandModel.append(newPingPong)
                }
            }
        ]
    }

    ListItem {
        id: itemOnConnect
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        height: labelSendOnConnect.implicitHeight + toSendOnConnect.implicitHeight + hideSendOnConnect.implicitHeight

        CheckBox {
            id: enableSendOnConnect
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 10
            }

            checked: serverList[currentlySelected]['commandList']['onConnect']['active']
        }

        Label {
            id: labelSendOnConnect
            anchors {
                left: enableSendOnConnect.right
                leftMargin: 10
            }

            text: i18n.tr('After connecting, send')
        }

        TextField {
            id: toSendOnConnect
            anchors {
                left: enableSendOnConnect.right
                right: parent.right
                top: labelSendOnConnect.bottom
                leftMargin: 10
                rightMargin: 10
            }

            text: serverList[currentlySelected]['commandList']['onConnect']['message']
        }

        CheckBox {
            id: hideSendOnConnect
            anchors {
                left: enableSendOnConnect.right
                top: toSendOnConnect.bottom
                leftMargin: 10
            }

            checked: serverList[currentlySelected]['commandList']['onConnect']['suppress']
        }

        Label {
            anchors {
                left: hideSendOnConnect.right
                top: toSendOnConnect.bottom
                leftMargin: 10
            }

            text: i18n.tr('Hide message')
        }
    }

    Component {
        id: commandDelegate

        ListItem {
            height: pingContent.implicitHeight + pongContent.implicitHeight + hidePing.implicitHeight

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "edit-delete"
                        onTriggered: {
                            pingPongList.splice(pingPongIndex, 1)
                            commandModel.clear()
                            for (var i = 0; i < pingPongList.length; i++) {
                                var pingPongTemp = pingPongList[i]
                                pingPongTemp['pingPongIndex'] = i
                                commandModel.append(pingPongTemp)
                            }
                        }
                    }
                ]
            }

            CheckBox {
                id: enablePingPong
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 10
                }

                checked: active

                onCheckedChanged: pingPongList[pingPongIndex]['active'] = enablePingPong.checked
            }

            Label {
                id: labelPing
                anchors {
                    left: enablePingPong.right
                    leftMargin: 10
                }

                text: i18n.tr('When receiving')
            }

            TextField {
                id: pingContent
                anchors {
                    left: labelPing.right
                    right: parent.right
                    top: parent.top
                    leftMargin: 10
                    rightMargin: 10
                }

                text: ping

                onDisplayTextChanged: pingPongList[pingPongIndex]['ping'] = pingContent.text
            }

            Label {
                id: labelPong
                anchors {
                    left: enablePingPong.right
                    top: pingContent.bottom
                    leftMargin: 10
                }

                text: i18n.tr('Send back')
            }

            TextField {
                id: pongContent
                anchors {
                    left: labelPing.right
                    right: parent.right
                    top: pingContent.bottom
                    leftMargin: 10
                    rightMargin: 10
                }

                text: pong

                onDisplayTextChanged: pingPongList[pingPongIndex]['pong'] = pongContent.text
            }

            Label {
                id: hideLabel
                anchors {
                    left: enablePingPong.right
                    top: pongContent.bottom
                    leftMargin: 10
                }

                text: i18n.tr('Hide')
            }

            CheckBox {
                id: hidePing
                anchors {
                    left: hideLabel.right
                    top: pongContent.bottom
                    leftMargin: 10
                }

                checked: suppressPing

                onCheckedChanged: pingPongList[pingPongIndex]['suppressPing'] = hidePing.checked
            }

            Label {
                id: hidePingLabel
                anchors {
                    left: hidePing.right
                    top: pongContent.bottom
                    leftMargin: 10
                }

                text: 'Ping'
            }

            CheckBox {
                id: hidePong
                anchors {
                    left: hidePingLabel.right
                    top: pongContent.bottom
                    leftMargin: 10
                }

                checked: suppressPong

                onCheckedChanged: pingPongList[pingPongIndex]['suppressPong'] = hidePong.checked
            }

            Label {
                id: hidePongLabel
                anchors {
                    left: hidePong.right
                    top: pongContent.bottom
                    leftMargin: 10
                }

                text: 'Pong'
            }
        }
    }

    ListView {
        anchors {
            top: itemOnConnect.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: ListModel {
            id: commandModel
        }
        delegate: commandDelegate
    }

    Component.onCompleted: {
        commandModel.clear()

        for (var i = 0; i < serverList[currentlySelected]['commandList']['pingPong'].length; i++)
        {
            pingPongList.push(serverList[currentlySelected]['commandList']['pingPong'][i])
            var pingPongTemp = pingPongList[i]
            pingPongTemp['pingPongIndex'] = i
            commandModel.append(pingPongTemp)
        }
    }
}