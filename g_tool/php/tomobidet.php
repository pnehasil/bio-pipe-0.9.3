<?php

$trvar = htmlspecialchars($_GET['trvar'], ENT_QUOTES, "UTF-8");

$xtvar = urlencode($trvar) ;
$xtvar = str_replace('%26gt','',$xtvar);
$xtvar = str_replace('+','%2B',$xtvar);
$xtvar = str_replace('-','%2D',$xtvar);
$xtvar = str_replace('>','%3E',$xtvar);
$xtvar = str_replace(':','%3A',$xtvar);
$xtvar = str_replace('%3B','%3E',$xtvar);


//$xtvar="NM_002439.4:c.3133G>A";

//echo "<br> argument >>$xtvar<< <br>";

//set POST variables
//$url = 'https://mobidetails.iurc.montp.inserm.fr/MD/api/variant/create';
$url = 'https://mobidetails.chu-montpellier.fr/api/variant/create';
$fields = array(
                        'variant_chgvs' => $xtvar,
                        //'caller' => urlencode("browser"),
                        'caller' => urlencode("cli"),
                        'api_key' => urlencode("am-I0XwOIQWK3U8eVC-JfP7x0hIIXpGaSHeyJffhyuQ")
                );


//url-ify the data for the POST
$fields_string = "";
foreach($fields as $key=>$value) { $fields_string .= $key.'='.$value.'&'; }
rtrim($fields_string, '&');

//echo "<br><br> $fields_string <br><br>";

//open connection
$ch = curl_init();

//set the url, number of POST vars, POST data
curl_setopt($ch,CURLOPT_URL, $url);
curl_setopt($ch,CURLOPT_POST, count($fields));
curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
curl_setopt($ch,CURLOPT_RETURNTRANSFER, "true");

//execute post
$result = curl_exec($ch);

//close connection
curl_close($ch);

//echo "<br><br>";
//echo $result;
//echo "<br><br>";

$pom=(explode(":", $result));
$xmoburl = "https:" . $pom[3];
//$murl = rtrim($xmoburl, '"}');
$murl = str_replace('"}','',$xmoburl);

//echo "<br><br><a href=\"$murl\"> Klik $murl </a>";

if (StrPos ($result, "mobidetails_error")) {
   echo "<br><br>";
   echo "<br><h3> Chyba: $result </h3></pom><br><br> ";
   echo "Vstupni parametr: $xtvar";
}
else {
   header("Location: $murl");
}


?>
