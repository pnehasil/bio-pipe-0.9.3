#!/usr/bin/env ksh93

load_params "$@"

log "Gen zwr from vcf"
 
. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

FLOG=${WOR_LOGDIR}/${phase}_60_$(date +%y%m%d-%H%M%S).log

OUT_DIR="${OUT_DIR}/TABS"
mkdir ${OUT_DIR}

TMP_FIL=${TMP_DIR}/vcf_tmp.txt

#/mnt/md0/Workspace/Wor120/run_120/GATK_VCF/jednotlive/001_PKM2309_run120.GATK_regions.vcf
#for file in `ls ${GATK_VCF_JED}/*GATK_regions.vcf`
for file in `ls ${GATK_VCF_JED}/*n.final.decomp.tmp`
  do
    #bf=`basename -s .GATK_regions.vcf $file` 
    bf=`basename -s .n.final.decomp.tmp $file` 
    ofile=${OUT_DIR}/$bf.vcf.zwr
    pac=`echo $bf | cut -d"_" -f1,2`

    log "$file -> $ofile"

    rm -f ${TMP_FIL}
    for line in `cat ${file} | sed '/^#/d' | sed 's/\t/|/g'`
     do

       pr=`echo $line | cut -d"|" -f1-2`
       dr=`echo $line | cut -d"|" -f4-5`
       tr=`echo $line | cut -d"|" -f10`
       x=`echo $tr | cut -d":" -f2`
       tr1=`echo $x | cut -d"," -f1`
       tr2=`echo $x | cut -d"," -f2`

       if [ "$tr1" == "./." ]
        then
         tr1=-1
         tr2=-1
       fi
       
       echo "$pr|$pac|$dr|$tr1|$tr2" >> ${TMP_FIL} 

     done

    gen_pzwr ${TMP_FIL} ${ofile} "^VCF" 
    mupip_load ${GTM_DIR} ${ofile} "-for=zwr" >> ${FLOG} 2>&1
    rm -f ${TMP_FIL}

  done

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

