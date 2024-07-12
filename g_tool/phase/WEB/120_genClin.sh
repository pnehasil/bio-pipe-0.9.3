#!/usr/bin/env ksh93

load_params "$@"

log "Gen CLNSIGCONF.sql"
 
. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

FLOG=${WOR_LOGDIR}/${phase}_120_$(date +%y%m%d-%H%M%S).log
log "Start" >> ${FLOG}

CLIN_DIR="${OUT_DIR}/CLIN"
mkdir ${CLIN_DIR}

table="CLNSIGCONF"
sql="${CLIN_DIR}/CLNSIGCONF.sql"

rm -f ${CLIN_DIR}/clindet.cli
for file in `ls ${GATK_VCF_JED_GEM}/*cli`
  do
     cat $file >> ${CLIN_DIR}/clindet.cli
  done
sort ${CLIN_DIR}/clindet.cli | uniq | sed 's/|/<br>/g' > ${CLIN_DIR}/clindet.final

echo "USE run_${RUN}x${DBS};" > $sql
echo "DROP TABLE if exists  \`$table\`;" >> $sql
echo "CREATE TABLE \`$table\` (" >> $sql
echo '`chr` varchar(40) DEFAULT NULL,' >> $sql
echo '`start` int(11) DEFAULT NULL,' >> $sql
echo '`end` int(11) DEFAULT NULL,' >> $sql
echo '`ref` varchar(127) DEFAULT NULL,' >> $sql
echo '`alt` varchar(127) DEFAULT NULL,' >> $sql
echo '`cli` varchar(400) DEFAULT NULL' >> $sql
echo "--" >> $sql
echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8;" >> $sql
echo "--" >> $sql
echo "ALTER TABLE \`$table\`;" >> $sql
echo "--" >> $sql

for line in `cat ${CLIN_DIR}/clindet.final | sed 's/\t/#/g'`
 do
   chr=`echo $line | cut -d"#" -f1`
   start=`echo $line | cut -d"#" -f2`
   end=`echo $line | cut -d"#" -f3`
   ref=`echo $line | cut -d"#" -f4`
   alt=`echo $line | cut -d"#" -f5`
   cli=`echo $line | cut -d"#" -f6`

   echo "INSERT INTO \`$table\` (\`chr\`,\`start\`,\`end\`,\`ref\`,\`alt\`,\`cli\`) VALUES (\"$chr\",\"$start\",\"$end\",\"$ref\",\"$alt\",\"$cli\");" >> $sql

 done

log "insert $sql"

mysql -u rweb -p"modry_prizrak" -h 10.2.46.147 < $sql 2>${FLOG}



grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

