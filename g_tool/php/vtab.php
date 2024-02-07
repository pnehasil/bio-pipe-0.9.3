<?php

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

$ppac = str_replace('_pin', '', $pac);

echo "<br>";

$mysqli1 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}
$res=$mysqli1->query("SELECT * FROM var_cze03 where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

$cnt1 = $res->num_rows;
mysqli_close($mysqli1);

if($cnt1 == 0)
 {
   // v CZECANCE se nic nenaslo, tak naplnime promenne defaultni hodnotou "None"

    $xtranscript = "None";
    $xcds_change = "None";
    $xaa_change = "None";
    $ximpact = "None";
    $ximpact_severity = "None";
    $xmale = "None";
    $xfemale = "None";

 }
elseif($cnt1 == 1)
  {
    $row1 = $res->fetch_assoc();

    $xgen = $row1['gene'] ;
    $xchrom = $row1['chrom'] ;
    $xstart = $row1['start'] ;
    $xend = $row1['end'] ;
    $xref = $row1['ref'] ;
    $xalt = $row1['alt'] ;
    $xtranscript = $row1['transcript'] ;
    $xcds_change = $row1['cds_change'] ;
    $xaa_change = $row1['aa_change'] ;
    $ximpact = $row1['impact'] ;
    $ximpact_severity = $row1['impact_severity'] ;
    $xmale = $row1['male'] ;
    $xfemale = $row1['female'] ;

   $gtablnk = "https://www.uniprot.org/uniprot/?query=gene:" . $xgen . "+AND+organism:9606&sort=score";
   $ttablnk = "https://www.ncbi.nlm.nih.gov/nuccore/" . $xtranscript;

   $pos = strpos($xaa_change,'c.');
   $ctablnk = "https://www.ncbi.nlm.nih.gov/clinvar/?term=" . $xcds_change;

  }
else {
  // musi byt prave jeden zaznam - nesmi byt vice variant s totoznym chr,start,end,ref,alt

   echo "Nejaka divna chyba. ";
   echo "Text nize prosim poslat na petr.nehas@gmail.com<br><br>";
   echo "Vicero zaznamu v tabulce variant:<br>";
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

// tim mame vyresena data z CZECANCy a podivame se na tabulku "nasich variant"

$mysqli3 = new mysqli($server_name,$user,$pass,$rdatabase);
if ($mysqli3->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
}
$mysqli3->set_charset("utf8");

$res3=$mysqli3->query("SELECT * FROM nase_var where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

$cnt3 = $res3->num_rows;


//echo "cnt3>>$cnt3<<";
//echo "<br>";

mysqli_close($mysqli3);

if ($cnt3 > 1) {
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
  exit;
}
elseif ($cnt3 == 1) {
   $row3 = $res3->fetch_assoc();
   $poz1 = $row3['poz1'] ;
   $poz2 = $row3['poz2'] ;
   $dia = $row3['dia'] ;
   $class = $row3['class'] ;
  }
else {
   $poz1 = "None" ;
   $poz2 = "None" ;
   $dia = "None" ;
   $class = "None" ;
  }

// tim mame naplneny promenne pro prvni cast a muzeme ji vyplivnout na screen

echo "<table border=0>";
echo "<tr>";
echo "<td align=\"center\"><b> Data z CZECANCy </b> </td>";
echo "<td> </td>";
echo "<td align=\"center\"><b> Data z \"nasich variant\" </b> </td>";
echo "</tr>";

echo "<tr height=30><td> </td><td width=\"30\"> </td><td> </td></tr>";

echo "<tr><td>";

echo "<table border=2>";
echo "<tr><td> <b>Gene.refGene: &nbsp; &nbsp; &nbsp;</b> </td><td> <a href=\"$gtablnk\" target=\"_blank\">$xgen</a> </td>";
echo "<td width=20> </td><td> <b>Impact</b> </td><td> $ximpact </td></tr>";
echo "</tr>";
echo "<tr><td> <b>Nase TV:</b> </td><td> <a href=\"$ttablnk\" target=\"_blank\">$xtranscript</a> </td>";
echo "<td> </td><td> <b> Impact severity </td><td> $ximpact_severity </td>";
echo "</tr>";
echo "<tr><td> <b>Kodujici:</b> </td><td> <a href=\"$ctablnk\" target=\"_blank\">$xcds_change</a> </td>";
echo "<td> </td><td> <b> Male </td><td> $xmale </td>";
echo "</tr>";
echo "<tr><td> <b>Protein:</b> </td><td> $xaa_change </td>";
echo "<td> </td><td> <b> Female </td><td> $xfemale </td>";
echo "</tr>";
echo "</table>";
 
echo "</td><td> </td><td>";

$zl = strlen($dia); 
if($zl > 120) { $zdia = substr($dia,0,120); $zdia = $zdia . "...";}
else { $zdia = $dia;}

$zl = strlen($poz1); 
if($zl > 120) { $zpoz1 = substr($poz1,0,120); $zpoz1 = $zpoz1 . "...";}
else { $zpoz1 =  $poz1;}
    
$zl = strlen($poz2); 
if($zl > 120) { $zpoz2 = substr($poz2,0,120); $zpoz2 = $zpoz2 . "...";}
else { $zpoz2 =  $poz2;}

echo "<table border=2>";
echo "<tr><td> <b>Class: </b> </td><td> $class </td>";
echo "</tr>";
echo "<tr><td> <b>Poz.1: </b> </td><td> $zpoz1 </td>";
echo "</tr>";
echo "<tr><td> <b>Poz.2: </b> </td><td> $zpoz2 </td>";
echo "</tr>";
echo "<tr><td> <b><a href=\"detdiag.php\" onclick=\"window.open('detdiag.php?chr=$chr&start=$start&end=$end&alt=$alt&ref=$ref','newwindow','width=1024,height=600,location,resizable'); return false;\">Do zpravy:</a></b> </td><td> $zdia </td>";

echo "</tr>";
echo "</table>";

echo "</td></tr>";
echo "</table>";

echo "<br>";
echo "<br>";

echo "<a href=\"./igv.php?chr=$xchrom&start=$xstart&pac=$ppac&run=$database\" target=\"blank\"><b>IGV</b></a> pro $database $pac $chr $start";

echo " &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ";
echo " &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ";
echo " &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ";

if ( $cnt3 == 0 ) { // nemame data v nasich variantach, dame moznost zalozit novou
     echo "Varianta není v naší databázi. <a href=\"./vnova.php?pac=$ppac&chr=$chr&start=$start&end=$end&ref=$ref&alt=$alt\" onclick=\"window.open('vnova.php?chr=$chr&start=$start&end=$end&alt=$alt&ref=$ref','newwindow','width=1100,height=800'); return false;\"><b>Vložit?</b></a>";
}
else {
     echo "Variantu mame v naší databázi. <a href=\"./updiag.php?pac=$ppac&chr=$chr&start=$start&end=$end&ref=$ref&alt=$alt\" onclick=\"window.open('updiag.php?chr=$chr&start=$start&end=$end&alt=$alt&ref=$ref','newwindow','width=1100,height=800'); return false;\"><b>Upravit?</b></a>";

}

echo "<br><a href=\"./bio.php?chr=$xchrom&start=$xstart&pac=$ppac&run=$database\" target=\"blank\"><b>Biodalliance</b></a> pro $database $pac $chr $start";

echo "<br>";
echo "<br>";
echo "<b><a href=\"pos_upr.php\" onclick=\"window.open('pos_upr.php?chr=$chr&start=$start&end=$end&alt=$alt&ref=$ref','newwindow','width=600,height=800,location,resizable'); return false;\"><b>Poslední úpravy</b></a>";

echo " &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;";
echo "<b><a href=\"ins_konfirmace.php\" onclick=\"window.open('ins_konfirmace.php?pac=$pac&chr=$chr&start=$start&end=$end&alt=$alt&ref=$ref','newwindow','width=600,height=800,location,resizable'); return false;\"><b>Konfirmovat?</b></a>";


//$mysqli4 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
//if ($mysqli4->connect_errno) {
//    echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
//}
//$mysqli4->set_charset("utf8");
//
//$res4=$mysqli4->query("SELECT * FROM ch_dia where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\" ORDER by time DESC;");
//
//$cnt4 = $res4->num_rows;
//
//
//echo "cnt4>>$cnt4<<";
//echo "<br>";
//if($cnt4 > 0) {
//
//   echo "<b>Posledni upravy:</b>";
//
//   while($row4 = $res4->fetch_assoc())  {
//   $time = $row4['time'] ;
//   $zuser = $row4['user'] ;
//   $item = $row4['item'] ;
//
//   echo "$zuser $time $item <br>";
//
//   }
//
//}
//
//   mysqli_close($mysqli4);


echo "<br>";
echo "<br>";
echo "<br>";
echo "<hr>";
echo "<br>";
echo "<br>";

echo "<center><b> Data z gemini - pacientska data </b></center>";
echo "<br>";
echo "<br>";

// select do dat natazenych z gemni
$mysqli2 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli2->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
}

$res2=$mysqli2->query("SELECT * FROM $pac where chrom=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\" ;");
$cnt2 = $res2->num_rows;
$row2 = $res2->fetch_assoc();

mysqli_close($mysqli2);

// a vyblijeme ven

include "detgemini.php";

echo "<br>";
echo "<br>";
echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";

?>


