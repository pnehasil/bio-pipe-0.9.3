#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=16
MULTIPROCESS=1                          # set to 0 for debugging

log "### Alela part 2.2 ###"

[ -d ${CNV_KIT_DIR} ] || error_exit "${CNV_KIT_DIR} not found"
[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${BEDTOOLS_DIR} ] || error_exit "${BEDTOOLS_DIR} not found"
[ -d ${PINDEL_DIR} ] || error_exit "${PINDEL_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_131_$(date +%y%m%d-%H%M%S).log

proc_pin() {
     file=$1

    bf=`basename -s .nnn.txt $file`
    ofile=${FPIN_DIR}/$bf.txt

    log "Pindel $file -> $ofile "	 
    ${PINDEL_DIR}/pindel  -f ${REF_DIR}/HG19uscs.fa -i $file -o $ofile >>${FLOG} 2>&1
}

###########################  MAIN ###########################

log "Starting pindel parallel process for files in ${FPIN_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${FPIN_DIR}/*.nnn.txt ` 
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_pin ${f} &
     else
      proc_pin ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Pindel done"
