#!/usr/bin/env ksh93
# this scripts executes parallelized export from gemini database
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${PREP_DOUBLE_PROC}
MULTIPROCESS=1                          # set to 0 for debugging

proc_double() {

   file=$1
  
   log "Prepare $file"

   bf=`basename -s .double.txt $file`
   tfile=/tmp/$bf
   wfile=${GATK_VCF_JED_GEM}/$bf.dw
   rm -f $wfile

   cat $file | sed 's/\t/|/g' | sed 's/^chr//' > $tfile

   lsta=0
   lline=""
   for line in `cat $tfile`
     do
       sta=`echo $line | cut -d"|" -f2`
       roz=`expr $sta - $lsta | sed 's/-//'`

       if [ "$roz" -lt "3" ]
        then
         c1=`echo $lline | ${BIN_DIR}/get_double.pl`
         c2=`echo $line | ${BIN_DIR}/get_double.pl`
         #t1=`echo $c1 | cut -d"|" -f1`
         #t2=`echo $c2 | cut -d"|" -f1`
         #h1=`echo $c1 | cut -d"|" -f2`
         #h2=`echo $c2 | cut -d"|" -f2`

         if [ "_$c1" != "_|" ]
          then
            if [ "$c1" == "$c2" ] # podle toho jak holky odpovi mozna zrusim parsovani t1, c1...
             then
              echo "$lline" >> $wfile
              echo "$line" >> $wfile
            fi
         fi
       fi

      lsta=$sta
      lline=$line
     done

     rm $tfile

#007_BRCA6087_run47.double.txt
#chr21	36206931	36206932	RUNX1	c.614-34C>T

}

###########################  MAIN ###########################

log "Prepare double errs for web ${MAX_JOBS} job(s)"

[ -d ${GEMINI_DIR} ] || error_exit "${GEMINI_DIR} not found"
[ -d ${GATK_VCF_JED} ] || error_exit "${GATK_VCF_JED} not found"
[ -d ${GATK_VCF_JED_GEM} ] || error_exit "${GATK_VCF_JED_GEM} not found"

FLOG=${WOR_LOGDIR}/${phase}_180_$(date +%y%m%d-%H%M%S).log

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED_GEM}/*double.txt`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_double ${f} &
     else
      proc_double ${f} 
   fi
  done
wait

log "Prepare done"

