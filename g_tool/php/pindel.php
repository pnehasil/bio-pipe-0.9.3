<?php

$then = time();

include "./kkk.php";
include "./dat.php";
include "./lll.php";


echo "<br>";
echo "<center><b> PINDEL $PAC  </b></center>";
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

$FPAC=$PAC . "_pin";
$mysqli1->real_query("SELECT * FROM $FPAC ORDER BY `group`, priority");
$res1 = $mysqli1->use_result();

echo "<form action=\"vdiag.php\">";

echo "<table border=2>";
echo "<tr bgcolor=e0e0e0>";
echo "<td> Do zp. </td><td> group </td>";
echo "<td> gene </td><td> codon_change </td><td> aa_change </td><td> exon </td><td> qual </td>";    
echo "<td> depth </td><td> impact_so </td><td> vzd. </td><td> clinvar_sig </td><td> clinvar_rev </td>";
echo "<td> in-house class </td><td> CZE_cons </td>";
echo "<td> WT </td><td> ALT </td><td> %VAF </td>";
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
   $vtablnk = "./vtab.php?pac=$FPAC&chr=$xchrom&start=$xstart&end=$xend&ref=$xref&alt=$xalt";
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
          echo "<td> CZE_cons </td><td> WT </td><td> ALT </td><td> %VAF </td>";
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
    echo "<td> $xzwt </td><td> $xzalt </td><td> $vaf </td>";
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




echo "<br><br>";
$now = time();
echo sprintf("Elapsed:  %f", $now-$then);


?>


