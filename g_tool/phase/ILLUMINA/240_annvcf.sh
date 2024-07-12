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

FLOG=${WOR_LOGDIR}/${phase}_240_$(date +%y%m%d-%H%M%S).log

proc_pic() {

    file=$1

    bf=`basename $file`
    annf=${VARSC_DIR}/VCF_ANN/$bf.ann

    cat $file | ${JAVA8_BIN}/java -Xmx12G -jar ${SNPEFF_DIR}/snpEff.jar -classic -formatEff -noShiftHgvs -hgvs \
    -spliceSiteSize 12 -v hg19 -onlyTr ${BED_DIR}/mytranscripts_NM.txt > $annf 2>>${FLOG}


    log "END $file -> $annf"


}

###########################  MAIN ###########################

log "Starting VCFann parallel process for files in ${VARSC_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

mkdir ${VARSC_DIR}/VCF_ANN || error_exit "Cannot create ${VARSC_DIR}/VCF_ANN"

for f in `ls ${VARSC_DIR}/VCF/*.vcf`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_pic ${f} &
     else
      proc_pic ${f} 
   fi
  done
wait

cat ${FLOG} | grep -v ^# | grep -i ERROR
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

log "VCFann done"
