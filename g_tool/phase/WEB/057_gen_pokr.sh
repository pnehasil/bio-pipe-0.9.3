#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=8
MULTIPROCESS=1                          # set to 0 for debugging
TRS=25

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

proc_pok() {

    file=$1
    XTMP_DIR=${POK_DIR}/$2
    mkdir ${XTMP_DIR}
 
    tmp1=${XTMP_DIR}/tmp1.txt 
    tmp2=${XTMP_DIR}/tmp2.txt 
    tmp3=${XTMP_DIR}/tmp3.txt 
    tmp4=${XTMP_DIR}/tmp4.txt 

    bf=`basename -s .picard.sorted.RG.rmdup.bam $file`
    ofile=${POK_DIR}/$bf.txt
    dfile=${POK_DIR}/$bf.fin

    log "Samtools $file -> $ofile"
    ${SAMTOOLS_DIR}/samtools depth -b ${BED_DIR}/pokryti_pojistovna_sort.bed $file > $ofile
 
    rm -f $tmp1
    rm -f $tmp2
    rm -f $tmp3
    rm -f $tmp4

log "${XTMP_DIR}/tmp1 start"

    # setridime podle pokryti a vezmeme odshora az do TRS
    cat $ofile | sort -k3 -n | sed 's/\t/|/g' > $tmp1
    for line in `cat $tmp1`
     do
       hod=`echo $line | cut -d"|" -f3`
       if [ $hod -lt $TRS ]
        then
         echo $line >> $tmp2
        else
         break
       fi
     done

log "${XTMP_DIR}/tmp2 OK"

     cat $tmp2 | sed 's/|/\t/g' | sort -n -k2 | sed 's/\t/|/g' > $tmp3

log "${XTMP_DIR}/tmp3 OK"

     # ze souvisleho intervalu vezmeme jen prvni a posledni clen
     last=0
     for line in `cat $tmp3`
      do
        hod=`echo $line | cut -d"|" -f2`
        xhod=`expr $hod - 1`
        if [ $xhod -ne $last ]
         then
          echo $lline >> $tmp4
          echo $line >> $tmp4
          last=$hod
          lline=$line
         else
          lline=$line
          last=$hod
        fi
      done
     tail -1 $tmp3 >> $tmp4
     sed -i '1d' $tmp4

log "${XTMP_DIR}/tmp4 OK"

     # a ted vytvorime zacatek|konec intervalu
     last=0
     for line in `cat $tmp4`
      do
        if [ $last -eq 0 ]
         then
          #lichy radek
          lline=$line
          last=1
         else
          #sudy radek
          echo "$lline|$line" >> $dfile
          last=0
        fi
      done

log "$dfile OK"

    #rm -f $tmp1
    #rm -f $tmp2
    #rm -f $tmp3
    #rm -f $tmp4

}

###########################  MAIN ###########################


log "Gen pokryti parallel process for files in ${RG_DIR} max ${MAX_JOBS} job(s"

POK_DIR="${OUT_DIR}/pokryti"
mkdir -p ${POK_DIR}
CNT=0

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RG_DIR}/*bam`
 do
   CNT=`expr $CNT + 1`
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_pok ${f} ${CNT} &
     else
      proc_pok ${f} ${CNT}
   fi
 done
wait

#samtools depth -b ./pokryti_pojistovna_sort.bed ./007_BRCA5728_run38.picard.sorted.RG.realigned.recal.rmdup.bam > ./pokryti_5728.txt
