load_params "$@"

log "Check source folder ${SRC}"

[ -e ${SRC}/*R1.fastq.gz ] || error_exit "source *fastq.gz not found"

# pridat kontrolu, jesti kazdy R1 ma R2

log "Create directory structure in ${TGT}"

OUT_DIR="${TGT}/run_${RUN}"
[ -d ${OUT_DIR} ] && error_exit "${OUT_DIR} exist"

RG_DIR="${OUT_DIR}/RG"
SAM_DIR="${OUT_DIR}/sam"
MAPS_DIR="${OUT_DIR}/mapstat"
SORT_DIR="${OUT_DIR}/sorted_bam"
RMDUP_DIR="${OUT_DIR}/rmdup_bam"
REALIGNED_DIR="${OUT_DIR}/realigned"
RECALIBRATED_DIR="${OUT_DIR}/recalibrated"
GATK_VCF_DIR="${OUT_DIR}/GATK_VCF"
GATK_VCF_JED="${OUT_DIR}/GATK_VCF/jednotlive"
GATK_VCF_JED_GEM="${OUT_DIR}/GATK_VCF/jednotlive/gemini"
VCF_DIR="${OUT_DIR}/vcf"
VCF_TABIX_DIR="${OUT_DIR}/vcf/tabix_vcf"
FPIC_DIR="${OUT_DIR}/picard"
GVCF_DIR="${OUT_DIR}/GVCF"
CNV_KIT_DIR="${OUT_DIR}/cnvkit"
FPIN_DIR="${OUT_DIR}/pindel"
NPIN_DIR="${OUT_DIR}/pindel/novy"
GATK3_VCF_DIR="${OUT_DIR}/GATK3"
GATK4_VCF_DIR="${OUT_DIR}/GATK4"
GVCF3_DIR="${OUT_DIR}/GVCF3"
GVCF4_DIR="${OUT_DIR}/GVCF4"


log "Check ref folder ${REF}"

SNPEFF_DIR="${REF}/snpeff_dir"
#[ -d ${SNPEFF_DIR} ] || error_exit "${SNPEFF_DIR} not found"

GATK_DIR="${REF}/gatk_dir"
[ -d ${GATK_DIR} ] || error_exit "${GATK_DIR} not found"

GATK4_DIR="${REF}/gatk4_dir"
[ -d ${GATK4_DIR} ] || error_exit "${GATK4_DIR} not found"

REF_GATK_DIR="${REF}/ref_gatk_dir"
[ -d ${REF_GATK_DIR} ] || error_exit "${REF_GATK_DIR} not found"

DATABASE_GATK_DIR="${REF}/database_gatk_dir"
[ -d ${REF_GATK_DIR} ] || error_exit "${REF_GATK_DIR} not found"

NOVOALIGN_DIR="${REF}/novoalign"
[ -d ${NOVOALIGN} ] || error_exit "${NOVOALIGN} not found"

PICARD_DIR="${REF}/picard"
[ -d ${PICARD_DIR} ] || error_exit "${PICARD_DIR} not found"

REF_DIR="${REF}/reference"
[ -d ${REF_DIR} ] || error_exit "${REF_DIR} not found"

BED_DIR="${REF}/bed_dir"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"

SAMTOOLS_DIR="${REF}/samtools"
[ -d ${SAMTOOLS_DIR} ] || error_exit "${SAMTOOLS_DIR} not found"

BCFTOOLS_DIR="${REF}/bcftools"
[ -d ${BCFTOOLS_DIR} ] || error_exit "${BCFTOOLS_DIR} not found"

BCFTOOLS_13_DIR="${REF}/bcftools_1.3"
[ -d ${BCFTOOLS_13_DIR} ] || error_exit "${BCFTOOLS_13_DIR} not found"

BEDTOOLS_DIR="${REF}/bedtools"
[ -d ${BEDTOOLS_DIR} ] || error_exit "${BEDTOOLS_DIR} not found"

CNV_KIT="${REF}/cnvkit"
#[ -d ${CNV_KIT} ] || error_exit "${CNV_KIT} not found"

PINDEL_DIR="${REF}/pindel"
#[ -d ${PINDEL_DIR} ] || error_exit "${PINDEL_DIR} not found"

VT_DIR="${REF}/vt_dir"
[ -d ${VT_DIR} ] || error_exit "${VT_DIR} not found"

TABIX_DIR="${REF}/tabix_dir"
[ -d ${TABIX_DIR} ] || error_exit "${TABIX_DIR} not found"

GEMINI_DIR="${REF}/gemini_dir"
[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"

GEMINI_DATA="${REF}/gemini_data"
[ -d ${GEMINI_DATA} ] || error_exit "${GEMINI_DATA} not found"

VEP_DIR="${REF}/vep_dir"
[ -d ${VEP_DIR} ] || error_exit "${VEP_DIR} not found"

VEP_CACHE="${REF}/vep_cache"
[ -d ${VEP_CACHE} ] || error_exit "${VEP_CACHE} not found"

BIN_DIR="${REF}/bin_dir"
#[ -d ${BIN_DIR} ] || error_exit "${BIN_DIR} not found"

JAVA8_BIN="${REF}/java8_bin"
[ -d ${JAVA8_BIN} ] || error_exit "${JAVA8_BIN} not found"

mkdir ${OUT_DIR} || error_exit "Cannot create ${OUT_DIR}"
mkdir ${RG_DIR} || error_exit "Cannot create ${RG_DIR}"
mkdir ${SAM_DIR} || error_exit "Cannot create ${SAM_DIR}"
mkdir ${MAPS_DIR} || error_exit "Cannot create ${MAPS_DIR}"
mkdir ${SORT_DIR} || error_exit "Cannot create ${SORT_DIR}"
mkdir ${RMDUP_DIR} || error_exit "Cannot create ${RMDUP_DIR}"
mkdir ${REALIGNED_DIR} || error_exit "Cannot create ${REALIGNED_DIR}"
mkdir ${RECALIBRATED_DIR} || error_exit "Cannot create ${RECALIBRATED_DIR}"
mkdir ${GATK_VCF_DIR} || error_exit "Cannot create ${GATK_VCF_DIR}"
mkdir ${GATK_VCF_JED} || error_exit "Cannot create ${GATK_VCF_JED}"
mkdir ${GATK_VCF_JED_GEM} || error_exit "Cannot create ${GATK_VCF_JED_GEM}"
mkdir ${VCF_DIR} || error_exit "Cannot create ${VCF_DIR}"
mkdir ${VCF_TABIX_DIR} || error_exit "Cannot create ${VCF_TABIX_DIR}"
mkdir ${FPIC_DIR} || error_exit "Cannot create ${FPIC_DIR}"
mkdir ${FPIN_DIR} || error_exit "Cannot create ${FPIN_DIR}"
mkdir ${NPIN_DIR} || error_exit "Cannot create ${NPIN_DIR}"
mkdir ${GVCF_DIR} || error_exit "Cannot create ${GVCF_DIR}"
mkdir ${CNV_KIT_DIR} || error_exit "Cannot create ${CNV_KIT_DIR}"
mkdir ${GATK3_VCF_DIR} || error_exit "Cannot create ${GATK3_VCF_DIR}"
mkdir ${GATK4_VCF_DIR} || error_exit "Cannot create ${GATK4_VCF_DIR}"
mkdir ${GVCF3_DIR} || error_exit "Cannot create ${GVCF3_DIR}"
mkdir ${GVCF4_DIR} || error_exit "Cannot create ${GVCF4_DIR}"

log "Create exp_lib"

echo "# This file is generated from ${WOR_PHASE_DIR}/010_create_dirs_env.sh" > ${WOR_LIB}/bioenv
echo "# ------ All changes will be lost. ------" >> ${WOR_LIB}/bioenv
echo "# " >> ${WOR_LIB}/bioenv
dt=`date`
echo "# $dt" >> ${WOR_LIB}/bioenv
echo "# " >> ${WOR_LIB}/bioenv

echo "export RG_DIR=${RG_DIR} " >> ${WOR_LIB}/bioenv
echo "export SAM_DIR=${SAM_DIR} " >> ${WOR_LIB}/bioenv
echo "export MAPS_DIR=${MAPS_DIR} " >> ${WOR_LIB}/bioenv
echo "export SORT_DIR=${SORT_DIR} " >> ${WOR_LIB}/bioenv
echo "export RMDUP_DIR=${RMDUP_DIR} " >> ${WOR_LIB}/bioenv
echo "export REALIGNED_DIR=${REALIGNED_DIR} " >> ${WOR_LIB}/bioenv
echo "export RECALIBRATED_DIR=${RECALIBRATED_DIR} " >> ${WOR_LIB}/bioenv
echo "export GATK_VCF_DIR=${GATK_VCF_DIR} " >> ${WOR_LIB}/bioenv
echo "export GATK_VCF_JED=${GATK_VCF_JED} " >> ${WOR_LIB}/bioenv
echo "export GATK_VCF_JED_GEM=${GATK_VCF_JED_GEM} " >> ${WOR_LIB}/bioenv
echo "export GATK_VCF_JED_ANO=${GATK_VCF_JED_ANO} " >> ${WOR_LIB}/bioenv
echo "export VCF_DIR=${VCF_DIR} " >> ${WOR_LIB}/bioenv
echo "export VCF_TABIX_DIR=${VCF_TABIX_DIR} " >> ${WOR_LIB}/bioenv
echo "export FPIC_DIR=${FPIC_DIR} " >> ${WOR_LIB}/bioenv
echo "export FPIN_DIR=${FPIN_DIR} " >> ${WOR_LIB}/bioenv
echo "export NPIN_DIR=${NPIN_DIR} " >> ${WOR_LIB}/bioenv
echo "export GVCF_DIR=${GVCF_DIR} " >> ${WOR_LIB}/bioenv
echo "export CNV_KIT_DIR=${CNV_KIT_DIR} " >> ${WOR_LIB}/bioenv
echo "export GATK3_VCF_DIR=${GATK3_VCF_DIR} " >> ${WOR_LIB}/bioenv
echo "export GATK4_VCF_DIR=${GATK4_VCF_DIR} " >> ${WOR_LIB}/bioenv
echo "export GVCF3_DIR=${GVCF3_DIR} " >> ${WOR_LIB}/bioenv
echo "export GVCF4_DIR=${GVCF4_DIR} " >> ${WOR_LIB}/bioenv

echo "# " >> ${WOR_LIB}/bioenv

echo "export NOVOALIGN_DIR=${NOVOALIGN_DIR} " >> ${WOR_LIB}/bioenv
echo "export PICARD_DIR=${PICARD_DIR} " >> ${WOR_LIB}/bioenv
echo "export REF_DIR=${REF_DIR} " >> ${WOR_LIB}/bioenv
echo "export SAMTOOLS_DIR=${SAMTOOLS_DIR} " >> ${WOR_LIB}/bioenv
echo "export BCFTOOLS_DIR=${BCFTOOLS_DIR} " >> ${WOR_LIB}/bioenv
echo "export BCFTOOLS_13_DIR=${BCFTOOLS_13_DIR} " >> ${WOR_LIB}/bioenv
echo "export BEDTOOLS_DIR=${BEDTOOLS_DIR} " >> ${WOR_LIB}/bioenv
echo "export GATK_DIR=${GATK_DIR} " >> ${WOR_LIB}/bioenv
echo "export GATK4_DIR=${GATK4_DIR} " >> ${WOR_LIB}/bioenv
echo "export REF_GATK_DIR=${REF_GATK_DIR} " >> ${WOR_LIB}/bioenv
echo "export DATABASE_GATK_DIR=${DATABASE_GATK_DIR} " >> ${WOR_LIB}/bioenv
echo "export BED_DIR=${BED_DIR} " >> ${WOR_LIB}/bioenv
echo "export SNPEFF_DIR=${SNPEFF_DIR} " >> ${WOR_LIB}/bioenv
echo "export CNV_KIT=${CNV_KIT} " >> ${WOR_LIB}/bioenv
echo "export PINDEL_DIR=${PINDEL_DIR} " >> ${WOR_LIB}/bioenv
echo "export VT_DIR=${VT_DIR} " >> ${WOR_LIB}/bioenv
echo "export TABIX_DIR=${TABIX_DIR} " >> ${WOR_LIB}/bioenv
echo "export GEMINI_DIR=${GEMINI_DIR} " >> ${WOR_LIB}/bioenv
echo "export GEMINI_DATA=${GEMINI_DATA} " >> ${WOR_LIB}/bioenv
echo "export VEP_DIR=${VEP_DIR} " >> ${WOR_LIB}/bioenv
echo "export VEP_CACHE=${VEP_CACHE} " >> ${WOR_LIB}/bioenv
echo "export BIN_DIR=${BIN_DIR} " >> ${WOR_LIB}/bioenv
echo "export JAVA8_BIN=${JAVA8_BIN} " >> ${WOR_LIB}/bioenv

# server specific environment variables

if [ -e ${WOR_HOME}/${SER}.conf ]
  then
   log "Config file ${WOR_HOME}/${SER}.conf found"
   cat ${WOR_HOME}/${SER}.conf >> ${WOR_LIB}/bioenv
  else
   error_exit "Config file ${WOR_HOME}/*.conf  not found" 
fi

export PATH=${GEMINI_DIR}:$PATH

echo "# --- end of file ---" >> ${WOR_LIB}/bioenv


chmod +x ${WOR_LIB}/bioenv


exit 0
