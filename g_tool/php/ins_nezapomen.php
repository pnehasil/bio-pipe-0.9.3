<?php

include "./kkk.php";
include "./dat.php";

echo "<br>";

$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");
$gen = htmlspecialchars($_GET['gen'], ENT_QUOTES, "UTF-8");
$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$odkud = htmlspecialchars($_GET['odkud'], ENT_QUOTES, "UTF-8");
$exom = htmlspecialchars($_GET['exom'], ENT_QUOTES, "UTF-8");


echo "<br>";

$mysqli1 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}
$res=$mysqli1->query("SELECT * FROM nezapomen where chr=\"$chr\" AND start=\"$start\" AND gen=\"$gen\" AND pac=\"$pac\";");

$cnt1 = $res->num_rows;
mysqli_close($mysqli1);

if($cnt1 == 0)
 {
   // zaznam dosud neni v tabulce, tak ho pridame


   $con = new mysqli($server_name,$user,$pass,$database);
   if ($con->connect_errno) {
       echo "Failed to connect to MySQL: (" . $con->connect_errno . ") " . $con->connect_error;
   }
   $con->set_charset("utf8");
   $sql = "INSERT INTO nezapomen(chr,start,pac,gen,exom)VALUES (\"$chr\",\"$start\",\"$pac\",\"$gen\",\"$exom\")";

   if (mysqli_query($con, $sql)) {

     $con->close();

     header("Location: ../$odkud");
     exit;

   }
   else {
     echo "Error: " . $sql . "" . mysqli_error($con);
   }


   $con->close();

}
if($cnt1 > 1) {
  // musi byt prave jeden zaznam - nesmi byt vice s totoznym chr,start,pac,gen

   echo "Nejaka divna chyba. ";
   echo "Text nize prosim poslat na petr.nehas@gmail.com<br><br>";
   echo "Vicero zaznamu v tabulce variant:<br>";
   echo "Chr>>$chr<br>";
   echo "Start>>$start<br>";
   echo "PAc>>$pac<br>";
   echo "Gen>>$Gen<br>";
   echo "<br>";

   echo "<br>";
   echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";
   echo "<br><br>";
   
   exit;

}

header("Location: ../$odkud");
exit;

?>


