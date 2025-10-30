import QtQuick 2.7
import Lomiri.Components 1.3

Page {
    signal serverManaged()

    anchors.fill: parent

    header: PageHeader {
        id: header
        title: currentlySelected < 0 ? i18n.tr('Add server') : i18n.tr('Edit server')

        trailingActionBar.actions: [
            Action {
                iconName: 'ok'
                text: currentlySelected < 0 ? i18n.tr('Add server') : i18n.tr('Save changes')

                onTriggered: {
                    if (currentlySelected < 0) {
                        serverList.push({
                            'name': (serverName.text != '' ? serverName.text : serverName.placeholderText),
                            'url': serverAddress.text,
                            'commandList': {
                                'onConnect': {
                                    'active': false,
                                    'message': '',
                                    'suppress': false
                                },
                                'pingPong': []
                            }
                        })
                    } else {
                        serverList[currentlySelected]['name'] = (serverName.text != '' ? serverName.text : serverName.placeholderText)
                        serverList[currentlySelected]['url'] = serverAddress.text
                    }
                    serverListChanged()
                    serverManaged()
                    pageStack.pop('AddServer.qml')
                }
            }
        ]
    }

    Row {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        id: serverNameRow

        Label {
            text: i18n.tr('Server name')
        }

        TextField {
            id: serverName
            text: currentlySelected < 0 ? '' : serverList[currentlySelected]['name']
            placeholderText: /^wss?:\/\/([^\/\?]+)/.exec(serverAddress.text)[1]
        }
    }

    Row {
        anchors {
            top:serverNameRow.bottom
            left: parent.left
            right: parent.right
        }
        id: serverAddressRow

        Label {
            text: i18n.tr('Server address')
        }

        TextField {
            id: serverAddress
            text: currentlySelected < 0 ? '' : serverList[currentlySelected]['url']
        }
    }
}