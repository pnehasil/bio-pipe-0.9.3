#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${CR_VCF0_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${RECALIBRATED_DIR} ] || error_exit "${RECALIBRATED_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${REF_GATK_DIR} ] || error_exit "${REF_GATK_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_141_$(date +%y%m%d-%H%M%S).log

proc_pic() {

    file=$1

    bf=`basename -s .picard.sorted.RG.realigned.recal.rmdup.bam $file`
    ofile=${GATK3_VCF_DIR}/$bf.GATK_regions.vcf

    log "$file -> $ofile"

    ${JAVA8_BIN}/java -Djava.io.tmpdir=${G_TMP_DIR} -Xmx${CR_VCF0_RAM} \
    -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T HaplotypeCaller \
    -R ${REF_GATK_DIR}/HG19uscs.fa \
    -I $file \
    -L ${BED_DIR}/CZE1_2_APC_primary_targets.bed \
    -o $ofile \
    -ip 300 \
    -stand_call_conf 30 >> ${FLOG} 2>&1

# nebo misto stand_call dat
# --emitRefConfidence GVCF?

}

###########################  MAIN ###########################

log "Starting create_vcf_jed parallel process for files in ${RECALIBRATED_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
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

log "Create_vcf_jed done"
