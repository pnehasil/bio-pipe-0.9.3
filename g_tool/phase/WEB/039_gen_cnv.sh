#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "Gen CNV detail"

# vygenerujeme celkovy soubor ze ktereho vytvorime html
# cnv pro Baru/Tanu

log "${TMP_DIR}/XMED/vse.txt"
cat  ${TMP_DIR}/XMED/chr*txt > ${TMP_DIR}/XMED/vse.txt

# pro kazdy tgen_GEN.txt vybereme data z ${TMP_DIR}/XMED/vse.txt
# a z nich vygenerujeme cgen*html

#vse
#SUFU_007_CZEPRSxPAR_run110|chr10_104263909_104264091|0.067835
#SUFU_007_CZEPRSxBRCA9269bu_run110|chr10_104263909_104264091|-0.121728
#SUFU_007_CZEPRSxBRCA9452_run110|chr10_104263909_104264091|-0.011565
#
#tgen
#CZEPRSxBRCA9470 chr22_29095815_29095935-e9
#CZEPRSxBRCA9470 chr22_29092878_29092985-e10


for tfile in `ls ${OUT_DIR}/tgen_*.txt`
  do
    gen=`basename $tfile -s | cut -d"_" -f2 | cut -d"." -f1`
    ofile="${OUT_DIR}/cgen_$gen.html"
    lfile="cgen_$gen.html"

    log "$gen"

    rm -f $ofile
    echo "<br>" >> $ofile
    echo "<br>" >> $ofile
    echo "<table border=1>" >> $ofile
    for line in `cat $tfile | sed 's/^ //' |sed 's/ /#/' | sed 's/-/#/'`
      do	    
       pac=`echo $line | cut -d"#" -f1`
       kor=`echo $line | cut -d"#" -f2`
       exon=`echo $line | cut -d"#" -f3 | sed 's/e//'`

       #vybereme data z vse.txt
       xlin=`grep $pac ${TMP_DIR}/XMED/vse.txt | grep $kor`

       zpac=`echo $xlin | cut -d"|" -f1 | cut -d"_" -f2,3,4`
       zhod=`echo $xlin | cut -d"|" -f3`

#       echo $zpac $kor
#       echo $xlin

       link=`echo "<a href=\"./soft/ins_cnv.php?pac=$zpac&gen=$gen&kor=$kor&zhod=$zhod&odkud=$lfile&exon=$exon\"><button>Do seznamu?</button></a>"`

       echo "<tr><td> $zpac </td><td> $kor </td><td> $zhod </td><td> $link </td></tr>" >> $ofile

      done
      echo "</table> ">> $ofile
      echo "<br>" >> $ofile
 done

exit 0
