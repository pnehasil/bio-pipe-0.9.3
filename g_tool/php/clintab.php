<?php header('Content-type: text/html; charset=utf-8');

include "./lll.php";
include "./kkk.php";
include "./dat.php";

$chr = htmlspecialchars($_GET['chr'], ENT_QUOTES, "UTF-8");
$start = htmlspecialchars($_GET['start'], ENT_QUOTES, "UTF-8");
$end = htmlspecialchars($_GET['end'], ENT_QUOTES, "UTF-8");
$ref = htmlspecialchars($_GET['ref'], ENT_QUOTES, "UTF-8");
$alt = htmlspecialchars($_GET['alt'], ENT_QUOTES, "UTF-8");


echo "$chr $start $end $ref $alt";

echo "<br>";
echo "<br>";

$mysqli1 = new mysqli($server_name,$user,$pass,$database);
if ($mysqli1->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli1->connect_errno . ") " . $mysqli1->connect_error;
}
$mysqli1->set_charset("utf8");
$res=$mysqli1->query("SELECT * FROM CLNSIGCONF where chr=\"$chr\" AND start=\"$start\" AND end=\"$end\" AND ref=\"$ref\" AND alt=\"$alt\";");

$cnt1 = $res->num_rows;
mysqli_close($mysqli1);

if($cnt1 > 0)
  {
    $row1 = $res->fetch_assoc();
    $xcli = $row1['cli'] ;

    echo $xcli;

  }


?>
