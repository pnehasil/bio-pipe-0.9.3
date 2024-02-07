#!/usr/bin/env ksh93

load_params "$@"

log "Copy bam fies"
 
. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv


BAM_DIR="${OUT_DIR}/bam"
mkdir ${BAM_DIR} || error_exit "Cannot create ${BAM_DIR}"

#001_PKM98_run118.picard.sorted.RG.realigned.recal.rmdup.bai
#001_PKM98_run118.picard.sorted.RG.realigned.recal.rmdup.bam

for file in `ls ${RECALIBRATED_DIR}/*recal.rmdup.bai`
  do
    bf=`basename $file`
    ext=`echo $bf | cut -d"." -f8`
    base=`echo $bf | cut -d"." -f1 | cut -d"_" -f2`
    cp $file ${BAM_DIR}/$base.$ext
  done


for file in `ls ${RECALIBRATED_DIR}/*recal.rmdup.bam`
  do
    bf=`basename $file`
    ext=`echo $bf | cut -d"." -f8`
    base=`echo $bf | cut -d"." -f1 | cut -d"_" -f2`
    cp $file ${BAM_DIR}/$base.$ext
  done
