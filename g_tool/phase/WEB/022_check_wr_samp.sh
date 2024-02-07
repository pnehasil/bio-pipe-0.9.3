#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=30
MULTIPROCESS=1                          # set to 0 for debugging

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

proc() {

    log "Begin $PAC -> wrong samples"

    PAC=$1
    tmp=${T_DIR}/tproc_$2
    tmp4=${T_DIR}/tmp4_$2

    grep $PAC $XMED/* | cut -d "|" -f3 > $tmp4

    CNTP=0
    CNTM=0
    for XX in `cat $tmp4`
     do
      DM=`echo "($XX-0.1)*10" | bc | cut -d"." -f1`
      if [ "$DM" == "" ] || [ "$DM" == "-" ]
       then
        echo "paznaky" > /dev/null
       else
        echo " treba porovnat" > /dev/null
        if [ $DM -lt -6 ]
         then
          CNTM=`expr $CNTM + 1`
        fi
       fi

      HM=`echo "($XX+0.1)*10" | bc | cut -d"." -f1`
      if [ "$HM" == "" ] || [ "$HM" == "-" ]
       then
        echo "paznaky" > /dev/null
       else
        echo " treba porovnat" > /dev/null
        if [ $HM -gt 5 ]
         then
          CNTP=`expr $CNTP + 1`
        fi
      fi

     done
     echo "$PAC|$CNTP|$CNTM" > $tmp

     log "End $PAC -> wrong samples"

}

###########################  MAIN ###########################


log "### Check for wrong samples ###"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

XMED=${TMP_DIR}/XMED

T_DIR=${G_TMP_DIR}/wr_samp
mkdir ${T_DIR} || error_exit "Cannot create ${T_DIR}"

tmp1=${T_DIR}/tmp1_$$
tmp2=${T_DIR}/tmp2_$$
tmp3=${T_DIR}/tmp3_$$

W_SAMP=${TMP_DIR}/blbe_vzorky.txt
rm -f ${W_SAMP}

#zjistime jake mame pacienty
find $GR1_DIR -print > $tmp1
for fil in `cat $tmp1`
 do
   if [ -f "$fil" ]
     then
       basename -s .zal $fil >> $tmp2
   fi
 done

cat $tmp2 | sort | uniq > $tmp3

# v tmp3 mame pacienty, najdeme k nim vypocitane mediany a spocteme
# kolikrat prelezli -0.6 a +0.5

CNT=0
for PAC in `cat $tmp3`
 do
   CNT=`expr $CNT + 1`
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc ${PAC} ${CNT} &
     else
      proc ${PAC} ${CNT} 
   fi
 done
wait

# slozime data od pacientu do jednoho spuboru pro pozdejsi zpracovani
cat ${T_DIR}/tproc_* >> ${W_SAMP}

# a uklidime po sobe
rm -rf ${T_DIR}
