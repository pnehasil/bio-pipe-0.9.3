#!/usr/bin/env ksh93
# this scripts executes parallelized translate of fastq files
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=24
MULTIPROCESS=1                          # set to 0 for debugging


proc_fasq() {

file=$1

# pro jednotlive podsoubory vypocteme median

fr=`basename -s .txt $file`
tmp=${TMP_DIR}/ztmp_$fr
pom=${TMP_DIR}/zpom_$fr
#echo "FILE>>$file ztmp>>$tmp"

log "$file > GR1"

# vybereme jen cisla pro vypocet medianu a ulozime do $tmp
    rm -f $tmp
    for line in `cat $file`
      do
        cis=`echo $line | cut -d"|" -f4`
        echo $cis >> $tmp
      done
     
# zjistime kolik radek ma $tmp a setridime ho pres pomocny soubor
      nlines=`wc -l $tmp | cut -d" " -f1`
      cat $tmp | sort -n > $pom
      mv $pom $tmp
     
# v polovine bude hledany median
      pmed=`echo "$nlines/2" | bc`
      count=0
      for line in `cat $tmp`
        do
          count=`expr $count + 1` 
          if [ $count -eq $pmed ]
           then
            med=$line
            break
          fi
        done
     
# pridame vypocet akualni hodnota - median do noveho souboru 
#
# chr16_3640541_3640797|SLX4|001_PKM100_run118|1.044183|-0.031804


    pre="_med.txt"
    nfile=`basename -s .txt $file`
    xfile="${TMP_DIR}/XMED/$nfile$pre"

    #echo $xfile
   
    for line in `cat $file`
      do
        cis=`echo $line | cut -d"|" -f4`
        hodn=`echo "$cis $med" | awk '{printf "%f", $1 - $2}'`
        K1=`echo $line | cut -d"|" -f1`
        G1=`echo $line | cut -d"|" -f2`
        K2=`echo $line | cut -d"|" -f3`
        echo "$G1$pod$K2|$K1|$hodn" >> $xfile

# a vytvorime rovnou podklady pro gnuplot
# ${GR1_DIR}/GEN/PAC

xexo=555
        PAC=`echo $K2 | cut -d"_" -f 2`
        mkdir -p ${GR1_DIR}/$G1
        xexo=`get_exon $G1 $K1 $tmp`
        ks=`echo $K1 | cut -d"_" -f2 | sed 's/ //g'`
        echo "$hodn $xexo $K1 $ks" >> ${GR1_DIR}/$G1/$PAC
      done

rm -f $tmp

}



###########################  MAIN ###########################

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "### Counting median  ###"

mkdir ${TMP_DIR}/XMED

pod="_"

log "MED -> ${TMP_DIR}/XMED/xtmpidx_MED.txt"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${TMP_DIR}/ZTMP/*txt`
  do 
   if [ ${MULTIPROCESS:-0} -eq 1 ] 
     then
       proc_fasq ${f} &
     else
      proc_fasq ${f} 
   fi
  done
wait

