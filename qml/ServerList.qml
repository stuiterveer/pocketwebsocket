import QtQuick 2.7
import Lomiri.Components 1.3

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: 'Pocket WebSocket'
    }

    Component {
        id: serverDelegate
        ListItem {
            Label {
                text: name
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: {
                connectionDetails['name'] = name
                connectionDetails['url'] = url
                pageStack.push(Qt.resolvedUrl('ServerConnect.qml'))
            }
        }
    }

    ListView {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: ListModel {
            id: serverModel
        }
        delegate: serverDelegate

        Component.onCompleted: {
            serverModel.clear()

            for (var i = 0; i < serverList.length; i++)
            {
                serverModel.append(serverList[i])
            }
        }
    }
}