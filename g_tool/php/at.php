<?php


$SN = "autorizace";
Session_name("$SN");
Session_start();
$sid = Session_id();
$date = Date("U");
$ad = Date("U") - 3000;

include "./lll.php";

$mysqli1 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}

$res=$mysqli1->query("SELECT * FROM autorizace where id=\"$sid\" AND date>\"$ad\";");
$cnt1 = $res->num_rows;
mysqli_close($mysqli1);

if($cnt1 < 1){
echo "<br>Neautorizovaný přístup je treba se <a href=\"./autorizace.php\" onclick=\"window.open('./autorizace.php',newwindow','width=800,height=600,location,resizable'); return false;\"> Přihlásit </a>";
Exit;
}

else { 
   $row = $res->fetch_assoc();
   $xuser = $row['nick']; 
}

?>

