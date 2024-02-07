
load_params "$@"

log "### VCF to GEmini ###"
. ${WOR_LIB}/bioenv

[ -d ${GVCF3_DIR} ] || error_exit "${GVCF3_DIR} not found"
[ -e ${GVCF3_DIR}/dohromady.vcf ] || error_exit "${GVCF3_DIR}/dohromady.vcf not ifound"

FLOG=${WOR_LOGDIR}/${phase}_110_$(date +%y%m%d-%H%M%S).log

file=${GVCF3_DIR}/dohromady.vcf
f2p=${GVCF3_DIR}/dohromady.f2p.vcf
FSp=${GVCF3_DIR}/dohromady.FSp.vcf
QDp=${GVCF3_DIR}/dohromady.QDp.vcf
FSpSOR=${GVCF3_DIR}/dohromady.FSpSOR.vcf
MQPSp=${GVCF3_DIR}/dohromady.MQPsP.vcf
fixp=${GVCF3_DIR}/dohromady.fixp.vcf
final=${GVCF3_DIR}/dohromady.final.vcf

${BCFTOOLS_DIR}/bcftools filter -S . -i "FORMAT/DP>4" $file > $f2p 2>>${FLOG}
${BCFTOOLS_DIR}/bcftools filter -i "FS <45" $f2p > $FSp 2>>${FLOG}
${BCFTOOLS_DIR}/bcftools filter -i "QD >1 " $FSp > $QDp 2>>${FLOG}
${BCFTOOLS_DIR}/bcftools filter -i "SOR <4 " $QDp > $FSpSOR 2>>${FLOG}

${BCFTOOLS_DIR}/bcftools filter -e "MQRankSum <-12.5 " $FSpSOR > $MQPSp 2>>${FLOG}
${BCFTOOLS_DIR}/vcffixup $MQPSp > $fixp 2>>${FLOG}
${BCFTOOLS_DIR}/bcftools view -i 'AC[0] > 0' $fixp > $final 2>>${FLOG}

VCF=$final
NORMVCF=${GVCF3_DIR}/dohromady.final_norm.vcf
REF=${DATABASE_GATK_DIR}/ucsc.hg19.fasta
tmp1=${GVCF3_DIR}/dohromady.final.decomp.tmp
tmp2=${GVCF3_DIR}/dohromady.final.norm.tmp

# decompose, normalize and annotate VCF with snpEff.
# NOTE: can also swap snpEff with VEP
# NOTE: -classic and -formatEff flags needed with snpEff >= v4.1
zless $VCF | sed 's/ID=AD,Number=./ID=AD,Number=R/' | ${VT_DIR}/vt decompose -s - > $tmp1 2>>${FLOG}
cat $tmp1  | ${VT_DIR}/vt normalize -n -r $REF - > $tmp2 2>>${FLOG}
cat $tmp2 | ${JAVA8_BIN}/java -Djava.io.tmpdir=${G_TMP_DIR} -Xmx${VCF2GEM_RAM} -jar ${SNPEFF_DIR}/snpEff.jar \
    -classic -formatEff -hgvs \
    -spliceSiteSize 12 -v hg19 -onlyTr ${BED_DIR}/mytranscripts_NM.txt >$NORMVCF 2>/dev/null 

echo "copy $NORMVCF $NORMVCF.zal"

cp $NORMVCF $NORMVCF.zal

#lines for delete - 5th column contain *
lines=`grep -P -n "\t\*\t" $NORMVCF | cut -d":" -f1`
TMP_FIL="/tmp/src_tmp_$$"
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

f1p=${GVCF3_DIR}/dohromady.final_norm.f1p.vcf
fixp=${GVCF3_DIR}/dohromady.final_norm.FS.fixp.vcf
normfinal=${GVCF3_DIR}/dohromady.final_norm.final.vcf

${BCFTOOLS_13_DIR}/bcftools filter -S 0 -i 'FMT/AD[1] / (FMT/AD[0] + FMT/AD[1]) > 0.1 && FMT/AD[1] > 3 && FMT/GQ >20' $NORMVCF > $f1p
${BCFTOOLS_DIR}/vcffixup $f1p > $fixp 2>>${FLOG}
${TABIX_DIR}/tabix -p vcf $fixp
${BCFTOOLS_13_DIR}/bcftools view -i 'AC[0] > 0' $fixp > $normfinal 2>>${FLOG}

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

