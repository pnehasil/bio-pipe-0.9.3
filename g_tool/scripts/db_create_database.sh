#!/usr/bin/env ksh93
#

load_params "$@"

log "Create DB segments in ${TGTENV}"


. ${TGTENV}/biowenv #> /dev/null
	CMD="$gtm_dist/mupip create"
	${CMD} || error_exit "Error status $?"

	exit 0
