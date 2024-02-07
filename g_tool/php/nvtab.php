<?php header('Content-type: text/html; charset=utf-8');

include "./lll.php";
include "./kkk.php";
include "./dat.php";

echo "<br>";

$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");
$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");

echo "<br>";

$mysqli1 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}
$mysqli1->set_charset("utf8");
$res=$mysqli1->query("SELECT * FROM nase_var where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

$cnt1 = $res->num_rows;
mysqli_close($mysqli1);

if($cnt1 == 1)
  {
    $row1 = $res->fetch_assoc();

    $xpoz1 = $row1['poz1'] ;
    $xpoz2 = $row1['poz2'] ;
    $xclass = $row1['class'] ;
    $xuser = $row1['user'] ;

  }
else {
  // musi byt prave jeden zaznam - nesmi byt vice variant s totoznym chr,start,end,ref,alt

   echo "Nejaka divna chyba. ";
   echo "Text nize prosim poslat na petr.nehas@gmail.com<br><br>";
   echo "Vicero zaznamu v tabulce nasich variant:<br>";
   echo "Chr>>$chr<br>";
   echo "Start>>$start<br>";
   echo "End>>$end<br>";
   echo "Ref>>$ref<br>";
   echo "Alt>>$alt<br>";
   echo "<br>";

   echo "<br>";
   echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";
   echo "<br><br>";

}



echo "<b> Data z \"nasich variant\" </b>";

echo "<br>";
echo "<br>";

echo "<table border=2>";
echo "<tr><td width=90> <b>Class: </b> </td><td width=600> $xclass </td>";
echo "</tr>";
echo "<tr><td> <b>Poz.1: </b> </td><td> $xpoz1 </td>";
echo "</tr>";
echo "<tr><td> <b>Poz.2: </b> </td><td> $xpoz2 </td>";
echo "</tr>";
echo "<tr><td> <b>Vlozil: </b> </td><td> $xuser </td>";
echo "</tr>";

echo "</table>";

echo "<br>";
echo "<br>";
echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";
echo "<br>";
echo "<br>";

?>


