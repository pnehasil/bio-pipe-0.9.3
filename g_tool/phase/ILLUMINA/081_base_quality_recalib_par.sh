#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

[ -d ${REALIGNED_DIR} ] || error_exit "${REALIGNED_DIR} not found"
[ -d ${RECALIBRATED_DIR} ] || error_exit "${RECALIBRATED_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${GATK_DIR} ] || error_exit "${GATK_DIR} not found"
[ -d ${REF_GATK_DIR} ] || error_exit "${REF_GATK_DIR} not found"
[ -d ${DATABASE_GATK_DIR} ] || error_exit "${DATABASE_GATK_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_081_$(date +%y%m%d-%H%M%S).log

typeset -i MAX_JOBS

MAX_JOBS=${RECAL1_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_recal() {

    file=$1

    bf=`basename -s .picard.sorted.RG.realigned.rmdup.bam $file`
    ofile=${RECALIBRATED_DIR}/$bf.table
    rfile=${RECALIBRATED_DIR}/$bf.picard.sorted.RG.realigned.recal.rmdup.bam
    sfile=${RECALIBRATED_DIR}/$bf.after.table
    pfile=${RECALIBRATED_DIR}/$bf.recal_plots.pdf

    log "Realigment $file -> $ofile"

    ${JAVA8_BIN}/java -Xmx${RECAL1_RAM} -Djava.io.tmpdir=${G_TMP_DIR} -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T PrintReads \
    -R ${REF_GATK_DIR}/HG19uscs.fa \
    -nct 4 \
    -I $file \
    -BQSR $ofile \
    -o $rfile >> ${FLOG} 2>&1
}

###########################  MAIN ###########################

log "Starting base quality recalibration parallel process for files in ${REALIGNED_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${REALIGNED_DIR}/*.picard.sorted.RG.realigned.rmdup.bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_recal ${f} &
     else
      proc_recal ${f} 
   fi
  done
wait

log "Base quality recalibration done"

  grep -i ERROR ${FLOG}
  if [ $? -eq 0 ]
   then
     error_exit "Error found in ${FLOG}"
  fi   
