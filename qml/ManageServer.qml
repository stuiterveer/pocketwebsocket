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

    Label {
        anchors {
            top: header.bottom
            bottom: serverName.bottom
            left: parent.left
            leftMargin: generalMargin
        }
        verticalAlignment: Text.AlignVCenter
        id: serverNameLabel
        text: i18n.tr('Server name')
    }

    TextField {
        anchors {
            top: header.bottom
            left: serverNameLabel.width > serverAddressLabel.width ? serverNameLabel.right : serverAddressLabel.right
            right: parent.right
            leftMargin: generalMargin
            rightMargin: generalMargin
        }
        id: serverName
        text: currentlySelected < 0 ? '' : serverList[currentlySelected]['name']
        placeholderText: (/^wss?:\/\/([^\/\?]+)/.exec(serverAddress.text) || ['',''])[1]
    }

    Label {
        anchors {
            top: serverAddress.top
            bottom: serverAddress.bottom
            left: parent.left
            leftMargin: generalMargin
        }
        verticalAlignment: Text.AlignVCenter
        id: serverAddressLabel
        text: i18n.tr('Server address')
    }

    TextField {
        anchors {
            top: serverName.bottom
            left: serverName.left
            right: parent.right
            rightMargin: generalMargin
        }
        id: serverAddress
        text: currentlySelected < 0 ? '' : serverList[currentlySelected]['url']
        inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
    }
}