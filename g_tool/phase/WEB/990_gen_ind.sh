#!/usr/bin/env ksh93

load_params "$@"

log "Gen index.html"
 
. ${WOR_LIB}/bioweb

#limit pri jehoz prekroceni se vzorek nezaradi do regulerniho zpracovani
TRS=200

OUT_FIL="${OUT_DIR}/index.php"
blbe_vzorky=${TMP_DIR}/blbe_vzorky.txt
pod="_"

cat ${WOR_HOME}/web_templ/ind_1.tem > ${OUT_FIL}
echo "<center><h3> Run ${RUN} </h3></center>" >> ${OUT_FIL}
echo "<br><br>" >> ${OUT_FIL}
cat ${WOR_HOME}/web_templ/ind_2.tem >> ${OUT_FIL}

#tabulka blbe vzorky - vyrazujeme ze zpracovani
#BRCA5728|27|345
#BRCA5771|147|232

xpom=/tmp/xpom_$$
rm -f $xpom
for xline in `cat $blbe_vzorky`
 do
   valp=`echo $xline | cut -d"|" -f2`
   valm=`echo $xline | cut -d"|" -f3`

   if [ "$valp" -gt "$TRS" ] && [ "$valm" -gt "$TRS" ]
    then
     echo $xline >> $xpom
   fi
 done

if [ -e $xpom ]
 then
  echo "    <pre>" >>${OUT_FIL}
  echo " " >>${OUT_FIL}
  echo "    <b>Vyhozeno pro celkovou nedostatecnost:" >>${OUT_FIL}
  echo " " >>${OUT_FIL}
  echo "     +------------------+" >>${OUT_FIL}
  echo "     |  Pacient   Score |" >>${OUT_FIL}
  echo "     +------------------+" >>${OUT_FIL}
  for xline in `cat $xpom`
   do
     xpac=`echo $xline | cut -d"|" -f1`
     xhodp=`echo $xline | cut -d"|" -f2`
     xhodm=`echo $xline | cut -d"|" -f3`
     xhod=`echo $xhodp/$xhodm`
     echo "     |  $xpac    $xhod  |"  >>${OUT_FIL}
   done
  echo "     +------------------+" >>${OUT_FIL}
  echo "   </b>" >>${OUT_FIL}
  echo " " >>${OUT_FIL}
  echo "   </pre>" >>${OUT_FIL}
  #size=${#myvar}
 else
   echo "   <b>  Vzorky se povedly, žádný nebyl vyřazen </b><br><br>" >>${OUT_FIL}
fi  

#rm -f $xpom

#cat ${WOR_HOME}/web_templ/ind_3.tem >> ${OUT_FIL}

echo "  <br>" >> ${OUT_FIL}
echo "  <hr>" >> ${OUT_FIL}
echo "<?php" >> ${OUT_FIL}
cat ${WOR_HOME}/web_templ/ind_php_cnv.tem | sed "s/XXRUNXX/run${RUN}/" >> ${OUT_FIL}
echo "?>" >> ${OUT_FIL}
echo "</body>" >> ${OUT_FIL}
echo "</html>" >> ${OUT_FIL}

