<?php

include "./kkk.php";
include "./dat.php";

include "./at.php";

$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");

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

echo "<br>";

echo "<table border=5><tr>";
echo "<td> <b>Nase databaze variant</b> </td><td width=60> </td>";
echo "<td> <b>Chr:</b> $chr </td><td width=30> </td>";
echo "<td> <b>Start:</b> $start </td><td width=30> </td>";
echo "<td> <b>End:</b> $end </td><td width=30> </td>";
echo "<td> <b>Ref:</b> $ref </td><td width=30> </td>";
echo "<td> <b>Alt:</b> $alt </td>";
echo "</tr></table>";
echo "<br>";


echo "<form method=\"POST\" action=\"vins.php\">";
echo "<br>";

echo "<input type=\"hidden\" name=\"chr\" value=\"$chr\">";
echo "<input type=\"hidden\" name=\"start\" value=\"$start\">";
echo "<input type=\"hidden\" name=\"end\" value=\"$end\">";
echo "<input type=\"hidden\" name=\"ref\" value=\"$ref\">";
echo "<input type=\"hidden\" name=\"alt\" value=\"$alt\">";



//echo "<td> Class: <input type=\"text\" name=\"class\" value=\"\" lenght=\"1\"></td>";

echo "<b>Class:</b> ";
echo "<select name=\"class\" size=\"1\"> ";
echo "<option value=\"-1\">Nevim ";
echo "<option value=\"1\" selected>1 ";
echo "<option value=\"2\">2 ";
echo "<option value=\"3\">3 ";
echo "<option value=\"4\">4 ";
echo "<option value=\"5\">5 ";
echo "<option value=\"6\">risk_allele ";
echo "<option value=\"7\">drug_response ";
echo "<option value=\"8\">seq_error ";
echo "</select> ";
echo "<br>";
echo "<br>";

echo "<b>Poz1:</b> <br>";
echo "<textarea rows=\"2\" cols=\"140\" name=\"poz1\">";
echo "</textarea>";
echo "<br>";
echo "<br>";
echo "<b>Poz2:</b> <br>";
echo "<textarea rows=\"2\" cols=\"140\" name=\"poz2\">";
echo "</textarea>";
echo "<br>";
echo "<br>";

echo "<b>Do zpravy:</b><br> ";
echo "<textarea rows=\"20\" cols=\"140\" name=\"dia\">";
echo "</textarea>";
echo "<br>";
echo "<br>";

echo "    <input type=\"submit\" value=\"Ulozit\">";
echo "</form>";

echo "<script>";
echo "window.resizeTo(1200,850)";
echo "</script>";


?>
