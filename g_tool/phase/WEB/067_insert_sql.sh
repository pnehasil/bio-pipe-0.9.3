#!/usr/bin/env ksh93

load_params "$@"

log "Gen detail pages"
 
. ${WOR_LIB}/bioweb

SRC_DIR="${MUMPS_DIR}"
SQL_DIR=${WOR_HOME}/sql

pod="_"
trun="run"

log "Create database for run ${RUN}"

FLOG=${WOR_LOGDIR}/${phase}_67_$(date +%y%m%d-%H%M%S).log

echo "create database run_${RUN}x${DBS};" > ${TMP_DIR}/crdat.sql
mysql -h10.2.46.147 -u rweb -p"modry_prizrak" < ${TMP_DIR}/crdat.sql >> ${FLOG} 2>&1
if [ $? -ne 0 ]
 then 
   error_exit "Cannot create database"
fi

for file in `ls ${SRC_DIR}/*sql`
  do

    log "Insert $file" 
    mysql -h10.2.46.147 -u rweb -p"modry_prizrak" < $file >> ${FLOG} 2>&1
    if [ $? -ne 0 ]
     then 
       log "Insert $file failed"
    fi
  done

for file in `ls ${SQL_DIR}/*sql`
  do

    log "Processt $file" 
    echo "USE run_${RUN}x${DBS};" > /tmp/$$_cr.sql
    cat $file >> /tmp/$$_cr.sql
    mysql -h10.2.46.147 -u rweb -p"modry_prizrak" < /tmp/$$_cr.sql >> ${FLOG} 2>&1
    if [ $? -ne 0 ]
     then 
       log "Insert $file failed"
    fi
    rm /tmp/$$_cr.sql
  done

grep -i ERROR ${FLOG}
if [ $? -eq 0 ]
 then
   error_exit "Error found in ${FLOG}"
fi


