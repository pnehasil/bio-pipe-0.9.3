#!/usr/bin/env ksh93
# this scripts executes parallelized export from gemini database
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${ADD_ALT_WT_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_crwt() {

   file=$1

   bf=`basename -s .n.final.decomp.tmp $file`
   pac=`echo $bf | cut -d"_" -f1-3`

   log " Create  ${WT_DIR}/$pac.txt"

   XTMP_FIL=${WT_DIR}/$pac.txt
   for line in `cat ${file} | sed '/^#/d' | sed 's/\t/|/g'`
    do

      pr=`echo $line | cut -d"|" -f1-2`
      dr=`echo $line | cut -d"|" -f4-5`
      tr=`echo $line | cut -d"|" -f10`
      x=`echo $tr | cut -d":" -f2`
      tr1=`echo $x | cut -d"," -f1`
      tr2=`echo $x | cut -d"," -f2`

      echo "$pac|$pr|$dr|$tr1|$tr2" >> ${XTMP_FIL}

    done

#001_PKMK187_run51|chr22|42031953|C|G|0|48
#001_BNKV114_run101|chr1|226019261|G|A|3|4

}

proc_wt() {

   ifile=$1

   pac=`basename -s .txt $ifile`

   log "ADD ALT,WT $pac"

   XTMP_DIR=${WT_DIR}/$pac
   mkdir ${XTMP_DIR}

   grep $pac ${GATK_VCF_JED_GEM}/dohromady.GATK_regions.txt | sed 's/\t/#/g' > ${XTMP_DIR}/dohromady.txt
   
   for line in `cat ${XTMP_DIR}/dohromady.txt`
    do

       pr=`echo $line | cut -d"#" -f1-2 | sed 's/#/|/g'`
       dr=`echo $line | cut -d"#" -f4 | sed 's/#/|/g'`

       ref=`echo $line | cut -d"#" -f8`
       alt=`echo $line | cut -d"#" -f9`

       hl=`echo "$pr|$dr|$ref|$alt"`

       pac=`echo $line | cut -d"#" -f1`

       p1="-"
       p2="-"
       xl=`echo $line#$p1#$p2`
       grep "$hl" ${WT_DIR}/$pac.txt > ${XTMP_DIR}/xtmp.txt
       if [ $? -eq 0 ]
        then
         p1=`cat ${XTMP_DIR}/xtmp.txt | cut -d"|" -f6`
         p2=`cat ${XTMP_DIR}/xtmp.txt | cut -d"|" -f7`
         xl=`echo $line#$p1#$p2`
        else
         delka=`echo ${#ref}`
         dr=`expr $dr - $delka + 1`
         hl=`echo "$pr|$dr|$ref|$alt"`
         grep "$hl" ${WT_DIR}/$pac.txt > ${XTMP_DIR}/xtmp.txt
         if [ $? -eq 0 ]
          then
          p1=`cat ${XTMP_DIR}/xtmp.txt | cut -d"|" -f6`
          p2=`cat ${XTMP_DIR}/xtmp.txt | cut -d"|" -f7`
          xl=`echo $line#$p1#$p2`
         fi
       fi

       echo $xl >> ${XTMP_DIR}/vys.txt
    done
}

###########################  MAIN ###########################

log "Add ALT and WT max ${MAX_JOBS} job(s)"

[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${GATK_VCF_JED_GEM} ] || error_exit "${GATK_VCF_JED_GEM} not found"

FLOG=${WOR_LOGDIR}/${phase}_170_$(date +%y%m%d-%H%M%S).log

WT_DIR=${GATK_VCF_JED_GEM}/wt
mkdir ${WT_DIR}

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED}/*.n.final.decomp.tmp`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_crwt ${f} &
     else
      proc_crwt ${f} 
   fi
  done
wait

for f in `ls ${WT_DIR}/*.txt`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_wt ${f} &
     else
      proc_wt ${f} 
   fi
  done
wait

# vygenerujeme hlavicku 
dbfile=`ls ${GATK_VCF_JED_GEM}/*db | head -1`
${GEMINI_DIR}/gemini query --header -q "select * from variants LIMIT 0" $dbfile > ${GATK_VCF_JED_GEM}/hlava.txt

cat ${GATK_VCF_JED_GEM}/hlava.txt | sed "s/^/pac\t/" | sed "s/$/\tWT\tALT/" > ${GATK_VCF_JED_GEM}/dohromady.GATK_regions_WT.txt

for file in `ls ${WT_DIR}/*txt`
 do
   pac=`basename -s .txt $file`
   cat ${WT_DIR}/$pac/vys.txt | sed 's/#/\t/g' >> ${GATK_VCF_JED_GEM}/dohromady.GATK_regions_WT.txt
   
   cat ${GATK_VCF_JED_GEM}/hlava.txt | sed "s/$/\tWT\tALT/" > ${GATK_VCF_JED_GEM}/$pac.GATK_regions_WT.txt
   cat ${WT_DIR}/$pac/vys.txt | sed "s/^$pac#//" | sed 's/#/\t/g' >> ${GATK_VCF_JED_GEM}/$pac.GATK_regions_WT.txt

 done

rm ${GATK_VCF_JED_GEM}/hlava.txt
log "ADD ALR,WT done"
