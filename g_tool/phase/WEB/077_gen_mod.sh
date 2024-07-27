#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"

typeset -i MAX_JOBS

MAX_JOBS=8
MULTIPROCESS=1                          # set to 0 for debugging

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv



proc_mod() {

    file=$1

    log "$file start"
    bf=`basename -s .dep $file`
    hfile=${MOUT_DIR}/$bf.html

    R --slave --no-restore --file=/mnt/xraid/Workspace/Wor264T/g_tool/phase/WEB/modraky.R --args "$file" "$bf" "$MOUT_DIR/"

    cat ${WOR_HOME}/web_templ/poj_1.tem > ${hfile}
    echo "<center><h3> Run ${RUN} </h3></center>" >> ${hfile}
    echo "<br><br>" >> ${hfile}

    echo "<table>" >> ${hfile}

    cnt=0
    for img in `ls ${MOUT_DIR}/$bf*png`
      do
	 bimg=`basename $img`
	 himg=`basename $img | sed 's/png/html/'`
	 mod=`echo $(($cnt%4))`

	 echo $mod

         if [ $mod -eq 0 ]
	 then
	    echo "<tr>" >> ${hfile}
	 fi

	 echo "<td> <a href=./$himg> <img src=./$bimg width=\"400\"></a> </td>" >> ${hfile}

         if [ $mod -eq 3 ]
	 then
	    echo "</tr>" >> ${hfile}
	    echo "<tr><td height=\"80\"> </td></tr>" >>  ${hfile}
	 fi

         cnt=`expr $cnt + 1`

      done

    echo "</tr>" >> ${hfile}
    echo "</table>" >> ${hfile}


    log "$file end"

}  

###########################  MAIN ###########################

log "Gen depth start"

SRC_DIR="${RECALIBRATED_DIR}"
MOUT_DIR=${OUT_DIR}/modraci

mkdir ${MOUT_DIR}

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX
for f in `ls ${RECALIBRATED_DIR}/*dep`
 do
   CNT=`expr $CNT + 1`
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc_mod ${f} ${CNT} &
     else
      proc_mod ${f} ${CNT}
   fi
 done
wait


log "Gen depth end"

