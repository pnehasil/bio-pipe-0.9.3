<?php

include "./dat.php";


$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");


$fbam="http://".$_SERVER['HTTP_HOST']."/web/runy/".$database."/bam/".$pac.".bam";
$ibam="http://".$_SERVER['HTTP_HOST']."/web/runy/".$database."/bam/".$pac.".bai";


echo "<!DOCTYPE html>";
echo "<html lang=\"en\">";
echo "<head>";
echo "<meta charset=\"utf-8\">";
echo "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">";
echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\">";
echo "<meta name=\"description\" content=\"\">";
echo "<meta name=\"author\" content=\"\">";
echo "<link rel=\"shortcut icon\" href=\"https://igv.org/web/img/favicon.ico\">";
echo "<title>igv.js</title>";

echo "<!-- IGV JS-->";
echo "<script src=\"./igv/igv.js\"></script>";

echo "</head>";

echo "<body>";

$xloc=$chr.":".$start;

echo "<br>";

echo "<center>";
echo "<table border=3>";
echo "<tr height=30><td> <b>Patient:</b> </td><td> $pac $database </td>";
echo "<td> <b>Loc:</b> </td><td> $xloc </td></tr>";
echo "<tr height=30><td> <b>Bam file:</b> </td><td> $fbam </td>";
echo "<td> <b>Idx file:</b> </td><td> $ibam </td></tr>";
echo "</table>";
echo "</center>";

echo "<br>";
echo "<br>";

echo "<div id=\"igv-div\" style=\"padding-top: 10px;padding-bottom: 10px; border:1px solid lightgray\"></div>";

echo "<script type=\"text/javascript\">";

echo "    document.addEventListener(\"DOMContentLoaded\", function () {";

echo "        var options =";
echo "        {";
echo "            genome: \"hg19\",";
echo "            locus: \"$xloc\",";
echo "            tracks: [";
echo "                {";
echo "                    type: 'alignment',";
echo "                    format: 'bam',";
echo "                    url: \"$fbam\",";
echo "                    indexURL: \"$ibam\",";
echo "                    name: \"$pac\"";
echo "                }";
echo "            ]";
echo "        };";

echo "        var igvDiv = document.getElementById(\"igv-div\");";

echo "        igv.createBrowser(igvDiv, options)";
echo "                .then(function (browser) {";
echo "                    console.log(\"Created IGV browser\");";
echo "                })";

echo "    });";

echo "</script>";

echo "<br>";
echo "<br>";

echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";

echo "</body>";
echo "</html>";


?>


