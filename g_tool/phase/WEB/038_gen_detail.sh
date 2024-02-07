#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "Gen detail"

TMP_EFIL="/tmp/texo.txt"

for gen in `ls ${GR2_DIR}/*_m.png`
  do
    gen=`basename $gen | cut -d"_" -f1`
    lnk="$gen.lnk"
    tfile="${OUT_DIR}/tgen_$gen.txt"

      echo ${GR2_DIR}/${lnk}

       if [ -e ${GR2_DIR}/${lnk} ]
        then
          for pac in `cat ${GR2_DIR}/${lnk}`
           do
#echo "get_kor ${GR1_DIR}/$gen/$pac $pac /tmp/$pac$$ "		   
              get_kor ${GR1_DIR}/$gen/$pac $pac /tmp/$pac$$ 
              for zxlin in `cat /tmp/$pac$$`
               do
                 zzpom=`echo $zxlin | cut -d"|" -f2` # prida do popisku exon
                 xexo="e666"
                 xexo=`get_exon $gen $zzpom ${TMP_EFIL}`
                 echo " $zxlin-e$xexo" | sed 's/|/ /' >> $tfile 

               done 
               rm /tmp/$pac$$
           done
       fi
   done
  rm ${TMP_EFIL}


for tfile in `ls ${OUT_DIR}/tgen_*.txt`
  do
    gen=`basename $tfile -s | cut -d"_" -f2 | cut -d"." -f1`
    ofile="${OUT_DIR}/tgen_$gen.html"
    lfile="tgen_$gen.html"

    rm -f $ofile
 
    cat $tfile |cut -d" " -f2| sort | uniq > /tmp/tg.u1

    for zpac in `cat /tmp/tg.u1`
     do
       grep $zpac $tfile | sed 's/_/ /g' | sed 's/-/ /g' > /tmp/tg.u2
       chr=`cat /tmp/tg.u2 | sort -n -k3 | uniq | cut -d" " -f3 | head -1`
       min=`cat /tmp/tg.u2 | sort -n -k3 | uniq |cut -d" " -f4 | head -1`
       max=`cat /tmp/tg.u2 | sort -n -k4 | uniq |cut -d" " -f5 | tail -1`

       if [ $min -gt $max ]
        then
         pom=$min
         min=$max
         max=$pom
       fi

       zex=`cat /tmp/tg.u2 | cut -d" " -f6 | sort | uniq | sed 's/e//g' `
       pom=""
       for xex in `echo $zex`
        do
         pom="$pom $xex"
        done
       zex=$pom 
       lzex=`echo $zex | sed 's/ /x/g'`

       link=`echo "<a href=\"./soft/ins_nezapomen.php?pac=$zpac&gen=$gen&chr=$chr&start=$min&odkud=$lfile&exom=$lzex\"><button>Do seznamu?</button></a>"`

       echo "<b>$zpac</b> $gen <a href=\"./soft/igv.php?chr=$chr&start=$min&pac=$zpac\" target=\"blank\">$chr $min-$max</a> exon(y) $zex $link" >> $ofile
       echo "<br>" >> $ofile

     done
 done

rm -f /tmp/tg.u1
rm -f /tmp/tg.u2

exit 0
