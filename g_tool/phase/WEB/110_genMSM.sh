#!/usr/bin/env ksh93

load_params "$@"

log "Gen MSH2 tables"
 
. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

FLOG=${WOR_LOGDIR}/${phase}_110_$(date +%y%m%d-%H%M%S).log

MSH_DIR="${OUT_DIR}/MSH2"
mkdir ${MSH_DIR}

suf="_MSH2"

for file in `ls ${VARSC_DIR}/xgrep/*cnt`
  do
    bf=`basename $file  | cut -d"_" -f2`
    sql=${MSH_DIR}/$bf.sql
    table=$bf$suf

    log "$bf -> $sql"

    line=`cat $file`
    mutG=`echo $line | cut -d"#" -f2`
    allG=`echo $line | cut -d"#" -f3`
    mutT=`echo $line | cut -d"#" -f4`
    allT=`echo $line | cut -d"#" -f5`

    echo "USE run_${RUN}x${DBS};" > $sql
    #echo "DROP TABLE \`$table\`;" >> $sql
    echo "CREATE TABLE \`$table\` (" >> $sql
    echo '`mutG` int(11) DEFAULT NULL,' >> $sql
    echo '`allG` int(11) DEFAULT NULL,' >> $sql
    echo '`mutT` int(11) DEFAULT NULL,' >> $sql
    echo '`allT` int(11) DEFAULT NULL' >> $sql
    echo "--" >> $sql
    echo ") ENGINE=InnoDB DEFAULT CHARSET=utf8;" >> $sql
    echo "--" >> $sql
    echo "ALTER TABLE \`$table\`;" >> $sql
    echo "--" >> $sql

    echo "INSERT INTO \`$table\` (\`mutG\`,\`allG\`,\`mutT\`,\`allT\`) VALUES (\"$mutG\",\"$allG\",\"$mutT\",\"$allT\");" >> $sql

    log "insert $sql"

    mysql -u rweb -p"modry_prizrak" -h 10.2.46.147 < $sql 2>${FLOG}


done

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi

