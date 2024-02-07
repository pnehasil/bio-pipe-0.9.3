#!/usr/bin/env ksh93
# this scripts executes parallelized translate of fastq files
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${FAST2SAM_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_fasq() {

   cfile=$1
   file=`basename $cfile`
   log "Counting statistics $file"
        ${NOVOALIGN_DIR}/novoalign -d ${REF_DIR}/hg19.nix -f ${SRC}/${file}*R1.fastq.gz ${SRC}/${file}*R2.fastq.gz -#50K -i 250,90 -c ${FAST2SAM_THR} -e 500 -o SAM 2> ${TMP_DIR}/${file}.stat.mapstat > ${TMP_DIR}/${file}.stat.sam 

   log "End statistics $file"

   line=`cat ${TMP_DIR}/$file.stat.mapstat | grep "Mean"`
   mean=`echo $line | awk '{print $3}' | sed 's/,//'`
   stdev=`echo $line | awk '{print $6}' | cut -f1 -d"."`

   log "Start full $file"
    ${NOVOALIGN_DIR}/novoalign -d ${REF_DIR}/hg19.nix -f ${SRC}/${file}*R1.fastq.gz ${SRC}/${file}*R2.fastq.gz -i $mean,$stdev -c ${FAST2SAM_THR} -e 500 -o SAM 2> ${MAPS_DIR}/${file}.mapstat > ${SAM_DIR}/${file}.sam

   log "End full $file"
}

###########################  MAIN ###########################

TMP_DIR="${G_TMP_DIR}/tmp_$$"
log "Create tmp dir ${TMP_DIR}"
mkdir ${TMP_DIR} || error_exit "Cannot create ${TMP_DIR}"

log "Starting novoalign parallel process for files in ${SRC} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${SRC}/*R1.fastq.gz | cut -f 1-3 -d "_"`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_fasq ${f} &
     else
      proc_fasq ${f} 
   fi
  done
wait

log "remove ${TMP_DIR}"  
rm -rf ${TMP_DIR}

log "Novoalign done"
