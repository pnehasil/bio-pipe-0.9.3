#!/usr/bin/env ksh93

load_params "$@"

log "Gen csv and sql"
 
. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

FLOG=${WOR_LOGDIR}/${phase}_61_$(date +%y%m%d-%H%M%S).log


SRC_VIK="${BED_DIR}/CZE1.1_ctrls_1662_viktor.txt"
[ -e ${SRC_VIK} ] || error_exit "source ${SRC_VIK} not found"

SRC_DIR="${TGT}/run_${RUN}/GATK_VCF/jednotlive/gemini"

OUT_DIR="${OUT_DIR}/TABS"

TMP_FIL=${TMP_DIR}/vik_tmp.txt
ZWR_FIL=${TMP_DIR}/vik_tmp.zwr

cat ${SRC_VIK} | cut -f1-3,7,8,143,145 | sed 's/\t/|/g' > ${TMP_FIL}
sed -i '1d' ${TMP_FIL}

gen_vzwr ${TMP_FIL} ${ZWR_FIL} "^VIKO" 
mupip_load ${GTM_DIR} ${ZWR_FIL} "-for=zwr" > ${FLOG} 2>&1

# load PTScarr a SCTRLS
log "Load sctrls.zwr"
ZWR_SCTR="${BED_DIR}/sctrls.zwr"
[ -e ${ZWR_SCTR} ] || error_exit "source ${ZWR_SCTR} not found"
mupip_load ${GTM_DIR} ${ZWR_SCTR} "-for=zwr" > ${FLOG} 2>&1


log "Load ptscarr.zwr"
ZWR_PTSC="${BED_DIR}/ptscarr.zwr"
[ -e ${ZWR_PTSC} ] || error_exit "source ${ZWR_PTSC} not found"
mupip_load ${GTM_DIR} ${ZWR_PTSC} "-for=zwr" > ${FLOG} 2>&1


#001_PKM85_run118.GATK_regions.web
for file in `ls ${SRC_DIR}/*GATK_regions.web`
  do
    bf=`basename -s .GATK_regions.web $file` 
    ofile=${OUT_DIR}/$bf.zwr
    pac=`echo $bf | cut -d"_" -f1,2`
   
   gen_zwr $file $pac "^WTMP" $ofile
   mupip_load ${GTM_DIR} $ofile "-for=zwr" >> ${FLOG} 2>&1

  done

#001_PKM85_run118.GATK_regions_vep.web
for file in `ls ${SRC_DIR}/*GATK_regions_vep.web`
  do
    bf=`basename -s .GATK_regions_vep.web $file` 
    ofile=${OUT_DIR}/$bf.vep.zwr
    pac=`echo $bf | cut -d"_" -f1,2`
   
   gen_vepzwr $file $pac "^VEP" $ofile
   mupip_load ${GTM_DIR} $ofile "-for=zwr" >> ${FLOG} 2>&1

  done

#007_BRCA7475_run73.pindel.web
for file in `ls ${NPIN_DIR}/*pindel.web`
  do
    bf=`basename -s .pindel.web $file` 
    ofile=${OUT_DIR}/$bf.pin.zwr
    pac=`echo $bf | cut -d"_" -f1,2`

    sed -i 's/\t/|/g' $file
   
   gen_zwr $file $pac "^PTMP" $ofile
   mupip_load ${GTM_DIR} $ofile "-for=zwr" >> ${FLOG} 2>&1

  done

# load "nase kontroly" alias vybrane sloupe z CZECANCA databaze bude patrne jinak
   mupip_load ${GTM_DIR} ${BED_DIR}/var03cze.zwr "-for=zwr" 

# load clivar database
#   mupip_load ${GTM_DIR} ${BED_DIR}/zclin.zwr "-for=zwr" 

# load pocet exonu na gen
   mupip_load ${GTM_DIR} ${BED_DIR}/gen_exon.zwr "-for=zwr" 

# sloupec unknown z GVCF/unkn_col.web
SRC_UNK="${GVCF_DIR}/unkn_col.web"
[ -e ${SRC_UNK} ] || error_exit "source ${SRC_UNK} not found"

ZWR_FIL=${TMP_DIR}/unk_tmp.zwr

gen_uzwr ${SRC_UNK} ${ZWR_FIL} "^UNKN"
mupip_load ${GTM_DIR} ${ZWR_FIL} "-for=zwr" > ${FLOG} 2>&1


. ${GTM_DIR}/biowenv
$gtm_dist/mumps -direct <<-EOF > /dev/null
        D ^ADDVKS("${MUMPS_DIR}","run_${RUN}")
        halt
EOF

. ${GTM_DIR}/biowenv
$gtm_dist/mumps -direct <<-EOF > /dev/null
        D ^ADDVKP("${MUMPS_DIR}","run_${RUN}")
        halt
EOF

# vygenerujene addvar.sql
#. ${GTM_DIR}/biowenv
#$gtm_dist/mumps -direct <<-EOF > /dev/null
#        D ^ADDPVAR("${MUMPS_DIR}","${RUN}")
#        halt
#EOF

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

