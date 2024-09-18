#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=10
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${RECALIBRATED_DIR} ] || error_exit "${RECALIBRATED_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${VARSC_DIR} ] || error_exit "${VARSC_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_215_$(date +%y%m%d-%H%M%S).log

proc() {

    file=$1

    bf=`basename -s .picard.sorted.RG.realigned.recal.rmdup.bam $file`
    ofile=${VARSC_DIR}/xgrep/$bf.cnt
    tfile=${VARSC_DIR}/xgrep/$bf.sel.bam
    utfile=${VARSC_DIR}/xgrep/$bf.sel.up.bam

    ${SAMTOOLS_DIR}/samtools view $file "chr2:47641559-47641561" | cut -f4,10 > $tfile 2>>${FLOG}

    rm -f $utfile
    for line in `cat $tfile | sed 's/\t/#/'`
       do
	  kor1=`echo $line | cut -d"#" -f1`
	  str=`echo $line | cut -d"#" -f2`

	  if [ $kor1 -lt 47641558 ]
	    then
               odecist=`expr 47641558 - $kor1`
	       upstr=${str:$odecist:30}
	       echo $upstr >> $utfile
             else
	       upstr=${str:0:30}
	       echo $upstr >> $utfile
	  fi
       done

    mutG=`grep GAAAAAAAAAAAA $utfile | wc -l`
    allG=`grep AAAAAAAAAAAAA $utfile | wc -l`

    mutT=`grep TTAAAAAAAAAAA $utfile | wc -l`
    allT=`grep AAAAAAAAAAAAA $utfile | wc -l`

    echo $bf#$mutG#$allG#$mutT#$allT > $ofile

    log "END $file -> $ofile"


}

###########################  MAIN ###########################

log "Starting grepGA parallel process for files in ${VARSC_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

mkdir -p ${VARSC_DIR}/xgrep || error_exit "Cannot create ${VASRC_DIR}/xgrep"

for f in `ls ${RECALIBRATED_DIR}/*.picard.sorted.RG.realigned.recal.rmdup.bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc ${f} &
     else
      proc ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "GrepGA done"
