import QtQuick 2.7
import Lomiri.Components 1.3

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: 'Pocket WebSocket'

        trailingActionBar.actions: [
            Action {
                iconName: 'list-add'
                text: i18n.tr('Add server')

                onTriggered: {
                    var addServerPage = pageStack.push(Qt.resolvedUrl('AddServer.qml'))
                    addServerPage.serverAdded.connect(reloadServers)
                }
            }
        ]
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
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "edit-delete"
                        onTriggered: {
                            serverList.splice(serverIndex, 1)
                            serverListChanged()
                            reloadServers()
                        }
                    }
                ]
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
            reloadServers()
        }
    }

    function reloadServers() {
        serverModel.clear()

        for (var i = 0; i < serverList.length; i++)
        {
            var serverTemp = serverList[i]
            serverTemp['serverIndex'] = i
            serverModel.append(serverTemp)
        }
    }
}