import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

//тут все создается
ApplicationWindow {
    width: 393
    minimumWidth: 320
    height: 700
    visible: true
    title: qsTr("HotKeyHub")

    Material.theme: Material.Dark
    Material.background: "#09090B"
    Material.primary: "#00BC7D"
    Material.accent: "#00BC7D"

    property alias mainStackView:mainStackView
    property alias page1:page1
    property alias page2:page2
    property alias page3:page3

    StackView {
        id: mainStackView
        anchors.fill: parent
        initialItem: page1

        pushEnter: Transition {
            ParallelAnimation {
                ScaleAnimator {
                    from: 0.7
                    to: 1.0
                    duration: 320
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 0.0
                    to: 1.0
                    duration: 320
                }
            }
        }

        pushExit: Transition {
            ParallelAnimation {
                ScaleAnimator {
                    from: 1.0
                    to: 0.7
                    duration: 320
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 1.0
                    to: 0.0
                    duration: 320
                }
            }
        }

        popEnter: Transition {
            ParallelAnimation {
                ScaleAnimator {
                    from: 0.7
                    to: 1.0
                    duration: 320
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 0.0
                    to: 1.0
                    duration: 320
                }
            }
        }

        popExit: Transition {
            ParallelAnimation {
                ScaleAnimator {
                    from: 1.0
                    to: 0.7
                    duration: 320
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 1.0
                    to: 0.0
                    duration: 320
                }
            }
        }
    }

    Component{
        id:page1
        StartPane {}
    }

    Component{
        id:page2
        EnterIpPane {}
    }
    Component{
        id:page3
        MainWindowPane {}
    }
}
