#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=30
MULTIPROCESS=1                          # set to 0 for debugging

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

proc_gen() {

    file=$1
    suf="_dw"
 

    bf=`basename -s .dw $file | cut -d"_" -f1,2`
    bt=`basename -s .dw $file | cut -d"_" -f2`
    sql=${MUMPS_DIR}/$bf.dw.sql
    table=$bt$suf

    log "Start $file -> sql"

    echo "USE run_${RUN};" > $sql
    echo "CREATE TABLE \`$table\` (" >> $sql
    echo '`gene` varchar(20) DEFAULT NULL,' >> $sql
    echo '`chrom` varchar(20) DEFAULT NULL,' >> $sql
    echo '`beg` int(11) DEFAULT NULL,' >> $sql
    echo '`end` int(11) DEFAULT NULL,' >> $sql
    echo '`aa_change` varchar(71) DEFAULT NULL' >> $sql
    echo "--" >> $sql
    echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8;" >> $sql

    id=0
    for line in `cat $file | sort | uniq`
     do
      chr=`echo $line | cut -d"|" -f1`
      beg=`echo $line | cut -d"|" -f2`
      end=`echo $line | cut -d"|" -f3`
      gen=`echo $line | cut -d"|" -f4`
      aac=`echo $line | cut -d"|" -f5`

      echo "INSERT INTO \`$table\` (\`gene\`,\`chrom\`,\`beg\`,\`end\`,\`aa_change\`) VALUES (\"$gen\",\"$chr\",\"$beg\",\"$end\",\"$aac\");" >> $sql

     done

    log "End $file -> sql"

}

###########################  MAIN ###########################


log "Gen sql double errs"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${GATK_VCF_JED_GEM}/*dw`
 do

   #filtrace na nechtene mutace
   cp $f $f.zal
   for kdel in `cat ${WOR_PHASE_DIR}/DW_BLACK.txt`
     do
         log "Mazeme $kdel"
	 #perl -ni -e "print unless /$kdel/" $f
	 grep -v $kdel $f > /tmp/pom
	 mv /tmp/pom $f
     done
     rm /tmp/pom

   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_gen ${f} &
     else
      proc_gen ${f} 
   fi
 done
wait

