#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${BAM_IDX_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

log "### Indexing parallel ###"

[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
[ -d ${SAMTOOLS_DIR} ] || error_exit "${SAMTOOLS_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_060_$(date +%y%m%d-%H%M%S).log

proc_idx() {

     file=$1
     log "Start indexing $file"
     ${SAMTOOLS_DIR}/samtools index $file >> ${FLOG} 2>&1
     log "End indexing $file"
}

###########################  MAIN ###########################

log "### Indexing parallel process for files in ${RMDUP_DIR} max ${MAX_JOBS} job(s) ###"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RG_DIR}/*bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_idx ${f} &
     else
      proc_idx ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Indexing done"
