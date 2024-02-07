#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "Check input file"

export LC_ALL="C" # for numeric sort

[ -d ${OUT_DIR} ] || error_exit "${OUT_DIR} not found"

log "Cut data for gnuplot"


for dir in `ls ${GR1_DIR} | grep -v ","` # vynechame adresare s carkou v nazvu
  do
    cd ${GR1_DIR}/$dir
    for xfile in `ls *`
      do
       mv $xfile $xfile.zal
       cat $xfile.zal | cut -d" " -f1,2 > $xfile
      done 
  done

log "Generate images"

cd ${GR2_DIR}
for i in `ls *plot`
  do
    #echo $i
    out=`echo $i | cut -d"." -f1`
    gnuplot $i > $out.png

  done

