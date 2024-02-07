#!/usr/bin/env ksh93

load_params "$@"

log "Gen detail pages"
 
. ${WOR_LIB}/bioweb

SRC_DIR="${MUMPS_DIR}"
OUT_DIR=${OUT_DIR}/det

mkdir ${OUT_DIR}

pod="_"
trun="run"

for file in `ls ${SRC_DIR}/*dat`
  do

    bf=`basename -s .dat $file`
    ofile=${OUT_DIR}/$bf$pod$trun$RUN
    echo "BF>>$bf"
    echo "FILE>>$file"
    cp $file $ofile.csv 

#    OUT_FILH="${OUT_DIR}/$bf$pod$trun$RUN.html"
#    cat ${WOR_HOME}/web_templ/lnk_1.tem > ${OUT_FILH} 
#
#    echo "<br>" >> ${OUT_FILH}
#    echo "<center><B>------ Run$pod${RUN} &nbsp;&nbsp;  $pac   ------</b></center>" >> ${OUT_FILH}
#    echo "<br>" >> ${OUT_FILH}
#    echo "<br>" >> ${OUT_FILH}
#    echo "<br>" >> ${OUT_FILH}
#
#    echo "<table border=2>" >> ${OUT_FILH}
#    for xlin in `cat $file | sed 's/|/<\/td><td>/g'`
#      do
# tady je prostor na upravy, vkladani sloupcu atd
#        echo "<tr><td>$xlin</td></tr>" >> ${OUT_FILH}
#      done
#
#    echo "</table>" >> ${OUT_FILH}
#    echo "  <br>" >> ${OUT_FILH}
#    echo "</body>" >> ${OUT_FILH}
#    echo "</html>" >> ${OUT_FILH}

  done


