import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Backend

//тут оснновной TabBar и основное окно
Page{
    padding: 0

    Rectangle{
        id:topMenu
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height:70
        color:"transparent"

        Rectangle{
            id:pcRec
            radius: 50
            width: 40
            height:40
            color:"#072D22"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 15
            anchors.topMargin: 15

            Image{
                id:imagePc
                visible: false
                anchors.centerIn: parent
                width: 20
                height:20
                source:"qrc:/icons/monitor.png"
            }

            ColorOverlay{
                source:imagePc
                anchors.fill: imagePc
                color:"#01B77E"
            }

        }

        ColumnLayout {
            anchors.left: pcRec.right
            anchors.leftMargin: 12
            anchors.verticalCenter: pcRec.verticalCenter

            Text {
                text: Backend.deviceData["pcName"]
                color: "White"
                font.bold: true
                font.pixelSize: 17
            }

            RowLayout {
                spacing: 6
                Rectangle {
                    width: 5
                    height: 5
                    radius: 5
                    color: "#01AE74"
                }
                Text {
                    font.pixelSize: 10
                    text: "ПОДКЛЮЧЕНО"
                    color: "White"
                }
            }
        }


        Button {
            id: exitButton
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.rightMargin: 15

            width: 40
            height: 40
            hoverEnabled: true

            background: Rectangle {
                anchors.fill: parent
                color: "#18181B"
                radius: width / 2
            }

            Image {
                id: exitImage
                width: 20
                height: 20
                anchors.centerIn: parent
                source: "qrc:/icons/log-out.png"
            }

            ColorOverlay {
                id: colorOverlay
                source: exitImage
                anchors.fill: exitImage
                color: exitButton.hovered ? "#FF4D4D" : "#82828A"
            }

            onClicked:{
                mainStackView.pop()
                mainStackView.pop()
                mainStackView.pop()
            }
        }
    }

    Rectangle{
        height:1
        anchors.top: topMenu.bottom
        anchors.left: topMenu.left
        width:topMenu.width
        color:"#27272A"
    }

    SwipeView {
        id: mainSwipeView
        anchors.top: topMenu.bottom
        anchors.left: parent.left
        width: parent.width
        height: parent.height - topMenu.height

        currentIndex: tabBar.currentIndex

        clip: true
        interactive: false
        orientation: Qt.Horizontal

        MediaPage {
            id: mediaPage
        }
        TouchpadPage {
            id: touchpadPage
        }
        HotkeyPage {
            id: hotkeyPage
        }
    }

    CustomTabBar{
        id:tabBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width:parent.width
    }
}

