#!/usr/bin/env ksh93

load_params "$@"

log "Gen index.html"
 
. ${WOR_LIB}/bioweb

SP_DIR=${WOR_HOME}/php
PHP_DIR="${OUT_DIR}/soft"
mkdir ${PHP_DIR} || error_exit "Cannot create ${PHP_DIR}"

echo "<?php" > ${PHP_DIR}/dat.php
echo "\$database=\"run_${RUN}x${DBS}\";" >> ${PHP_DIR}/dat.php
echo "?>" >> ${PHP_DIR}/dat.php

cp -a ${SP_DIR}/igv  ${PHP_DIR}
#cp ${SP_DIR}/ukaz.php ${PHP_DIR}
#cp ${SP_DIR}/filtrace.html ${PHP_DIR}
#cp ${SP_DIR}/igv.php ${PHP_DIR}
#cp ${SP_DIR}/kkk.php ${PHP_DIR}
#cp ${SP_DIR}/lll.php ${PHP_DIR}
#cp ${SP_DIR}/vtab.php ${PHP_DIR}
#cp ${SP_DIR}/igv.php ${PHP_DIR}
#cp ${SP_DIR}/pacvar.php ${PHP_DIR}
#cp ${SP_DIR}/vins.php ${PHP_DIR}
#cp ${SP_DIR}/vnova.php ${PHP_DIR}

cp ${SP_DIR}/*php ${PHP_DIR}
cp ${SP_DIR}/*html ${PHP_DIR}
cp ${SP_DIR}/*sh ${PHP_DIR}
cp ${SP_DIR}/*sql ${PHP_DIR}
