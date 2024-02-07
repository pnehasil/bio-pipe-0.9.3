#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=8
MULTIPROCESS=1                          # set to 0 for debugging

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

proc_gen() {

    file=$1
    tmp=/tmp/exo_$$_$2
 
    bf=`basename -s .fin $file | cut -d"_" -f1,2`
    bt=`basename -s .fin $file | cut -d"_" -f2`
    sql=${MUMPS_DIR}/$bf.pok.sql
    table=$bt$ext

    log "Start $file -> sql"

    echo "USE run_${RUN};" > $sql
    echo "CREATE TABLE \`$table\` (" >> $sql
    echo '`id` int(11) NOT NULL,' >> $sql
    echo '`gene` varchar(20) DEFAULT NULL,' >> $sql
    echo '`chr1` varchar(10) DEFAULT NULL,' >> $sql
    echo '`chr2` varchar(10) DEFAULT NULL,' >> $sql
    echo '`beg` int(11) DEFAULT NULL,' >> $sql
    echo '`end` int(11) DEFAULT NULL,' >> $sql
    echo '`exo` varchar(10) DEFAULT NULL,' >> $sql
    echo '`ecnt`varchar(10) DEFAULT NULL,' >> $sql
    echo '`pk1` varchar(10) DEFAULT NULL,' >> $sql
    echo '`pk2` varchar(10) DEFAULT NULL' >> $sql
    echo "--" >> $sql
    echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8;" >> $sql
    echo "--" >> $sql
    echo "ALTER TABLE \`$table\`" >> $sql
    echo '     ADD UNIQUE KEY `id` (`id`);' >> $sql
    echo "--" >> $sql

    id=0
    for line in `cat $file`
     do
      id=`expr $id + 1`
      chr1=`echo $line | cut -d"|" -f1`
      chr2=`echo $line | cut -d"|" -f4`
      beg=`echo $line | cut -d"|" -f2`
      end=`echo $line | cut -d"|" -f5`
      pk1=`echo $line | cut -d"|" -f3`
      pk2=`echo $line | cut -d"|" -f6`

      xres=`get_exon2 $chr1 $beg $tmp`
      rm $tmp
      exo=`echo $xres | cut -d"|" -f1`
      cnt=`echo $xres | cut -d"|" -f2`
      gen=`echo $xres | cut -d"|" -f3`

      echo "INSERT INTO \`$table\` (\`id\`,\`gene\`,\`chr1\`,\`chr2\`,\`beg\`,\`end\`,\`pk1\`,\`pk2\`,\`exo\`,\`ecnt\`) VALUES (\"$id\",\"$gen\",\"$chr1\",\"$chr2\",\"$beg\",\"$end\",\"$pk1\",\"$pk2\",\"$exo\",\"$cnt\");" >> $sql

     done

    log "End $file -> sql"

}

###########################  MAIN ###########################


log "Gen sql"

POK_DIR="${OUT_DIR}/pokryti"
ext="_pok"
CNT=0

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${POK_DIR}/*fin`
 do
   CNT=`expr $CNT + 1`
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_gen ${f} ${CNT} &
     else
      proc_gen ${f} ${CNT} 
   fi
 done
wait

