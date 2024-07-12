<?php

include "./kkk.php";
include "./dat.php";
include "./lll.php";

$PAC=$argv[1];

$qual = "on";
$depth = "on";
$maxaafall = "on";
$vik9carrier = "on";
$Class = "on";
$impactso = "on";

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

$mysqli1->real_query("SELECT * FROM $PAC ORDER BY priority");
$res1 = $mysqli1->use_result();

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
   $adr = "https://www.ncbi.nlm.nih.gov/clinvar/?term=" . $t3pom . " " . $xgene;

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
      if ($xclinvar_sig == 'conflicting_interpretations_of_pathogenicity') { $zobraz = 0;}
      if ($xclinvar_sig == 'conflicting_classifications_of_pathogenicity') { $zobraz = 0;}

   }


   if($NV > 2) { $zobraz = 1;}
   if($xCzecanca_kons > 2) { $zobraz = 1;}

   if($NV == 8) { $zobraz = 0;}

   if($NV == 6) { $NV="risk";}
   if($NV == 7) { $NV="drug";}
   if($NV == 8) { $NV="serr";}

   // vzdy zobrazit: (Janicka 31.1.2023)
   include "APC.php";

   // a konecne vysypeme tabulku na stranku
if($zobraz == 1) {
    echo "$xid";
    echo "\n";
}


}

mysqli_close($mysqli1);
mysqli_close($mysqli2);


?>
