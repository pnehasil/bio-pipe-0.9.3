#!/usr/bin/env ksh93

load_params "$@"
 
. ${WOR_LIB}/bioweb

log "Copy web files to ${WEB_DIR} on ${WEB_IPA}"

WRUN_DIR=${WEB_DIR}/run_${RUN}x${DBS}

command="mkdir ${WRUN_DIR}"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"

scp -P 7534 ${OUT_DIR}/*html pn@${WEB_IPA}:${WRUN_DIR} || error_exit "scp ${OUT_DIR}/*html to ${WEB_IPA}:${WRUN_DIR} failed"
scp -P 7534 ${OUT_DIR}/*php pn@${WEB_IPA}:${WRUN_DIR} || error_exit "scp ${OUT_DIR}/*html to ${WEB_IPA}:${WRUN_DIR} failed"

command="mkdir ${WRUN_DIR}/det"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/det/* pn@${WEB_IPA}:${WRUN_DIR}/det || error_exit "scp ${OUT_DIR}/det/* to ${WEB_IPA}:${WRUN_DIR}/det failed"

command="mkdir ${WRUN_DIR}/img"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/img/* pn@${WEB_IPA}:${WRUN_DIR}/img || error_exit "scp ${OUT_DIR}/img/* to ${WEB_IPA}:${WRUN_DIR}/img failed"

command="mkdir ${WRUN_DIR}/soft"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/soft/*php pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*php to ${WEB_IPA}:${WRUN_DIR}/soft failed"
scp -P 7534 ${OUT_DIR}/soft/*html pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*html to ${WEB_IPA}:${WRUN_DIR}/soft failed"

command="mkdir ${WRUN_DIR}/soft/igv"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/soft/igv/* pn@${WEB_IPA}:${WRUN_DIR}/soft/igv || error_exit "scp ${OUT_DIR}/soft/ivg* to ${WEB_IPA}:${WRUN_DIR}/soft/igv failed"

command="mkdir ${WRUN_DIR}/bam"
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
scp -P 7534 ${OUT_DIR}/bam/* pn@${WEB_IPA}:${WRUN_DIR}/bam || error_exit "scp ${OUT_DIR}/bam/* to ${WEB_IPA}:${WRUN_DIR}/bam failed"

if [ -f ${OUT_DIR}/extra/nejsou.txt ]
  then
    command="mkdir ${WRUN_DIR}/extra"
    rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"
    scp -P 7534 ${OUT_DIR}/extra/* pn@${WEB_IPA}:${WRUN_DIR}/extra || error_exit "scp ${OUT_DIR}/extra/* to ${WEB_IPA}:${WRUN_DIR}/extra failed"

fi
