#!/usr/bin/env ksh93

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${GEM2TXT_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_run() {

for line in `cat $1`
  do
   chr=`echo $line | cut -d "#" -f1`
   beg=`echo $line | cut -d "#" -f2`
   end=`echo $line | cut -d "#" -f3`
   ref=`echo $line | cut -d "#" -f7`
   alt=`echo $line | cut -d "#" -f8`
   unk=`echo $line | cut -d "#" -f152`

   echo "$chr|$beg|$end|$ref|$alt|$unk" >> $webfile

  done
}

###########################  MAIN ###########################

log "### Gemini to txt ###"

dbfile=${GVCF_DIR}/dohromady.g.db

[ -e ${GVCF_DIR}/dohromady.g.db ] || error_exit "${GVCF_DIR}/dohromady.g.db not ifound"

FLOG=${WOR_LOGDIR}/${phase}_115_$(date +%y%m%d-%H%M%S).log

ofile=${GVCF_DIR}/nase.txt
obezfile=${GVCF_DIR}/nase_bez_show.txt
webfile=${GVCF_DIR}/unkn_col.web

rm -f $webfile

log "gemini query -q select * from variants --header --carrier-summary-by-phenotype phenotype --show-samples $dbfile > $ofile"
${GEMINI_DIR}/gemini query -q "select * from variants" --header --carrier-summary-by-phenotype phenotype --show-samples $dbfile > $ofile 2>>$FLOG

log "gemini query -q select * from variants --header --carrier-summary-by-phenotype phenotype $dbfile > $obezfile"
${GEMINI_DIR}/gemini query -q "select * from variants" --header --carrier-summary-by-phenotype phenotype $dbfile > $obezfile 2>>$FLOG

TMP_DIR="${G_TMP_DIR}/tmp_$$"
log "Create tmp dir ${TMP_DIR}"
mkdir ${TMP_DIR} || error_exit "Cannot create ${TMP_DIR}"

tmpfile=${TMP_DIR}/t115_$$ 

log "Extract chrom,start,end,start,end,unknown from $obezfile"
cat $obezfile | sed 's/\t/#/g' | sed -e '1d' > $tmpfile

split -l 1000 $tmpfile ${TMP_DIR}/rr_

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${TMP_DIR}/rr*`
  do
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_run ${f} &
     else
      proc_run ${f}
   fi
  done
wait

rm -r ${TMP_DIR}

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi   
