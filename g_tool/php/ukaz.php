<?php
$then = time();

include "./kkk.php";
include "./dat.php";
include "./lll.php";

echo "<br>";

$first = htmlspecialchars($_GET['first'], ENT_QUOTES, "UTF-8");
$PAC = htmlspecialchars($_GET['pac'], ENT_QUOTES, "UTF-8");


if($first == 1) {
  $qual = "on";
  $depth = "on";
  $maxaafall = "on";
  $vik9carrier = "on";
  $Class = "on";
  $impactso = "on";
}
else {
  $qual = htmlspecialchars($_GET['qual'], ENT_QUOTES, "UTF-8");
  $depth = htmlspecialchars($_GET['depth'], ENT_QUOTES, "UTF-8");
  $maxaafall = htmlspecialchars($_GET['maxaafall'], ENT_QUOTES, "UTF-8");
  $vik9carrier = htmlspecialchars($_GET['vik9carrier'], ENT_QUOTES, "UTF-8");
  $Class = htmlspecialchars($_GET['Class'], ENT_QUOTES, "UTF-8");
  $impactso = htmlspecialchars($_GET['impactso'], ENT_QUOTES, "UTF-8");
}

if(($qual == "on") and ($depth = "on") and ($maxaafall == "on") and ($vik9carrier == "on") and ($Class == "on") and ($impactso == "on")) {
header("HTTP/1.1 301 Moved Permanently");
header("Location:./ukaz_first.php?pac=$PAC");
header("Connection: close");
}

echo "<br>";
echo "<center><b> $PAC &nbsp; &nbsp; $database  </b></center>";
echo "<br>";
echo "<br>";

//echo "<form action=\"ukaz.php\" target=\"_blank\">";
echo "<form action=\"ukaz.php\">";
echo "<table cellpadding=10 border=0><tr>";
echo "<td>";
if($qual == "on") { echo "    qual>150 <input type=\"checkbox\" name=\"qual\" checked=\"checked\">"; }
else { echo "    qual>150 <input type=\"checkbox\" name=\"qual\" >"; }
echo "</td>";

echo "<td>";
if($depth == "on") { echo "    depth>10 <input type=\"checkbox\" name=\"depth\" checked=\"checked\">";}
else { echo "    depth>10 <input type=\"checkbox\" name=\"depth\" >";}
echo "</td>";

echo "<td>";
if($maxaafall == "on") { echo "    max_aaf_all<0.005 <input type=\"checkbox\" name=\"maxaafall\" checked=\"checked\">";}
else { echo "    max_aaf_all<0.005 <input type=\"checkbox\" name=\"maxaafall\" >";}
echo "</td>";

echo "<td>";
if($vik9carrier == "on") { echo "    NCMG_9carrier<8 <input type=\"checkbox\" name=\"vik9carrier\" checked=\"checked\">";}
else { echo "    NCMG_9carrier<8 <input type=\"checkbox\" name=\"vik9carrier\" >";}
echo "</td>";

echo "<td>";
if($Class == "on") { echo "    Class>2 <input type=\"checkbox\" name=\"Class\" checked=\"checked\">";}
else { echo "    Class>2 <input type=\"checkbox\" name=\"Class\" >";}
echo "</td>";

echo "<td>";
if($impactso == "on") { echo "    impact_so <input type=\"checkbox\" name=\"impactso\" checked=\"checked\">";}
else { echo "    impact_so <input type=\"checkbox\" name=\"impactso\" >";}
echo "</td>";


echo "<td>";
echo "    <input type=\"submit\" value=\"Filtrovat\">";
echo "    <input type=\"hidden\" name=\"pac\" value=\"$PAC\">";
echo "<td>";
echo "</tr>";
echo "</form>";
echo "</table>";

echo "<a href=\"filtrace.html\" onclick=\"window.open('filtrace.html','newwindow','width=650,height=600'); return false;\">Popiska filtrace</a>";


echo "<br>";
echo "<br>";


$mysqli1 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}

$mysqli2 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
if ($mysqli2->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
}
$mysqli2->set_charset("utf8");

//echo $mysqli1->host_info . "\n";

$mysqli1->real_query("SELECT * FROM $PAC ORDER BY `group`,priority");
$res1 = $mysqli1->use_result();

echo "<form action=\"vdiag.php\">";

echo "<table border=2>";
echo "<tr bgcolor=e0e0e0>";
echo "<td> Do zp. </td><td> group </td>";
echo "<td> gene </td><td> codon_change </td><td> aa_change </td><td> exon </td><td> qual </td>";    
echo "<td> depth </td><td> impact_so </td><td> vzd. </td><td> clinvar_sig </td><td> clinvar_rev </td>";
echo "<td> in-house class </td><td> CZE_cons </td>";
echo "<td> WT </td><td> ALT </td><td> %VAF </td><td> RNA </td>";
echo "<td> transcript </td><td> chrom </td><td> start </td><td> end </td><td> ref </td><td> alt </td>";     
echo "<td> Mobi </td>";
echo "<td> max_aaf_all </td><td> aaf_esp_ea </td>";      
echo "<td> PTS_carriers </td><td> superCTRLs<br> 791 </td>";      
echo "<td> NCMG_9carrier<br> 1662 </td><td> NCMG_unknown </td>";
echo "<td> aaf_esp_all </td><td> aaf_1kg_eur </td><td> aaf_1kg_all </td>";     
echo "<td> gms_illumina </td><td> gms_solid </td><td> gms_iontorrent </td><td> cosmic_ids </td>";      
echo "<td> cadd_raw </td><td> cadd_scaled </td>";
echo "<td> polyphen_pred </td><td> polyphen_score </td><td> sift_pred </td><td> sift_score </td>";
echo "<td> aaf_gnomad_all </td><td> aaf_gnomad_nfe </td><td> aaf_gnomad_non_cancer </td>";
echo "<td> gnomad_popmax_AF </td><td> gnomad_num_het </td><td> gnomad_num_hom_alt </td>";
echo "<td> gnomad_num_chroms </td>";
echo "<td> aaf_exac_all </td><td> aaf_adj_exac_all </td>";        
echo "<td> aaf_adj_exac_nfe </td><td> exac_num_het </td><td> exac_num_hom_alt </td><td> aa_length </td>";       
echo "<td> num_reads_w_dels </td><td> allele_count </td><td> allele_bal </td><td> rs_ids </td>";  
echo "<td> in_omim </td><td> clinvar_disease_name </td><td> rmsk </td><td> unseq nt </td>";
echo "</tr>";

$cnt=0;
while ($row1 = $res1->fetch_assoc()) {

   $zobraz=1;

   $xid = $row1['id'] ;
   $xgene = $row1['gene'] ;

   $xcodon_change = $row1['codon_change'] ;
   $xaa_change = $row1['aa_change'] ;
   $xexon = $row1['exon'] ;
   $xqual = $row1['qual'] ;
   $xdepth = $row1['depth'] ;
   $xnum_alleles = $row1['num_alleles'] ;
   $xclinvar_sig = $row1['clinvar_sig'] ; 
   $xclinvar_rev = $row1['clinvar_rev'] ; 
   $x01_UBEO_Class = $row1['x01_UBEO_Class'] ;
   $xCzecanca_kons = $row1['Czecanca_kons'] ;
   $xmax_aaf_all = $row1['max_aaf_all'] ;
   $xaaf_esp_ea = $row1['aaf_esp_ea'] ;
   $ximpact_so = $row1['impact_so'] ;
   $xVIK_9carrier = $row1['VIK_9carrier'] ;
   $xVIK_unknown = $row1['VIK_unknown'] ;
   $xaaf_esp_all = $row1['aaf_esp_all'] ;
   $xaaf_1kg_eur = $row1['aaf_1kg_eur'] ;
   $xaaf_1kg_all = $row1['aaf_1kg_all'] ;
   $xgms_illumina = $row1['gms_illumina'] ;
   $xgms_solid = $row1['gms_solid'] ;
   $xgms_iontorrent = $row1['gms_iontorrent'] ;
   $xcosmic_ids = $row1['cosmic_ids'] ;
   $xcadd_raw = $row1['cadd_raw'] ;
   $xcadd_scaled = $row1['cadd_scaled'] ;
   $xaaf_exac_all = $row1['aaf_exac_all'] ;
   $xaaf_adj_exac_all = $row1['aaf_adj_exac_all'] ;
   $xaaf_adj_exac_nfe = $row1['aaf_adj_exac_nfe'] ;
   $xexac_num_het = $row1['exac_num_het'] ;
   $xexac_num_hom_alt = $row1['exac_num_hom_alt'] ;
   $xaa_length = $row1['aa_length'] ;
   $xtranscript = $row1['transcript'] ;
   $xchrom = $row1['chrom'] ;
   $xstart = $row1['start'] ;
   $xend = $row1['end'] ;
   $xref = $row1['ref'] ;
   $xalt = $row1['alt'] ;
   $xnum_reads_w_dels = $row1['num_reads_w_dels'] ;
   $xallele_count = $row1['allele_count'] ;
   $xallele_bal = $row1['allele_bal'] ;
   $xrs_ids = $row1['rs_ids'] ;
   $xin_omim = $row1['in_omim'] ;
   $xclinvar_disease_name = $row1['clinvar_disease_name'] ;
   $xrmsk = $row1['rmsk'] ;
   $xzwt = $row1['zwt'] ;
   $xzalt = $row1['zalt'] ;
   $xgunknown = $row1['gunknown'] ;
   $xgroup = $row1['group'] ;
   $xaaf_gnomad_all = $row1['aaf_gnomad_all'];
   $xaaf_gnomad_nfe = $row1['aaf_gnomad_nfe'];
   $xaaf_gnomad_non_cancer = $row1['aaf_gnomad_non_cancer'];
   $xgnomad_popmax_AF = $row1['gnomad_popmax_AF'];
   $xgnomad_num_het = $row1['gnomad_num_het'];
   $xgnomad_num_hom_alt = $row1['gnomad_num_hom_alt'];
   $xgnomad_num_chroms  = $row1['gnomad_num_chroms'];
   $xpoly_pred = $row1['poly_pred'];
   $xpoly_score = $row1['poly_score'];
   $xsift_pred = $row1['sift_pred'];
   $xsift_score = $row1['sift_score'];
   $PTSxcarriers=$row1['PTScarr'];
   $superCTRLs=$row1['superCTRLS'];
   $RNA=$row1['RNA'];


   $vaf=round(100*$xzalt/($xzalt+$xzwt));

   $pos = strpos($xaa_change,'c.');
   $t0pom = substr($xaa_change,$pos);
   $t1pom = str_replace(" ", "", $t0pom);
   $t2pom = str_replace("+", "%2b", $t1pom);
   $t3pom = str_replace("-", "%2d", $t2pom);
   //$adr = "https://www.ncbi.nlm.nih.gov/clinvar/?term=" . $t3pom . " " . $xgene;
   $adr = "https://www.ncbi.nlm.nih.gov/clinvar/?term=" . $xgene . ":" . $t3pom;

   $adr_rs = "https://www.ncbi.nlm.nih.gov/clinvar/?term=" . $xrs_ids;

   // promenna pro vypocet varianty v mobidet
   $trvar = urlencode( $xtranscript . ":" . substr($xaa_change,$pos));
   $trvar = str_replace('-','%2D',$trvar);

   if(($xqual <= 150) and ($qual == "on")) { $zobraz=0;}
   if(($xdepth <= 9) and ($depth == "on")) { $zobraz=0;}
   if(($xmax_aaf_all > 0.005) and ($maxaafall == "on"))   { $zobraz=0;}
   if(($xVIK_9carrier > 7) and ($vik9carrier == "on"))  { $zobraz=0;}
   
   // dalsi voser, chceme zobrazit jen nektere, takze kdyz neni radek k zobrazeni, sereme nato
   // ale kdyz je k zobrazeni a mame filtrovat dle impact_so, tak povolime jen vybrane
   if(($impactso == "on") and ($zobraz == 1)) {
     $zobraz=0;
     
     if($ximpact_so == "missense_variant")  { $zobraz=1;}
     if($ximpact_so == "frameshift_variant")  { $zobraz=1;}
     if($ximpact_so == "splice_acceptor_variant")  { $zobraz=1;}
     if($ximpact_so == "splice_donor_variant")  { $zobraz=1;}
     if($ximpact_so == "start_lost")  { $zobraz=1;}
     if($ximpact_so == "stop_gained")  { $zobraz=1;}
     if($ximpact_so == "stop_lost")  { $zobraz=1;}
     if($ximpact_so == "initiator_codon_variant")  { $zobraz=1;}
     if($ximpact_so == "rare_amino_acid_variant")  { $zobraz=1;}
     if($ximpact_so == "chromosomal_deletion")  { $zobraz=1;}
     if($ximpact_so == "inframe_insertion")  { $zobraz=1;}
     if($ximpact_so == "inframe_deletion")  { $zobraz=1;}
     if($ximpact_so == "disruptive_inframe_insertion")  { $zobraz=1;}
     if($ximpact_so == "disruptive_inframe_deletion")  { $zobraz=1;}
     if($ximpact_so == "disruptive_inframe_duplication")  { $zobraz=1;}
   }

   // jakoz vzdy zobrazime +-X od konce exonu
//   if ($zobraz == 0) { 
//      $posun=0;
//      $delka = strlen($xaa_change);
//      //echo "Delka>>$delka\n";
//
//      if($delka > 4) {
//        $pole=explode(".",$xaa_change);
//        if($pole[0] == "c") {
//          $ret1 = $pole[1];
//          for ($i=0; $i < $delka; $i++)
//          {
//            $pos = substr($pole[1],$i,1);
//            //echo "pos>>$pos\n";
//            if(($pos == "+") OR ($pos == "-")) {
//              $pocitame = 1;
//              //echo "mame znamenko\n";
//              if((is_numeric(substr($pole[1],$i+1,1))) & (is_numeric(substr($pole[1],$i+2,1)))) {
//                //echo "Dvouciferne cislo\n";
//                $posun = 99;
//                break;
//              }
//              if((is_numeric(substr($pole[1],$i+1,1))) & (!(is_numeric(substr($pole[1],$i+2,1))))) {
//                //echo "jednociferne cislo\n";
//                $posun = substr($pole[1],$i+1,1);
//                break;
//              }
//            }
//          }
//        }
//      }
//
//     if(($posun < 6) AND ($posun > 0)) { $zobraz = 1;}
//     //echo "$posun\n";
//   }


   // zaokrouhlime pozadovane sloupce, aby nebyly prilis siroke
   $xqual = round($xqual,0);
   $xmax_aaf_all = round($xmax_aaf_all,4);
   $xaaf_esp_ea = round($xaaf_esp_ea,4);
   $xaaf_esp_all = round($xaaf_esp_all,4);
   $xaaf_1kg_eur = round($xaaf_1kg_eur,4);
   $xaaf_1kg_all = round($xaaf_1kg_all,4);
   $xaaf_exac_all = round($xaaf_exac_all,4);
   $xaaf_adj_exac_all = round($xaaf_adj_exac_all,4);
   $xaaf_adj_exac_nfe = round($xaaf_adj_exac_nfe,4);

   // upravime poradi u aa_change
   $pos = strpos($xaa_change,'c.');
   if($pos > 0) {
     $p = substr($xaa_change, $pos);
     $c = substr($xaa_change,0, $pos-1);
     $xaa_change=$p . "/" . $c;
   }

   // pripravime si link do tabulky "nasich variant"
   $vtablnk = "./vtab.php?pac=$PAC&chr=$xchrom&start=$xstart&end=$xend&ref=$xref&alt=$xalt";
   $gtablnk = "https://www.uniprot.org/uniprot/?query=gene:" . $xgene . "+AND+organism:9606&sort=score";
   $ttablnk = "https://www.ncbi.nlm.nih.gov/nuccore/" . $xtranscript;

   // zkratime aa_change a clinvar_sig
   if(((strlen($xaa_change)) > 25)) {
     $xaa_change = substr($xaa_change,0,25);
     $xaa_change = $xaa_change . "...";
   }
   if(((strlen($xclinvar_sig )) > 28)) {
     $xclinvar_sig = substr($xclinvar_sig,0,28);
     $xclinvar_sig = $xclinvar_sig . "...";
   }

   // spocteme vzdalenost od koncu a zacatku
   $res2 = $mysqli2->query("SELECT * FROM vzd_exonu where chrom='$xchrom' AND start <= $xstart AND end >= $xstart;");
   $cnt2 = $res2->num_rows;

   if($cnt2 > 1) { $vzd="m/m"; }
   elseif($cnt2 == 0) { $vzd="-/-"; }
   else {
     $row2 = $res2->fetch_assoc();

     $st = $row2['start'];
     $en = $row2['end'];
     $a = $xstart - $st + 1;
     $b = $en - $xstart;
    
     // pro zobrazeni +- X od konce/zacatku 
     if(is_numeric($a)) {
      if($a < 4) { $zobraz = 1;}
     }

     if(is_numeric($b)) {
      if($b < 4) { $zobraz = 1;}
     }

     $vzd=$a . "/". $b;
   }

   // zjistime jestli je class v tabulce "nasich variant"
   $NV="";


   $mysqli3 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
   if ($mysqli3->connect_errno) {
     echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
   }
   $mysqli3->set_charset("utf8");


   $mysqli3->real_query("SELECT * FROM nase_var where chrom=\"$xchrom\" AND start=\"$xstart\" AND end=\"$xend\" AND ref=\"$xref\" AND alt=\"$xalt\";");
   $res3 = $mysqli3->use_result();

   if ($row3 = $res3->fetch_assoc()) {
      $NV = $row3['class'] ;
   }
   else {$NV="";}

   mysqli_close($mysqli3);


   // je-li alespon v jednom poli in-house class & Czecanaca_kons 1, nebo 2
   // nechceme videt
    if(($Class == "on") and ($zobraz == 1)) {
     if(($NV <> "") and ($NV < 2)) { $zobraz=0;}
     if(($xCzecanca_kons <> "") and ($xCzecanca_kons < 3)) { $zobraz=0;} 
    }

   // a na zaver - VZDY zobrazime: 
   // - clinvar_sig obsahuje athogenic, ale nezobrazime 
   //   kdyz ma hodnotu 'conflicting_interpretations_of_pathogenicity'
   // - in-hose class > 2 
   // - CZE_cons > 2 


   // pokud bylo zobrazeno z jinych conflicting_interpretations_of_pathogenicity nebudeme resit
   if ($zobraz == 0) {
      $pos = strpos($xclinvar_sig,'athogen');
      if ($pos == true) { $zobraz = 1;}
      if (($xclinvar_sig == 'conflicting_interpretations_of_pathogenicity')) { $zobraz = 0;}
   }


   if($NV > 2) { $zobraz = 1;}
   if($xCzecanca_kons > 2) { $zobraz = 1;}

   if($NV == 6) { $NV="risk";}
   if($NV == 7) { $NV="drug";}
   if($NV == 8) { $NV="serr";}

   // vzdy zobrazit: (Janicka 31.1.2023)
   include "APC.php";

   // a konecne vysypeme tabulku na stranku

      if($zobraz == 1) {
        $cnt=$cnt+1;
        if(($cnt % 25) == 0) { 
          echo "<tr bgcolor=e0e0e0>";
          echo "<td> Do zp. </td><td> group </td>";
          echo "<td> gene </td><td> codon_change </td><td> aa_change </td><td> exon </td><td> qual </td>";    
          echo "<td> depth </td><td> impact_so </td><td> vzd. </td>" ;
          echo "<td> clinvar_sig </td><td> clinvar_rev </td><td> in-house class </td>";
          echo "<td> CZE_cons </td><td> WT </td><td> ALT </td><td> %VAF </td><td> RNA </td>";
          echo "<td> transcript </td><td> chrom </td><td> start </td><td> end </td><td> ref </td><td> alt </td>";     
          echo "<td> Mobi </td>";
          echo "<td> max_aaf_all </td><td> aaf_esp_ea </td>";      
          echo "<td> PTS_carriers </td><td> superCTRLs  </td>";      
          echo "<td> NCMG_9carrier </td><td> NCMG_unknown </td>";
          echo "<td> aaf_esp_all </td><td> aaf_1kg_eur </td><td> aaf_1kg_all </td>";     
          echo "<td> gms_illumina </td><td> gms_solid </td><td> gms_iontorrent </td><td> cosmic_ids </td>";      
          echo "<td> cadd_raw </td><td> cadd_scaled </td>";
          echo "<td> polyphen_pred </td><td> polyphen_score </td><td> sift_pred </td><td> sift_score </td>"; 	
          echo "<td> aaf_gnomad_all </td><td> aaf_gnomad_nfe </td><td> aaf_gnomad_non_cancer </td>";
          echo "<td> gnomad_popmax_AF </td><td> gnomad_num_het </td><td> gnomad_num_hom_alt </td>";
          echo "<td> gnomad_num_chroms </td>";
          echo "<td> aaf_exac_all </td><td> aaf_adj_exac_all </td>";        
          echo "<td> aaf_adj_exac_nfe </td><td> exac_num_het </td><td> exac_num_hom_alt </td><td> aa_length </td>";       
          echo "<td> num_reads_w_dels </td><td> allele_count </td><td> allele_bal </td><td><a href=\"$adr_rs\"> rs_ids </a></td>";  
          echo "<td> in_omim </td><td> clinvar_disease_name </td><td> rmsk </td><td> unseq nt </td>";
          echo "</tr>";
      }

    echo "<tr>";
    echo "<td>"; 

    $cd="dia_" . $xid;
    echo "<input type=\"checkbox\" name=\"$cd\">"; 

    echo "</td><td> $xgroup </td>";
    echo "<td> <a href=\"$gtablnk\" target=\"_blank\">$xgene</a> </td>";
    echo "<td> $xcodon_change </td>";
    echo "<td> <a href=\"$vtablnk\" target=\"_blank\">$xaa_change</a> </td><td> $xexon </td>";
    echo "<td> $xqual </td><td> $xdepth </td><td> $ximpact_so </td><td> $vzd </td>";
    echo "<td> <a href=\"$adr\" target=\"_blank\"> $xclinvar_sig </a> </td>";
    echo "<td>  $xclinvar_rev </td>";

    echo "<td><a href=\"nvtab.php\" onclick=\"window.open('nvtab.php?pac=$PAC&chr=$xchrom&start=$xstart&end=$xend&ref=$xref&alt=$xalt','newwindow','width=650,height=300'); return false;\">$NV</a></td>";

    echo "<td> $xCzecanca_kons </td>";
    echo "<td> $xzwt </td><td> $xzalt </td><td> $vaf </td><td> $RNA </td>";
    echo "<td> <a href=\"$ttablnk\" target=\"_blank\">$xtranscript</a> </td>";
    echo "<td> <a href=\"./igv.php?chr=$xchrom&start=$xstart&pac=$PAC&run=$database\">$xchrom</a> </td>";
    echo "<td> $xstart </td><td> $xend </td><td> $xref </td><td> $xalt </td>";
    echo "<td> <a href=\"tomobidet.php?trvar=$trvar\" target=\"_blank\"> $trvar </a> </td>";
    echo "<td> $xmax_aaf_all </td><td> $xaaf_esp_ea </td>";
    echo "<td> $PTSxcarriers </td><td> $superCTRLs </td>";      
    echo "<td> $xVIK_9carrier </td>";
    echo "<td> $xVIK_unknown </td><td> $xaaf_esp_all </td>";
    echo "<td> $xaaf_1kg_eur </td><td> $xaaf_1kg_all </td><td> $xgms_illumina </td><td> $xgms_solid </td>";
    echo "<td> $xgms_iontorrent </td><td> $xcosmic_ids </td><td> $xcadd_raw </td><td> $xcadd_scaled </td>";
    echo "<td> $xpoly_pred </td><td> $xpoly_score </td><td> $xsift_pred </td><td> $xsift_score </td>";
    echo "<td> $xaaf_gnomad_all </td><td> $xaaf_gnomad_nfe </td><td> $xaaf_gnomad_non_cancer </td>";
    echo "<td> $xgnomad_popmax_AF </td><td> $xgnomad_num_het </td><td> $xgnomad_num_hom_alt </td>";
    echo "<td> $xgnomad_num_chroms </td>";
    echo "<td> $xaaf_exac_all </td><td> $xaaf_adj_exac_all </td><td> $xaaf_adj_exac_nfe </td><td> $xexac_num_het </td>";
    echo "<td> $xexac_num_hom_alt </td><td> $xaa_length </td>";
    echo "<td> $xnum_reads_w_dels </td>";
    echo "<td> $xallele_count </td><td> $xallele_bal </td><td><a href=\"$adr_rs\" target=\"_blank\"> $xrs_ids </a></td><td> $xin_omim </td>";
    echo "<td> $xclinvar_disease_name </td><td> $xrmsk </td><td> $xgunknown </td>";
 
    echo "</tr>";


   }

}
echo "</table>";

echo "$cnt Lines";
echo "<br>";
echo "<br>";

echo "    <input type=\"submit\" value=\"Do zpravy\">";
echo "    <input type=\"hidden\" name=\"PAC\" value=\"$PAC\">";
echo "</form>";

echo "<hr>";
echo "<br>";


mysqli_close($mysqli1);
mysqli_close($mysqli2);



$mysqli9 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli9->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli9->connect_errno . ") " . $mysqli9->connect_error;
}
$mysqli9->set_charset("utf8");


echo "<b>Dvojité mutace</b> &nbsp; &nbsp; &nbsp; <a href=\"./ukaz_dvojite.php?pac=$PAC\">Ukaž všechny</a><br><br>";
echo "<table border=2>";
echo "<tr><td width=100 align=center> <b>Gene</b> </td><td width=100 align=center> <b>Chrom</b> </td>";
echo "<td width=120 align=center> <b>Start</b> </td><td width=120 align=center> <b>End</b> </td>";
echo "<td width=120 align=center> <b>aa_change</b> </td>";
echo "</tr>";

$WPAC=$PAC . "_dw";
$res9=$mysqli9->query("SELECT * FROM $WPAC order by gene,chrom,beg ;");
$cnt9 = $res9->num_rows;

if($cnt9 > 0) {
  while ($row9 = $res9->fetch_assoc()) {
     $wchr = $row9['chrom'] ;
     $wbeg = $row9['beg'] ;
     $wend = $row9['end'] ;
     $wgene = $row9['gene'] ;
     $waa_change = $row9['aa_change'] ;

     echo "<tr>";
     echo "<td align=center> $wgene </td>";
     echo "<td align=center>  <a href=\"./igv.php?chr=$wchr&start=$wbeg&pac=$PAC&run=$database\" target=\"blank\">chr$wchr</a> </td>";
     echo "<td align=center> $wbeg </td>";
     echo "<td align=center> $wend </td>";
     echo "<td align=center> $waa_change </td>";
     echo "</tr>";

  }
}

echo "</table>";
echo "<br><br>";

echo "<b>Špatně pokryté oblasti < 25</b><br><br>";

echo "<table border=2>";
echo "<tr><td width=100 align=center> <b>Gene</b> </td><td width=100 align=center> <b>Exon</b> </td>";
echo "<td width=120 align=center> <b>Chrom</b> </td><td width=120 align=center> <b>Start</b> </td>";
echo "<td width=120 align=center> <b>End</b> </td><td width=120 align=center> <b>Cnt</b>";
echo "</tr>";

$KPAC=$PAC . "_pok";
$res9=$mysqli9->query("SELECT * FROM $KPAC order by gene ;");
$cnt9 = $res9->num_rows;

if($cnt9 > 0) {
  while ($row9 = $res9->fetch_assoc()) {
     $chr1 = $row9['chr1'] ;
     $chr2 = $row9['chr2'] ;
     $beg = $row9['beg'] ;
     $end = $row9['end'] ;
     $pk1 = $row9['pk1'] ;
     $pk2 = $row9['pk2'] ;
     $exo = $row9['exo'] ;
     $ecnt = $row9['ecnt'] ;
     $gene = $row9['gene'] ;

     echo "<tr><td align=center> $gene </td>";
     echo "<td align=center> $exo/$ecnt </td>";
     echo "<td align=center> <a href=\"./igv.php\" onclick=\"window.open('./igv.php?chr=$chr1&start=$beg&end=$end&pac=$PAC&run=$database','newwindow','width=1600,height=800,location,resizable'); return false;\"> $chr1-$chr2 </a>";
     echo "</td>";
     echo "<td align=center> $beg </td>";
     echo "<td align=center> $end </td>";
     echo "<td align=center> $pk1-$pk2 </td>";
     echo "</tr>";
    
  }
}
 
echo "</table>";

mysqli_close($mysqli9);


echo "<br><br>";
$now = time();
echo sprintf("Elapsed:  %f", $now-$then);

?>


