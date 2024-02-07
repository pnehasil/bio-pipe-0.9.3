#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${ADD_RD_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

log " ### Add read group ###"

[ -d ${RMDUP_DIR} ] || error_exit "${RMDUP_DIR} not found"
[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
[ -d ${PICARD_DIR} ] || error_exit "${PICARD_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_050_$(date +%y%m%d-%H%M%S).log

proc_add() {

     file=$1
     bf=`basename -s .picard.sorted.rmdup.bam $file`
     ofile="$bf.picard.sorted.RG.rmdup.bam"

     log "Start $file -> ${RG_DIR}/$ofile"
     ${JAVA8_BIN}/java -Xmx${ADD_RD_RAM} -Djava.io.tmpdir=${G_TMP_DIR} \
     -jar ${PICARD_DIR}/picard.jar AddOrReplaceReadGroups \
     I=${file} \
     O=${RG_DIR}/$ofile \
     RGID=$file \
     RGLB=$file \
     RGPL=illumina \
     RGPU=1 \
     RGSM=$file >> ${FLOG} 2>&1
     log "End $file -> ${RG_DIR}/$ofile"
}

###########################  MAIN ###########################

log "### Add read group parallel process for files in ${RMDUP_DIR} max ${MAX_JOBS} job(s) ###"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RMDUP_DIR}/*bam`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_add ${f} &
     else
      proc_add ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "Add read group done"
