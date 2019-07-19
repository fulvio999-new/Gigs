import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "./js/Storage.js" as Storage


Page {
      id: editSavedGigsUrlPage
      visible: false

      header: PageHeader {
         title: i18n.tr("Edit saved gigs Url")
      }

/*
  Content of the editing page for saved Artist Gigs url

*/
Column{
    id: manageSavedGigsUrl
    anchors.fill: parent
    //width: editSavedGigsUrlPage.width

    spacing: units.gu(3.5)

    Component{
        id: invalidInputComponent
        Dialog {
            id: invalidInputDialog
            title: i18n.tr("Operation Result")
            text: i18n.tr("FAILURE: Invalid input")+ i18n.tr( "(url is correct ?,  don't use https)")

            Button {
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(invalidInputDialog)
            }
        }
    }

    Component{
        id: operationSuccessComponent
        Dialog {
            id: operationSuccessDialog
            title: i18n.tr("Operation Result")
            text: i18n.tr("SUCCESS: Operation executed")

            Button {
                id: closeButton
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(operationSuccessDialog)
            }
        }
    }


    /* Confirm Dialog before delete an Artist with his Gigs url */
    Component {
        id: confirmDeleteUrlComponent

        Dialog {
                id: dataBaseEraserDialog
                text: "<b>"+i18n.tr("Remove selected artist with Gig URL ?")+ "<br/>"+i18n.tr("(there is no restore)")+"</b>"

                Row{
                   anchors.horizontalCenter: parent.horizontalCenter
                   Label{
                        id: deleteOperationResult
                        text: " "
                   }
                }

                Row{
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
                              /* 'id' is a field loaded from the database but not shown in the UI */
                                   var gigsUrlId = savedGigsUrlListModel.get(savedGigsUrlListView.currentIndex).id;
                                   Storage.deleteGigsUrl(gigsUrlId);

                                   deleteOperationResult.text = i18n.tr("Operation executed successfully")
                                   Storage.loadAllSavedGigsUrl(); //refresh
                            }
                        }
                  }
            }
    }


    Component {
       id: gigsUrlDelegate
       GigsUrlDelegate{}
    }

    UbuntuListView {
        id: savedGigsUrlListView
        anchors.fill: parent
        anchors.topMargin: units.gu(8)
        model: savedGigsUrlListModel
        delegate: gigsUrlDelegate
        /* if false, the List scroll under the above component (ie. the search form) */
        clip: true
        /* disable the pull/dragging of the model list elements */
        boundsBehavior: Flickable.StopAtBounds
        highlight: HighlightSavedGigsUrl{}
        focus: true
    }

    /* allow scroll to prevent keyboard overlap during edit operation */
    Scrollbar {
        flickableItem: savedGigsUrlListView
        align: Qt.AlignTrailing
    }

}

}
