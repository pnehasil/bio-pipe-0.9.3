load_params "$@"

SRC_FIL=${TGT}/run_${RUN}/cnvkit/CNV_final.txt

log "Check source file"
[ -e ${SRC_FIL} ] || error_exit "source ${SRC_FIL} not found"

log "Check output folder"
OUT_DIR="${TGT}/run_${RUN}"
[ -d ${OUT_DIR} ] || error_exit "${OUT_DIR} not found"

log "Create directory structure in ${OUT_DIR}"
OUT_DIR="${TGT}/run_${RUN}/WWW"
TMP_DIR=${OUT_DIR}/tmp
GR1_DIR=${OUT_DIR}/tmp/GR1
GR2_DIR=${OUT_DIR}/tmp/GR2
GR3_DIR=${OUT_DIR}/tmp/GR3
MUMPS_DIR="${TMP_DIR}/MUMPS"
PRELEZLE=${OUT_DIR}/tmp/prelezle.txt

WEB_DIR="/mnt/sdc/www/runy"
WEB_IPA="10.2.46.147"

mkdir ${OUT_DIR} || error_exit "Cannot create ${OUT_DIR}"
mkdir ${TMP_DIR} || error_exit "Cannot create ${TMP_DIR}"
mkdir ${GR1_DIR} || error_exit "Cannot create ${GR1_DIR}"
mkdir ${GR2_DIR} || error_exit "Cannot create ${GR2_DIR}"
mkdir ${GR3_DIR} || error_exit "Cannot create ${GR3_DIR}"
mkdir ${MUMPS_DIR} || error_exit "Cannot create ${MUMPS_DIR}"

log "Create exp_lib"

echo "# This file is generated from ${WOR_PHASE_DIR}/010_create_dirs_env.sh" > ${WOR_LIB}/bioweb
echo "# ------ All changes will be lost. ------" >> ${WOR_LIB}/bioweb
echo "# " >> ${WOR_LIB}/bioweb
dt=`date`
echo "# $dt" >> ${WOR_LIB}/bioweb
echo "# " >> ${WOR_LIB}/bioweb

echo "export SRC_FIL=${SRC_FIL} " >> ${WOR_LIB}/bioweb

echo "export OUT_DIR=${OUT_DIR} " >> ${WOR_LIB}/bioweb
echo "export TMP_DIR=${TMP_DIR} " >> ${WOR_LIB}/bioweb
echo "export GR1_DIR=${GR1_DIR} " >> ${WOR_LIB}/bioweb
echo "export GR2_DIR=${GR2_DIR} " >> ${WOR_LIB}/bioweb
echo "export GR3_DIR=${GR3_DIR} " >> ${WOR_LIB}/bioweb
echo "export PRELEZLE=${PRELEZLE} " >> ${WOR_LIB}/bioweb
echo "export MUMPS_DIR=${MUMPS_DIR} " >> ${WOR_LIB}/bioweb
echo "export WEB_DIR=${WEB_DIR} " >> ${WOR_LIB}/bioweb
echo "export WEB_IPA=${WEB_IPA} " >> ${WOR_LIB}/bioweb

# server specific environment variables

if [ -e ${WOR_HOME}/${SER}.conf ]
  then
   log "Config file ${WOR_HOME}/${SER}.conf found"
   cat ${WOR_HOME}/${SER}.conf >> ${WOR_LIB}/bioweb
  else
   error_exit "Config file ${WOR_HOME}/*.conf  not found"
fi


echo "# --- end of file ---" >> ${WOR_LIB}/bioweb


chmod +x ${WOR_LIB}/bioweb


exit 0
