#!/usr/bin/env ksh93
# this scripts executes parallelized translate of fastq files
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=24
MULTIPROCESS=1                          # set to 0 for debugging


proc_fasq() {

file=$1
for line in `cat $file | tr '\t' '|'`
  do 

    # novy cnv
    chr=`echo $line | cut -d"|" -f1`
    k1=`echo $line | cut -d"|" -f2`
    k2=`echo $line | cut -d"|" -f3`
    #gen=`echo $line | cut -d"|" -f4`
    gen=`echo $line | cut -d"|" -f4 | cut -d"_" -f1`
    #pac=`echo $line | cut -d"|" -f7`
    pac=`echo $line | cut -d"|" -f6`
    hod=`echo $line | cut -d"|" -f5` 
    #xhod=`echo $line | cut -d"|" -f6` 
    #hod=`echo "scale=7; $xhod*0.998-6.6475" | bc`
    #UBE4B_4


 if [ "$gen" == "-1" ]
  then
    echo " gen -1"
  else
    echo "$chr$pod$k1$pod$k2 $gen $pac $hod" >> ${TMP_DIR}/tmp1.txt
    echo "$chr$pod$k1$pod$k2|$gen|$pac|$hod" >> ${TMP_DIR}/ZTMP/$chr$pod$k1$pod$k2.txt
  fi
   
  done 
}



###########################  MAIN ###########################

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "### Format ${SRC_FIL} in ${MAX_JOBS} processes ###"

[ -d ${OUT_DIR} ] || error_exit "${OUT_DIR} not found"

# zkontrolujeme, jestli lsou v CNV_final.txt vsichni pacosi
# kteri maji fastq

log "Check CNV_final.txt"
for pfast in `ls ${SRC}/*R1.fastq.gz | cut -f 1-3 -d "_"`
  do
    bf=`basename -s .fastq.gz $pfast`
    grep -m1 $bf ${SRC_FIL} > /dev/null
    if [ $? -eq 0 ]
    then
	    log "$bf OK"
    else
	    error_exit "$bf is'nt in ${SRC_FIL}"
    fi
  done

# z CNV_final.txt vybereme jen co nas zajima
# a vhodne zmenime oddelovace kvuli sortovani

pod="_"
rm -f ${TMP_DIR}/tmp1.txt
rm -f ${TMP_DIR}/tmp2.txt

log "TR -> ${TMP_DIR}/tmp1.txt"

mkdir ${TMP_DIR}/ZTMP
mkdir ${TMP_DIR}/ztmp
split -l 10000 ${SRC_FIL}  ${TMP_DIR}/ztmp/xx_

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${TMP_DIR}/ztmp/xx_*`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_fasq ${f} &
     else
      proc_fasq ${f} 
   fi
  done
wait

#rm -rf ${TMP_DIR}/ZTMP
#rm -rf ${TMP_DIR}/ztmp

log "### Format ${SRC_FIL} End ###"

exit 0
