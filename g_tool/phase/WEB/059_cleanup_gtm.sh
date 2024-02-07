#!/usr/bin/env ksh93

load_params "$@"

log "Clean GTM"
 
. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

. ${GTM_DIR}/biowenv
mupip rundown -r "*"

rm ${GTM_DIR}/gbls/*dat

mupip create

