if(isset($_POST["username"]) && ($_POST["username"] !='')){
$username=($_POST["username"]);

$complete_link=$link_pre.$username.$timestamp_now.$link_post;
$complete_link_file=$userlist_path.$complete_link;	

$applist=rtrim(($_POST["applist"]), ":::"); //rtrim last 3char

$pattern=":::"; 

$app_array = split( $pattern , $applist);

//write header 
$f = fopen($complete_link_file, "w");
$data=" <!DOCTYPE HTML>
    <html lang='de'>
    <head>
    <meta charset='utf-8'>

</script>
    </body>
    </html>
";

fwrite($f, $data);

//do all stuff
//closing file


//give link to user (<a href="bla">bla</a> so he can copy n past or click directly how he wants. usability is cool ;-)
echo 'hallo '.$username.' deine liste ist nun online unter <a href="http://app-liste.de/userlist/'.$complete_link.'">'.$complete_link.'</a></p></br>';
	
	
}
else echo "no valid username";

?>	







