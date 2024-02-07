#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${NPIN_PROC}
MULTIPROCESS=1                          # set to 0 for debugging


FLOG=${WOR_LOGDIR}/${phase}_135_$(date +%y%m%d-%H%M%S).log

proc() {

    fil=$1
    suf=$2

     log "Start $1"

     bf=`basename -s .txt_D $fil`
     nf=$bf$d
     cp ${FPIN_DIR}/$bf*_D ${NPIN_DIR}/$nf
     nf=$bf$si
     cp ${FPIN_DIR}/$bf*_SI ${NPIN_DIR}/$nf
     nf=$bf$rp
     cp ${FPIN_DIR}/$bf*_RP ${NPIN_DIR}/$nf
     nf=$bf$li
     cp ${FPIN_DIR}/$bf*_LI ${NPIN_DIR}/$nf
     nf=$bf$td
     cp ${FPIN_DIR}/$bf*_TD ${NPIN_DIR}/$nf
     nf=$bf$inv
     cp ${FPIN_DIR}/$bf*_INV ${NPIN_DIR}/$nf

     ${BIN_DIR}/pindel2vcf -P ${NPIN_DIR}/$bf -r ${REF_DIR}/HG19uscs.fa -R HG19UCSC -d 20100830 -G -mc 10 -v ${NPIN_DIR}/$bf.vcf >> $FLOG 2>&1

   #log "Bgzip, tabix, bcftools"
   bgzip ${NPIN_DIR}/$bf.vcf

   tabix ${NPIN_DIR}/$bf.vcf.gz

   ${BCFTOOLS_13_DIR}/bcftools annotate -x FMT/PL  ${NPIN_DIR}/$bf.vcf.gz > ${NPIN_DIR}/$bf.PL.vcf

   bgzip ${NPIN_DIR}/$bf.PL.vcf

   tabix ${NPIN_DIR}/$bf.PL.vcf.gz

   ${BCFTOOLS_13_DIR}/bcftools view -i 'INFO/SVLEN < -20 | INFO/SVLEN > 20'  ${NPIN_DIR}/$bf.PL.vcf.gz > ${NPIN_DIR}/$bf.PL_filtr20.vcf

   cat ${NPIN_DIR}/$bf.PL_filtr20.vcf | awk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k2,2n"}' >  ${NPIN_DIR}/$bf.PL_filtr20_sort.vcf

   #log "Bgzip, tabix"
   bgzip ${NPIN_DIR}/$bf.PL_filtr20_sort.vcf

   tabix ${NPIN_DIR}/$bf.PL_filtr20_sort.vcf.gz

VCF=${NPIN_DIR}/$bf.PL_filtr20_sort.vcf.gz
tmp1=${NPIN_DIR}/$bf.tmp1
tmp2=${NPIN_DIR}/$bf.tmp2
NORMVCF=${NPIN_DIR}/$bf.norm.vcf
REF=${DATABASE_GATK_DIR}/ucsc.hg19.fasta


zless $VCF | sed 's/ID=AD,Number=./ID=AD,Number=R/' | ${VT_DIR}/vt decompose -s - > $tmp1 2>>${FLOG}
cat $tmp1  | ${VT_DIR}/vt normalize -n -r $REF - > $tmp2 2>>${FLOG}
cat $tmp2 | java -Xmx${NPIN_RAM} -jar ${SNPEFF_DIR}/snpEff.jar -classic -formatEff -noShiftHgvs -hgvs \
    -spliceSiteSize 12 -v hg19 -onlyTr ${BED_DIR}/mytranscripts_NM.txt > $NORMVCF 2>>${FLOG}

#echo "copy $NORMVCF $NORMVCF.zal"

cp $NORMVCF $NORMVCF.zal

#lines for delete - 5th column contain *
lines=`grep -P -n "\t\*\t" $NORMVCF | cut -d":" -f1`
TMP_FIL="/tmp/src_tmp_$$_$suf"
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

f1p=${NPIN_DIR}/$bf.final_norm.f1p.vcf
fixp=${NPIN_DIR}/$bf.final_norm.FS.fixp.vcf
normfinal=${NPIN_DIR}/$bf.final_norm.final.vcf

#${BCFTOOLS_13_DIR}/bcftools filter -S 0 -i 'FMT/AD[1] / (FMT/AD[0] + FMT/AD[1]) > 0.1 && FMT/AD[1] > 4' $NORMVCF > $f1p
${BCFTOOLS_13_DIR}/bcftools filter -i 'FMT/AD[1] / (FMT/AD[0] + FMT/AD[1]) > 0.1 && FMT/AD[1] > 4' $NORMVCF > $f1p
${BCFTOOLS_DIR}/vcffixup $f1p > $normfinal 2>>${FLOG}
#${TABIX_DIR}/tabix -p vcf $fixp

   dbfile=${NPIN_DIR}/$bf.pindel.db
   tfile=${NPIN_DIR}/$bf.pindel.txt
   wfile=${NPIN_DIR}/$bf.pindel.web
   vcf_file=${GEMINI_DATA}/clinvar_20190102.tidy.vcf.gz
   export PATH=${GEMINI_DIR}:$PATH

   log "Start gemini load $ifile -> $dbfile"
   ${GEMINI_DIR}/gemini load -v $normfinal -t snpEff --cores 1 $dbfile >>${FLOG} 2>>${FLOG}

   log "Start gemini select $dbfile -> $tfile"
   ${GEMINI_DIR}/gemini query --header  -q "select * from variants" $dbfile > $tfile 2>>${FLOG}


   log "Start add CLNREVSTAT -> $dbfile"
   ${GEMINI_DIR}/gemini annotate -f $vcf_file -c CLNREVSTAT -a extract -e CLNREVSTAT -t text -o list $dbfile


   log "Start gemini select $dbfile -> $wfile"
   ${GEMINI_DIR}/gemini query --header -q "select gene,codon_change,aa_change,exon,qual,depth,num_alleles,clinvar_sig,max_aaf_all,aaf_esp_ea,impact_so,aaf_esp_all,aaf_1kg_eur,aaf_1kg_all,gms_illumina,gms_solid,gms_iontorrent,cosmic_ids,cadd_raw,cadd_scaled,aaf_exac_all,aaf_adj_exac_all,aaf_adj_exac_nfe,exac_num_het,exac_num_hom_alt,aa_length,transcript,chrom,start,end,ref,alt,num_reads_w_dels,allele_count,allele_bal,rs_ids,in_omim,clinvar_disease_name,rmsk,aaf_gnomad_all,aaf_gnomad_nfe,aaf_gnomad_non_cancer,gnomad_popmax_AF,gnomad_num_het,gnomad_num_hom_alt,gnomad_num_chroms,CLNREVSTAT from variants" $dbfile > $wfile 2>>${FLOG}

    
   log "End $1"

    }


FLOG=${WOR_LOGDIR}/${phase}_135_$(date +%y%m%d-%H%M%S).log

#[ -d ${CNV_KIT_DIR} ] || error_exit "${CNV_KIT_DIR} not found"
#[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
#[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
#[ -d ${BEDTOOLS_DIR} ] || error_exit "${BEDTOOLS_DIR} not found"
#[ -d ${PINDEL_DIR} ] || error_exit "${PINDEL_DIR} not found"

#[ -e ${RG_DIR}/*.picard.sorted.RG.rmdup.bam ] || error_exit "${RG_DIR}*.picard.sorted.RG.rmdup.bam not found"

log "Create New pindel parallel in ${NPIN_PROC} processes"
#001_PKM1878_run38.txt_LI

d="_D"
si="_SI"
rp="_RP"
li="_LI"
td="_TD"
inv="_INV"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

CNT=0
for f in `ls ${FPIN_DIR}/*_D | grep -v dohromady`
 do
   CNT=`expr $CNT + 1`	  
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc ${f} $CNT &
     else
       proc ${f} $CNT
   fi     
 done
wait

log "New pindel end"

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

