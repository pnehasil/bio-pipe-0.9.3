#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GEM2WEB_PAR_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

log "Extract from gemini for WEB"

[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${GATK_VCF_JED_GEM} ] || error_exit "${GATK_VCF_JED_GEM} not found"

FLOG=${WOR_LOGDIR}/${phase}_200_$(date +%y%m%d-%H%M%S).log

proc_gemini () {

   ifile=$1

   bf=`basename -s .GATK_regions.db $ifile`
   tfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions.web
   cfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions.cli
   vfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions_vep.web

   vepdb=${GATK_VCF_JED_GEM}/$bf.GATK_regions_vep.db

   log "$ifile -> $tfile"

   ${GEMINI_DIR}/gemini query --header -q "select gene,codon_change,aa_change,exon,qual,depth,num_alleles,clinvar_sig,max_aaf_all,aaf_esp_ea,impact_so,aaf_esp_all,aaf_1kg_eur,aaf_1kg_all,gms_illumina,gms_solid,gms_iontorrent,cosmic_ids,cadd_raw,cadd_scaled,aaf_exac_all,aaf_adj_exac_all,aaf_adj_exac_nfe,exac_num_het,exac_num_hom_alt,aa_length,transcript,chrom,start,end,ref,alt,num_reads_w_dels,allele_count,allele_bal,rs_ids,in_omim,clinvar_disease_name,rmsk,aaf_gnomad_all,aaf_gnomad_nfe,aaf_gnomad_non_cancer,gnomad_popmax_AF,gnomad_num_het,gnomad_num_hom_alt,gnomad_num_chroms,CLNREVSTAT from variants where num_hom_ref <> 1" $ifile > $tfile 2>>${FLOG}

   ${GEMINI_DIR}/gemini query -q "select chrom,start,end,ref,alt,CLNSIGCONF from variants where num_hom_ref <> 1" $ifile > $cfile 2>>${FLOG}

   #${GEMINI_DIR}/gemini query --header -q "select chrom,start,end,ref,alt,polyphen_pred,polyphen_score,sift_pred,sift_score from variants where is_coding=1 or is_exonic=1 or is_splicing=1 or is_lof=1 or exon>0 or biotype='protein_coding' or aa_change='p.%'" $vepdb > $vfile 2>>${FLOG}

   ${GEMINI_DIR}/gemini query --header -q "select chrom,start,end,ref,alt,polyphen_pred,polyphen_score,sift_pred,sift_score from variants" $vepdb > $vfile 2>>${FLOG}

   sed -i 's/|/#/g' $vfile
   sed -i 's/\t/|/g' $vfile


   ${GEMINI_DIR}/gemini query --header -q "select * from variants" $ifile > $tfile.all 2>>${FLOG}

   sed -i 's/|/#/g' $tfile
   sed -i 's/\t/|/g' $tfile
}

###########################  MAIN ###########################

log "Starting parallel extarct from gemini, max ${MAX_JOBS} job(s)"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED_GEM}/*.GATK_regions.db`
  do
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_gemini ${f} &
     else
      proc_gemini ${f}
   fi
  done
wait

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi
