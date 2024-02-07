<?php
       $mysqli3 = new mysqli($server_name,$user,$pass,$rdatabase);
       if ($mysqli3->connect_errno) {
           echo "Failed to connect to MySQL: (" . $mysqli3->connect_errno . ") " . $mysqli3->connect_error;
       }
       $mysqli3->set_charset("utf8");

    $res3=$mysqli3->query("SELECT * FROM nase_var where chrom=\"$xchrom\" AND start=\"$xstart\" AND end=\"$xend\" AND ref=\"$xref\" AND alt=\"$xalt\";");

        $cnt3 = $res3->num_rows;
//echo "cnt3>>$cnt3<<";
//echo "<br>";

     if ($cnt3 == 1) {
        $row3 = $res3->fetch_assoc();
        $poz1 = $row3['poz1'] ;
        $poz2 = $row3['poz2'] ;
        $dia = $row3['dia'] ;
        $class = $row3['class'] ;
       }   
     elseif ($cnt3 == 0) {
        $poz1 = "Zaznam nenalezen" ;
        $poz2 = "Zaznam nenalezen" ;
        $dia = "Zaznam nenalezen" ;
        $class = "Zaznam nenalezen" ;
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

mysqli_close($mysqli3);

?>
