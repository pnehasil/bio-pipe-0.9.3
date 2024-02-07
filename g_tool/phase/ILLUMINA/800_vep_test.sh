#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${CR_VCF1_PROC}
MULTIPROCESS=0                          # set to 0 for debugging

[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"

FLOG=${WOR_LOGDIR}/${phase}_800_$(date +%y%m%d-%H%M%S).log

proc_ann() {

    file=$1

    bf=`basename -s .GATK_regions.vcf $file`
    f2p=${GATK_VCF_JED}/$bf.n.f2p.vcf
    FSp=${GATK_VCF_JED}/$bf.n.FSp.vcf
    QDp=${GATK_VCF_JED}/$bf.n.QDp.vcf
    FSpSOR=${GATK_VCF_JED}/$bf.n.FSpSOR.vcf
    MQPSp=${GATK_VCF_JED}/$bf.n.MQPsP.vcf
    fixp=${GATK_VCF_JED}/$bf.n.fixp.vcf
    final=${GATK_VCF_JED}/$bf.n.final.vcf

#    ${BCFTOOLS_DIR}/bcftools filter -S . -i 'FMT/DP > 4 ' $file > $f2p 2>>${FLOG}
#    ${BCFTOOLS_DIR}/bcftools filter -i "FS <30" $f2p > $FSp 2>>${FLOG}
#    ${BCFTOOLS_DIR}/bcftools filter -i "QD >1 " $FSp > $QDp 2>>${FLOG}
#    ${BCFTOOLS_DIR}/bcftools filter -i "SOR <4 " $QDp > $FSpSOR 2>>${FLOG}

#    ${BCFTOOLS_DIR}/bcftools filter -e "MQRankSum <-12.5 " $FSpSOR > $MQPSp 2>>${FLOG}
#    ${BCFTOOLS_DIR}/vcffixup $MQPSp > $fixp 2>>${FLOG}

    VCF=$fixp
    NORMVCF=${GATK_VCF_JED}/$bf.n.final_norm_vep.vcf
    REF=${DATABASE_GATK_DIR}/ucsc.hg19.fasta
    tmp1=${GATK_VCF_JED}/$bf.n.final.decomp.tmp
    tmp2=${GATK_VCF_JED}/$bf.n.final.norm.tmp

# decompose, normalize and annotate VCF with snpEff.
# NOTE: can also swap snpEff with VEP
# NOTE: -classic and -formatEff flags needed with snpEff >= v4.1
#zless $VCF | sed 's/ID=AD,Number=./ID=AD,Number=R/' | ${VT_DIR}/vt decompose -s - > $tmp1 2>>${FLOG}
#cat $tmp1  | ${VT_DIR}/vt normalize -n -r $REF - > $tmp2 2>>${FLOG}
#cat $tmp2 | java -Djava.io.tmpdir=${G_TMP_DIR} -Xmx${CR_VCF1_RAM} -jar ${SNPEFF43_DIR}/snpEff.jar \
#    -classic -formatEff -noShiftHgvs -hgvs \
#    -spliceSiteSize 12 -v hg19 -onlyTr ${BED_DIR}/mytranscripts_NM.txt  > $NORMVCF 2>>${FLOG}
#
#    echo "copy $NORMVCF $NORMVCF.zal"
#
#    cp $NORMVCF $NORMVCF.zal
#
#    #lines for delete - 5th column contain *
#    lines=`grep -P -n "\t\*\t" $NORMVCF | cut -d":" -f1`
#    TMP_FIL="${G_TMP_DIR}/src_tmp_$$"
#    log "Create ad hoc script ${TMP_FIL}"
#
#    todel="'"
#    for xline in `echo $lines`
#       do
#         pom="d"
#         todel=`echo "$todel$xline$pom;"`
#       done
#       echo "sed -i $todel' $NORMVCF" > ${TMP_FIL}
#
#    log "Run script ${TMP_FIL}"
#    ksh ${TMP_FIL}
#    rm ${TMP_FIL}
#
#    f1p=${GATK_VCF_JED}/$bf.n.final_norm.f1p.vcf
#    fixp=${GATK_VCF_JED}/$bf.n.final_norm.FS.fixp.vcf
    normfinal=${GATK_VCF_JED}/$bf.n.final_norm.final.vcf
    NORMVCF=${GATK_VCF_JED}/$bf.n.final_norm_vep.vcf
#
#    ${BCFTOOLS_13_DIR}/bcftools filter -S 0 -i 'FMT/AD[1] / (FMT/AD[0] + FMT/AD[1]) > 0.1 && FMT/AD[1] > 3 && FMT/GQ >20' $NORMVCF > $f1p
#    ${BCFTOOLS_DIR}/vcffixup $f1p > $normfinal 2>>${FLOG}
#    ${TABIX_DIR}/tabix -p vcf $normfinal

echo "VEP"
export PATH=${GEMINI_DIR}:$PATH

#${VEP_DIR}/vep --offline --dir_cache ${VEP_CACHE} --sift b --polyphen b --vcf -i $normfinal -o $NORMVCF 

#${GEMINI_DIR}/gemini load -v $NORMVCF -t snpEff --cores 10  ${GATK_VCF_JED}/$bf.snp.db
#${GEMINI_DIR}/gemini load -v $NORMVCF -t VEP --cores 10  ${GATK_VCF_JED}/$bf.vep.db
#${GEMINI_DIR}/gemini load -v $NORMVCF -t all --cores 10  ${GATK_VCF_JED}/$bf.all.db


${GEMINI_DIR}/gemini query --header -q "select exon,sift_pred,polyphen_pred,transcript from variants" ${GATK_VCF_JED}/$bf.snp.db > ${GATK_VCF_JED}/$bf.snp.txt
${GEMINI_DIR}/gemini query --header -q "select exon,sift_pred,polyphen_pred,transcript from variants" ${GATK_VCF_JED}/$bf.vep.db > ${GATK_VCF_JED}/$bf.vep.txt
${GEMINI_DIR}/gemini query --header -q "select exon,sift_pred,polyphen_pred,transcript from variants" ${GATK_VCF_JED}/$bf.all.db > ${GATK_VCF_JED}/$bf.all.txt

#${GEMINI_DIR}/gemini query --header --carrier-summary-by-phenotype phenotype -q "select * from variants" ${GATK_VCF_JED}/$bf.all.db 

exit

    #rm tmp1 tmp2 tmp3 tmp4 tmp5
}

###########################  MAIN ###########################

log "Starting annotation parallel process for files in ${GATK_VCF_JED} max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED}/*.GATK_regions.vcf`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_ann ${f} &
     else
      proc_ann ${f} 
   fi
  done
wait

#    grep -i ERROR ${FLOG}
#    if [ $? -eq 0 ]
#     then
#       error_exit "Error found in ${FLOG}"
#    fi   

log "Annotation done"
