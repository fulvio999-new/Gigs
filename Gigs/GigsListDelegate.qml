import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import "Utility.js" as Utility

    /*
       Delegate component used to display Gig information (country, date....)
    */
   Item {
        id: gigItem

        width: gigsListPage.width
        height: units.gu(15) /* heigth of the rectangle */
        visible: true;

        /* create a container for each job */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "black"
            radius: 5
        }

        /* This mouse region covers the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent

            onClicked: {
                /* move the highlight component to the currently selected item */
                listView.currentIndex = index
            }
        }

        /* create a row for each entry in the Model */
        Row {
            id: topLayout
            x: 10; y: 7; height: background.height; width: parent.width
            spacing: units.gu(4)

            /* Build statu Image icon */
            Column{
                id: gigsColumn
                width: units.gu(5);
                height: gigItem.height

                spacing: units.gu(1)

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "pink"
                    height: units.gu(8)
                    width: height

                    Image {
                        id: lengthImage
                        source: "gigEvent.png"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width * 0.7
                        height: parent.height * 0.7
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Column {
                id: containerColumn
                width: topLayout.width - units.gu(10);
                height: gigItem.height
                anchors.verticalCenter: topLayout.Center
                spacing: units.gu(0.8)

                Label {
                    text: i18n.tr("Place")+": " + eventPlace
                    fontSize: "medium"
                }

                Label {
                    text: i18n.tr("Date")+" (yyyy-mm-dd) : " + eventDate
                    fontSize: "medium"
                }

                Label {
                    text: i18n.tr("Country")+": "+ eventCountry
                    id : countryLabel
                    fontSize: "medium"
                }

                Label {
                    text: i18n.tr("City")+": "+ eventCity
                    id : eventCityLabel
                    fontSize: "medium"
                }

                Label {
                    text: i18n.tr("Url")+": "+ Utility.getHyperLink(eventUrl)
                    id : eventUrlLabel
                    fontSize: "medium"
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

        }
    }
