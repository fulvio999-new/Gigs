import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0



/*
  Application help page
*/
Column{
    id: manageSavedGigsUrl
    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)

    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(3)
    }

    TextArea {
          width: parent.width
          height: parent.height
          readOnly: true
          autoSize: true
          placeholderText: i18n.tr("This App query")+": "+"https://gigs.gigatools.com/"+
                           "<br/>"+i18n.tr("to get info about the events of an artist,dj, producer.")+
                           "<br/>"+i18n.tr("Obviously the artist must use that service.")+
                           "<br/><br/>"+i18n.tr("The search gigs url have a fixed format that must be like this:")+
                           "<br/><br/>"+i18n.tr("http://gigs.gigatools.com/u/'artistName'.json")+
                           "<br/><br/><b>"+i18n.tr("NOTE: Don't use 'https' in the url")+"</b>"+
                           "<br/><br/>"+i18n.tr("Where 'artistName' is the ONLY variable part.")+
                           "<br/>"+i18n.tr("Is the name/nickname choosen by the artist/singer/dj")+
                           "<br/><br/>"+i18n.tr("The '.json' suffix communicate at gigatools.com service the data format wanted")+
                           "<br/><br/><br/><b>"+i18n.tr("Where i can find gigs url ?")+"</b>"+
                           "<br/><br/>"+i18n.tr("On artist Facebook page, Soundcloud page...")+
                           "<br/><br/>"+i18n.tr("The 'Artist name' field required by this application is a free name of your choice.")+
                           "<br/>"+i18n.tr("The important thing is the gig url (use http urls, NOT https).")+
                           "<br/>"+i18n.tr("To check if gigs url is correct and return data, try it with your browser")
      }

}
