import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0

import "./js/RestClient.js" as RestClient
import "./js/Storage.js" as Storage
import "./js/Utility.js" as Utility


MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'gigs.fulvio'
    automaticOrientation: true

    /* to test themes others then default one */
    //theme.name: "Ubuntu.Components.Themes.SuruDark"

    /*------- Tablet (width >= 110) -------- */
    //vertical
    //width: units.gu(75)
    //height: units.gu(111)

    //horizontal (rel)
    width: units.gu(100)
    height: units.gu(75)

    //Tablet horizontal
    //width: units.gu(128)
    //height: units.gu(80)

    //Tablet vertical
    //width: units.gu(80)
    //height: units.gu(128)

    /* ----- phone 4.5 (the smallest one) ---- */
    //vertical
    //width: units.gu(50)
    //height: units.gu(96)

    //horizontal
    //width: units.gu(96)
    //height: units.gu(50)
    /* -------------------------------------- */

    property string appVersion : "1.2"
    property string targetUrl

    /* PopUp with Application info */
    Component {
       id: productInfo
       ProductInfo{}
    }

    Component {
       id: dataBaseEraserDialog
       DataBaseEraserDialog{}
    }

    Component {
        id:noDataFoundComponent

        /* General info about the application */
        Dialog {
             id: noDataFoundDialogue
             title: i18n.tr("Warning")
             text: i18n.tr("No data found. Url is correct ?")

             Button {
                 text: i18n.tr("Close")
                 onClicked: PopupUtils.close(noDataFoundDialogue)
             }
        }
    }

    Settings {
        id:settings
        property bool isFirstUse : true;
        property bool defaultDataImported : false;
    }

    Component.onCompleted: {

       if(settings.isFirstUse == true){
          settings.isFirstUse = false

          Storage.createTables();
          Storage.insertDefaultArtistUrl();

          settings.defaultDataImported = true
       }
    }

    PageStack {
         id: pageStack

           /* set the firts page of the application */
         Component.onCompleted: {
            pageStack.push(gigsListPage);
         }

         Page {
               id: gigsListPage
               anchors.fill: parent

               header: PageHeader {
               id: header
               title: i18n.tr('Gigs')

                /* the bar on the left side */
                leadingActionBar.actions: [

                       Action {
                             id: aboutPopover
                             iconName: "info"
                             text: i18n.tr("About")
                             onTriggered:{
                                 PopupUtils.open(productInfo)
                             }
                        }
                  ]

                  /* trailingActionBar is the bar on the right side */
                  trailingActionBar.actions: [

                        Action {
                                iconName: "delete"
                                text: i18n.tr("Delete")
                                onTriggered:{
                                    PopupUtils.open(dataBaseEraserDialog)
                                }
                         },

                         Action {
                              iconName: "settings"
                              text: i18n.tr("Settings")
                              onTriggered:{
                                   pageStack.push(Qt.resolvedUrl("ManageGigsUrlPage.qml"))
                               }
                         },

                          Action {
                               iconName: "help"
                               text: i18n.tr("Help")
                               onTriggered:{
                                    pageStack.push(Qt.resolvedUrl("HelpPage.qml"))
                                }
                          }
                   ]
            }

            /* the list of ALL events form the chosen artist */
            ListModel{
               id: eventListModel
            }

            /* the list of saved Gigs url */
            ListModel{
               id: savedGigsUrlListModel
            }

            /* the info about chosen artist */
            ListModel{
               id: artistiInfoModel
            }

            Component {
               id: gigsListDelegate
               GigsListDelegate{}
            }

            /* render of the entry in the OptionSelector */
            Component {
                id: artistChooserDelegate
                OptionSelectorDelegate { text: artistName; subText: gigsUrl; }
            }

            //-------------- Dialog Artist chooser -----------------
            Component {
                      id: artistChooserComponent

                      Dialog {
                          id: artistPickerDialog
                          contentWidth: units.gu(42)
                          title: i18n.tr("Found")+": "+savedGigsUrlListModel.count +" "+i18n.tr("Artist(s)")

                          OptionSelector {
                              id: artistChooserSelector
                              expanded: true
                              multiSelection: false
                              delegate: artistChooserDelegate
                              model: savedGigsUrlListModel
                              containerHeight: itemHeight * 4
                          }

                          Row{
                              spacing:units.gu(2)
                              anchors.horizontalCenter: parent.horizontalCenter

                              Button {
                                  text: i18n.tr("Select")
                                  width: units.gu(14)
                                  onClicked: {
                                      chooseArtistButton.text = savedGigsUrlListModel.get(artistChooserSelector.selectedIndex).artistName;
                                      targetUrl = savedGigsUrlListModel.get(artistChooserSelector.selectedIndex).gigsUrl;
                                      PopupUtils.close(artistPickerDialog)

                                      /* clean previous results */
                                      eventListModel.clear();
                                      artistiInfoModel.clear();

                                      searchGigsButton.enabled = true
                                      filterJobField.enabled = false
                                      gigsFilterButton.enabled = false
                                      artistInfoButton.enabled = false
                                  }
                              }

                              Button {
                                  text: i18n.tr("Close")
                                  width: units.gu(14)
                                  onClicked: {
                                      PopupUtils.close(artistPickerDialog)
                                  }
                              }
                          }
                    }
            }


            //-------------- Artist Information PopUp -----------------
            Component {
                      id: artistInfoComponent

                      Dialog {
                          id: artistInfoDialog
                          contentWidth: root.width - Utility.getPopupReductionFactor()
                          title: i18n.tr("Artist Informations")

                          Row{
                              anchors.horizontalCenter: parent.horizontalCenter
                              Label{
                                 text: "Name: "+artistiInfoModel.get(0).artistname
                              }
                          }

                          Row{
                              anchors.horizontalCenter: parent.horizontalCenter
                              Label{
                                 text: "Booking: "+artistiInfoModel.get(0).bookingcontact
                              }
                          }

                          Row{
                              anchors.horizontalCenter: parent.horizontalCenter
                              Label{
                                 text: "Mixcloud: "+ Utility.getHyperLink(artistiInfoModel.get(0).mixcloud_url)
                                 onLinkActivated: Qt.openUrlExternally(link)
                              }
                          }

                          Row{
                              anchors.horizontalCenter: parent.horizontalCenter
                              Label{
                                 text: "Soundcloud: "+ Utility.getHyperLink(artistiInfoModel.get(0).soundcloud_url)
                                 onLinkActivated: Qt.openUrlExternally(link)
                              }
                          }

                          Row{
                              anchors.horizontalCenter: parent.horizontalCenter
                              Label{
                                 text: "Twitter name: "+artistiInfoModel.get(0).twittername
                              }
                          }

                          Row{
                              anchors.horizontalCenter: parent.horizontalCenter
                              Label{
                                 text: "Web site: "+Utility.getHyperLink(artistiInfoModel.get(0).url)
                                 onLinkActivated: Qt.openUrlExternally(link)
                              }
                          }

                          Button {
                                  anchors.horizontalCenter: parent.horizontalCenter
                                  text: i18n.tr("Close")
                                  width: units.gu(14)
                                  onClicked: {
                                      PopupUtils.close(artistInfoDialog)
                                  }
                           }
                    }
             }
            //---------------------------------------------------------


            /* keep sorted the loaded gigs List */
            SortFilterModel {
                id: sortedModelListGigs
                model: eventListModel
                sort.order: Qt.AscendingOrder
                sortCaseSensitivity: Qt.CaseSensitive
            }

            /* The Gigs list loaded from the chosen url */
            UbuntuListView {
               id: listView
               anchors.fill: parent
               anchors.topMargin: units.gu(30) /* amount of space from the above component */
               model: sortedModelListGigs
               delegate: gigsListDelegate

               /* disable the dragging of the model list elements */
               boundsBehavior: Flickable.StopAtBounds
               highlight: HighlightComponent{}
               focus: true
               /* clip:true to prevent that UbuntuListView draw out of his assigned rectangle, default is false */
               clip: true
            }

           Scrollbar {
               flickableItem: listView
               align: Qt.AlignTrailing
           }

           Column{
                anchors.fill: parent
                spacing: units.gu(2)

                /* transparent placeholder: required to place the content under the header */
                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: units.gu(8)
                }

                Row {
                      id:searchArtistRow
                      spacing: units.gu(3)
                      anchors.horizontalCenter: parent.horizontalCenter

                      Button{
                         id:chooseArtistButton
                         text:i18n.tr("Choose Artist")
                         width: units.gu(25)
                         onClicked:{
                             Storage.loadAllSavedGigsUrl();
                             PopupUtils.open(artistChooserComponent, chooseArtistButton)
                         }
                      }

                      Button{
                         id:searchGigsButton
                         text:i18n.tr("Search")
                         enabled:false
                         width: units.gu(14)
                         color: UbuntuColors.green
                         onClicked:{
                             loadingGigsListActivity.running = !loadingGigsListActivity.running /* start animation */

                             eventListModel.clear();
                             var returnCode = RestClient.getUserEventList(root.targetUrl)

                             if (returnCode === -1){
                                 PopupUtils.open(noDataFoundComponent, searchGigsButton)
                                 loadingGigsListActivity.running = !loadingGigsListActivity.running  /* stop animation */

                             }else{
                                 loadingGigsListActivity.running = !loadingGigsListActivity.running  /* stop animation */
                                 filterJobField.enabled = true
                                 gigsFilterButton.enabled = true
                                 artistInfoButton.enabled = true
                             }
                          }
                      }
                }

                Row{
                    id: gigsFilterRow
                    spacing: units.gu(3)
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextField {
                        id: filterJobField
                        placeholderText: i18n.tr("Filter by Country...")
                        width: units.gu(25)
                        enabled:false
                        onTextChanged: {

                            if(text.length === 0 ) { /* show all jobs */
                                sortedModelListGigs.filter.pattern = /./
                                sortedModelListGigs.sort.order = Qt.AscendingOrder
                                sortedModelListGigs.sortCaseSensitivity = Qt.CaseSensitive
                            }
                        }
                     }

                     Button{
                         id:gigsFilterButton
                         text: i18n.tr("Filter")
                         enabled:false
                         width: units.gu(14)
                         onClicked: {

                            if(filterJobField.text.length > 0 ) /* do filter */
                            {
                                /* flag "i" = ignore case */
                                sortedModelListGigs.filter.pattern = new RegExp(filterJobField.text, "i")
                                sortedModelListGigs.sort.order = Qt.AscendingOrder
                                sortedModelListGigs.sortCaseSensitivity = Qt.CaseSensitive

                                    /* filter by eventCountry */
                                    sortedModelListGigs.sort.property = "eventCountry"
                                    sortedModelListGigs.filter.property = "eventCountry"


                            } else { /* show all gigs */

                                sortedModelListGigs.filter.pattern = /./
                                sortedModelListGigs.sort.order = Qt.AscendingOrder
                                sortedModelListGigs.sortCaseSensitivity = Qt.CaseSensitive
                            }
                        }
                     }
                }

                Row{
                    id: gigsFoundRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(9.5)

                     ActivityIndicator {
                        id: loadingGigsListActivity
                     }

                     Label{
                        id:totalGigsFoundLabel
                        anchors.verticalCenter: artistInfoButton.verticalCenter
                        visible:true
                        text: listView.count +" "+i18n.tr("Gig(s)")
                     }

                     Button{
                        id:artistInfoButton
                        text:i18n.tr("Artist info")
                        enabled: false
                        width: units.gu(14)
                        onClicked:{
                            PopupUtils.open(artistInfoComponent, artistInfoButton)
                        }
                     }
                }
            }
        }
    }

}
