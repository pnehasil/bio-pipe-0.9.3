#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${REALIG2_PROC}
MULTIPROCESS=1                          # set to 0 for debugging
load_params "$@"

[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
[ -d ${REALIGNED_DIR} ] || error_exit "${REALIGNED_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${GATK_DIR} ] || error_exit "${GATK_DIR} not found"
[ -d ${REF_GATK_DIR} ] || error_exit "${REF_GATK_DIR} not found"
[ -d ${DATABASE_GATK_DIR} ] || error_exit "${DATABASE_GATK_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_071_$(date +%y%m%d-%H%M%S).log

proc_rel() {

    file=$1

    bf=`basename -s .picard.sorted.RG.rmdup.bam $file`
    ofile=${REALIGNED_DIR}/$bf.intervals
    rfile=${REALIGNED_DIR}/$bf.picard.sorted.RG.realigned.rmdup.bam

    log "Realigment $file -> $rfile"

    ${JAVA8_BIN}/java -Xmx${REALIG2_RAM} -Djava.io.tmpdir=${G_TMP_DIR} \
    -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T IndelRealigner \
    -R ${REF_GATK_DIR}/HG19uscs.fa \
    -L ${BED_DIR}/CZE1_2_APC_primary_targets.bed \
    -ip 300 \
    -I $file \
    -known ${DATABASE_GATK_DIR}/Mills_and_1000G_gold_standard.indels.hg19_resorted.vcf \
    -targetIntervals $ofile \
    -o $rfile >> ${FLOG} 2>&1
}

###########################  MAIN ###########################


log "Starting realigment picard parallel process for files in ${RG_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RG_DIR}/*bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_rel ${f} &
     else
      proc_rel ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

log "Realigment done"
