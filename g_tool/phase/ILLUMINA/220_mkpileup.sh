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

FLOG=${WOR_LOGDIR}/${phase}_220_$(date +%y%m%d-%H%M%S).log

proc_pic() {

    file=$1

    bf=`basename -s .picard.sorted.RG.realigned.recal.rmdup.bam $file`
    ofile=${VARSC_DIR}/Pil/$bf.pileup
    tfile=${VARSC_DIR}/Pil/$bf.sel.bam

    ${SAMTOOLS_DIR}/samtools view -b $file "chr2:47641559-47641561" > $tfile 2>>${FLOG}
    ${SAMTOOLS_DIR}/samtools mpileup -f ${REF_DIR}/HG19uscs.fa $tfile > $ofile 2>>${FLOG}
    #rm -f $tfile

    log "END $file -> $ofile"


}

###########################  MAIN ###########################

log "Starting mkpil parallel process for files in ${VARSC_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

mkdir -p ${VARSC_DIR}/Pil || error_exit "Cannot create ${VASRC_DIR}/Pil"

for f in `ls ${RECALIBRATED_DIR}/*.picard.sorted.RG.realigned.recal.rmdup.bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_pic ${f} &
     else
      proc_pic ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Mkpil done"
