import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import BackendDatabase

// GuideSection.qml
Item {
    id: root

    property string title: ""
    property var rules: []
    property var keyPairs: []

    height: column.implicitHeight

    Column {
        id: column
        width: parent.width
        spacing: 12

        // ── Заголовок секции ───────────────────────────────
        Text {
            text: root.title
            color: "white"
            font.pixelSize: 15
            font.bold: true
        }

        // ── Карточка-контейнер (как в твоём приложении) ───
        Rectangle {
            width: parent.width
            height: contentCol.implicitHeight + 24
            color: "#242424"
            radius: 12

            Column {
                id: contentCol
                width: parent.width - 24
                anchors.centerIn: parent
                spacing: 0

                // ── Если есть rules — рисуем список пунктов
                Repeater {
                    model: root.rules
                    delegate: Row {
                        width: parent.width
                        spacing: 8
                        topPadding: index === 0 ? 0 : 10
                        bottomPadding: index === root.rules.length - 1 ? 0 : 10

                        // Зелёная точка-буллет
                        Rectangle {
                            width: 6; height: 6
                            radius: 3
                            color: "#22c55e"  // зелёный акцент как в приложении
                            anchors.verticalCenter: ruleText.verticalCenter
                        }

                        Text {
                            id: ruleText
                            width: parent.width - 14
                            text: modelData
                            color: "#cccccc"
                            font.pixelSize: 13
                            wrapMode: Text.Wrap
                        }
                    }
                }

                // ── Если есть keyPairs — рисуем строки таблицы
                Repeater {
                    model: root.keyPairs
                    delegate: Column {
                        width: parent.width

                        // Разделитель между строками (кроме первой)
                        Rectangle {
                            width: parent.width
                            height: index === 0 ? 0 : 1
                            color: "#333333"
                        }

                        // Сама строка: название слева, чип с командой справа
                        Row {
                            width: parent.width
                            height: 40
                            spacing: 8

                            // Название клавиши
                            Text {
                                width: parent.width * 0.5
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData[0]
                                color: "#cccccc"
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            // Чип с командой — как в твоих карточках
                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: chipText.implicitWidth + 16
                                height: 26
                                radius: 8
                                color: "#333333"

                                Text {
                                    id: chipText
                                    anchors.centerIn: parent
                                    text: modelData[1]
                                    color: "#22c55e"
                                    font.pixelSize: 12
                                    font.family: "Courier New"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
