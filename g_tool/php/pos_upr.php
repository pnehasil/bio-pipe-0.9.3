<?php

include "./lll.php";
include "./kkk.php";
include "./dat.php";


$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");
$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");


$mysqli4 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli4->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
}
$mysqli4->set_charset("utf8");

$res4=$mysqli4->query("SELECT * FROM ch_dia where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\" ORDER by time DESC;");

$cnt4 = $res4->num_rows;

if($cnt4 > 0) {

   echo "<center>";
   echo "<h2>Poslední úpravy:</h2>";
   echo "<table border=5>";
   echo "<tr height=35><td align=\"center\" width=80> <b>Uživatel</b> </td>";
   echo "<td align=\"center\" width=180> Dne </td>";
   echo "<td align=\"center\" width=100> Změnil </td>";
   echo "<td align=\"center\" width=90> Chrom </td>";
   echo "<td align=\"center\" width=100> Start </td>";
   echo "<td align=\"center\" width=100> End </td>";
   echo "<td align=\"center\" width=60> Alt </td>";
   echo "<td align=\"center\" width=60> Ref </td>";
   echo "</tr>";

   while($row4 = $res4->fetch_assoc())  {
   $time = $row4['time'] ;
   $zuser = $row4['user'] ;
   $item = $row4['item'] ;

   $chr=$row4['chrom'] ;
   $start=$row4['start'] ;
   $end=$row4['end'] ;
   $alt=$row4['alt'] ;
   $ref=$row4['ref'] ;

   if($item === "poz1") { $item = "Poznámka1"; }
   if($item === "poz2") { $item = "Poznámka2"; }
   if($item === "dia") { $item = "Do zprávy"; }
   if($item === "class") { $item = "Class"; }

   echo "<tr height=35><td align=\"center\" width=80> <b>$zuser</b> </td>";
   echo "<td align=\"center\" width=180> $time </td>";
   echo "<td align=\"center\" width=100> $item </td>";
   echo "<td align=\"center\" width=90> $chr </td>";
   echo "<td align=\"center\" width=100> $start </td>";
   echo "<td align=\"center\" width=100> $end </td>";
   echo "<td align=\"center\" width=60> $alt </td>";
   echo "<td align=\"center\" width=60> $ref </td>";

   echo "</tr>";



   }

}

mysqli_close($mysqli4);

echo "</table>";
echo "</center>";

echo "<br>";
echo "<br>";
echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";

?>


