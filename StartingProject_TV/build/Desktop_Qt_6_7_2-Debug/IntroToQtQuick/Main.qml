pragma ComponentBehavior: Bound
// for permitting access to window.themeColor
// from inside any component declarations in this file

import QtQuick

Window {
    id: window

    /* Your solution should contain these key features:

    - Add a Window with dimensions which resemble the kind of
      remote control shape you want

    - Using components from the Qt Quick module such as Text,
      Image, Rectangle and any other components you want to use
      in your design, construct your shape, colors and layout of
      the elements you need.

    - You should include a number of Buttons providing features
      such as Volume +/-, Mute, Channel +/-, Power on/off, and
      perhaps even some cursor arrows.

    - Add image resources to your project and use them in your
      design and try to show how the image URL might be changed
      using bindings inside a string template expression.

    - Add a font to your project and use a FontLoader to be able
      to use the font in your Text components.

    - Create re-usable items using inline components adding any
      "required" properties where necessary

    - Using bindings and signal handlers to connect your UI
      elements to the provided tvControl object (below) so that
      interacting with your Buttons for example, could change
      the visible, enabled, or color of some of the other
      elements based on the changed state of the tvControl
      object’s properties.

    */

    // Here we have chosen a reasonable shape for your
    // remote control, but feel free to design your own.
    width: 240
    height: 740
    visible: true
    color: "black"

    // the window provides a themeColor property which you
    // may use wherever you need to refer to the same color
    property color themeColor: "silver"

    property color test: "silver"

    /* Here are a few components you can use to get you going */

    component BorderGradient: Rectangle {
        id: borderGradientRectangle

        // BorderGradient:
        // A simple Rectangle with a 2-color gradient

        // We use the Rectangle's own color property as
        // the first gradient stop color (so we upgrade the
        // color property to a required property)
        property color color2: borderGradientRectangle.color.darker()

        color: window.themeColor

        gradient: Gradient {
            GradientStop {
                position: 0
                color: borderGradientRectangle.color
            }
            GradientStop {
                position: 1
                color: borderGradientRectangle.color2
            }
        }
    }

    component DoubleBorderGradient: BorderGradient {
        id: doubleBorderGradient

        // DoubleBorderGradient:
        // A BorderGradient with another one nested inside
        // with a specified innerMargin

        property int innerMargin: 2

        BorderGradient {
            // inner gradient
            anchors {
                fill: parent
                margins: doubleBorderGradient.innerMargin
            }

            radius: doubleBorderGradient.radius - doubleBorderGradient.innerMargin

            // swap the colors around
            color: doubleBorderGradient.color2
            color2: doubleBorderGradient.color
        }
    }

    // veronika stepankova 797601396

    component Button: DoubleBorderGradient {
        id: button

        // Button:
        // A clickable DoubleBorderGradient with a useful
        // clicked signal and a pressed property alias

        readonly property alias pressed: tapHandler.pressed
        signal clicked

        implicitWidth: 100
        implicitHeight: 40

        radius: Math.min(width, height) / 2

        color: tapHandler.pressed ? window.themeColor : window.themeColor.darker()
        color2: tapHandler.pressed ? window.themeColor.darker() : window.themeColor

        TapHandler {
            id: tapHandler
            gesturePolicy: TapHandler.WithinBounds
            onTapped: button.clicked()
        }
    }

    component CircleButton: Button {
        id: circleButton

        // CircleButton:
        // A circular Button for convenience

        width: 200
        height: width // a circle

        // The CircleButton uses Item's containmentMask
        // property to return the boolean result of a
        // simplified test to check if the point is inside
        // the circle or not.
        containmentMask: QtObject {
            function contains(clickPoint: point) : bool {
                return (Math.pow(clickPoint.x - circleButton.radius, 2) +
                        Math.pow(clickPoint.y - circleButton.radius, 2))
                        < Math.pow(circleButton.radius, 2)
            }
        }
    }

    component DoubleButton: DoubleBorderGradient {
        id: doubleButton

        property alias topImg: topImg.source
        property alias bottonImg: bottonImg.source
        readonly property alias upPressed: mouseAreaUp.pressed
        readonly property alias downPressed: mouseAreaDown.pressed

        width: 40
        height: 150

        radius: Math.min (width, height)/2

        signal clickedUp
        signal clickedDown

        color: upPressed || downPressed ? window.themeColor : window.themeColor.darker()
        color2: upPressed || downPressed ? window.themeColor.darker() : window.themeColor

        Image {
            id: topImg
            height: 50
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: 5
                rightMargin: 5
                topMargin: 5
            }
        }

        Image {
            id: bottonImg
            height: 50
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 5
                rightMargin: 5
                bottomMargin: 5
            }
        }

        MouseArea {
            id: mouseAreaUp
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.verticalCenter
            }

            onClicked: {
                doubleButton.clickedUp()
            }
        }

        MouseArea {
            id: mouseAreaDown
            anchors {
                left: parent.left
                right: parent.right
                top: parent.verticalCenter
                bottom: parent.bottom
            }
            onClicked: {
                doubleButton.clickedDown()
            }
        }
    }

    QtObject {
        id: tvControl

        // The tvControl object is provided for you to use as a
        // mock back-end providing a number of typical properties
        // and features you might find on a remote control.
        // There are even 5 channels with sample channelNames.

        property int channelNumber: 0
        readonly property string channelName: channelNames[channelNumber]

        // TV Features
        property bool closedCaptionsEnabled: true
        property bool hdrEnabled: true
        property bool castConnected: true
        property bool listening: false
        property bool muted: false
        property real volume: 0.75
        readonly property bool soundOn: !muted && volume > 0

        function incrementVolume() {
            volume = Math.min(1, volume + 0.1)
        }

        function decrementVolume() {
            volume = Math.max(0, volume - 0.1)
        }

        function incrementChannel() {
            channelNumber = Math.min(channelNames.length - 1, channelNumber + 1)
        }

        function decrementChannel() {
            channelNumber = Math.max(0, channelNumber - 1)
        }

        property list<string> channelNames: [
            "News Station",
            "Comedy Cable",
            "Eats and Beats",
            "Weather",
            "Cartoons",
            "Reality TV"
        ]
    }

    // Here we provide a suggested remote control background
    DoubleBorderGradient {
        id: remoteControlBackground

        anchors.fill: parent
        innerMargin: 10
        radius: 40
    }

    // As a demonstration of one of the Button types,
    // we add a power button.
    CircleButton {
        id: powerButton

        anchors {
            top: parent.top
            right: parent.right
            topMargin: 20
            rightMargin: 20
        }

        width: 40
        height: 40
        color: "darkred"

        onClicked: window.close()

        Image {
            source: "images/power.svg"
            anchors {
                fill: parent
                margins: 5
            }
        }
    }

    DoubleBorderGradient {
        id: display
        anchors {
            top: powerButton.bottom
            left:parent.left
            right: parent.right
            topMargin: 20
            leftMargin: 20
            rightMargin: 20
        }

        height: 100
        color: "green"
        radius: 8

        Rectangle {
            id: volumeBar
            property double valueActual: 0.0

            width: 10
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                topMargin: 10
                bottomMargin: 10
                rightMargin: 10
            }

            border {
                width: 2
                color: "black"
            }

            color: "transparent"

            Rectangle {
                id: progressState
                color: "black"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: tvControl.muted ? 0.0 :  parent.height * tvControl.volume
            }
        }

        Item {
            id: programIndex
            anchors {
                top: parent.top
                left: parent.left
                right: volumeBar.left
                topMargin: 5
                leftMargin: 5
                rightMargin: 5
            }

            height: parent.height / 4

            FontLoader {
                id: silkscreenFont
                source: Qt.resolvedUrl("fonts/Silkscreen/Silkscreen-Regular.ttf")
            }

            Text {
                text: "Program"
                anchors {
                    left: parent.left
                    top: parent.top
                    right: channelId.left
                }
                font {
                    family: silkscreenFont.font.family
                    pixelSize: 16
                }
            }

            Text {
                id: channelId
                anchors {
                    right: parent.right
                    top: parent.top
                }
                text: tvControl.channelNumber
                font {
                    family: silkscreenFont.font.family
                    pixelSize: 16
                }
            }
        }

        Text {
            id: channelText
            anchors {
                left: parent.left
                top: programIndex.bottom
                right: volumeBar.left
                leftMargin: 5
            }
            text: tvControl.channelName
            font {
                family: silkscreenFont.font.family
                pixelSize: 16
            }
        }

        Item {
            id: icons
            height: parent.height / 3
            anchors {
                left: parent.left
                right: volumeBar.left
                bottom: parent.bottom
            }

            Image {
                id: ccImage
                height: parent.height
                width: height
                visible: tvControl.closedCaptionsEnabled
                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: 3
                }
                source: "images/closed_caption.svg"
            }
            Image {
                id: hdrImage
                height: parent.height
                width: height
                visible: tvControl.hdrEnabled
                anchors {
                    left: ccImage.right
                    top: parent.top
                    leftMargin: 3
                }
                source: "images/hdr_on.svg"
            }
            Image {
                id: castImage
                height: parent.height
                width: height
                visible: tvControl.castConnected
                anchors {
                    left: hdrImage.right
                    top: parent.top
                    leftMargin: 3
                }
                source: "images/cast_connected.svg"
            }
            Image {
                id: micImage
                height: parent.height
                width: height
                anchors {
                    left: castImage.right
                    top: parent.top
                    leftMargin: 3
                }
                source: "images/mic.svg"
                Timer {
                    running: tvControl.listening
                    interval: 500
                    repeat: true
                    onTriggered: micImage.visible = !micImage.visible
                    onRunningChanged: if ( !running ) micImage.visible = true
                }
            }
            Image {
                id: speakerImage
                height: parent.height
                width: height
                anchors {
                    left: micImage.right
                    top: parent.top
                    leftMargin: 3
                }
                source: "images/speaker"+(tvControl.soundOn?"" : "_muted")+".svg"
            }
        }
    }


    Item {
        id: functionButtons

        anchors {
            left: parent.left
            right: parent.right
            top: display.bottom
            leftMargin: 20
            rightMargin: 20
            topMargin: 20
        }
        height: 40

        Button {
            id: ccButton
            width: parent.width / 4
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            Image {
                anchors {
                    fill: parent
                    margins: 5
                }
                fillMode: Image.PreserveAspectFit

                source: "images/closed_caption_white.svg"
            }
            onClicked: tvControl.closedCaptionsEnabled = !tvControl.closedCaptionsEnabled
        }

        Button {
            id: hdrButton
            width: parent.width / 4
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.horizontalCenter
            }
            Image {
                anchors {
                    fill: parent
                    margins: 5
                }
                fillMode: Image.PreserveAspectFit

                source: "images/hdr_on_white.svg"
            }
            onClicked: tvControl.hdrEnabled = !tvControl.hdrEnabled
        }

        Button {
            id: castButton
            width: parent.width / 4
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.horizontalCenter
            }
            Image {
                anchors {
                    fill: parent
                    margins: 5
                }
                fillMode: Image.PreserveAspectFit

                source: "images/cast_white.svg"
            }
            onClicked: tvControl.castConnected = !tvControl.castConnected
        }

        Button {
            id: muteButton
            width: parent.width / 4
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            Image {
                anchors {
                    fill: parent
                    margins: 5
                }
                fillMode: Image.PreserveAspectFit

                source: "images/speaker_muted_white.svg"
            }
            onClicked: tvControl.muted = !tvControl.muted
        }
    }

    Item {
        id: dPAD

        anchors {
            top: functionButtons.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }

        // the width and height are the same as one CircleButton
        width: 200
        height: 200

        Item {
            id: rotate
            anchors.fill: parent
            rotation: 45

            Item {
                id: optBtn

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.horizontalCenter
                    bottom: parent.verticalCenter
                }

                clip: true


                CircleButton {
                    width: dPAD.width
                    height: dPAD.height
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                }

                Image {
                    rotation: -45
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: 25
                        bottomMargin: 25
                    }

                    source: "images/settings.svg"
                }
            }
            Item {
                id: rewindPauseBtn
                width: parent.width/2
                height: parent.height/2

                anchors {
                    top: parent.verticalCenter
                    left: parent.left
                    right: parent.horizontalCenter
                    bottom: parent.bottom
                }


                clip: true


                CircleButton {
                    width: dPAD.width
                    height: dPAD.height
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                    }
                }

                Image {
                    rotation: -45
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: 25
                        bottomMargin: 25
                    }

                    source: "images/fast_rewind.svg"
                }
            }
            Item {
                id: playPauseBtn
                width: parent.width/2
                height: parent.height/2

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                }

                clip: true


                CircleButton {
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }
                }

                Image {
                    rotation: -45
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: 25
                        bottomMargin: 25
                    }

                    source: "images/play_pause.svg"
                }
            }

            Item {
                id: forvardBtn
                width: parent.width/2
                height: parent.height/2

                anchors {
                    top: parent.top
                    right: parent.right
                }

                clip: true


                CircleButton {
                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                }

                Image {
                    rotation: -45
                    anchors {
                        bottom: parent.bottom
                        right:  parent.right
                        rightMargin: 25
                        bottomMargin: 25
                    }

                    source: "images/fast_forward.svg"
                }
            }

            Rectangle {
                color: window.themeColor
                width: 3
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
            Rectangle {
                color: window.themeColor
                height: 3
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
            CircleButton {
                id: centerButton
                width: parent.width / 2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                Image {
                    id: micBtn
                    source: "images/mic_white.svg"
                    rotation: -45
                    height: width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: tvControl.listening = !tvControl.listening
            }
        }
    }

    DoubleButton {
        anchors {
            left: parent.left
            top: dPAD.bottom
            leftMargin: 40
            topMargin: 20
        }
        topImg: "images/plus.svg"
        bottonImg: "images/minus.svg"
        onClickedUp: tvControl.incrementChannel()
        onClickedDown: tvControl.decrementChannel()
    }

    DoubleButton {
        anchors {
            right: parent.right
            top: dPAD.bottom
            rightMargin: 40
            topMargin: 20
        }
        topImg: "images/volume_up.svg"
        bottonImg: "images/volume_down.svg"
        onClickedUp: tvControl.incrementVolume()
        onClickedDown: tvControl.decrementVolume()
    }
}
