<?php

include "./kkk.php";
include "./dat.php";

include "./at.php";

$muze=0;

if( $xuser == 'petra') { $muze=1; }
if( $xuser == 'makca') { $muze=1; }
if( $xuser == 'janicka') { $muze=1; }

if( $muze == 0 ) {
  echo "<script>";
  echo "window.resizeTo(300,200)";
  echo "</script>";

  echo "<center><br>Konfirmovat muze jen VIP osoba <br><br>";
  echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit</button>";
  echo "</center>";
  exit;
}


$mysqli3 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli3->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
}
$mysqli3->set_charset("utf8");

$res3=$mysqli3->query("SELECT * FROM nase_var where user <> 'petra' AND user <> 'makca' AND user <> 'janicka' ;");

echo "<br>";
echo "<b><center>Dosud nekonfirmované varianty:</b></center>";
echo "<br>";
echo "<br>";
echo "<br>";

while($row3 = $res3->fetch_assoc())  {

    $xchr = $row3['chrom'] ;
    $xstart = $row3['start'] ;
    $xend = $row3['end'] ;
    $xalt = $row3['alt'] ;
    $xref = $row3['ref'] ;
    $xclass = $row1['class'] ;
    $xpoz1 = $row3['poz1'] ;
    $xpoz2 = $row3['poz2'] ;
    $xdia = $row3['dia'] ;
    $zuser = $row3['user'] ;

    echo "<table><tr>";
    echo "<td><b> Chrom:</b> $xchr </td>";
    echo "<td width=20> </td>";
    echo "<td><b> Start:</b> $xstart </td>";
    echo "<td width=20> </td>";
    echo "<td><b> End:</b> $xend </td>";
    echo "<td width=20> </td>";
    echo "<td><b> Alt:</b> $xalt </td>";
    echo "<td width=20> </td>";
    echo "<td><b> Ref:</b> $xref </td>";
    echo "<td width=20> </td>";
    echo "<td><b> Class:</b> $xclass </td>";
    echo "<td width=20> </td>";
    echo "<td><b> Naposled upravila:</b> $zuser </td>";
    echo "</tr></table>";

    echo "<br>";

    echo "<table>";
    echo "<tr><td><b> Poz1:</b><br> $xpoz1 </td></tr>";
    echo "<tr><td height=20> </td></tr>";
    echo "<tr><td><b> Poz2:</b><br> $xpoz2 </td></tr>";
    echo "</tr></table>";

    echo "<br>";

    echo "<table><tr>";
    echo "<td><b> Do zpravy:</b><br>$xdia</td></tr>";
    
    echo "<tr><td height=20> </td></tr>";

    echo "<tr><td><button type=\"button\" onclick=\"window.open('vkonfupd.php?chr=$xchr&start=$xstart&end=$xend&ref=$xref&alt=$xalt','newwindow'); return false;\">Konfirmovat</button></td>";

    echo "</tr></table>";
  
    echo "<br><br><hr>";


}

//echo "<td> <b>Chr:</b> $chr </td><td width=30> </td>";
//echo "<td> <b>Start:</b> $start </td><td width=30> </td>";
//echo "<td> <b>End:</b> $end </td><td width=30> </td>";
//echo "<td> <b>Ref:</b> $ref </td><td width=30> </td>";
//echo "<td> <b>Alt:</b> $alt </td>";
//echo "</tr></table>";


//echo "<form method=\"POST\" action=\"vins.php\">";
//echo "<br>";

//echo "<input type=\"hidden\" name=\"chr\" value=\"$chr\">";
//echo "<input type=\"hidden\" name=\"start\" value=\"$start\">";
//echo "<input type=\"hidden\" name=\"end\" value=\"$end\">";
//echo "<input type=\"hidden\" name=\"ref\" value=\"$ref\">";
//echo "<input type=\"hidden\" name=\"alt\" value=\"$alt\">";


mysqli_close($mysqli3);

?>
