#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb

log "Gen all.html"

OUT_FIL="${OUT_DIR}/all.html"

IMG_DIR="${OUT_DIR}/img"
mkdir -p ${IMG_DIR} > /dev/null

cat ${WOR_HOME}/web_templ/poj_1.tem > ${OUT_FIL}
echo "<center><h3> Run ${RUN} </h3></center>" >> ${OUT_FIL}
echo "<br><br>" >> ${OUT_FIL}

echo "<table>" >> ${OUT_FIL}

cnt=0
for gen in `ls ${GR2_DIR}/*_m.png`
  do
    gen=`basename $gen | cut -d"_" -f1`
    im="$gen.png"
    imm=`echo $gen"_m.png"`
    lnk="$gen.lnk"

    cp ${GR2_DIR}/${im} ${IMG_DIR}
    cp ${GR2_DIR}/${imm} ${IMG_DIR}

echo ${GR2_DIR}/${lnk}

    cnt=`expr $cnt + 1`
    if [ "$cnt" -eq 1 ]
     then
       echo "<tr>" >> ${OUT_FIL}
       echo "  <td valign=\"top\">" >> ${OUT_FIL}
       echo "<b><center> $gen </center></b><br>" >> ${OUT_FIL}
       echo "     <a href=\"./img/$im\"><img src=./img/$imm border=\"0\" width=\"550\"></a>" >> ${OUT_FIL} 
       if [ -e ${GR2_DIR}/${lnk} ]
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
       echo "     <a href=\"./img/$im\"><img src=./img/$imm border=\"0\" width=\"550\"></a>" >> ${OUT_FIL} 
       if [ -e ${GR2_DIR}/${lnk} ]
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
       echo "     <a href=\"./img/$im\"><img src=./img/$imm border=\"0\" width=\"550\"></a>" >> ${OUT_FIL} 
       if [ -e ${GR2_DIR}/${lnk} ]
         then
           echo "    <br>" >> ${OUT_FIL}
           echo "    <button type=\"button\" onclick=\"window.open('./tgen_$gen.html','newwindow','width=800,height=600'); return false;\">Detaily?</button>" >> ${OUT_FIL}
       fi
       echo "  </td>" >> ${OUT_FIL}
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
