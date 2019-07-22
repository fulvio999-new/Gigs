
/*

Function used to manage the application database where are saved GIGA url of you favourite artist

*/

 function getDatabase() {
    return LocalStorage.openDatabaseSync("gigs_db", "1.0", "StorageDatabase", 1000000);
 }


 /* create the necessary tables */
 function createTables() {

     var db = getDatabase();
     db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS gigs_data(id INTEGER PRIMARY KEY AUTOINCREMENT, artist_name TEXT, gigs_url TEXT)');
        });
 }


 /* Insert default giga urls for some artist: See soundcloud for new artist, url.
    Note: rest call with httpS url does not work
 */
 function insertDefaultArtistUrl(){

     if(settings.defaultDataImported == false) https://gigs.gigatools.com/u/fatimahajji.json
     {
         insertNewGigsUrl("Marika Rossa", "http://gigs.gigatools.com/u/marikarossa.json");
         insertNewGigsUrl("David Moraler", "http://gigs.gigatools.com/u/DMorales.json");
         insertNewGigsUrl("Andrea Raffa", "http://gigs.gigatools.com/u/andrearaffa.json");
         insertNewGigsUrl("Fatima Hajji", "http://gigs.gigatools.com/u/fatimahajji.json");

         return true;
      }else
         return false;
 }


 /* Insert Gigs url for a new artist */
 function insertNewGigsUrl(artistName, gigsUrl){

        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {

            var rs = tx.executeSql('INSERT INTO gigs_data(artist_name, gigs_url) VALUES (?,?);', [artistName, gigsUrl]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
  }


  /* Update informations about a previously saved Gigs url */
  function updateGigsUrl(id,artistName, gigsUrl){

       var db = getDatabase();
       var res = "";

       db.transaction(function(tx) {
           var rs = tx.executeSql('UPDATE gigs_data SET artist_name=?, gigs_url=? WHERE id=?;', [artistName,gigsUrl,id]);
           if (rs.rowsAffected > 0) {
               res = "OK";
           } else {
               res = "Error";
           }
       }
       );
       return res;
  }


  /* delete a Gigs url informations */
  function deleteGigsUrl(id){
        var db = getDatabase();

        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM gigs_data WHERE id =?;',[id]);
           }
        );
  }

  /* load ALL the saved Gigs url  */
  function loadAllSavedGigsUrl(){

      savedGigsUrlListModel.clear();
      var db = getDatabase();
      var rs = "";

      db.transaction(function(tx) {
           rs = tx.executeSql('select id, artist_name, gigs_url from gigs_data');
         }
      );

      if(rs.rows.length === 0){
          savedGigsUrlListModel.append({"artistName" : "NO GIGS URL FOUND", "gigsUrl" : "----" } );
      }else{

          for(var i =0;i < rs.rows.length;i++) {
              savedGigsUrlListModel.append({"id" : rs.rows.item(i).id, "artistName" : rs.rows.item(i).artist_name, "gigsUrl" : rs.rows.item(i).gigs_url } );
              /* console.log("Found name: "+rs.rows.item(i).artist_name +" URL: "+rs.rows.item(i).gigs_url); */
          }
      }
  }



 /* Remove ALL saved Jenkins URL */
 function deleteAllGigsUrl(){

        var db = getDatabase();

        db.transaction(function(tx) {
          var rs = tx.executeSql('DELETE FROM gigs_data;');
         }
       );

       savedGigsUrlListModel.clear();
       eventListModel.clear();      
 }
