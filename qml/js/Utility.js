
/* -------------------- Various utility functions -------------------- */



    /* used to check if a mandatory field is provided by the user */
    function isInputTextEmpty(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 )
           return true
        else
           return false;
    }



    /* Depending on the Pagewidht of the Page (ie: the Device type) decide the Height of the scrollable */
    function getContentHeight(){

        if(rootPage.width > units.gu(80))
            return configurationPage.height + configurationPage.height/2 + units.gu(20)
        else
            return configurationPage.height + configurationPage.height/2 + units.gu(10) //phone
    }


    /* return true if the string ends with .json */
    function endsWithJson(url){

       var suffix = ".json";

       return url.indexOf(suffix, url.length - suffix.length) !== -1;

    }

    /* validate a gigs url: return true if valid */
    function isGigsUlrValid(str) {

      var regex = /(http):\/\/(\w+:{0,1}\w*)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/;

      if(!regex .test(str)) {
        return false;
      } else {
        return true;
      }

    }



    /* Utility function to format the javascript date to have double digits for day and month (default is one digit in js)
       Example return date like: YYYY-MM-DD
       eg: 2017-04-28
    */
    function formatDateToString(date)
    {
       var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
       var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
       var yyyy = date.getFullYear();

       return (yyyy + "-" + MM + "-" + dd);
    }


    /* If input text is different from N/A return tha text as html hyper link */
    function getHyperLink(textToConvert){
        if(textToConvert === null || textToConvert === 'N/A')
           return "N/A";
        else
          return colorLinks(i18n.tr("<a href=\"%1\">"+truncateUrlString(textToConvert)+"</a>").arg(textToConvert))
    }


    /* to create a blue hyper link to show in a label */
    function colorLinks(text) {

        var linkColor = "blue";
        var t = "<a href=\"%1\">"+text+"</a>"

        return t.replace(/<a(.*?)>(.*?)</g, "<a $1><font color=\"" + linkColor + "\">$2</font><")
    }


    /* Depending on the Page widht of the Page (ie: the Device type) decide the offest heigth */
    function getOffsetAmount(){
        if(rootPage.width > units.gu(80))
            return units.gu(33) //tablet
        else
            return units.gu(41)
    }

    /* Depending on the Page widht of the Page (ie: the Device type) how to reduce the the Artist info popup size */
    function getPopupReductionFactor(){
        if(root.width > units.gu(80))
            return units.gu(53) //tablet
        else
            return units.gu(4)
    }

    function getTextFieldReductionFactor(){
        if(root.width > units.gu(80))
            return units.gu(60) //tablet
        else
            return units.gu(34)
    }

    /* used to truncate jobs url too long in the phone job list page */
    function truncateUrlString(urlString){

        var length = 30;
        var newUrlString;

        if(root.width > units.gu(80)){
            return urlString; //tablet: no truncate
        }else {

            if (urlString.length > length) {
                newUrlString = urlString.substring(0, length)+'...';
                console.log("returning: "+newUrlString);
                return newUrlString;
            }else{
                return urlString
            }
        }
    }
