<?php

include "./lll.php";
include "./at.php";

echo "<br>";
//echo "INSERT<BR><BR>";

$chr = htmlspecialchars($_POST['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_POST['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_POST['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_POST['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_POST['alt'], ENT_QUOTES, "UTF-8");
$class = htmlspecialchars($_POST['class'], ENT_QUOTES, "UTF-8");
$poz1 = htmlspecialchars($_POST['poz1'], ENT_QUOTES, "UTF-8");
$poz2 = htmlspecialchars($_POST['poz2'], ENT_QUOTES, "UTF-8");
$dia = htmlspecialchars($_POST['dia'], ENT_QUOTES, "UTF-8");

//echo "Chr>>$chr<br>";
//echo "Start>>$start<br>";
//echo "End>>$end<br>";
//echo "Ref>>$ref<br>";
//echo "Alt>>$alt<br>";
//echo "Class>>$class<br>";
//echo "Poz1>>$poz1<br>";
//echo "Poz2>>$poz2<br>";
//echo "Dia>>$dia<br>";

//echo "<br>";

// zjistime, jestli uz zanam nahodou neexistuje


$mysqli3 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli3->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
}
$mysqli3->set_charset("utf8");

$res3=$mysqli3->query("SELECT * FROM nase_var where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

$cnt3 = $res3->num_rows;

mysqli_close($mysqli3);

//echo "CNT>>$cnt3";

// chceme ukladat, v tabulce nesmi byt zadny zaznam
if ($cnt3 >0) {

  echo "<script>";
  echo "window.resizeTo(300,200)";
  echo "</script>";

  echo "<center><br>Zaznam jiz existuje<br><br>";
  echo "<button type=\"button\" onclick=\"javascript:window.close()\">OK</button>";
  echo "</center>";
  exit;
}


$con = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($con->connect_errno) {
    echo "Failed to connect to MySQL: (" . $con->connect_errno . ") " . $con->connect_error;
}
$con->set_charset("utf8");
$sql = "INSERT INTO nase_var(chrom,start,end,ref,alt,poz1,poz2,dia,class,user)VALUES (\"$chr\",\"$start\",\"$end\",\"$ref\",\"$alt\",\"$poz1\",\"$poz2\",\"$dia\",\"$class\",\"$xuser\")";


if (mysqli_query($con, $sql)) {

// do tabulky zmen ulozime co se zmenilo

     $ipaddress = $_SERVER['REMOTE_ADDR'];

     $mysqli = new mysqli($server_name,$ruser,$rpass,$rdatabase);
     if ($mysqli->connect_errno) {
         echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
     }
     $mysqli->set_charset("utf8");

     if($class != "") {
       //echo " CLASS se zmenil <BR>"; 
       $sql1 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','class','$xuser','$class','$chr','$start','$end','$alt','$ref')";
       if ($mysqli->query($sql1) == TRUE) {
           //echo "Vlozen zaznam do tabulky zmen";
       } 
       else {
           echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
       }
     }

     if($poz1 != "") { 
       //echo " poz1 se zmenil <BR>"; 
       $sql2 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','poz1','$xuser','$poz1','$chr','$start','$end','$alt','$ref')";
       if ($mysqli->query($sql2) == TRUE) {
           //echo "Vlozen zaznam do tabulky zmen";
       } 
       else {
           echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
       }
     }

     if($poz2 != "") { 
       //echo " poz2 se zmenil <BR>"; 
       $sql3 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','poz2','$xuser','$poz2','$chr','$start','$end','$alt','$ref')";
       if ($mysqli->query($sql3) == TRUE) {
           //echo "Vlozen zaznam do tabulky zmen";
       } 
       else {
           echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
       }
     }

     if($dia != "") { 
       //echo " dia se zmenil <BR>"; 
       $sql4 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','dia','$xuser','$dia','$chr','$start','$end','$alt','$ref')";
       if ($mysqli->query($sql4) == TRUE) {
           //echo "Vlozen zaznam do tabulky zmen";
       } 
       else {
           echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
       }
     }

   $mysqli->close();

   echo "<script>";
   echo "window.resizeTo(300,200)";
   echo "</script>";
 
   echo "<center><br>Zaznam byl ulozen <br><br>";
   echo "<button type=\"button\" onclick=\"javascript:window.close()\">OK</button>";
   echo "</center>";
} 

else {
  echo "Error: " . $sql . "" . mysqli_error($con);
}


$con->close();


?>
