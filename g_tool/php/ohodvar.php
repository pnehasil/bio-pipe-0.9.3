<?php

include "./kkk.php";
include "./dat.php";
include "./lll.php";

$GEN = htmlspecialchars($_GET['gen'], ENT_QUOTES, "UTF-8");

echo "<br>";

echo "<center><B> Neoskorovane varianty pro gen $GEN </B></center>";
echo "<br>";
echo "<br>";

$pos = 1 + strpos($database,'_');
$run = substr($database,$pos);


$mysqli1 = new mysqli($server_name,$user,$pass,$rdatabase);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}
$mysqli1->set_charset("utf8");

$mysqli2 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli2->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
}
$mysqli2->set_charset("utf8");

$mysqli3 = new mysqli($server_name,$user,$pass,$rdatabase);
if ($mysqli3->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
}
$mysqli2->set_charset("utf8");

// najdeme vsechny varianty pro dany run a podivame se, jestli uz jsou ohodnocene (jsou v nase_var)
// k neohodnocenym najdene v tabulce pacientu gen a podle toho je pak vypiseme
$sql = "SELECT * FROM pac_var where run=$run";

if (!$result = $mysqli1->query($sql)) {

    echo "Error: Our query failed <BR>";
    echo "Query: " . $sql . "<BR>n";
    echo "Errno: " . $mysqli1->errno . "<BR>";
    echo "Error: " . $mysqli1->error . "<BR>";
    exit;
}

if ($result->num_rows === 0) {
    echo "Zadne varianty se nenasly";
    exit;
}

echo "<table border=2>";
echo "<tr bgcolor=e0e0e0>";
echo "<td>  </td><td> gene </td><td> codon_change </td><td> aa_change </td><td> exon </td><td> qual </td>";    
echo "<td> depth </td><td> impact_so </td><td> clinvar_sig </td><td> clinvar_rev </td>";
echo "<td> UBEO_Class </td><td> Czecanca_kons </td>";
echo "<td> WT </td><td> ALT </td>";
echo "<td> max_aaf_all </td><td> aaf_esp_ea </td>";      
echo "<td> VIK_9carrier </td><td> VIK_unknown </td>";
echo "<td> aaf_esp_all </td><td> aaf_1kg_eur </td><td> aaf_1kg_all </td>";     
echo "<td> gms_illumina </td><td> gms_solid </td><td> gms_iontorrent </td><td> cosmic_ids </td>";      
echo "<td> cadd_raw </td><td> cadd_scaled </td><td> aaf_exac_all </td><td> aaf_adj_exac_all </td>";        
echo "<td> aaf_adj_exac_nfe </td><td> exac_num_het </td><td> exac_num_hom_alt </td><td> aa_length </td>";       
echo "<td> transcript </td><td> chrom </td><td> start </td><td> end </td><td> ref </td><td> alt </td>";     
echo "<td> num_reads_w_dels </td><td> allele_count </td><td> allele_bal </td><td> rs_ids </td>";  
echo "<td> in_omim </td><td> clinvar_disease_name </td><td> rmsk </td><td> gunknown </td>";
echo "</tr>";


while ($row1 = $result->fetch_assoc()) {

  $xpac = $row1['pac'] ; 
  $xchrom = $row1['chrom'] ; 
  $xstart = $row1['start'] ; 
  $xend = $row1['end'] ; 
  $xalt = $row1['alt'] ; 
  $xref = $row1['ref'] ; 

// kontrola na nase_var
  $sql3 = "SELECT * from nase_var WHERE chrom='$xchrom' AND start=$xstart AND end=$xend AND alt='$xalt' AND ref='$xref'";

  if (!$res3 = $mysqli3->query($sql3)) {

     echo "Error: Our query failed <BR>";
     echo "Query: " . $sql3 . "<BR>";
     echo "Errno: " . $mysqli3->errno . "<BR>";
     echo "Error: " . $mysqli3->error . "<BR>";
     exit;
 }

 if ($res3->num_rows === 0) { // v nase_var neni, pokracujeme dal


//echo "PAC>> $xpac <BR>";

     $sql2 = "SELECT * from $xpac WHERE chrom='$xchrom' AND start=$xstart AND end=$xend AND alt='$xalt' AND ref='$xref' AND gene='$GEN'";

//echo "$sql2 <BR>";

     if (!$res2 = $mysqli2->query($sql2)) {

        echo "Error: Our query failed <BR>";
        echo "Query: " . $sql2 . "<BR>";
        echo "Errno: " . $mysqli2->errno . "<BR>";
        echo "Error: " . $mysqli2->error . "<BR>";
        exit;
    }

    if ($res2->num_rows != 0) {

       $row2 = $res2->fetch_assoc();

//--------------------------------

       $xid = $row2['id'] ;
       $xgene = $row2['gene'] ;

       $xcodon_change = $row2['codon_change'] ;
       $xaa_change = $row2['aa_change'] ;
       $xexon = $row2['exon'] ;
       $xqual = $row2['qual'] ;
       $xdepth = $row2['depth'] ;
       $xnum_alleles = $row2['num_alleles'] ;
       $xclinvar_sig = $row2['clinvar_sig'] ; 
       $xclinvar_rev = $row2['clinvar_rev'] ; 
       $x01_UBEO_Class = $row2['x01_UBEO_Class'] ;
       $xCzecanca_kons = $row2['Czecanca_kons'] ;
       $xmax_aaf_all = $row2['max_aaf_all'] ;
       $xaaf_esp_ea = $row2['aaf_esp_ea'] ;
       $ximpact_so = $row2['impact_so'] ;
       $xVIK_9carrier = $row2['VIK_9carrier'] ;
       $xVIK_unknown = $row2['VIK_unknown'] ;
       $xaaf_esp_all = $row2['aaf_esp_all'] ;
       $xaaf_1kg_eur = $row2['aaf_1kg_eur'] ;
       $xaaf_1kg_all = $row2['aaf_1kg_all'] ;
       $xgms_illumina = $row2['gms_illumina'] ;
       $xgms_solid = $row2['gms_solid'] ;
       $xgms_iontorrent = $row2['gms_iontorrent'] ;
       $xcosmic_ids = $row2['cosmic_ids'] ;
       $xcadd_raw = $row2['cadd_raw'] ;
       $xcadd_scaled = $row2['cadd_scaled'] ;
       $xaaf_exac_all = $row2['aaf_exac_all'] ;
       $xaaf_adj_exac_all = $row2['aaf_adj_exac_all'] ;
       $xaaf_adj_exac_nfe = $row2['aaf_adj_exac_nfe'] ;
       $xexac_num_het = $row2['exac_num_het'] ;
       $xexac_num_hom_alt = $row2['exac_num_hom_alt'] ;
       $xaa_length = $row2['aa_length'] ;
       $xtranscript = $row2['transcript'] ;
       $xnum_reads_w_dels = $row2['num_reads_w_dels'] ;
       $xallele_count = $row2['allele_count'] ;
       $xallele_bal = $row2['allele_bal'] ;
       $xrs_ids = $row2['rs_ids'] ;
       $xin_omim = $row2['in_omim'] ;
       $xclinvar_disease_name = $row2['clinvar_disease_name'] ;
       $xrmsk = $row2['rmsk'] ;
       $xzwt = $row2['zwt'] ;
       $xzalt = $row2['zalt'] ;
       $xgunknown = $row2['gunknown'] ;


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
       $vtablnk = "./vnova.php?pac=$PAC&chr=$xchrom&start=$xstart&end=$xend&ref=$xref&alt=$xalt";
       $gtablnk = "https://www.uniprot.org/uniprot/?query=gene:" . $xgene . "+AND+organism:9606&sort=score";
       $ttablnk = "https://www.ncbi.nlm.nih.gov/nuccore/" . $xtranscript;


       echo "<td> <button type=\"button\" onclick=\"window.open('$vtablnk','newwindow'); return false;\">Hodnotit</button> </td>";
       echo "<td> <a href=\"$gtablnk\" target=\"_blank\">$xgene</a> </td>";
       echo "<td> $xcodon_change </td>";
       echo "<td> <a href=\"$vtablnk\" target=\"_blank\">$xaa_change</a> </td><td> $xexon </td>";
       echo "<td> $xqual </td><td> $xdepth </td><td> $ximpact_so </td>";
       echo "<td> <a href=\"$adr\" target=\"_blank\"> $xclinvar_sig </a> </td>";
       echo "<td>  $xclinvar_rev </td>";
       echo "<td> $x01_UBEO_Class </td><td> $xCzecanca_kons </td>";
       echo "<td> $xzwt </td><td> $xzalt </td>";
       echo "<td> $xmax_aaf_all </td><td> $xaaf_esp_ea </td><td> $xVIK_9carrier </td>";
       echo "<td> $xVIK_unknown </td><td> $xaaf_esp_all </td>";
       echo "<td> $xaaf_1kg_eur </td><td> $xaaf_1kg_all </td><td> $xgms_illumina </td><td> $xgms_solid </td>";
       echo "<td> $xgms_iontorrent </td><td> $xcosmic_ids </td><td> $xcadd_raw </td><td> $xcadd_scaled </td>";
       echo "<td> $xaaf_exac_all </td><td> $xaaf_adj_exac_all </td><td> $xaaf_adj_exac_nfe </td><td> $xexac_num_het </td>";
       echo "<td> $xexac_num_hom_alt </td><td> $xaa_length </td>";
       echo "<td> <a href=\"$ttablnk\" target=\"_blank\">$xtranscript</a> </td>";
       echo "<td> <a href=\"./igv.php?chr=$xchrom&start=$xstart&pac=$PAC&run=$database\">$xchrom</a> </td>";
       echo "<td> $xstart </td><td> $xend </td><td> $xref </td><td> $xalt </td><td> $xnum_reads_w_dels </td>";
       echo "<td> $xallele_count </td><td> $xallele_bal </td><td> $xrs_ids </td><td> $xin_omim </td>";
       echo "<td> $xclinvar_disease_name </td><td> $xrmsk </td><td> $xgunknown </td>";
 
       echo "</tr>";


//---------------------------------

    }
 
 }


}

echo "</table>";

mysqli_close($mysqli3);
mysqli_close($mysqli2);
mysqli_close($mysqli1);

?>
