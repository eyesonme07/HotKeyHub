import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
//а это красивый TabBar
Rectangle {
    id: root
    height: 80
    color: "#1a1a1a"

    ListModel {
        id: tabModel
        ListElement { label: "Медиа";   iconPath: "qrc:/icons/music.png" }
        ListElement { label: "Трекпад"; iconPath: "qrc:/icons/navigation.png" }
        ListElement { label: "Хоткеи";  iconPath: "qrc:/icons/command.png" }
    }

    property int currentIndex: 0
    property real tabWidth: root.width / tabModel.count

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            height: 3

            Rectangle {
                width: root.tabWidth * 0.4
                height: 3
                color: "#00D492"
                radius: 2

                x: root.currentIndex * root.tabWidth
                   + (root.tabWidth - width) / 2

                Behavior on x {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
            }
        }

        Row {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: tabModel

                Item {
                    width: root.tabWidth
                    height: parent.height

                    property bool isActive: root.currentIndex === index

                    property color itemColor: isActive ? "#00D492" : "#808080"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.currentIndex = index
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        Item {
                            width: 28
                            height: 28
                            anchors.horizontalCenter: parent.horizontalCenter

                            Image {
                                id: tabIcon
                                anchors.fill: parent
                                source: iconPath
                                fillMode: Image.PreserveAspectFit
                                visible: false
                            }

                            ColorOverlay {
                                anchors.fill: tabIcon
                                source: tabIcon
                                color: parent.parent.parent.itemColor

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }
                        }

                        Text {
                            text: label
                            color: parent.parent.itemColor
                            font.pixelSize: 12
                            font.bold: parent.parent.isActive
                            anchors.horizontalCenter: parent.horizontalCenter

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }
                }
            }
        }
    }
}
