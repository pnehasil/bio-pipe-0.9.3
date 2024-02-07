<?php

include "./kkk.php";
include "./lll.php";

include "./dat.php";

$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");


echo "<br>";
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

//echo "Diagnoza<br>";

       $mysqli2 = new mysqli($server_name,$user,$pass,$rdatabase);
       if ($mysqli2->connect_errno) {
           echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
       }
       $mysqli2->set_charset("utf8");

    $res2=$mysqli2->query("SELECT * FROM nase_var where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

        $cnt2 = $res2->num_rows;
//echo "cnt2>>$cnt2<<";
//echo "<br>";

     if ($cnt2 == 1) {
        $row2 = $res2->fetch_assoc();
        $poz1 = $row2['poz1'] ;
        $poz2 = $row2['poz2'] ;
        $dia = $row2['dia'] ;

        echo "<b> Pozn. 1:</b><br>";
        echo "$poz1<br><br>";

        echo "<b> Pozn. 2:</b><br>";
        echo "$poz2<br><br>";

        echo "<b>Do zpravy:</b><br>";
        echo "$dia<br><br>";
       }   
     elseif ($cnt2 == 0) {
        echo "Nic se nenaslo<br>";
        echo "<br>";
     }
     else {
       // musi byt prave jeden zaznam - nesmi byt vice variant s totoznym chr,start,end,ref,alt

       echo "Nejaka divna chyba. ";
       echo "Text nize prosim poslat na petr.nehas@gmail.com<br><br>";
       echo "Vicero zaznamu v tabulce nase_var:<br>";
       echo "Chr>>$xchrom<br>";
       echo "Start>>$xstart<br>";
       echo "End>>$xend<br>";
       echo "Ref>>$xref<br>";
       echo "Alt>>$xalt<br>";
       echo "<br>";
    }

mysqli_close($mysqli2);

echo "<br>";
echo "<table><tr>";
echo "<td>";
echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";
echo "</td>";

echo "<td width=240> ";
echo "</td>";

echo "<td>";
echo "<button type=\"button\" onclick=\"window.open('updiag.php?chr=$chr&start=$start&end=$end&ref=$ref&alt=$alt','newwindow'); return false;\">Upravit</button>";
echo "</td>";
echo "</tr></table>";
echo "<br><br>";


?>





