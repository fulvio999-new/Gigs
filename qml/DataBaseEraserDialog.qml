import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0
import "./Storage.js" as Storage


/*
   Show a Dialog where the user can delete ALL the database content: Artist and gigs url
 */
Dialog {
    id: dataBaseEraserDialog
    text: "<b>"+ i18n.tr("Remove ALL database data ?")+"<br/>"+i18n.tr("(there is NO restore)")+ "</b>"

    Rectangle {
        id: rectangleContainer
        width: parent.width //units.gu(180);
        height: units.gu(9);

        Item{

            Column{
                id: mainColumn
                spacing: units.gu(2)              

                Row{
                    spacing: units.gu(1)

                    /* placeholder */
                    Rectangle {
                        color: "transparent"
                        width:  units.gu(3)
                        height: units.gu(3)
                    }

                    Button {
                        id: closeButton
                        width: units.gu(12)
                        text:  i18n.tr("Close")
                        onClicked: PopupUtils.close(dataBaseEraserDialog)
                    }

                    Button {
                        id: deleteButton
                        width: units.gu(12)
                        text:  i18n.tr("Delete")
                        color: UbuntuColors.orange
                        onClicked: {
                            //delete ALL
                            Storage.deleteAllGigsUrl();
                            deleteOperationResult.color = UbuntuColors.green;
                            deleteOperationResult.text = i18n.tr("Operation executed successfully");                            
                          }
                       }
                    }               

                    Row{
                        x: rectangleContainer.width/8
                        Label{
                            id: deleteOperationResult
                        }
                    }
                 }
            }
        }
    }
