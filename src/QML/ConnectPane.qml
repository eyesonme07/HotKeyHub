import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import BackendAsio

//окно подключения
Pane {
    property int count: 0
    property bool isRunning: false

    function connectStatus() {
        var status = BackendAsio.isConnected()
        console.log("connectStatus count:", count, "status:", status)

        if (count > 10) {
            console.log("Таймаут подключения")
            stopConnection()
            mainStackView.pop()
            return
        }

        if (status) {
            console.log("Успешно подключено!")
            stopConnection()
            mainStackView.push(page3)
            return
        }

        count++
    }

    function stopConnection() {
        timer.stop()
        isRunning = false
        count = 0
    }

    function startConnection() {
        count = 0
        isRunning = true
        timer.start()
    }

    ColumnLayout{
        spacing :24
        anchors.centerIn: parent
        width:parent.width*0.85
        Rectangle{
            id:wifiRec
            width: 100
            height:100
            color:"#18181B"
            radius: 50
            Layout.alignment: Qt.AlignHCenter

            Image{
                id:wifiIMage
                anchors.centerIn: parent
                width: parent.width/2
                height:parent.height/2
                source: "qrc:/icons/wifi.png"
                visible: false
            }
            ColorOverlay{
                anchors.fill: wifiIMage
                color: "#00D492"
                source: wifiIMage
            }

            BusyIndicator{
                anchors.centerIn: parent
                width: parent.width+15
                height:parent.height+15
            }
        }

        Text{
            text:"Подключение..."
            font.pixelSize: 25
            font.bold: true
            color: "White"
            Layout.alignment: Qt.AlignHCenter
        }
    }


    Timer {
        id: timer
        interval: 300
        repeat: true
        onTriggered: connectStatus()
    }

    StackView.onActivated: {
        startConnection()
    }

    StackView.onDeactivated: {
        stopConnection()
    }
}
