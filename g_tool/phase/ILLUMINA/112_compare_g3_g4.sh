#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv


[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"

FLOG=${WOR_LOGDIR}/${phase}_112_$(date +%y%m%d-%H%M%S).log


	file=${GVCF3_DIR}/dohromady.final_norm.final.vcf
	bf=`basename -s .final_norm.final.vcf $file`
	f4=${GVCF4_DIR}/dohromady.final_norm.final.vcf

	log "Start compare GVCFs $bf"

	cons=${GVCF_DIR}/$bf.c.txt
	rm -f $cons

	grep -v ^# $file | sed 's/\t/#/g' > ${GVCF3_DIR}/$bf.3.txt
	grep -v ^# $f4 | sed 's/\t/#/g' > ${GVCF4_DIR}/$bf.4.txt

	g3=${GVCF3_DIR}/$bf.3.txt
	g4=${GVCF4_DIR}/$bf.4.txt

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

	grep ^# $file > ${GVCF_DIR}/$bf.final_norm.final.vcf
        cat $cons | sort -V -k1,1 -k2,2n >> ${GVCF_DIR}/$bf.final_norm.final.vcf



#    grep -i ERROR ${FLOG}
#    if [ $? -eq 0 ]
#     then
#       error_exit "Error found in ${FLOG}"
#    fi   

log "Compare GVCF3/4 done"
