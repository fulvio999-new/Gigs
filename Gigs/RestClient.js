.import "Utility.js" as Utility


    /*
       Get all events/gigs for the chosen artist using the gigatools url received in argument and fill the listModel to dispaly them
       Url mus be like: http://gigs.gigatools.com/u/"+artistName+".json
    */
    function getUserEventList(artistGigsUrl) {
        //console.log("Giga url:"+artistGigsUrl);
        //note: running on device, httpS call doesn't works
        var xmlhttp = new XMLHttpRequest();
        var urlToCall = artistGigsUrl;

        var returnCode = 0; //OK

        xmlhttp.onreadystatechange=function() {

             if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
             {
                  /* returned data is composed of two json array */
                  var obj = JSON.parse(xmlhttp.responseText);

                  /* 1) first array contains artist information */
                  var userInfo = obj[0];

                  var artistname = userInfo.user.artistname === null ? "N/A" : userInfo.user.artistname;
                  var bookingcontact = userInfo.user.bookingcontact === null ? "N/A" : userInfo.user.bookingcontact;
                  var mixcloud_url = userInfo.user.mixcloud_url === null ? "N/A" : userInfo.user.mixcloud_url;
                  var soundcloud_url = userInfo.user.soundcloud_url === null ? "N/A" : userInfo.user.soundcloud_url;
                  var twittername = userInfo.user.twittername === null ? "N/A" : userInfo.user.twittername;
                  var url = userInfo.user.url === null ? "N/A" : userInfo.user.url;

                  artistiInfoModel.append({"artistname" : artistname, "bookingcontact" : bookingcontact, "mixcloud_url" : mixcloud_url, "soundcloud_url":soundcloud_url, "twittername":twittername, "url": url } );


                  /* 2) second array contains artist gigs data */
                  var eventList = obj[1];
                  //console.log("*** Total Event length: "+eventList.length); //zero based

                  for(var i=0; i<eventList.length; i++){

                     try{
                         /* workaround to check if color is set if a job have no 'color' set, means that is a folder, and this statement generate an Exception */
                         var eventId = eventList[i].event.id === null ? "N/A" : eventList[i].event.id;
                         var eventPlace = eventList[i].event.venue === null ? "N/A" : eventList[i].event.venue;  //ie: the club,disco
                         var eventDate = eventList[i].event.eventdate === null ? "N/A" : eventList[i].event.eventdate;
                         var city = eventList[i].event.city === null ? "N/A" : eventList[i].event.city;
                         var country = eventList[i].event.country === null ? "N/A" : eventList[i].event.country;
                         var eventUrl = eventList[i].event.url === "" ? "N/A" : eventList[i].event.url; //event web site

                         eventListModel.append({"eventId" : eventId, "eventPlace" : eventPlace, "eventDate" : eventDate, "eventCity":city, "eventCountry":country, "eventUrl": eventUrl } );

                     }catch(e){
                        console.log("Error loading event list from url: "+artistGigsUrl+ " cause: "+e)
                     }
                 }
             }
             //else if(xmlhttp.status != 200) {
            //    returnCode = -1;
            // }
        }

        xmlhttp.open("GET", urlToCall, true);
        xmlhttp.send();

        return returnCode;
    }
