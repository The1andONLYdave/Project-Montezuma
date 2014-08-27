//nach normalem POST prüfen
if(isset($_POST["username"]) && ($_POST["username"] !='')){
$username=($_POST["username"]);

//Link Pfade bauen für neue Datei
$complete_link=$link_pre.$username.$timestamp_now.$link_post;
$complete_link_file=$userlist_path.$complete_link;	

//letzte 3 Doppelpunkte abschneiden, werden als Trennzeichen nach jedem Feld in POST benutzt
$applist=rtrim(($_POST["applist"]), ":::"); //rtrim last 3char

//Parsen bei jedem 3xDoppelpunkt, es kommt über POST nen ziemlich langer String
$pattern=":::"; 
$app_array = split( $pattern , $applist);

//write header wir bauen eine neue HTML Datei auf dem Server mit dem was wir aus den POST Daten berechnen
$f = fopen($complete_link_file, "w");
$data=" <!DOCTYPE HTML>
    <html lang='de'>
    <head>
    <meta charset='utf-8'>
//Bla super cooler stuff mit POST Daten Bearbeitung und kram.
</script>
    </body>
    </html>
";

fwrite($f, $data);

//do all stuff
//closing file
//ups fclose fehlt hier noch, naja geht auch ohne bisher

//give link to user (<a href="bla">bla</a> so he can copy n past or click directly how he wants. usability is cool ;-)
echo 'hallo '.$username.' deine liste ist nun online unter <a href="http://app-liste.de/userlist/'.$complete_link.'">'.$complete_link.'</a></p></br>';
//das <a href> ist das wonach im Android-Teil geparst wird	
	
}
else echo "no valid username";
//wenn keine POST Daten oder Format falsch keine HTML erzeugen und nix zum Parsen zurückgeben, dann is eh was falsch o.ä.
?>	







