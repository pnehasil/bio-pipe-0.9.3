#!/usr/bin/env ksh93

load_params "$@"


. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "### Check for wrong samples ###"

#limit pri jehoz prekroceni se vzorek nezaradi do regulerniho zpracovani
TRS=200  


tmp1=${G_TMP_DIR}/tmp1_$$

W_SAMP=${TMP_DIR}/blbe_vzorky.txt

cd $GR1_DIR

for xsam in `cat ${W_SAMP}`
 do
   pac=`echo $xsam | cut -d"|" -f1`
   valp=`echo $xsam | cut -d"|" -f2`
   valm=`echo $xsam | cut -d"|" -f3`

   if [ "$valp" -gt "$TRS" ] && [ "$valm" -gt "$TRS" ]
    then
     find . -name $pac >> $tmp1
   fi
 done

if [ -e $tmp1 ]
 then
  for pr in `cat $tmp1`
   do
    log "mv $pr $GR3_DIR"
    cp --parents $pr $GR3_DIR
    rm $pr
   done
  rm $tmp1 
 else
   log "No wrong samples found"
fi

