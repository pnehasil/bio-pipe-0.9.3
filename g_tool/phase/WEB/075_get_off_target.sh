#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "Gen depth.html"

OUT_FIL="${OUT_DIR}/depth.html"

tmp=${TMP_DIR}/etmp_$$
rm -f $tmp

cat ${WOR_HOME}/web_templ/poj_1.tem > ${OUT_FIL}
echo "<center><h3> Off target pro run $RUN </h3></center>" >> ${OUT_FIL}
echo "<br><br>" >> ${OUT_FIL}

CNT=0
SUM=0
echo "<table>" >> ${OUT_FIL}
for file in `ls ${FPIC_DIR}/*V3.hs.metrics.txt`
do
	pom=`grep ^CZE $file | cut -f19`
	ff=`basename -s .V3.hs.metrics.txt $file`
	echo "<tr><td> $ff </td><td> $pom </td></tr>" >> ${OUT_FIL}

	CNT=`expr $CNT + 1`
	SUM=`echo $SUM + $pom | bc`

	RES=`echo "scale=6; $SUM/$CNT" | bc | awk '{printf "%f", $0}'`
done


echo "</table>" >> ${OUT_FIL}
echo "<br><br> <b>Prumer jest $RES</b>" >> ${OUT_FIL}



echo "  <br>" >> ${OUT_FIL}
echo "  <br>" >> ${OUT_FIL}
echo "  <hr>" >> ${OUT_FIL}
echo "</body>" >> ${OUT_FIL}
echo "</html>" >> ${OUT_FIL}

exit 0
