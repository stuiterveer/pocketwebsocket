import QtQuick 2.7
import Lomiri.Components 1.3

Page {
    signal serverAdded()

    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr('Add server')
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
        }
    }

    Button {
        anchors {
            top: serverAddressRow.bottom
        }
        id: sendNewMessage

        height: units.gu(4)
        color: isDark ? 'Light Green' : 'Green'

        text: i18n.tr('Add server')

        onClicked: {
            serverList.push({
                'name': serverName.text,
                'url': serverAddress.text
            })
            serverListChanged()
            serverAdded()
            pageStack.pop('AddServer.qml')
        }
    }
}