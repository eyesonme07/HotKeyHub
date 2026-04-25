import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import BackendDatabase
import Backend
import BackendAsio
import Qt5Compat.GraphicalEffects

Rectangle {
    id: hotKeyItem
    property string name: ''
    property string key: ''
    property bool deleteVisible:false
    radius: 16
    border.width: 1
    border.color: "#3F3F47"
    color: "#151518"
    implicitHeight: column.implicitHeight + 32

    property var list: []

    Component.onCompleted: {
        var splitList = Backend.splitKey(key)
        for(var i = 0; i < splitList.length; ++i){
            modelList.append({text: splitList[i]})

            list.push(splitList[i])
        }
    }

    function clickKey(isPress){
        var length = list.length

        if(length === 0){return}

        var map = {}

        map["command"] = isPress?"pressKey":"releaseKey"
        map["keys"] = length

        for(var i = 0;i<length;++i){
            map[i] = list[i]
        }
        BackendAsio.command(map)
    }

    MouseArea{
        anchors.fill: parent

        onPressed:{
            clickKey(true)
        }
        onReleased: {
            clickKey(false)
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        Text {
            text: name
            color: "White"
            font.pixelSize: 14
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8
            flow: Flow.LeftToRight

            Repeater {
                model: ListModel {
                    id: modelList
                }
                Rectangle {
                    width: itemText.width + 12
                    height: itemText.height + 8
                    border.color: "#3F3F47"
                    color: "#27272A"
                    border.width: 1
                    radius: 8
                    Text {
                        id: itemText
                        anchors.centerIn: parent
                        color: "White"
                        font.pixelSize: 11
                        text: model.text
                    }
                }
            }
        }
    }

    Button {
        visible: deleteVisible
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 4
        anchors.rightMargin: 4

        width: 25
        height: 25

        flat: true
        padding: 0
        topInset: 0
        bottomInset: 0
        leftInset: 0
        rightInset: 0


        background: Rectangle {
            radius: width / 2
            color: "#FB2C36"

            Image {
                id: deleteImage
                source: "qrc:/icons/trash.png"
                width: 14
                height: 14
                anchors.centerIn: parent
                visible: false
            }

            ColorOverlay {
                source: deleteImage
                width: deleteImage.width
                height: deleteImage.height
                anchors.centerIn: parent
                color: "white"
            }
        }
        onClicked: {
            if(BackendDatabase.deleteHotKey(name)){
                hotKeyItem.visible=false
            }
        }
    }
}
