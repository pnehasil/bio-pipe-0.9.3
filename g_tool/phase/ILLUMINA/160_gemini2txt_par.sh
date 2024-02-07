#!/usr/bin/env ksh93
# this scripts executes parallelized export from gemini database
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GEM2TXT_PAR_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_gemini() {

   ifile=$1

   bf=`basename -s .GATK_regions.db $ifile`
   tfile=${GATK_VCF_JED_GEM}/$bf.GATK_regions.txt
   rfile=${GATK_VCF_JED_GEM}/$bf.double.txt

   log "gemini export $ifile -> $tfile"
   ${GEMINI_DIR}/gemini query --header -q "select * from variants" $ifile > $tfile 2>>${FLOG}

   log "gemini export $ifile -> $rfile"
   ${GEMINI_DIR}/gemini query -q "select chrom,start,end,gene,aa_change from variants" $ifile > $rfile 2>>${FLOG}

   log "End export $ifile -> $tfile"
}

###########################  MAIN ###########################

log "Starting gemini extract parallel ${GATK_VCF_JED_GEM} max ${MAX_JOBS} job(s)"

[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${GATK_VCF_JED_GEM} ] || error_exit "${GATK_VCF_JED_GEM} not found"

FLOG=${WOR_LOGDIR}/${phase}_160_$(date +%y%m%d-%H%M%S).log

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

log "Create ${GATK_VCF_JED_GEM}/dohromady.GATK_regions.txt"

rm -rf ${GATK_VCF_JED_GEM}/dohromady.GATK_regions.txt

# hlavicka 
dbfile=`ls ${GATK_VCF_JED_GEM}/*.GATK_regions.db | head -1`
${GEMINI_DIR}/gemini query --header -q "select * from variants LIMIT 0" $dbfile > ${GATK_VCF_JED_GEM}/hlava.txt
cat ${GATK_VCF_JED_GEM}/hlava.txt | sed "s/^/pac\t/" > ${GATK_VCF_JED_GEM}/dohromady.GATK_regions.txt
rm ${GATK_VCF_JED_GEM}/hlava.txt

for ft in `ls ${GATK_VCF_JED_GEM}/*.GATK_regions.txt | grep -v dohromady`
  do 
   bf=`basename -s .GATK_regions.txt $ft`
   cat $ft | sed '-e 1d' | sed "s/^/$bf\t/" >> ${GATK_VCF_JED_GEM}/dohromady.GATK_regions.txt
  done

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

log "Genini paralel extract done"
