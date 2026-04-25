import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import BackendDatabase


Item {
    id: hotkeyPage

    Component.onCompleted: {
        var map = BackendDatabase.loadData()
        var keys=Object.keys(map)

        for(var i=0;i<keys.length;++i){
            repModel.append({text:keys[i],key:map[keys[i]],deleteVisible:false})
        }
    }

    Rectangle{
        width:parent.width
        height:parent.height-80
        anchors.top: parent.top
        anchors.left:parent.left
        color:"transparent"

        Rectangle {
            id: toolMenu
            height: 90
            width: parent.width
            anchors.top: parent.top
            color:"transparent"

            Text{
                text:"Горячие клавиши"
                font.bold: true
                color:"White"
                font.pixelSize: 16
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            CheckBox{
                id:checkBox
                checked: false
                anchors.right: buttonOpenDialog.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text:"Удаление"

                onClicked: {
                    var ch = checkBox.checked
                    for(var i=0;i<repModel.count;++i){
                        repModel.setProperty(i,"deleteVisible",ch)
                    }
                }
            }

            Button{
                id:buttonOpenDialog
                width:45
                height:55

                background: Rectangle{
                    radius:width/2
                    color:"#00D492"

                    Image{
                        id:plusImage
                        anchors.centerIn: parent
                        source: "qrc:/icons/plus.png"
                        width: parent.width/2
                        height:width
                        visible:false
                    }
                    ColorOverlay{
                        source: plusImage
                        color:"Black"
                        anchors.fill: plusImage
                    }
                }
                anchors.right:parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter

                onClicked:{
                    dialogAddHotKey.open()
                }
            }

        }

        ScrollView {
            anchors.top: toolMenu.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            padding: 20

            contentWidth: availableWidth

            GridLayout {
                width: parent.width
                columns: 2
                columnSpacing: 8
                rowSpacing: 16

                Repeater{
                    model: ListModel{
                        id:repModel
                    }
                    HotKeyItem{
                        name: model.text
                        key: model.key
                        Layout.fillWidth: true
                        deleteVisible: model.deleteVisible
                        Layout.alignment: Qt.AlignTop
                    }
                }

            }
        }
    }

    Dialog{
        id: dialogAddHotKey
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height *0.8
        padding: 5

        ColumnLayout{
            spacing: 4
            anchors.fill: parent
            anchors.margins: 16

            RowLayout{
                Layout.fillWidth: true

                Item {
                    width: iconHotKeyDialog.width
                    height: iconHotKeyDialog.height

                    Image{
                        id: iconHotKeyDialog
                        source: "qrc:/icons/command.png"
                        width:30
                        height:30
                        visible: false
                    }
                    ColorOverlay{
                        anchors.fill: iconHotKeyDialog
                        color: "#0A8A63"
                        source: iconHotKeyDialog
                    }
                }
                Text{
                    text: "Новый хоткей"
                    font.pixelSize: 16
                    color: "White"
                    font.bold: true
                }
            }

            Text{
                Layout.alignment: Qt.AlignLeft
                text: "НАЗВАНИЕ ДЕЙСТВИЯ"
                color: "grey"
                font.pixelSize: 15
            }
            TextField{
                id:nameField
                placeholderText: "Например: открыть почту"
                Layout.fillWidth: true
            }
            Text{
                Layout.alignment: Qt.AlignLeft
                text: "КОМБИНАЦИЯ КЛАВИШ"
                color: "grey"
                font.pixelSize: 15
            }
            RowLayout {
                Layout.fillWidth: true

                TextField {
                    id: keyField
                    Layout.fillWidth: true
                }

                Button {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignVCenter

                    background: Rectangle {
                        color: "transparent"

                        Image {
                            id: imageWhat
                            source: "qrc:/icons/message-question.png"
                            anchors.centerIn: parent
                        }

                        ColorOverlay {
                            anchors.fill: imageWhat
                            source: imageWhat
                            color: "white"
                        }
                    }
                    onClicked: {
                        dialogGuide.open()
                    }
                }
            }
            Rectangle{
                height:50
            }

            Button{
                text:"Сохранить"
                highlighted: true
                Material.foreground: "Black"
                font.pixelSize: 16
                font.bold: true
                Layout.fillWidth: true

                onClicked: {
                    if(BackendDatabase.addHotKey(nameField.text,keyField.text)){
                        repModel.append({text:nameField.text,key:keyField.text,deleteVisible:false})
                        nameField.text=''
                        keyField.text=''
                        dialogAddHotKey.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: dialogGuide

        width: parent.width * 0.9
        height: parent.height * 0.85
        anchors.centerIn: parent

        // Убираем стандартное оформление диалога
        background: Rectangle {
            color: "#1a1a1a"
            radius: 16
        }

        // Всё содержимое диалога
        contentItem: Column {
            spacing: 0

            // ── Шапка ──────────────────────────────────────────
            Item {
                width: parent.width
                height: 56

                Text {
                    anchors.centerIn: parent
                    text: "Гайд по командам"
                    color: "white"
                    font.pixelSize: 18
                    font.bold: true
                }

                // Крестик закрытия
                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32; height: 32
                    radius: 16
                    color: "#2a2a2a"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "#aaaaaa"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: dialogGuide.close()
                    }
                }
            }

            // Разделитель
            Rectangle {
                width: parent.width
                height: 1
                color: "#2a2a2a"
            }

            // ── Скроллируемое содержимое ───────────────────────
            ScrollView {
                width: parent.width
                // высота = высота диалога минус шапка и отступы
                height: dialogGuide.height - 57 - 32
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                Column {
                    width: dialogGuide.width * 0.9
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    topPadding: 20
                    bottomPadding: 20

                    // ── Блок "Правила" ─────────────────────────
                    GuideSection {
                        width: parent.width
                        title: "Основные правила"
                        // Список пунктов — простые строки
                        rules: [
                            "Несколько клавиш одновременно — разделяй через +",
                            "Специальные клавиши пишутся полным словом: ctrl, shift, alt...",
                            "Обычные символы — просто буква или цифра: ctrl+c, win+r",
                            "Если слово длиннее 1 символа и не спецклавиша — берётся только первый символ",
                            "Чтобы напечатать текст — пиши символы через +: h+e+l+l+o"
                        ]
                    }

                    // ── Блок "Специальные клавиши" ─────────────
                    GuideSection {
                        width: parent.width
                        title: "Специальные клавиши"
                        // Список пар [название, команда]
                        keyPairs: [
                            ["Ctrl",         "ctrl"],
                            ["Shift",        "shift"],
                            ["Alt",          "alt"],
                            ["Win",          "win"],
                            ["Enter",        "enter"],
                            ["Tab",          "tab"],
                            ["Backspace",    "backspace"],
                            ["Space",        "space"],
                            ["Escape",       "escape"],
                            ["↑ ↓ ← →",      "up / down / left / right"],
                            ["F1–F12",       "f1 … f12"],
                            ["Page Up/Down", "pageup / pagedown"],
                            ["Home / End",   "home / end"],
                            ["Insert",       "insert"],
                            ["Delete",       "delete"],
                            ["Num Lock",     "numlock"],
                            ["Caps Lock",    "capslock"],
                            ["Print Screen", "printscr"],
                            ["Pause",        "pause"],
                            ["Scroll Lock",  "scroll"]
                        ]
                    }

                    // ── Блок "Примеры" ─────────────────────────
                    GuideSection {
                        width: parent.width
                        title: "Примеры"
                        keyPairs: [
                            ["Копировать",       "ctrl+c"],
                            ["Вставить",         "ctrl+v"],
                            ["Сохранить как",    "ctrl+shift+s"],
                            ["Открыть Выполнить","win+r"],
                            ["Закрыть окно",     "alt+f4"],
                            ["Напечатать «hi»",  "h+i"],
                            ["Скриншот",         "printscr"]
                        ]
                    }
                }
            }
        }
    }
}
