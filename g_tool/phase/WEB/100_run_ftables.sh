#!/usr/bin/env ksh93

load_params "$@"
 
. ${WOR_LIB}/bioweb

log "Run ftables"

WRUN_DIR=${WEB_DIR}/run_${RUN}
echo ${WRUN_DIR} 

OUT_FIL="${G_TMP_DIR}/gen_cop.sh"
pod="_"

echo "export RUN=\"run_${RUN}\"" > ${OUT_FIL}
cat ${WOR_HOME}/scripts/gen_ftab.sh >> ${OUT_FIL}

scp -P 7534 ${WOR_HOME}/php/id_to_file.php pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*php to ${WEB_IPA}:${WRUN_DIR}/soft failed"
scp -P 7534 ${OUT_FIL} pn@${WEB_IPA}:${WRUN_DIR}/soft || error_exit "scp ${OUT_DIR}/soft/*php to ${WEB_IPA}:${WRUN_DIR}/soft failed"

command="sh ${WRUN_DIR}/soft/gen_cop.sh /mnt/sdc/www/runy/run_$RUN/soft"
echo $command
rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"



#cp ${WOR_HOME}/php/id_to_file.php ${G_TMP_DIR}


#command="mkdir ${WRUN_DIR}/soft/OUT"
#rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"

#command="sh ${WRUN_DIR}/soft/gen_cop.sh"
#rsh -p 7534 pn@${WEB_IPA} $command || error_exit "rsh $command failed"

#echo ${WEB_IPA}
#echo ${WRUN_DIR}

log "End ftables"
