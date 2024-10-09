#!/usr/bin/env ksh93

load_params "$@"
 
. ${WOR_LIB}/bioweb

FLOG=${WOR_LOGDIR}/${phase}_990_$(date +%y%m%d-%H%M%S).log

log "Copy web files to ${WEB_DIR} on ${WEB_IPA}"

WRUN_DIR=${WEB_DIR}/run_${RUN}x${DBS}
SQL_DIR=${WOR_HOME}/sql

command="mkdir ${WRUN_DIR}"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"

scp -P 7534 ${OUT_DIR}/*html pn@${WEB_IPA}:${WRUN_DIR} || error_exit "scp ${OUT_DIR}/*html to ${WEB_IPA}:${WRUN_DIR} failed"
scp -P 7534 ${OUT_DIR}/*php pn@${WEB_IPA}:${WRUN_DIR} || error_exit "scp ${OUT_DIR}/*html to ${WEB_IPA}:${WRUN_DIR} failed"

command="mkdir ${WRUN_DIR}/img"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/img/* pn@${WEB_IPA}:${WRUN_DIR}/img || error_exit "scp ${OUT_DIR}/img/* to ${WEB_IPA}:${WRUN_DIR}/img failed"

command="mkdir ${WRUN_DIR}/soft"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/soft/*php pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*php to ${WEB_IPA}:${WRUN_DIR}/soft failed"
scp -P 7534 ${OUT_DIR}/soft/*html pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*html to ${WEB_IPA}:${WRUN_DIR}/soft failed"
scp -P 7534 ${OUT_DIR}/soft/*sh pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*sh to ${WEB_IPA}:${WRUN_DIR}/soft failed"
scp -P 7534 ${OUT_DIR}/soft/*sql pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*sql to ${WEB_IPA}:${WRUN_DIR}/soft failed"

echo "create database run_${RUN}x${DBS};" > ${TMP_DIR}/crdat.sql
mysql -h10.2.46.147 -u rweb -p"modry_prizrak" < ${TMP_DIR}/crdat.sql >> ${FLOG} 2>&1
if [ $? -ne 0 ]
 then
   error_exit "Cannot create database"
fi

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

