import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/* Notify an operation result */
Dialog {

    id: invalidInputDialog
    title: i18n.tr("Operation Result")

    /* the message to display, passed as parameter  */
    property string msg;

    Column{
        spacing: units.gu(2)

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
                id:messageLabel               
                text: msg 
            }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: i18n.tr("Close")
                width: units.gu(14)
                onClicked:
                    PopupUtils.close(invalidInputDialog)
            }
        }
    }
}
