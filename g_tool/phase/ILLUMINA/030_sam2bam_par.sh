#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${SAM2BAM_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

log "### SAM to BAM & sort ###"

[ -d ${SAM_DIR} ] || error_exit "${SAM_DIR} not found"
[ -d ${SORT_DIR} ] || error_exit "${SORT_DIR} not found"
[ -d ${PICARD_DIR} ] || error_exit "${PICARD_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_030_$(date +%y%m%d-%H%M%S).log

proc_bam() {

     file=$1
     log "Start sam2bam $file "

     bf=`basename -s .sam $file`
     bfile="${SORT_DIR}/$bf.picard.sorted.bam"

     log "$file -> $bfile"
     ${JAVA8_BIN}/java -Djava.io.tmpdir=${G_TMP_DIR} -Xmx${SAM2BAM_RAM} \
     -jar ${PICARD_DIR}/picard.jar SortSam \
     I=$file \
     O=$bfile \
     SO=coordinate >> ${FLOG} 2>&1

     log "End sam2bam $file "
}

###########################  MAIN ###########################

log "Starting sam2bam picard parallel process for files in ${SAM_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${SAM_DIR}/*sam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_bam ${f} &
     else
      proc_bam ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

log "Sam2bam done"
