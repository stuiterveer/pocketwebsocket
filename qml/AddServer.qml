import QtQuick 2.7
import Lomiri.Components 1.3

Page {
    signal serverAdded()

    anchors.fill: parent

    header: PageHeader {
        id: header
        title: currentlyEditing < 0 ? i18n.tr('Add server') : i18n.tr('Edit server')
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
            text: currentlyEditing < 0 ? '' : serverList[currentlyEditing]['name']
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
            text: currentlyEditing < 0 ? '' : serverList[currentlyEditing]['url']
        }
    }

    Button {
        anchors {
            top: serverAddressRow.bottom
        }
        id: sendNewMessage

        height: units.gu(4)
        color: isDark ? 'Light Green' : 'Green'

        text: currentlyEditing < 0 ? i18n.tr('Add server') : i18n.tr('Save changes')

        onClicked: {
            if (currentlyEditing < 0) {
                serverList.push({
                    'name': serverName.text,
                    'url': serverAddress.text
                })
            } else {
                serverList[currentlyEditing] = {
                    'name': serverName.text,
                    'url': serverAddress.text
                }
            }
            serverListChanged()
            serverAdded()
            pageStack.pop('AddServer.qml')
        }
    }
}