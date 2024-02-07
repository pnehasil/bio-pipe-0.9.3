#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${HS_METRICS_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

log "### Hs metrics seqcap V3 ###"

[ -d ${REF_DIR} ] || error_exit "${REF_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${RMDUP_DIR} ] || error_exit "${RMDUP_DIR} not found"
[ -d ${PICARD_DIR} ] || error_exit "${PICARD_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_090_$(date +%y%m%d-%H%M%S).log

proc_pic() {

     file=$1

    bf=`basename -s .picard.sorted.rmdup.bam $file`
    ofile=${FPIC_DIR}/$bf.V3.hs.metrics.txt
    tfile=${FPIC_DIR}/$bf.V3.coverage_per_target.txt

    log "Picard $file -> $ofile"
    ${JAVA8_BIN}/java -Xmx${HS_METRICS_RAM} -Djava.io.tmpdir=${G_TMP_DIR} \
    -jar ${PICARD_DIR}/picard.jar CalculateHsMetrics \
    BAIT_INTERVALS=${BED_DIR}/CZE1_2_APC_primary_targets_upr.txt \
    TARGET_INTERVALS=${BED_DIR}/CZE1_2_APC_primary_targets_upr.txt \
    INPUT=$file \
    OUTPUT=$ofile \
    PER_TARGET_COVERAGE=$tfile \
    REFERENCE_SEQUENCE=${REF_DIR}/HG19uscs.fa >> ${FLOG} 2>&1
}

###########################  MAIN ###########################

log "Starting hs metrics seqcap V3 picard parallel process for files in ${RMDUP_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RMDUP_DIR}/*.picard.sorted.rmdup.bam`;
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

log "Hs metrics seqcap V3 picard done"
