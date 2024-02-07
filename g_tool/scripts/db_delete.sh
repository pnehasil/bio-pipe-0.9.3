#!/usr/bin/env ksh93
#

load_params "$@"

log "Delete DB ${TGTENV}"

[ -d ${TGTENV} ] || error_exit "No target directory found"

. ${TGTENV}/bio1env #> /dev/null
	CMD="rm -f ${TGTENV}/gbls/*dat"
	log ${CMD}
	${CMD} || error_exit "Error status $?"

	exit 0
