#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=10
MULTIPROCESS=0                          # set to 0 for debugging

[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${VARSC_DIR} ] || error_exit "${VARSC_DIR} not found"

FLOG=${WOR_LOGDIR}/${phase}_250_$(date +%y%m%d-%H%M%S).log

proc_pic() {

    file=$1

    bf=`basename -s .vcf.ann $file`
    outf=${VARSC_DIR}/table/$bf.pom

    echo $bf
    for line in `cat $file | grep -v ^# | sed 's/\t/#/g' `
      do
        chr=`echo $line | cut -d"#" -f1`
        kor=`echo $line | cut -d"#" -f2`
        ref=`echo $line | cut -d"#" -f4`
        alt=`echo $line | cut -d"#" -f5`
	pom=`echo $line | cut -d"#" -f10`
	dp=`echo $pom | cut -d":" -f4`
	ad=`echo $pom | cut -d":" -f6`
	fr=`echo $pom | cut -d":" -f7`

	echo $chr $kor $ref $alt $dp $ad $fr >> $outf

      done


}

###########################  MAIN ###########################

log "Starting gemini load parallel process for files in ${VARSC_DIR} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

mkdir ${VARSC_DIR}/table || error_exit "Cannot create ${VARSC_DIR}/table"

for f in `ls ${VARSC_DIR}/VCF_ANN/*.ann`
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

log "Gemini load done"
