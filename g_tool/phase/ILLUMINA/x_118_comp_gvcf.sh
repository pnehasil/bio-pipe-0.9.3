#!/usr/bin/env ksh93

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GEM2TXT_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_run() {

  gene=$1

  log "Diff $gene start"

  grep $gene ${GVCF_DIR}/vyb3.txt > ${GVCF_DIR}/$gene.3.txt
  grep $gene ${GVCF_DIR}/vyb4.txt > ${GVCF_DIR}/$gene.4.txt

  diff ${GVCF_DIR}/$gene.3.txt ${GVCF_DIR}/$gene.4.txt > ${GVCF_DIR}/diff.$gene.txt

  log "Diff $gene end"
}

###########################  MAIN ###########################

log "### Compare GVCFs ###"

[ -e ${GVCF3_DIR}/nase_bez_show.txt ] || error_exit "${GVCF3_DIR}/nase_bez_show.txt not ifound"
[ -e ${GVCF4_DIR}/nase_bez_show.txt ] || error_exit "${GVCF4_DIR}/nase_bez_show.txt not ifound"

FLOG=${WOR_LOGDIR}/${phase}_118_$(date +%y%m%d-%H%M%S).log

cat ${GVCF3_DIR}/nase_bez_show.txt | cut -f1-3,7,8,53 > ${GVCF_DIR}/vyb3.txt
cat ${GVCF4_DIR}/nase_bez_show.txt | cut -f1-3,7,8,53 > ${GVCF_DIR}/vyb4.txt

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for g in BRCA1 BRCA2 PALB2 CHEK2 ATM NBN CDH1 TP53 PTEN RAD51C RAD51D BRIP1 BARD1 STK11 MLH1 MSH2 MSH6 PMS2 EPCAM APC MUTYH RAD50
  do
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_run ${g} &
     else
      proc_run ${g}
   fi
  done
wait


#grep -i ERROR ${FLOG}
#if [ $? -eq 0 ]
# then
#   error_exit "Error found in ${FLOG}"
#fi   
