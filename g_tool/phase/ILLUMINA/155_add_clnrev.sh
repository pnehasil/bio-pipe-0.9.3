#!/usr/bin/env ksh93
# this scripts executes parallelized load into gemini database
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GEM_CLNREV_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_gemini() {

   dbfile=$1
   vcf_file=${GEMINI_DATA}/clinvar_20190102.tidy.vcf.gz

   log "Start add CLNREVSTAT $ifile -> $dbfile"
   ${GEMINI_DIR}/gemini annotate -f $vcf_file -c CLNREVSTAT -a extract -e CLNREVSTAT -t text -o list $dbfile
   #${GEMINI_DIR}/gemini load -v $ifile -t snpEff --cores 1 $dbfile >>${FLOG} 2>>${FLOG}

   log "End add CLNREVSTAT $ifile -> $dbfile"
}

###########################  MAIN ###########################

log "Start add CLNREVSTAT into gemini DB parallel ${GATK_VCF_JED_GEM} max ${MAX_JOBS} job(s)"

[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${GATK_VCF_JED_GEM} ] || error_exit "${GATK_VCF_JED_GEM} not found"

FLOG=${WOR_LOGDIR}/${phase}_150_$(date +%y%m%d-%H%M%S).log

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED_GEM}/*.db`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_gemini ${f} &
     else
      proc_gemini ${f} 
   fi
  done
wait

log "Gemini paralel CLNREVSTAT done"

