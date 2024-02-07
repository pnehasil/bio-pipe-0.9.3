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

FLOG=${WOR_LOGDIR}/${phase}_142_$(date +%y%m%d-%H%M%S).log

proc_com() {

	file=$1
	bf=`basename -s .GATK_regions.vcf $file`
	f4=${GATK4_VCF_DIR}/$bf.GATK_regions.vcf

	log "Start compare VCFs $bf"

	cons=${GATK_VCF_JED}/$bf.c.txt
	rm -f $cons

	grep -v ^# $file | sed 's/\t/#/g' > ${GATK3_VCF_DIR}/$bf.3.txt
	grep -v ^# $f4 | sed 's/\t/#/g' > ${GATK4_VCF_DIR}/$bf.4.txt

	g3=${GATK3_VCF_DIR}/$bf.3.txt
	g4=${GATK4_VCF_DIR}/$bf.4.txt

	for line in `cat $g3`
	  do
	    hl=`echo $line | cut -d"#" -f1-5`
            nasli=`grep -m1 $hl $g4`  		  
	    if [ $? -eq 0 ]
	    then
		    q3=`echo $line | cut -d"#" -f6 | cut -d"." -f1`
		    q4=`echo $nasli | cut -d"#" -f6 | cut -d"." -f1`

		    if [ $q3 -gt $q4 ]
		    then
			    echo $line | sed 's/#/\t/g' >> $cons
		    else
			    echo $nasli | sed 's/#/\t/g' >> $cons
		    fi
	    else
		    echo $line | sed 's/#/\t/g' >> $cons
	    fi
	  done

	for line in `cat $g4`
	  do
	    hl=`echo $line | cut -d"#" -f1-5`
            nasli=`grep -m1 $hl $g3`  		  
	    if [ $? -ne 0 ]
	    then
		    echo $line | sed 's/#/\t/g' >> $cons
	    fi
	  done

	grep ^# $file > ${GATK_VCF_JED}/$bf.GATK_regions.vcf
        cat $cons | sort -V -k1,1 -k2,2n >> ${GATK_VCF_JED}/$bf.GATK_regions.vcf

	log "END compare VCFs $bf"

}

###########################  MAIN ###########################

log "Starting compare GATKs parallel process for files in ${GATK_VCF_JED} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
CNT=0
for f in `ls ${GATK3_VCF_DIR}/*.GATK_regions.vcf`
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

log "Compare GATK3/4 done"
