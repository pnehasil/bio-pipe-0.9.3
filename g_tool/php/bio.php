<?php

include "./dat.php";


$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$pac = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");


$fbam="http://".$_SERVER['HTTP_HOST']."/web/".$database."/bam/".$pac.".bam";
$ibam="http://".$_SERVER['HTTP_HOST']."/web/".$database."/bam/".$pac.".bai";


echo "<!DOCTYPE html>";
echo "<html lang=\"en\">";
echo "<head>";
echo "<meta charset=\"utf-8\">";
echo "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">";
echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\">";
echo "<meta name=\"description\" content=\"\">";
echo "<meta name=\"author\" content=\"\">";
echo "<title>Biodalliance</title>";

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

echo "<script language=\"javascript\" src=\"./igv/dalliance-compiled.js\"></script>";
echo "<script language=\"javascript\">";
echo "  new Browser({";
echo "    chr:          '$chr',";
echo "    viewStart:    $start,";
echo "    viewEnd:      $start,";

echo "    coordSystem: {";
echo "      speciesName: '$pac',";
echo "      taxon: 9606,";
//echo "      auth: 'GRCh',";
echo "      auth: ' ',";
//echo "      version: '37',";
//echo "      ucscName: 'hg19'";
echo "    },";

echo "    sources:     [{name:                 '$pac',";
echo "                   desc:                 '$pac',";
echo "                   bamURI:               '$fbam'}],";


echo "  });";
echo "</script>";

echo "<div id=\"svgHolder\"></div>";

echo "<br>";
echo "<br>";

echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";

echo "</body>";
echo "</html>";


?>


