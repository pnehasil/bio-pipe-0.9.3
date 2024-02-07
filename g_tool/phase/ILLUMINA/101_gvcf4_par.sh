#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GVCF_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${RECALIBRATED_DIR} ] || error_exit "${RECALIBRATED_DIR} not found"
[ -d ${GVCF_DIR} ] || error_exit "${GVCF_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_101_$(date +%y%m%d-%H%M%S).log

proc_vcf() {

    file=$1
    bf=`basename -s .picard.sorted.RG.realigned.recal.rmdup.bam $file`
    ofile=${GVCF4_DIR}/$bf.g.vcf

    log "GVCF4 $file -> $ofile"
    ${GATK4_DIR}/gatk --java-options "-Xmx${CR_VCF0_RAM} -Djava.io.tmpdir=${G_TMP_DIR}" HaplotypeCaller \
    -R ${REF_GATK_DIR}/HG19uscs.fa \
    -I $file \
    -L ${BED_DIR}/CZE1_2_APC_primary_targets.bed \
    -ip 300 \
    -O $ofile \
    --emit-ref-confidence GVCF >> ${FLOG} 2>&1

}


###########################  MAIN ###########################

log "Create GVCF parallel process for files in ${RECALIBRATED_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RECALIBRATED_DIR}/*.picard.sorted.RG.realigned.recal.rmdup.bam`;
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_vcf ${f} &
     else
      proc_vcf ${f} 
   fi
  done
wait


TMP_FIL="${G_TMP_DIR}/src4_tmp_$$"
log "Create ad hoc script ${TMP_FIL}"

log "Create ${GVCF4_DIR}/dohromady.g.vcf"

echo "${JAVA8_BIN}/java -Djava.io.tmpdir=${G_TMP_DIR} -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T CombineGVCFs \\" > ${TMP_FIL}
echo "-R ${REF_GATK_DIR}/HG19uscs.fa \\" >> ${TMP_FIL}
for xfile in `ls ${GVCF4_DIR}/*.g.vcf | grep -v dohromady`
   do
echo "     --variant $xfile \\" >> ${TMP_FIL}
   done
echo "-o ${GVCF4_DIR}/dohromady.g.vcf >> ${FLOG} 2>&1" >> ${TMP_FIL}

log "Run script ${TMP_FIL}"
ksh ${TMP_FIL}
[ -e ${GVCF4_DIR}/dohromady.g.vcf ] || error_exit "Unexpected error found 8-)"
rm ${TMP_FIL}

log "Create ${GVCF4_DIR}/dohromady.vcf"
/usr/lib/jvm/java-8-openjdk-amd64/bin/java -Djava.io.tmpdir=${G_TMP_DIR} -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T GenotypeGVCFs \
-R ${REF_GATK_DIR}/HG19uscs.fa \
--variant ${GVCF4_DIR}/dohromady.g.vcf \
-o ${GVCF4_DIR}/dohromady.vcf >> ${FLOG} 2>&1

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Create GVCF4 done"
