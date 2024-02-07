#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${CR_VCF1_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"

FLOG=${WOR_LOGDIR}/${phase}_105_$(date +%y%m%d-%H%M%S).log

proc_com() {

	file=$1
	bf=`basename -s .g.vcf $file`
	f4=${GVCF4_DIR}/$bf.g.vcf

	log "Start merge GVCFs $bf"

	cons=${GVCF_DIR}/$bf.c.txt
	rm -f $cons

	grep -v ^# $file | sed 's/\t/#/g' > ${GVCF3_DIR}/$bf.3.txt
	grep -v ^# $f4 | sed 's/\t/#/g' > ${GVCF4_DIR}/$bf.4.txt

	g3=${GVCF3_DIR}/$bf.3.txt
	g4=${GVCF4_DIR}/$bf.4.txt

	cat $g3 > $cons
	cat $g4 >> $cons
	sort $cons | uniq | sed 's/#/\t/g'> $cons.xx
	mv $cons.xx $cons

	#grep '^#' $file > ${GVCF_DIR}/$bf.g.vcf
	grep '^#' $f4 > ${GVCF_DIR}/$bf.g.vcf
        cat $cons | sort -V -k1,1 -k2,2n >> ${GVCF_DIR}/$bf.g.vcf

	log "END merge VCFs $bf"

}

###########################  MAIN ###########################

log "Starting merge GATKs parallel process for files in ${GATK_VCF_JED} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
CNT=0
for f in `ls ${GVCF3_DIR}/*g.vcf`
  do 
   CNT=`expr $CNT + 1`
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_com ${f} $CNT &
     else
      proc_com ${f} $CNT
   fi
  done
wait

#    grep -i ERROR ${FLOG}
#    if [ $? -eq 0 ]
#     then
#       error_exit "Error found in ${FLOG}"
#    fi   

log "Merge GVCF3/4 done"
