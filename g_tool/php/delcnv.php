<?php

include "./kkk.php";
include "./dat.php";
include "./lll.php";

//include "./at.php";

$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");
$kor = htmlspecialchars($_GET['kor'], ENT_QUOTES, "UTF-8");


     $con = new mysqli($server_name,$user,$pass,$database);
     if ($con->connect_errno) {
         echo "Failed to connect to MySQL: (" . $con->connect_errno . ") " . $con->connect_error;
     }
     $con->set_charset("utf8");

     $sql = "DELETE FROM cnv WHERE pac=\"$pac\" AND kor=\"$kor\"";
     if (!mysqli_query($con, $sql)) { echo "Error: " . $sql . "" . mysqli_error($con);}
     $con->close();

header("HTTP/1.1 301 Moved Permanently");
header("Location:../index.php");
header("Connection: close");

?>
