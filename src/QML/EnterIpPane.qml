import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import BackendAsio

//тут пользователь пишет ip для подключения
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
                icon.source: "qrc:/icons/terminal.png"
                icon.color:"#00D492"
                background: Rectangle{
                    color:"transparent"
                }
            }
        }

        Text{
            text:"Ввод Ip-адреса"
            font.pixelSize: 25
            font.bold: true
            color: "White"
            Layout.alignment: Qt.AlignHCenter
        }
        Text{
            text:"Откройте серверное приложение на вашем ПК, которое вы скачали с GitHub. Найдите там локальный IP-адрес и введите его ниже."
            width:parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 13
            lineHeight: 1.25
            color:"#9F9FA9"
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width*0.95
        }
        TextField {
            id: ipField

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 19
            color:"#9F9FA9"
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width*0.95
            placeholderText: "Например, 192.168.1.5"

            inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText

            validator: RegularExpressionValidator {
                regularExpression: /^(\d{1,3}\.){3}\d{1,3}$|^$/
            }

            property bool isValid: false

            onTextChanged: {
                isValid = validateIp(text)
                if(isValid){
                    buttonConnect.enabled=true
                }
                else{
                    buttonConnect.enabled=false
                }
            }


            function validateIp(ip) {
                if (ip === "") return false

                const parts = ip.split('.')
                if (parts.length !== 4) return false

                for (let part of parts) {
                    if (part === "" || isNaN(part) || part < 0 || part > 255) {
                        return false
                    }
                    if (part.length > 1 && part.startsWith('0')) {
                        return false
                    }
                }
                return true
            }
        }

        RowLayout{
            spacing: 5
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 8

            Button {
                text: "Назад"
                Material.roundedScale: Material.SmallScale

                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: 120
                Layout.minimumWidth: 73
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                font.pixelSize: 14
                Material.background: "#18181B"
                Material.foreground: "White"

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideNone
                }

                onClicked: mainStackView.pop()
            }
            Button{
                id:buttonConnect
                text:"Подключиться"
                Material.roundedScale: Material.SmallScale
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: 400
                Layout.minimumWidth: 200
                Layout.fillWidth: true
                Layout.preferredHeight: 70

                font.pixelSize: 15
                Material.background: "#00BC7D"
                Material.foreground: "Black"
                enabled: false

                onClicked: {
                    BackendAsio.connectClient(ipField.text)
                    var pane = connectComponent.createObject(mainStackView)
                    mainStackView.push(pane)
                }
            }
        }
    }

    Component {
        id: connectComponent
        ConnectPane {}
    }
}

