import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import QtQuick.LocalStorage 2.0
import "./js/Storage.js" as Storage


/*
   Show a Dialog where the user can delete ALL the database content: Artist and gigs url
 */
 /* Show a Dialog where the user can choose to delete ALL the saved expense */
 Dialog {
         id: dataBaseEraserDialog
         text: "<b>"+ i18n.tr("Remove ALL database data ?")+"<br/>"+i18n.tr("(there is NO restore)")+ "</b>"

         Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                 id: deleteOperationResult
                 text: " "
            }
         }

         Row{
               //x: dataBaseEraserDialog.width/10
               anchors.horizontalCenter: dataBaseEraserDialog.Center
               spacing: units.gu(1)

               Button {
                     id: closeButton
                     text: i18n.tr("Close")
                     width: units.gu(14)
                     onClicked: PopupUtils.close(dataBaseEraserDialog)
               }

               Button {
                     id: importButton
                     text: i18n.tr("Delete")
                     width: units.gu(14)
                     color: UbuntuColors.red
                     onClicked: {
                        Storage.deleteAllGigsUrl();
                        Storage.loadAllSavedGigsUrl();
                        /* to allow the import of default data again */
                        settings.defaultDataImported = false;
                        deleteOperationResult.color = UbuntuColors.green;
                        deleteOperationResult.text = i18n.tr("Operation executed successfully");
                     }
                 }
           }
     }
