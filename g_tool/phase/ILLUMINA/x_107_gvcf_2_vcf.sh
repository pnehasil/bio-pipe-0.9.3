#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

FLOG=${WOR_LOGDIR}/${phase}_107_$(date +%y%m%d-%H%M%S).log

log "Create VCF for files in ${GVCF_DIR} "

TMP_FIL="${G_TMP_DIR}/src_tmp_$$"
log "Create ad hoc script ${TMP_FIL}"

log "Create ${GVCF_DIR}/dohromady.g.vcf"

echo "${JAVA8_BIN}/java -Djava.io.tmpdir=${G_TMP_DIR} -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T CombineGVCFs \\" > ${TMP_FIL}
echo "-R ${REF_GATK_DIR}/HG19uscs.fa \\" >> ${TMP_FIL}
for xfile in `ls ${GVCF_DIR}/*.g.vcf | grep -v dohromady`
   do
echo "     --variant $xfile \\" >> ${TMP_FIL}
   done
echo "-o ${GVCF_DIR}/dohromady.g.vcf >> ${FLOG} 2>&1" >> ${TMP_FIL}

log "Run script ${TMP_FIL}"
ksh ${TMP_FIL}
[ -e ${GVCF_DIR}/dohromady.g.vcf ] || error_exit "Unexpected error found 8-)"
rm ${TMP_FIL}

exit ###################

log "Create ${GVCF_DIR}/dohromady.vcf"
${JAVA8_BIN}/java -Djava.io.tmpdir=${G_TMP_DIR} -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T GenotypeGVCFs \
-R ${REF_GATK_DIR}/HG19uscs.fa \
--variant ${GVCF_DIR}/dohromady.g.vcf \
-o ${GVCF_DIR}/dohromady.vcf >> ${FLOG} 2>&1

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Create VCF done"
