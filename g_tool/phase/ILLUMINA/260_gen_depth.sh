#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=40
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${VARSC_DIR} ] || error_exit "${VARSC_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_260_$(date +%y%m%d-%H%M%S).log

proc_pic() {

    file=$1

    bf=`basename -s .picard.sorted.RG.realigned.recal.rmdup.bam $file`
    outf=${RECALIBRATED_DIR}/$bf.dep

    echo $outf
    ${SAMTOOLS_DIR}/samtools depth $file > $outf


}

###########################  MAIN ###########################

log "Starting depth max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

for f in `ls ${RECALIBRATED_DIR}/*.bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_pic ${f} &
     else
      proc_pic ${f} 
   fi
  done
wait

cat ${FLOG} | grep -i ERROR
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Depth done"
