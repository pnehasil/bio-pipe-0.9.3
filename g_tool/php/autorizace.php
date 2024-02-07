<?php
Header("Pragma: No-cache");
Header("Cache-Control: No-cache, Must-revalidate");
Header("Expires: ".GMDate("D, d M Y H:i:s")." GMT");
 
$nick=$_POST["nick"];
$pass=$_POST["pass"];

include "./lll.php";

if((IsSet($nick)) AND (IsSet($pass))){
   $p = MD5($pass);

   $mysqli1 = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
   if($mysqli1->connect_errno) {
       echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
   }
   $mysqli1->set_charset("utf8");

   $res1=$mysqli1->query("SELECT * FROM uzivatele WHERE nick=\"$nick\" AND pass=\"$p\";");
   $cnt1 = $res1->num_rows;

   mysqli_close($mysqli1);

   if($cnt1 <> 1){
      echo "Špatný login, nebo heslo - můžete to zkusit <a href=\"autorizace.php\">znovu...</a>";
      exit;
   }
   else {
  

     $SN = "autorizace"; 
     Session_name("$SN");
     Session_start();
     //Session_register("nick");
     $_SESSION["nick"]=$nick;
     $sid = Session_id();
     $time = Date("U");
     $at = Date("U") - 1800;

//insert do tabulky autorizace
//$MSQ = MySQL_Query("INSERT INTO autorizace VALUES ('$sid', $time)");
//$MSQ = MySQL_Query("DELETE FROM autorizace WHERE time < $at");

     $con = new mysqli($rserver_name,$ruser,$rpass,$rdatabase);
     if ($con->connect_errno) {
         echo "Failed to connect to MySQL: (" . $con->connect_errno . ") " . $con->connect_error;
     }
     $con->set_charset("utf8");

     $sql = "INSERT INTO autorizace(id,date,nick)VALUES (\"$sid\",\"$time\",\"$nick\")";

     if (mysqli_query($con, $sql)) {

       echo "<script>";
       echo "window.resizeTo(300,200)";
       echo "</script>";

       echo "<center>";
       echo "<br>";
       echo "<br>";
       echo "<b>Uzivatel $nick byl prihasen</b> <br><br>";
       echo "<button type=\"button\" onclick=\"javascript:window.close()\">OK</button>";
       echo "</center>";
     } 
     else {
       echo "Error: " . $sql . "" . mysqli_error($con);
     }

     $sql = "DELETE FROM autorizace WHERE date < $at";

     if (!mysqli_query($con, $sql)) { echo "Error: " . $sql . "" . mysqli_error($con);}

     $con->close();
   }
}
else {

   echo "<br>";
   echo "<h1 align=\"center\">Přihlášení</h1>";

   echo "<form method=\"post\" action=\"autorizace.php\">";

   echo "<table width=\"40%\" border=\"1\" cellspacing=\"0\" cellpadding=\"3\" align=\"center\" bgcolor=\"white\">";
   echo "<tr bgcolor=\"#4A4A4A\"><td colspan=\"2\" class=\"tableheading\"> &nbsp; </td></tr>";
   echo "<tr><td><b>Login:</b> </td>";
   echo "<td><input style=\"WIDTH: 430px\" type=\"text\" name=\"nick\" size=\"50\" maxlength=\"50\" class=\"input\" value=\"\" </td></tr>";
   echo "<tr><td valign=\"top\"> <b>Heslo:</b> </td>";
   echo "<td><input type=\"Password\" name=\"pass\" style=\"WIDTH: 430px\"></td></tr>";
   echo "<tr><td colspan=\"2\" align=\"center\"><input type=\"submit\"  value=\"Odeslat\" class=\"input\"></td></tr>";
   echo "</table></td></tr>";

   echo "</form>";

}

?>
