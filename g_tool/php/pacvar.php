<?php
   $xid = $row2['id'] ;
   $xgene = $row2['gene'] ;

   $xcodon_change = $row2['codon_change'] ;
   $xaa_change = $row2['aa_change'] ;
   $xexon = $row2['exon'] ;
   $xqual = $row2['qual'] ;
   $xdepth = $row2['depth'] ;
   $xnum_alleles = $row2['num_alleles'] ;
   $xclinvar_sig = $row2['clinvar_sig'] ;
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
   $xchrom = $row2['chrom'] ;
   $xstart = $row2['start'] ;
   $xend = $row2['end'] ;
   $xref = $row2['ref'] ;
   $xalt = $row2['alt'] ;
   $xnum_reads_w_dels = $row2['num_reads_w_dels'] ;
   $xallele_count = $row2['allele_count'] ;
   $xallele_bal = $row2['allele_bal'] ;
   $xrs_ids = $row2['rs_ids'] ;
   $xin_omim = $row2['in_omim'] ;
   $xclinvar_disease_name = $row2['clinvar_disease_name'] ;
   $xrmsk = $row2['rmsk'] ;


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


   // a konecne vysypeme tabulku na stranku

   echo "<table border=2>";

   echo "<tr bgcolor=e0e0e0>";
   echo "<td> id </td><td> gene </td><td> codon_change </td><td> aa_change </td><td> exon </td><td> qual </td>";    
   echo "<td> depth </td><td> num_alleles </td><td> clinvar_sig </td>";
   echo "</tr>";

   echo "<tr>";
   echo "<td> $xid </td><td> $xgene </td>";
   echo "<td> $xcodon_change </td>";
   echo "<td> $xaa_change </td><td> $xexon </td>";
   echo "<td> $xqual </td><td> $xdepth </td><td> $xnum_alleles </td>";
   echo "<td> $xclinvar_sig </td>";
   echo "</tr>";

   echo "<tr height=20><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";

   echo "<tr bgcolor=e0e0e0>";
   echo "<td> 01_UBEO_Class </td><td> Czecanca_kons </td>";
   echo "<td> max_aaf_all </td><td> aaf_esp_ea </td>";      
   echo "<td> impact_so </td>";
   echo "<td> VIK_9carrier </td><td> VIK_unknown </td>";
   echo "<td> aaf_esp_all </td><td> aaf_1kg_eur </td>";
   echo "</tr>";

   echo "<tr>";
   echo "<td> $x01_UBEO_Class </td><td> $xCzecanca_kons </td>";
   echo "<td> $xmax_aaf_all </td><td> $xaaf_esp_ea </td><td> $ximpact_so </td>";
   echo "<td> $xVIK_9carrier </td>";
   echo "<td> $xVIK_unknown </td><td> $xaaf_esp_all </td>";
   echo "<td> $xaaf_1kg_eur </td>";
   echo "</tr>";

   echo "<tr height=20><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";

   echo "<tr bgcolor=e0e0e0>";
   echo "<td> aaf_1kg_all </td>";     
   echo "<td> gms_illumina </td><td> gms_solid </td><td> gms_iontorrent </td><td> cosmic_ids </td>";      
   echo "<td> cadd_raw </td><td> cadd_scaled </td><td> aaf_exac_all </td><td> aaf_adj_exac_all </td>";        
   echo "</tr>";

   echo "<tr>";
   echo "<td> $xaaf_1kg_all </td><td> $xgms_illumina </td><td> $xgms_solid </td>";
   echo "<td> $xgms_iontorrent </td><td> $xcosmic_ids </td><td> $xcadd_raw </td><td> $xcadd_scaled </td>";
   echo "<td> $xaaf_exac_all </td><td> $xaaf_adj_exac_all </td>";
   echo "</tr>";

   echo "<tr height=20><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";

   echo "<tr bgcolor=e0e0e0>";
   echo "<td> aaf_adj_exac_nfe </td><td> exac_num_het </td><td> exac_num_hom_alt </td><td> aa_length </td>";       
   echo "<td> transcript </td><td> chrom </td><td> start </td><td> end </td><td> ref </td>";
   echo "</tr>";

   echo "<tr>";
   echo "<td> $xaaf_adj_exac_nfe </td><td> $xexac_num_het </td>";
   echo "<td> $xexac_num_hom_alt </td><td> $xaa_length </td>";
   echo "<td> $xtranscript </td>";
   echo "<td> $xchrom </td>";
   echo "<td> $xstart </td><td> $xend </td><td> $xref </td>";
   echo "</tr>";

   echo "<tr height=20><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>";

   echo "<tr bgcolor=e0e0e0>";
   echo "<td> alt </td>";     
   echo "<td> num_reads_w_dels </td><td> allele_count </td><td> allele_bal </td><td> rs_ids </td>";  
   echo "<td> in_omim </td><td> clinvar_disease_name </td><td> rmsk </td>";
   echo "</tr>";

   echo "<tr>";
   echo "<td> $xalt </td><td> $xnum_reads_w_dels </td>";
   echo "<td> $xallele_count </td><td> $xallele_bal </td><td> $xrs_ids </td><td> $xin_omim </td>";
   echo "<td> $xclinvar_disease_name </td><td> $xrmsk </td>";
   echo "</tr>";

echo "</table>";


?>
