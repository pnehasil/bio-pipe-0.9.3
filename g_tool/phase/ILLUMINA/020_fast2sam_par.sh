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

   log "Start full $file"

    /mnt/raid/Shared/bwa2/bwa-mem2 mem -t ${FAST2SAM_THR} \
   ${REF_DIR}/HG19uscs.fa \
   ${SRC}/${file}*R1.fastq.gz \
   ${SRC}/${file}*R2.fastq.gz > ${SAM_DIR}/${file}.sam 2>${FLOG}

   log "End full $file"
}

###########################  MAIN ###########################

TMP_DIR="${G_TMP_DIR}/tmp_$$"
FLOG=${WOR_LOGDIR}/${phase}_020_$(date +%y%m%d-%H%M%S).log
log "Create tmp dir ${TMP_DIR}"
mkdir ${TMP_DIR} || error_exit "Cannot create ${TMP_DIR}"

log "Starting BWA parallel process for files in ${SRC} max ${MAX_JOBS} job(s)"

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

log "BWA done"
