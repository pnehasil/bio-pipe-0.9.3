#!/usr/bin/env ksh93

load_params "$@"
. ${WOR_LIB}/bioenv

 log "### Cnv remote part 1 ###"

 CNV_PORT=2233
 CNV_IP="10.2.46.166"

 command="rm -rf /mnt/raid/users/petra/petr/run$RUN"
 rsh -p ${CNV_PORT} petra@${CNV_IP} $command || error_exit "rsh $command failed"

 command="mkdir -p /mnt/raid/users/petra/petr/run$RUN/RG/cnvkit/picard"
 rsh -p ${CNV_PORT} petra@${CNV_IP} $command || error_exit "rsh $command failed"

 R_RG_DIR="/mnt/raid/users/petra/petr/run$RUN/RG"
 R_PIC_DIR="/mnt/raid/users/petra/petr/run$RUN/RG/cnvkit/picard"

 scp -P 2233 ${RG_DIR}/* petra@${CNV_IP}:${R_RG_DIR} || error_exit "scp ${RG_DIR}/* to petra@${CNV_IP}:${R_RG_DIR} failed"
 scp -P 2233 ${FPIC_DIR}/* petra@${CNV_IP}:${R_PIC_DIR} || error_exit "scp ${FPIC_DIR}/* to petra@${CNV_IP}:${R_PIC_DIR} failed"

 command="cd /mnt/raid/users/petra/petr/run$RUN/RG ; /mnt/raid/users/petra/petr/petra_cnv.sh"
 rsh -p ${CNV_PORT} petra@${CNV_IP} $command || error_exit "rsh $command failed"

 scp -P 2233 petra@${CNV_IP}:${R_RG_DIR}/cnvkit/CNV* ${CNV_KIT_DIR} || error_exit "scp petra@${CNV_IP}:${R_RG_DIR}/cnvkit/CNV* ${CNV_KIT_DIR} failed"
 
