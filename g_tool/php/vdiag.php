<?php

include "./kkk.php";
include "./lll.php";

include "./dat.php";

echo "<br>";

$PAC = htmlspecialchars($_GET['PAC'], ENT_QUOTES, "UTF-8");
$dozpravy = "";

echo " <b> Zprava pro $PAC </b>";
echo "<br>";
echo "<br>";

//echo "<b><u>Výsledek:<br></u></b>";
//echo "<b>Ve 22 hodnocených genech byly identifikovány</b> následující <b>příčinné mutace</b> (class 4 a 5):<br>";
echo "<br><br>";
echo "<table border=1><tr>";
echo "<td width=100> Gen </td><td width=150> cDNA </td><td width=130> Protein </td>";
echo "<td width=100> Typ </td><td width=100 > Stav </td><td width=150 > Nase klasifikace </td> ";
echo "</tr>";


// nepeknou metodou zjistime id v tabulce pacientskych variant  
// to je to co vidime na strance a zaskrtli jsme v prvnim sloupci
// nic lepsiho me nenapadlo...
for ($x = 0; $x <= 100000; $x+=1) {
   $pom = "dia_" . $x;

    if(isset($_GET["$pom"])) {
       $id="X";
       $pos = strpos($pom,'_');
      if($pos > 0) {
         $id = substr($pom, $pos+1);
      }

// mame id a tak si zjistime gen,start,end,ref,alt
      $mysqli1 = new mysqli($server_name,$user,$pass,$database);
      if ($mysqli1->connect_errno) {
          echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
      }

        $res=$mysqli1->query("SELECT * FROM $PAC where id=\"$id\";");
        $cnt = $res->num_rows;
        mysqli_close($mysqli1);

        if ($cnt == 1) {
           $row1 = $res->fetch_assoc();
           $xgene = $row1['gene'] ;
           $xchrom = $row1['chrom'] ;
           $xstart = $row1['start'] ;
           $xend = $row1['end'] ;
           $xref = $row1['ref'] ;
           $xalt = $row1['alt'] ;
           $xaa_change = $row1['aa_change'] ;

           $pos = strpos($xaa_change,'/');
           $ct = substr($xaa_change,$pos+1);
           $pt = substr($xaa_change,0,$pos);

           echo "<tr>";
           echo "<td> <b><i>$xgene</i></b> </td><td> <b>$ct</b> </td><td> <b>$pt</b> </td><td> <b>???</b> </td>";
           echo "<td> <b>het</b> </td>";



// text z policka diagnoza si uschovame a vyhodime ven az pod tabulkou
          $mysqli2 = new mysqli($server_name,$user,$pass,$rdatabase);
          if ($mysqli2->connect_errno) {
              echo "Failed to connect to MySQL: (" . $mysqli2->connect_errno . ") " . $mysqli2->connect_error;
          }
          $mysqli2->set_charset("utf8");

       $res2=$mysqli2->query("SELECT * FROM nase_var where chrom=\"$xchrom\" AND start=\"$xstart\" AND end=\"$xend\" AND ref=\"$xref\" AND alt=\"$xalt\";");

           $cnt2 = $res2->num_rows;

           if ($cnt2 == 1) {
              $row2 = $res2->fetch_assoc();
              //$poz1 = $row2['poz1'] ;
              //$poz2 = $row2['poz2'] ;
              $dia = $row2['dia'] ;
              $class = $row2['class'] ;

// ovsem potrebujeme jeste klasifikaci a tu zjistime tady
           echo "<td align=\"center\"> $class </td>";
           echo "</tr>";
 
              $dozpravy = $dozpravy . "<b><i>" . $xgene . "</i></b>- " . $row2['dia'] . "<br><br>" ;

              //echo "<b> Pozn. 1:</b><br>";
              //echo "$poz1<br><br>";

              //echo "<b> Pozn. 2:</b><br>";
              //echo "$poz2<br><br>";
      
              //echo "<b>Do zpravy:</b><br>";
              // echo "$dia<br><br>";
              
             }   
           elseif ($cnt2 == 0) {
              //echo "Nic se nenaslo<br>";
              //echo "<br>";
              $dozpravy = $dozpravy . "<b><i>" . $xgene . "</i></b>- " . "Zadny zaznam<br><br>" ;
              echo "<td align=\"center\"> None </td>";
              echo "</tr>";
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

        }
        else {
           echo "Nejaka divna chyba.<br> ";
           echo "Text nize prosim poslat na petr.nehas@gmail.com<br><br>";

           echo "ID=$id v $PAC nenalezeno a melo by tam byt. <br> ";
           echo "modul: vdiad.php"; 
           echo "<br>";

           echo "<br>";
           echo "<button type=\"button\" onclick=\"javascript:window.close()\">Zavrit okno</button>";
           echo "<br><br>";
        }




//echo "<hr><br><br>";
 
    } //isset
}  //for

echo "</table>";

echo "<br>";
echo "<br>";
echo "<br>";
echo $dozpravy;

?>





