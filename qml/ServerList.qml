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
                    currentlySelected = -1
                    var manageServerPage = pageStack.push(Qt.resolvedUrl('ManageServer.qml'))
                    manageServerPage.serverManaged.connect(reloadServers)
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
                currentlySelected = serverIndex
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
            trailingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "edit"
                        onTriggered: {
                            currentlySelected = serverIndex
                            var manageServerPage = pageStack.push(Qt.resolvedUrl('ManageServer.qml'))
                            manageServerPage.serverManaged.connect(reloadServers)
                        }
                    },
                    Action {
                        iconName: "filters"
                        onTriggered: {
                            currentlySelected = serverIndex
                            pageStack.push(Qt.resolvedUrl('CommandList.qml'))
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