import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

//тут говориться скачать сервер и тд
Pane{
    ColumnLayout{
        spacing :24
        anchors.centerIn: parent
        width:parent.width*0.85
        Rectangle{
            width: 100
            height:100
            color:"#18181B"
            radius: 50
            Layout.alignment: Qt.AlignHCenter

            Button{
                anchors.centerIn: parent
                icon.width: parent.width/2
                icon.height:parent.height/2
                icon.source: "qrc:/icons/server.png"
                icon.color:"#50A0FF"
                background: Rectangle{
                    color:"transparent"
                }
            }
        }

        Text{
            text:"Установка сервера"
            font.pixelSize: 25
            font.bold: true
            color: "White"
            Layout.alignment: Qt.AlignHCenter
        }
        Text{
            width: parent.width
            text:"Для работы приложения необходимо скачать и запустить серверную часть на вашем ПК. Убедитесь, что телефон и ПК находятся в одной Wi-Fi сети."
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 13
            lineHeight: 1.25
            color:"#9F9FA9"
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width*0.95
        }

        ColumnLayout{
            spacing: 5
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 8

            Button{
                text:"Скачать с GitHub"
                Material.roundedScale: Material.SmallScale
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: 400
                Layout.minimumWidth: 200
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                font.pixelSize: 15
                Material.background: "#18181B"
                Material.foreground: "White"

                icon.source: "qrc:/icons/github.png"
                icon.color: "White"
                icon.width: 15
                icon.height: 15

                onClicked:{
                    Qt.openUrlExternally('https://github.com/eyesonme07/HotKeyHub-Host')
                }
            }
            Button{
                text:"Я запустил сервер"
                Material.roundedScale: Material.SmallScale
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: 400
                Layout.minimumWidth: 200
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                font.pixelSize: 15
                Material.background: "#00BC7D"
                Material.foreground: "Black"

                onClicked:{
                    mainStackView.push(page2)
                }
            }
        }
    }
}
