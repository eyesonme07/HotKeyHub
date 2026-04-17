import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Backend

//окно  управления звкуом (смена песни и тд)
Item{
    id:mediaPage

    Connections {
        target: Backend
        function onDataChanged() {
            volumeSlider.value = Backend.deviceData["currentVolume"]
        }
    }

    ColumnLayout{
        anchors.centerIn:parent

        Rectangle{
            Layout.alignment: Qt.AlignHCenter

            width:200
            height:200

            gradient: Gradient{
                GradientStop{position:0.0;color:"#252638"}
                GradientStop{position:0.5;color:"#242D35"}
                GradientStop{position:1.0;color:"#1C2E2D"}
            }
            radius:20

            Image{
                id:musicImage
                source: "qrc:/icons/music.png"
                anchors.centerIn: parent
                visible: false
                width: 80
                height:80
            }
            ColorOverlay{
                source: musicImage
                anchors.fill: musicImage
                color:"#3e4957"
            }
        }

        Text{
            text: Backend.deviceData["currMusicName"] || "Нет трека"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 23
            lineHeight: 1.25
            color:"#FFFFFF"
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width*0.95
        }
        Text {
            text: Backend.deviceData["currMusicArtist"] || ""
            color: "#CFCFD3"
            font.pixelSize: 15
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle{
            height:40
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            Button {
                id: previousButton
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                Layout.fillWidth: false

                background: Rectangle {
                    radius: width/2
                    anchors.fill: parent
                    color: "#151518"
                }

                Image {
                    id: previousImage
                    source: "qrc:/icons/skip-back.png"
                    width: 20
                    height: 20
                    anchors.centerIn: parent
                }
                ColorOverlay {
                    source: previousImage
                    anchors.fill: previousImage
                    color: "#CFCFD3"
                }
                onClicked:{
                    Backend.command('previous')
                }
            }

            Button {
                id: pauseButton
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80
                Layout.fillWidth: false

                background: Rectangle {
                    radius: width/2
                    anchors.fill: parent
                    color: "#00BC7D"
                }

                Image {
                    id: pauseImage
                    source: Backend.deviceData["isPlayMusic"]
                                ? "qrc:/icons/pause.png"
                                : "qrc:/icons/play.png"
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                }
                ColorOverlay {
                    source: pauseImage
                    anchors.fill: pauseImage
                    color: "#09090B"
                }
                onClicked:{
                    Backend.command('play_pause')
                }
            }
            Button {
                id: nextButton
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                Layout.fillWidth: false

                background: Rectangle {
                    radius: width/2
                    anchors.fill: parent
                    color: "#151518"
                }

                Image {
                    id: nextImage
                    source: "qrc:/icons/skip-forward.png"
                    width: 20
                    height: 20
                    anchors.centerIn: parent
                }
                ColorOverlay {
                    source: nextImage
                    anchors.fill: nextImage
                    color: "#CFCFD3"
                }

                onClicked:{
                    Backend.command('next')
                }
            }
        }

        Rectangle{
            height:5
        }

        Rectangle {
            height: 50
            color: "#101012"
            radius: 15
            border.width: 1
            border.color: "#1B1B1E"

            Layout.fillWidth: true
            Layout.minimumWidth: mediaPage.width-30

            RowLayout {
                anchors.centerIn: parent

                spacing: 12

                Image {
                    id: volumeImage
                    source: "qrc:/icons/volume-2.png"

                    Layout.preferredWidth: 22
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignVCenter

                    fillMode: Image.PreserveAspectFit

                    ColorOverlay {
                        anchors.fill: parent
                        source: volumeImage
                        color: "#CFCFD3"
                    }
                }

                Slider {
                    id: volumeSlider
                    from: 0
                    to: 1
                    value: Backend.deviceData["currentVolume"]

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    onMoved: {
                        Backend.command('volume',volumeSlider.value)
                    }
                }

                Text {
                    text: Math.floor(volumeSlider.value*100) + "%"
                    color: "White"
                    font.pixelSize: 15
                    Layout.alignment: Qt.AlignVCenter
                    Layout.minimumWidth: 42
                }
            }
        }
    }
}
