<?php

include "./lll.php";
include "./at.php";

//echo "<br>";
//echo "UPDATE<BR><BR>";

$chr = htmlspecialchars($_POST['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_POST['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_POST['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_POST['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_POST['alt'], ENT_QUOTES, "UTF-8");
$class = htmlspecialchars($_POST['class'], ENT_QUOTES, "UTF-8");
$poz1 = htmlspecialchars($_POST['poz1'], ENT_QUOTES, "UTF-8");
$poz2 = htmlspecialchars($_POST['poz2'], ENT_QUOTES, "UTF-8");
$dia = htmlspecialchars($_POST['dia'], ENT_QUOTES, "UTF-8");

// zjistime puvodni hodnoty, aby se mohlo zjistit, co se zmenilo

$mysqli1 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}
$res=$mysqli1->query("SELECT * FROM nase_var WHERE chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

mysqli_close($mysqli1);

$row1 = $res->fetch_assoc();

$lpoz1 = $row1['poz1'] ;
$lpoz2 = $row1['poz2'] ;
$ldia = $row1['dia'] ;
$lclass = $row1['class'] ;
$luser = $row1['user'] ;




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

$con = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($con->connect_errno) {
    echo "Failed to connect to MySQL: (" . $con->connect_errno . ") " . $con->connect_error;
}
$con->set_charset("utf8");
$sql = "UPDATE nase_var set poz1=\"$poz1\", poz2=\"$poz2\", dia=\"$dia\", class=\"$class\", user=\"$xuser\" WHERE chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";";


if (mysqli_query($con, $sql)) {

  // a tady ulozime do tabulky zmen, co se udalo
  $ipaddress = $_SERVER['REMOTE_ADDR'];
  //$user = "TEST";

  $mysqli = new mysqli($server_name,$ruser,$rpass,$rdatabase);
  if ($mysqli->connect_errno) {
      echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
  }
  $mysqli->set_charset("utf8");

  if($class != $lclass) {
    //echo " CLASS se zmenil <BR>"; 
    $sql1 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','class','$xuser','$class','$chr','$start','$end','$alt','$ref')";
    if ($mysqli->query($sql1) == TRUE) {
        //echo "Vlozen zaznam do tabulky zmen";
    } 
    else {
        echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
    }
  }

  if($poz1 != $lpoz1) { 
    //echo " poz1 se zmenil <BR>"; 
    $sql2 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','poz1','$xuser','$poz1','$chr','$start','$end','$alt','$ref')";
    if ($mysqli->query($sql2) == TRUE) {
        //echo "Vlozen zaznam do tabulky zmen";
    } 
    else {
        echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
    }
  }

  if($poz2 != $lpoz2) { 
    //echo " poz2 se zmenil <BR>"; 
    $sql3 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','poz2','$xuser','$poz2','$chr','$start','$end','$alt','$ref')";
    if ($mysqli->query($sql3) == TRUE) {
        //echo "Vlozen zaznam do tabulky zmen";
    } 
    else {
        echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
    }
  }

  if($dia != $ldia) { 
    //echo " dia se zmenil <BR>"; 
    $sql4 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','dia','$xuser','$dia','$chr','$start','$end','$alt','$ref')";
    if ($mysqli->query($sql4) == TRUE) {
        //echo "Vlozen zaznam do tabulky zmen";
    } 
    else {
        echo "Error nepodarilo se ulozit do tabulky zmen: " . $mysqli->error;
    }
  }

  if($xuser != $luser) { 
    //echo " user se zmenil - patrne konfirmace <BR>"; 
    $sql5 = "INSERT INTO ch_dia(`ip`,`item`,`user`,`change`,`chrom`,`start`,`end`,`alt`,`ref`) VALUES ('$ipaddress','user','$xuser','$xuser','$chr','$start','$end','$alt','$ref')";
    if ($mysqli->query($sql5) == TRUE) {
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
