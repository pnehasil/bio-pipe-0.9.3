#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=10
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${VARSC_DIR} ] || error_exit "${VARSC_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_230_$(date +%y%m%d-%H%M%S).log

proc_pic() {

    file=$1

    bf=`basename -s .pileup $file`
    indelf=${VARSC_DIR}/VCF/$bf.indel.vcf
    snpf=${VARSC_DIR}/VCF/$bf.snp.vcf

    ${JAVA8_BIN}/java -jar ${VARSCAN_BIN}/VarScan.v2.3.9.jar mpileup2snp $file \
    --output-vcf 1 \
    --min-coverage 1 \
    --min-var-freq 0.0001 \
    --min-reads2 1 \
    --min-avg-qual 3 \
    --p-value 0.99 > $snpf 2>>${FLOG}

    ${JAVA8_BIN}/java -jar ${VARSCAN_BIN}/VarScan.v2.3.9.jar mpileup2snp $file \
    --output-vcf 1 \
    --min-coverage 1 \
    --min-var-freq 0.0001 \
    --min-reads2 1 \
    --min-avg-qual 3 \
    --p-value 0.99 > $indelf 2>>${FLOG}


    log "END $file -> $indelf, $snpf"


}

###########################  MAIN ###########################

log "Starting mkVCF parallel process for files in ${VARSC_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

mkdir ${VARSC_DIR}/VCF || error_exit "Cannot create ${VASRC_DIR}/Pil"

for f in `ls ${VARSC_DIR}/Pil/*.pileup`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_pic ${f} &
     else
      proc_pic ${f} 
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "MkVCF done"
