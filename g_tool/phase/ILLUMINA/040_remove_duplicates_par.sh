#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${RMDUP_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${SORT_DIR} ] || error_exit "${SORT_DIR} not found"
[ -d ${RMDUP_DIR} ] || error_exit "${RMDUP_DIR} not found"
[ -d ${PICARD_DIR} ] || error_exit "${PICARD_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_040_$(date +%y%m%d-%H%M%S).log

proc_rem() {

     file=$1
     bf=`basename -s .bam $file`
     ofile="$bf.rmdup.bam"
     mfile="$bf.rmstat.metrics"

     log "Start $file -> ${RMDUP_DIR}/$ofile"

     ${JAVA8_BIN}/java -Xmx${RMDUP_RAM} -Djava.io.tmpdir=${G_TMP_DIR} \
     -jar ${PICARD_DIR}/picard.jar MarkDuplicates \
      I=$file \
      O=${RMDUP_DIR}/$ofile \
      M=${MAPS_DIR}/$mfile >> ${FLOG} 2>&1

     log "End $file -> ${RMDUP_DIR}/$ofile"

}

###########################  MAIN ###########################

log "### Remove duplicates parallel process for files in ${SORT_DIR} max ${MAX_JOBS} job(s) ###"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${SORT_DIR}/*bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_rem ${f} &
     else
      proc_rem ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Remove duplicates done"
