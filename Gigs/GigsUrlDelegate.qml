
import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage
import "Utility.js" as Utility

   /*
     Display a seved Jenkins url with his Alias and offer the operations to manage it: edit, delete
     NOTE: don't place here other Components, Dialog: they doesn't work. Place them the parent
   */
   Column {
        id: gigsUrlListDelegate

        width: editSavedGigsUrlPage.width
        height: units.gu(13) /* the heigth of the rectangular container */
        visible: true;

        /* create a container for each category */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "grey"
            radius: 5
        }

        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent    /* MouseArea covers the entire delegate Item */
            onClicked: {
                /* move the highlight component to the currently selected Row */
                savedGigsUrlListView.currentIndex = index
            }
        }

        /* create a Row for each entry in the Model */
        Row {
            id: topLayout
            x: 10; y: 1; height: background.height; width: parent.width

            Column {
                id: containerColumn
                width: background.width - manageUrlColumn.width
                height: gigsUrlListDelegate.height
                spacing: units.gu(1)

                Rectangle {
                    id: placeholder
                    color: "transparent"
                    width: parent.width
                    height: units.gu(0.5)
                }

                Row{
                    id:displayNameRow
                    spacing: units.gu(1)
                    Label {
                        id: displayNameLabel
                        anchors.verticalCenter: artistNameTextField.verticalCenter
                        text: i18n.tr("Artist")+":"
                        font.bold: true
                    }

                    TextField {
                        id: artistNameTextField
                        text: artistName
                        hasClearButton: false
                        height: units.gu(4)
                        width: Utility.getTextFieldReductionFactor()
                        enabled: false
                    }
                }

                Row{
                    id:urlRow
                    spacing: displayNameLabel.text.length
                    Label {
                        anchors.verticalCenter: gigsUrlTextField.verticalCenter
                        text: i18n.tr("Url")+":"
                        font.bold: true
                    }

                    TextField {
                        id: gigsUrlTextField
                        x:artistNameTextField.x
                        hasClearButton: false
                        text: gigsUrl
                        width: Utility.getTextFieldReductionFactor()
                        height:units.gu(4)
                        enabled: false
                    }
                }
            }


            Column{
                id: manageUrlColumn
                height: parent.height
                width: units.gu(7);
                spacing: units.gu(1)

                Rectangle {
                    id: placeholder2
                    color: "transparent"
                    width: parent.width
                    height: units.gu(0.1)
                }

                //---- Delete gigs url
                Row{
                    id:deleteUrlRow
                    Icon {
                        id: deleteUrlIcon
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "delete"

                        MouseArea {
                            id: deleteUrlArea
                            width: deleteUrlIcon.width
                            height: deleteUrlIcon.height
                            onClicked: {
                                PopupUtils.open(confirmDeleteUrlComponent);
                            }
                        }
                    }
                }

                //---- Edit gigs url
                Row{
                    id:editUrlRow
                    Icon {
                        id: editUrlIcon
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "edit"

                        MouseArea {
                            width: editUrlIcon.width
                            height: editUrlIcon.height
                            onClicked: {
                                artistNameTextField.enabled = true
                                gigsUrlTextField.enabled = true
                                saveUrlRow.visible = true
                            }
                        }
                    }
                }

                //------ Update url (shown when edit icon is selected) ----
                Row{
                    id:saveUrlRow
                    visible: false
                    Icon {
                        id: editUrlIcon2
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "save"

                        MouseArea {
                            width: editUrlIcon.width
                            height: editUrlIcon.height
                            onClicked: {

                                /* 'id' is a field loaded from the database but not shown in the UI */
                                var gigsUrlId = savedGigsUrlListModel.get(savedGigsUrlListView.currentIndex).id;

                                if(Utility.isInputTextEmpty(artistNameTextField.text) || Utility.isInputTextEmpty(gigsUrlTextField.text) || !Utility.endsWithJson(gigsUrlTextField.text) || !Utility.isGigsUlrValid(gigsUrlTextField.text))
                                {
                                   PopupUtils.open(invalidInputComponent);
                                }else {
                                    Storage.updateGigsUrl(gigsUrlId,artistNameTextField.text,gigsUrlTextField.text);

                                    artistNameTextField.enabled = false
                                    gigsUrlTextField.enabled = false
                                    saveUrlRow.visible = false

                                    /* refresh model for the url chooser popup button */
                                    Storage.loadAllSavedGigsUrl();

                                    PopupUtils.open(operationSuccessComponent);
                                }
                            }
                        }
                    }
                }

           }
     }

}
