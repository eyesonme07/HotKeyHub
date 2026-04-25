import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import BackendAsio

//окно управление мышкой
Item {
    id: touchpadPage

    ColumnLayout {
        anchors.centerIn: parent
        width:parent.width-20
        spacing: 10

        Text {
            Layout.alignment: Qt.AlignLeft
            text: "Мышь и клавиатура"
            font.pixelSize: 23
            color: "White"
        }

        Rectangle {
            id:touchpad
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: touchpadPage.height/2
            radius: 20
            color: "#0F0F12"
            border.color: "#222225"
            border.width: 1

            CheckBox{
                id:scrollCheck
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 5
                anchors.rightMargin: 5
                font.pixelSize: 13
                text:"Скролл"
            }

            PointHandler {
                id: pointHandler
                acceptedDevices: PointerDevice.TouchScreen | PointerDevice.Mouse
                acceptedPointerTypes: PointerDevice.Finger | PointerDevice.Mouse

                property real sensitivity: 2.2
                property real scrollSensitivity: 3.5

                property real lastMouseX: 0
                property real lastMouseY: 0
                property real lastScrollY: 0

                onActiveChanged: {
                    if (active) {
                        touchpad.color = "#2a2a3a"

                        if (scrollCheck.checked) {
                            lastScrollY = point.position.y
                        } else {
                            lastMouseX = point.position.x
                            lastMouseY = point.position.y
                        }
                    } else {
                        touchpad.color = "#1c1c21"
                    }
                }

                onPointChanged: {
                    if (!active) return

                    if (scrollCheck.checked) {
                        let dy = point.position.y - lastScrollY

                        if (Math.abs(dy) > 2) {
                            BackendAsio.scroll(-dy * scrollSensitivity)
                            lastScrollY = point.position.y
                        }
                    }
                    else {
                        let dx = point.position.x - lastMouseX
                        let dy = point.position.y - lastMouseY

                        if (Math.abs(dx) > 1 || Math.abs(dy) > 1) {
                            BackendAsio.moveMouse(dx * sensitivity, dy * sensitivity)

                            lastMouseX = point.position.x
                            lastMouseY = point.position.y
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Button {
                text: "Левая"
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                background: Rectangle {
                    radius: 14
                    color: "#0F0F12"
                    border.width: 1
                    border.color: "#222225"
                }
                onClicked: {
                    BackendAsio.command("lButton")
                }
            }

            Button {
                text: "Правая"
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                background: Rectangle {
                    radius: 14
                    color: "#0F0F12"
                    border.width: 1
                    border.color: "#222225"
                }
                onClicked:{
                    BackendAsio.command("rButton")
                }
            }
        }
    }
}
