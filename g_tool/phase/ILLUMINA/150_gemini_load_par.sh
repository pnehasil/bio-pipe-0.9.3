#!/usr/bin/env ksh93
# this scripts executes parallelized load into gemini database
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GEM_LOAD_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_gemini() {

   ifile=$1

   bf=`basename -s .n.final_norm.final.vcf $ifile`
   dbfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions.db
   gem_in=${GATK_VCF_JED_GEM}/$bf.n.final_norm.final.eff.vcf

   python ${WOR_PHASE_DIR}/rozdel_vcf_eff.py $ifile $gem_in

   log "Start gemini load $ifile -> $dbfile"
   ${GEMINI_DIR}/gemini load -v $gem_in -t snpEff --cores 1 $dbfile >>${FLOG} 2>>${FLOG}

   log "End load $ifile -> $dbfile"
}

###########################  MAIN ###########################

log "Start gemini load parallel ${GATK_VCF_JED} max ${MAX_JOBS} job(s)"

[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${GATK_VCF_JED_GEM} ] || error_exit "${GATK_VCF_JED_GEM} not found"

FLOG=${WOR_LOGDIR}/${phase}_150_$(date +%y%m%d-%H%M%S).log


#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED}/*.n.final_norm.final.vcf`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_gemini ${f} &
     else
      proc_gemini ${f} 
   fi
  done
wait

log "Genini paralel load done"

