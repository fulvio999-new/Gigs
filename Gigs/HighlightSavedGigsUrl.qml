import QtQuick 2.0


/*
   Used to highlight the currently selected Artist+Gigs url from the saved list
*/
Component {
    id: highlightComponent

    Rectangle {
        width: 180; height: 44
        color: "blue";

        radius: 2
        /* move the Rectangle on the currently selected List item with the keyboard */
        y:savedGigsUrlListView.currentItem.y

        /* show an animation on change ListItem selection */
        Behavior on y {
            SpringAnimation {
                spring: 5
                damping: 0.1
            }
        }
    }
}
