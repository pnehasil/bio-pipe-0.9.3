<?php
   // vzdy zobrazit: (Janicka 31.1.2023)
   // Posilam varianty v APC s pojmenovanim podle jiny transkripcni varianty.
   // Chteli bychom videt u těchto variant nazev z prilohy a uvest gen APC…
   // Pro kontrolu lze pouzit 007_BRCA7581_run74 a 007_BRCA6167_run49.
   //gene       variant       		  chr     start           stop       ref     alt
   //1 APC      c.-195A>C                  5       112043220                  A       C
   //2 APC      c.-192_-191delinsTAGCAAGGG 5       112043223       112043224  AT      TAGCAAGGG
   //3 APC      c.-192A>T       	   5       112043223                  A       T
   //4 APC      c.-192A>G       	   5       112043223                  A       G
   //5 APC      c.-191T>G       	   5       112043224                  T       G
   //6 APC      c.-191T>C       	   5       112043223       112043224  T       C
   //7 APC      c.-190G>A       	   5       112043225                  G       A
   //8 APC      c.-220_-181del40           5       112043191       112043232  TGCGCATTGTAGTCTTCCCACCTCCCACAAGATGGCGGAGG       T

   if($xchrom == "chr5") {
     //1
     if(($xstart == 112043219) and ($xend == 112043220) and ($xref == "A") and ($xalt == "C")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-195A>C";
      }

     //2 tady si nejsem moc jisty koordinatama
     if(($xstart == 112043223) and ($xend == 112043224) and ($xref == "AT") and ($xalt == "TAGCAAGGG")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-192_-191delinsTAGCAAGGG";
      } 

     //3
     if(($xstart == 112043222) and ($xend == 112043223) and ($xref == "A") and ($xalt == "T")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-192A>T";
     }

     //4
     if(($xstart == 112043222) and ($xend == 112043223) and ($xref == "A") and ($xalt == "G")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-192A>G";
     }

     //5
     if(($xstart == 112043223) and ($xend == 112043224) and ($xref == "T") and ($xalt == "G")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-191T>G";
     }

     //6
     if(($xstart == 112043223) and ($xend == 112043224) and ($xref == "T") and ($xalt == "C")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-191T>C";
      } 

     //7
     if(($xstart == 112043224) and ($xend == 112043225) and ($xref == "G") and ($xalt == "A")) { 
      $xgene = "APC"; $zobraz = 1; 
      $xaa_change = "c.-190G>A";
     } 

     //8
     if(($xstart == 112043191) and ($xend == 112043232) and ($xref == "TGCGCATTGTAGTCTTCCCACCTCCCACAAGATGGCGGAGG") and ($xalt == "T")) { 
      $xgene = "APC"; $xgroup = 1; 
      $zobraz = 1; $xaa_change = "c.-220_-181del40"; 
     } 

   }
?>
