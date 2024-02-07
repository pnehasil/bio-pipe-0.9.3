<?php

include "./kkk.php";
include "./lll.php";
include "./at.php";

include "./dat.php";

$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");


echo "<script>";
echo "window.resizeTo(1100,800)";
echo "</script>";


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


       $mysqli2 = new mysqli($server_name,$user,$pass,$rdatabase);
       if ($mysqli2->connect_errno) {
           echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
       }
       $mysqli2->set_charset("utf8");

    $res2=$mysqli2->query("SELECT * FROM nase_var where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

        $cnt2 = $res2->num_rows;

     if ($cnt2 == 1) {
        $row2 = $res2->fetch_assoc();
        $poz1 = $row2['poz1'] ;
        $poz2 = $row2['poz2'] ;
        $dia = $row2['dia'] ;
        $class = $row2['class'] ;


        echo "<form method=\"POST\" action=\"vupd.php\">";
        echo "<br>";

        echo "<input type=\"hidden\" name=\"chr\" value=\"$chr\">";
        echo "<input type=\"hidden\" name=\"start\" value=\"$start\">";
        echo "<input type=\"hidden\" name=\"end\" value=\"$end\">";
        echo "<input type=\"hidden\" name=\"ref\" value=\"$ref\">";
        echo "<input type=\"hidden\" name=\"alt\" value=\"$alt\">";


        echo "<b>Class:</b> ";
        echo "<select name=\"class\" size=\"1\"> ";
        echo "<option value=\"-1\">Nevim ";

        if($class == 1) { echo "<option value=\"1\" selected>1 ";}
        else { echo "<option value=\"1\">1 ";}

        if($class == 2) { echo "<option value=\"2\" selected>2 ";}
        else { echo "<option value=\"2\">2 ";}

        if($class == 3) { echo "<option value=\"3\" selected>3 ";}
        else { echo "<option value=\"3\">3 ";}

        if($class == 4) { echo "<option value=\"4\" selected>4 ";}
        else { echo "<option value=\"4\">4 ";}

        if($class == 5) { echo "<option value=\"5\" selected>5 ";}
        else { echo "<option value=\"5\">5 ";}

        if($class == 6) { echo "<option value=\"6\" selected>risk_allele ";}
        else { echo "<option value=\"6\">risk_allele ";}

        if($class == 7) { echo "<option value=\"7\" selected>drug_response ";}
        else { echo "<option value=\"7\">drug_response ";}

        if($class == 8) { echo "<option value=\"8\" selected>seq_error ";}
        else { echo "<option value=\"8\">seq_error ";}


        echo "</select> ";
        echo "<br>";
        echo "<br>";


        echo "<b>Poz1:</b> <br>";
        echo "<textarea rows=\"2\" cols=\"140\" name=\"poz1\">";
        echo $poz1;
        echo "</textarea>";
        echo "<br>";
        echo "<br>";
        echo "<b>Poz2:</b> <br>";
        echo "<textarea rows=\"2\" cols=\"140\" name=\"poz2\">";
        echo $poz2;
        echo "</textarea>";
        echo "<br>";
        echo "<br>";

        echo "<b>Do zpravy:</b><br> ";
        echo "<textarea rows=\"20\" cols=\"140\" name=\"dia\">";
        echo $dia;
        echo "</textarea>";
        echo "<br>";

        echo "<br><br>";
        echo "    <input type=\"submit\" value=\"Ulozit\">";
        echo "</form>";



       }   
     elseif ($cnt2 == 0) {
       echo "Nic se nenaslo, tentokrat je to chybicka...<br>";
       echo "<br>";
       echo "Text nize prosim poslat na petr.nehas@gmail.com<br><br>";
       echo "Vicero zaznamu v tabulce nase_var:<br>";
       echo "Chr>>$xchrom<br>";
       echo "Start>>$xstart<br>";
       echo "End>>$xend<br>";
       echo "Ref>>$xref<br>";
       echo "Alt>>$xalt<br>";
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

?>





