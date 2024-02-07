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

FLOG=${WOR_LOGDIR}/${phase}_210_$(date +%y%m%d-%H%M%S).log

proc_ann() {

    file=$1
    suf=$2

    bf=`basename -s .GATK_regions.vcf $file`

    VCF=$1
    NORMVCF=${GATK_VCF_JED}/$bf.r.final_norm.final.vcf
    REF=${DATABASE_GATK_DIR}/ucsc.hg19.fasta
    tmp1=${GATK_VCF_JED}/$bf.r.final.decomp.tmp
    tmp2=${GATK_VCF_JED}/$bf.r.final.norm.tmp

# decompose, normalize and annotate VCF with snpEff.
# NOTE: can also swap snpEff with VEP
# NOTE: -classic and -formatEff flags needed with snpEff >= v4.1
zless $VCF | sed 's/ID=AD,Number=./ID=AD,Number=R/' | ${VT_DIR}/vt decompose -s - > $tmp1 2>>${FLOG}
cat $tmp1  | ${VT_DIR}/vt normalize -n -r $REF - > $tmp2 2>>${FLOG}
cat $tmp2 | java -Djava.io.tmpdir=${G_TMP_DIR} -Xmx${CR_VCF1_RAM} -jar ${SNPEFF_DIR}/snpEff.jar \
    -classic -formatEff -hgvs \
    -spliceSiteSize 12 -v hg19 -onlyTr ${BED_DIR}/mytranscripts_NM.txt  > $NORMVCF 2>>${FLOG}

    echo "copy $NORMVCF $NORMVCF.zal"

    cp $NORMVCF $NORMVCF.zal

    #lines for delete - 5th column contain *
    lines=`grep -P -n "\t\*\t" $NORMVCF | cut -d":" -f1`
    TMP_FIL="${G_TMP_DIR}/src_tmp_$$_$suf"
    log "Create ad hoc script ${TMP_FIL}"

    todel="'"
    for xline in `echo $lines`
       do
         pom="d"
         todel=`echo "$todel$xline$pom;"`
       done
       echo "sed -i $todel' $NORMVCF" > ${TMP_FIL}

    log "Run script ${TMP_FIL}"
    ksh ${TMP_FIL}
    rm ${TMP_FIL}

#    $cent*GATK_regions.raw

   dbfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions_raw.db
   rfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions.raw

   log "Start gemini load $ifile -> $dbfile"
   ${GEMINI_DIR}/gemini load -v $NORMVCF -t snpEff --cores 1 $dbfile >>${FLOG} 2>>${FLOG}
   log "End load $NORMVCF -> $dbfile"

   log "gemini export $dbfile -> $rfile"
   ${GEMINI_DIR}/gemini query --header -q "select * from variants" $dbfile > $rfile 2>>${FLOG}
   log "End export $dbfile -> $rfile"


    #rm tmp1 tmp2 tmp3 tmp4 tmp5
}

###########################  MAIN ###########################

log "Starting annotation parallel process for files in ${GATK_VCF_JED} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
CNT=0
for f in `ls ${GATK_VCF_JED}/*.GATK_regions.vcf`
  do 
   CNT=`expr $CNT + 1`
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_ann ${f} $CNT &
     else
      proc_ann ${f} $CNT
   fi
  done
wait

#    grep -i ERROR ${FLOG}
#    if [ $? -eq 0 ]
#     then
#       error_exit "Error found in ${FLOG}"
#    fi   

log "Annotation done"
