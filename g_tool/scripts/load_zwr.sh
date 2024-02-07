#!/usr/bin/env ksh93

#set -x

load_params "$@"

ZWR_DIR="${TGTENV}/IMPORT"

log "Load zwr extract from ${ZWR_DIR}"

[ -d ${ZWR_DIR} ] || error_exit "${ZWR_DIR} not found"

for ZFILE in `ls ${ZWR_DIR}/*zwr`
  do
    echo $ZFILE
    mupip_load ${TGTENV} ${ZFILE} "-for=zwr -fill=80" 
  done

exit

