
load_params "$@"

log "### VCF to GEmini ###"
. ${WOR_LIB}/bioenv

[ -d ${GVCF_DIR} ] || error_exit "${GVCF_DIR} not found"
[ -e ${GVCF_DIR}/dohromady.final_norm.final.vcf ] || error_exit "${GVCF_DIR}/dohromady.vcf not ifound"

FLOG=${WOR_LOGDIR}/${phase}_114_$(date +%y%m%d-%H%M%S).log

export PATH=${GEMINI_DIR}:$PATH

   ifile=${GVCF_DIR}/dohromady.final_norm.final.vcf
   dbfile=${GVCF_DIR}/dohromady.g.db

   log "Start gemini load $ifile -> $dbfile"
   ${GEMINI_DIR}/gemini load -v $ifile -t snpEff --cores ${VCF2GEM_LOAD} $dbfile >>${FLOG} #2>>${FLOG}
# kde ma gemini tmp pro load???

   log "End load $ifile -> $dbfile"

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   

