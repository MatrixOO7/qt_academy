import QtQuick

Window {
    id: root

    // TODO: change the size to ensure it forms the standard business card ratio of approx 1:1.586
    // HINT: you may wish to use a binding

    width: 640
    height: width / 1.586

    visible: true
    title: qsTr("Business Card")

    component ContactInfo: QtObject {

        // This is a ContactInfo object which provides the properties to fill in.
        // You can create as many instances of this as you like with different property values.

        // show these properties all the time:
        property string name
        property url photo

        // Basic Info properties:
        property string occupation
        property string company

        // Detailed Info properties:
        property string address
        property string country
        property string phone
        property string email
        property url webSite
    }

    property bool shwDetail: false
    property color btnColorLast: "white"
    property color btnTxtColorLast: "black"

    ContactInfo {
        id: myContactInfo

        // this is one example instance of a ContactInfo inline Component
        // showing how the properties are populated.

        name: "Your Name"
        photo: Qt.resolvedUrl("IDPhoto.png")
        occupation: "QML Enthusiast"
        company: "Indie Soft"
        address: "Candy Cane Lane"
        country: "North Pole"
        phone: "+01 2345 567 890"
        email: "email@server.com"
        webSite: Qt.url("https://www.qt.io")
    }

    /* Your solution should contain these key features:

        - A Text element for each of the ContactInfo properties.
        - The name and photo image should be shown all the time.
        - These should be grouped into two categories "Basic Info" and "Details".
        - Create a button using a MouseArea or TapHandler that can be used to
          toggle between showing the two categories of information.
        - Use a larger font size for the name
    */

    Rectangle {
        id: space
        anchors {
            fill: parent
            margins: 10
        }

        radius: 10

        border {
            color: "black"
            width: 2
        }

        Rectangle {
            width: parent.width / 3
            height: parent.width / 3
            border {
                width: 2
                color: "black"
            }

            anchors {
                margins: 10
                top: parent.top
                right: parent.right
            }


            radius: 10

            Image {
                id: photo
                fillMode: Image.PreserveAspectFit
                anchors {
                    centerIn: parent
                    fill: parent
                    margins: 10
                }
                source: myContactInfo.photo
            }
        }

        Column {
            id: basicInfo
            width: parent.width
            visible: !root.shwDetail

            anchors {
                top:  parent.top
                left: parent.left
                margins: 10
            }
            spacing: 10

            Text {
                width: basicInfo.width
                height: 50
                text: myContactInfo.name
                font {
                    pixelSize: 50
                    bold: true
                }

            }
            Text {
                width: basicInfo.width
                height: 20
                text: myContactInfo.occupation
            }
            Text {
                width: basicInfo.width
                height: 20
                text: myContactInfo.company
            }
        }

        Column {
            id: basicDetail
            width: parent.width
            visible: root.shwDetail

            anchors {
                top:  parent.top
                left: parent.left
                margins: 10
            }
            spacing: 10

            Text {
                width: basicInfo.width
                height: 50
                text: myContactInfo.name
                font {
                    pixelSize: 50
                    bold: true
                }

            }
            Text {
                width: basicInfo.width
                height: 30
                text: myContactInfo.address
                font {
                    pixelSize: 30
                }
            }
            Text {
                width: basicInfo.width
                height: 30
                text: myContactInfo.country
                font {
                    pixelSize: 30
                }
            }
            Text {
                width: basicInfo.width
                height: 20
                text: myContactInfo.phone
            }
            Text {
                width: basicInfo.width
                height: 20
                text: myContactInfo.email
                font.underline: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("mailto:"+myContactInfo.email+"?subject=Testovaci msg")
                        console.debug("DD")
                    }
                }
            }
            Text {
                width: basicInfo.width
                height: 20
                text: myContactInfo.webSite
                font.underline: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally(myContactInfo.webSite)
                        console.debug("DD")
                    }
                }
            }
        }

        Rectangle {
            id: btn
            width: parent.width / 5
            height: parent.height / 10
            radius: height / 2
            border {
                width: 1
                color: "black"
            }

            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 10
            }

            Behavior on color {
                ColorAnimation {
                    duration: 500
                }
            }

            Text {
                id: btnTxt
                anchors{
                    centerIn: btn
                }
                text: "Dateil"

                Behavior on color {
                    ColorAnimation {
                        duration: 500
                    }
                }
            }

            anchors.onVerticalCenterOffsetChanged: parent.width - width

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    root.shwDetail = !root.shwDetail
                }

                onPressed: {
                    root.btnColorLast = btn.color
                    btn.color = "black"
                    btnTxt.color = "white"
                }

                onReleased: {
                    btn.color = root.btnColorLast
                    btnTxt.color = "black"
                }

                onEntered: {
                    root.btnColorLast = btn.color
                    btn.color = "gray"
                }

                onExited: {
                    root.btnColorLast = btn.color
                    btn.color = "white"
                }
            }
        }

    }

}
