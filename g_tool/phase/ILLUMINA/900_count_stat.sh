
# ocekava v ${WOR_LOGDIR} soubor statlog

load_params "$@"
. ${WOR_LIB}/bioenv

TMP_FIL="${G_TMP_DIR}/tmp_$$" 
LOG_FIL=${WOR_LOGDIR}/statlog

[ -e ${LOG_FIL} ] || error_exit "${LOG_FIL} not found"

log "Count statistic"

for line in `cat ${LOG_FIL} | grep "Executing" | sed 's/ /|/g'`
  do 
    tim=`echo $line | cut -d "|" -f2`
    pha=`echo $line | cut -d "|" -f8`
    echo "$tim|$pha" >> ${TMP_FIL}
  done

grep "Phase ILLUMINA" ${LOG_FIL} | cut -d" " -f 1,3 | sed 's/ /|/g' >> ${TMP_FIL}

#[23:45:27]|010_create_dirs_env.sh

#cat ${TMP_FIL}

tim=0
ttot=0
ltim="x"
lpha="x"
lline="x"
lt="X"
for line in `cat ${TMP_FIL}`
 do
   t=`echo $line | cut -d"|" -f1 | sed 's/\[//g' | sed 's/\]//g'`
   th=`echo $t | cut -d":" -f1`
   tm=`echo $t | cut -d":" -f2`
   ts=`echo $t | cut -d":" -f3`
   tim=`echo $th $tm $ts | awk '{printf "%d", $1*60*60 + $2*60 +$3}'`

   pha=`echo $line | cut -d"|" -f2`

   if [ "$ltim" == "x" ]
    then
      ltim=$tim
      lline=$line
      ttot=0
      #echo "prvni pokracujeme"
      continue
   fi

   if [ $ltim -gt $tim ]
    then
     #echo " pres pulnoc $ltim $tim" 
     #86400 - $ltim + $tim
     ttim=`echo $ltim $tim | awk '{printf "%d", 86400 - $1 + $2}'`
    else
     #echo " normal"
     #$tim - $ltim
     ttim=`echo $ltim $tim | awk '{printf "%d", $2 - $1}'`
   fi

   ttot=`expr $ttot + $ttim`

   hod=`echo $ttim | awk '{printf "%d", $1/3600}'`
   if [ $hod -gt 0 ]
    then
      min=`echo $ttim $hod | awk '{printf "%d", ($1-$2*3600)/60}'`
    else
      min=`echo $ttim | awk '{printf "%d", $1/60}'`
   fi  
   if [ $ttim -lt 60 ]
    then
      sec=$ttim
    else
      sec=`echo $ttim $hod $min | awk '{printf "%d", $1-$2*3600-$3*60}'`
   fi

#echo "lline>>$lline line>>$line lt>>$lt t>>$t"
#echo "pha>>$pha lpha>> $lpha tim>>$tim ltim>>$ltim ttim>>$ttim hod>>$hod min>>$min sec>>$sec"
#echo "========================"
echo "$lline|$hod:$min:$sec"


   lt=$t
   lline=$line
   lpha=$pha
   ltim=$tim
 done

 hod=`echo $ttot | awk '{printf "%d", $1/3600}'`
 if [ $hod -gt 0 ]
  then
    min=`echo $ttot $hod | awk '{printf "%d", ($1-$2*3600)/60}'`
  else
    min=`echo $ttot | awk '{printf "%d", $1/60}'`
 fi  
 if [ $ttot -lt 60 ]
  then
    sec=$totm
  else
    sec=`echo $ttot $hod $min | awk '{printf "%d", $1-$2*3600-$3*60}'`
 fi

echo "Total $ttot sec - $hod:$min:$sec"

log "remove ${TMP_FIL}"  
rm -rf ${TMP_FIL}

log "Statistic done"
