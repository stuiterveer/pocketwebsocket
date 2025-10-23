import QtQuick 2.7
import Lomiri.Components 1.3

Page {
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
                    serverListChanged()
                    pageStack.pop('CommandList.qml')
                }
            }
        ]
    }

    ListItem {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent. right
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
}