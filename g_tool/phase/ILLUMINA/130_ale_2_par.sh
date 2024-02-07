#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

MAX_JOBS=32
MULTIPROCESS=1

log "### Alela part 2.1 ###"

[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${BEDTOOLS_DIR} ] || error_exit "${BEDTOOLS_DIR} not found"
[ -d ${PINDEL_DIR} ] || error_exit "${PINDEL_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_130_$(date +%y%m%d-%H%M%S).log

proc_idx() {
     file=$1
    log "Start index $file"
    ${SAMTOOLS_DIR}/samtools index $file >> ${FLOG} 2>&1
    log "End index $file"	
}

###########################  MAIN ###########################

log "Starting index parallel process for files in ${RECALIBRATED_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RECALIBRATED_DIR}/*.bam`
  do
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_idx ${f} &
     else
      proc_idx ${f}
   fi
  done
wait


log "Add tab+bf"	 
for file in `ls ${RECALIBRATED_DIR}/*.recal.rmdup.bam.bai`
  do
    bf=`basename -s .picard.sorted.RG.realigned.recal.rmdup.bam.bai $file`
    ffile=`basename -s .bai $file`
    echo "${RECALIBRATED_DIR}/$ffile " > ${FPIN_DIR}/$bf.nnn.txt
    sed -i  "s/$/\t150\t$bf/" ${FPIN_DIR}/$bf.nnn.txt
  done

  grep -i ERROR ${FLOG}
  if [ $? -eq 0 ]
   then
     error_exit "Error found in ${FLOG}"
  fi   

