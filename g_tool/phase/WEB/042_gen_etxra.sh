#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb

log "Gen extra_g.html"

EXTRAG="${SRC}/extra.txt"
OUT_FIL="${OUT_DIR}/extra_g.html"
IMG_DIR="${OUT_DIR}/extra"
mkdir -p ${IMG_DIR}

tmp=${TMP_DIR}/etmp_$$
rm -f $tmp

cat ${WOR_HOME}/web_templ/poj_1.tem > ${OUT_FIL}
echo "<center><h3> Run ${RUN} </h3></center>" >> ${OUT_FIL}
echo "<br><br>" >> ${OUT_FIL}

if [ -f $EXTRAG ]
 then
  for line in `cat $EXTRAG`
   do
     pac=`echo $line | cut -d"|" -f1`
     G1=`echo $line | cut -d"|" -f2`
     G2=`echo $line | cut -d"|" -f3`
     G3=`echo $line | cut -d"|" -f4`
     G4=`echo $line | cut -d"|" -f5`
     G5=`echo $line | cut -d"|" -f6`
     echo "  Pro $pac geny $G1 $G2 $G3 $G4 $G5 <br>" >> ${OUT_FIL}
     echo $G1 >> $tmp
     echo $G2 >> $tmp
     echo $G3 >> $tmp
     echo $G4 >> $tmp
     echo $G5 >> $tmp
   done
  echo "  <br>" >> ${OUT_FIL}
  echo "  <br>" >> ${OUT_FIL}
 else
  echo " Zadne extra geny se nepozaduji" >> ${OUT_FIL}
  echo "  <br>" >> ${OUT_FIL}
  echo "  <hr>" >> ${OUT_FIL}
  echo "</body>" >> ${OUT_FIL}
  echo "</html>" >> ${OUT_FIL}

  # aby nebyl error pri kopirovani
  touch ${IMG_DIR}/nejsou.txt
  exit
fi 

#upravime list genu
cat $tmp | sort | uniq > /tmp/xx_$$
mv /tmp/xx_$$ $tmp

echo "<table>" >> ${OUT_FIL}

cnt=0
for gen in `cat $tmp`
  do
    im="$gen.png"
    imm=`echo $gen"_m.png"`
    lnk="$gen.lnk"

    if [ -f ${GR2_DIR}/${im} ]
     then
       cp ${GR2_DIR}/${im} ${IMG_DIR}
       cp ${GR2_DIR}/${imm} ${IMG_DIR}
     else 
       cp ${WOR_HOME}/web_templ/gen_neni.png ${IMG_DIR}/${imm}
    fi

#echo ${GR2_DIR}/${lnk}

    cnt=`expr $cnt + 1`
    if [ "$cnt" -eq 1 ]
     then
       echo "<tr>" >> ${OUT_FIL}
       echo "  <td valign=\"top\">" >> ${OUT_FIL}
       echo "<b><center> $gen </center></b><br>" >> ${OUT_FIL}
       echo "     <a href=\"./extra/$im\"><img src=./extra/$imm border=\"0\" width=\"550\"></a>" >> ${OUT_FIL} 
       grep $gen ${PRELEZLE} #> /dev/null
       if [ $? -ne 1 ]
        then
          echo "    <br>" >> ${OUT_FIL}
          echo "    <button type=\"button\" onclick=\"window.open('./tgen_$gen.html','newwindow','width=800,height=600'); return false;\">Detaily?</button>" >> ${OUT_FIL}
       fi
       echo "  </td>" >> ${OUT_FIL}
    fi
    if [ "$cnt" -eq 2 ]
     then
       echo "  <td valign=\"top\">" >> ${OUT_FIL}
       echo "<b><center> $gen </center></b><br>" >> ${OUT_FIL}
       echo "     <a href=\"./extra/$im\"><img src=./extra/$imm border=\"0\" width=\"550\"></a>" >> ${OUT_FIL} 
       grep $gen ${PRELEZLE} #> /dev/null
       if [ $? -ne 1 ]
        then
          echo "    <br>" >> ${OUT_FIL}
          echo "    <button type=\"button\" onclick=\"window.open('./tgen_$gen.html','newwindow','width=800,height=600'); return false;\">Detaily?</button>" >> ${OUT_FIL}
       fi
       echo "  </td>" >> ${OUT_FIL}
    fi
    if [ "$cnt" -eq 3 ]
     then
       echo "  <td valign=\"top\">" >> ${OUT_FIL}
       echo "<b><center> $gen </center></b><br>" >> ${OUT_FIL}
       echo "     <a href=\"./extra/$im\"><img src=./extra/$imm border=\"0\" width=\"550\"></a>" >> ${OUT_FIL} 
       grep $gen ${PRELEZLE} #> /dev/null
       if [ $? -ne 1 ]
        then
          echo "    <br>" >> ${OUT_FIL}
          echo "    <button type=\"button\" onclick=\"window.open('./tgen_$gen.html','newwindow','width=800,height=600'); return false;\">Detaily?</button>" >> ${OUT_FIL}
       fi
       echo "  </td>" >> ${OUT_FIL}
       echo "</tr>" >> ${OUT_FIL}
       echo "<tr><td height=\"80\"> </td></tr>" >> ${OUT_FIL}
       cnt=0
    fi
  done
  
  if [ "$cnt" -eq 1 ]
   then
     echo "  <td>" >> ${OUT_FIL}
     echo "  </td>" >> ${OUT_FIL}
     echo "  <td>" >> ${OUT_FIL}
     echo "  </td>" >> ${OUT_FIL}
  fi
  if [ "$cnt" -eq 2 ]
   then
     echo "  <td>" >> ${OUT_FIL}
     echo "  </td>" >> ${OUT_FIL}
  fi

  echo "</tr>" >> ${OUT_FIL}
  echo "</table>" >> ${OUT_FIL}

  echo "  <br>" >> ${OUT_FIL}
  echo "  <hr>" >> ${OUT_FIL}
  echo "</body>" >> ${OUT_FIL}
  echo "</html>" >> ${OUT_FIL}

exit 0
