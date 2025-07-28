import QtQuick
import QtQuick.Controls

pragma ComponentBehavior: Bound

Window {
    id: root
    width: 320
    height: 480
    visible: true
    color: Qt.rgba(0,0,0,0)
    title: qsTr("Calculator")

    property bool isDark: true

    component BaseRect: Rectangle {
        radius: 5
        border {
            width: 2
            color: "blue"
        }
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 5
            leftMargin: 5
            rightMargin: 5
        }
        color: Qt.rgba(12, 12, 12, 255)
    }

    component BaseButton: Button {
        property alias textButton: btnText.text
        property color hoverColor: root.isDark ? "#7700DD" : "#FFFFFF"
        property color presedColor: root.isDark ? "#330088" : "#CCCCCC"
        property color releasedColor: root.isDark ? "#5500AA" : "#E6E6E6"

        property color hoverTextColor: root.isDark ? "#FFF2FF" : "#000000"
        property color presedTextColor: root.isDark ? "#FFFFFF" : "#1A1A1A"
        property color releasedTextColor: root.isDark ? "#FFFFFF" : "#1A1A1A"

        background: Rectangle {
            id: btnBackground
            radius: 5
            Text {
                id: btnText
                anchors.centerIn: parent
                text: "?"
                font {
                    pixelSize: btnBackground.height - (btnBackground.height * 0.4)
                    bold: true
                }

            }
        }

        state: "RELEASED"

        states: [
            State {
                name: "HOVER"
                PropertyChanges {
                    target: btnBackground
                    color: hoverColor
                }
                PropertyChanges {
                    target: btnText
                    color: hoverTextColor
                }
            },
            State {
                name: "PRESED"
                PropertyChanges {
                    target: btnBackground
                    color: presedColor
                }
                PropertyChanges {
                    target: btnText
                    color: presedTextColor
                }
            },
            State {
                name: "RELEASED"
                PropertyChanges {
                    target: btnBackground
                    color: releasedColor
                }
                PropertyChanges {
                    target: btnText
                    color: releasedTextColor
                }
            }
        ]

        transitions: [
            Transition {

                ColorAnimation {
                    duration: 200
                }
            }
        ]

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                parent.state = "PRESED"
            }
            onReleased: {
                parent.state = "RELEASED"
            }
            onEntered: {
                parent.state = "HOVER"
            }
            onExited: {
                parent.state = "RELEASED"
            }
        }
    }

    BaseRect {
        id: display
        height: parent.height * 0.2
    }

    BaseRect {
        id: controlPanel
        height: parent.height * 0.1

        anchors {
            top: display.bottom
        }
    }

    BaseRect {
        id: numPad
        anchors {
            top: controlPanel.bottom
            bottom: parent.bottom
            bottomMargin: 5
        }

        Grid {
            id: gridPad
            rows: 4
            columns: 4
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 10
            }
            spacing: 5
            Repeater{
                model: ["7","8","9","/",
                        "4","5","6","*",
                        "1","2","3","-",
                        "0",".","=","+"]
                delegate: BaseButton {
                    required property string modelData
                    width: gridPad.width / gridPad.columns - 5
                    height: gridPad.height / gridPad.rows - 5
                    textButton: modelData
                }
            }
        }
    }
}
