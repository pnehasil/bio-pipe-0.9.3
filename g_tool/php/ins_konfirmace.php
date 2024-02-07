<?php

include "./kkk.php";
include "./dat.php";

echo "<br>";

$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");
$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");

$mysqli2 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli2->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
}

$res2=$mysqli2->query("SELECT * FROM $pac where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\" ;");
$cnt2 = $res2->num_rows;
$row2 = $res2->fetch_assoc();

mysqli_close($mysqli2);

if($cnt2 <> 1) {

  // echo "<script>";
  //echo "window.resizeTo(300,200)";
  //echo "</script>";

  echo "Bordel v tabulce $pac:<br>";
  echo "chrom>>$chr<br>";
  echo "start>>$start<br>";
  echo "end>>$end<br>";
  echo "ref>>$ref<br>";
  echo "alt>>$alt<br>";
  echo "<button type=\"button\" onclick=\"javascript:window.close()\">OK</button>";
  echo "</center>";
  exit;
}
else {

   $id = $row2['id'] ;

   $mysqli3 = new mysqli($server_name,$user,$pass,$database);
   if ($mysqli3->connect_errno) {
       echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
   }

   $res3=$mysqli3->query("SELECT * FROM konfirmace where pac=\"$pac\" AND p_id=\"$id\" ;");
   $cnt3 = $res3->num_rows;

   mysqli_close($mysqli3);

   if($cnt3 == 0) { // nechceme vicero zaznamu

      $con = new mysqli($server_name,$user,$pass,$database);
      if ($con->connect_errno) {
          echo "Failed to connect to MySQL: (" . $con->connect_errno . ") " . $con->connect_error;
      }
      $con->set_charset("utf8");
      $sql = "INSERT INTO konfirmace(pac,p_id)VALUES (\"$pac\",\"$id\")";

      if (mysqli_query($con, $sql)) {

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
   }
  else { echo "<script>window.close()</script>"; }

}


?>


