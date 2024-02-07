#!/usr/bin/env ksh93

load_params "$@"

. ${WOR_LIB}/bioweb
. ${WOR_LIB}/bioenv

log "Check input file"

export LC_ALL="C" # for numeric sort

[ -d ${OUT_DIR} ] || error_exit "${OUT_DIR} not found"

rm -f ${PRELEZLE}

log "Create program for gnuplot"


for dir in `ls ${GR1_DIR} | grep -v ","` # vynechame adresare s carkou v nazvu
  do

    cd ${GR1_DIR}/$dir

# setridit vsechny soubory dle prvni koordinaty a pridat do prvniho sloupce cislo radku
# tridime vzestupne, kdyz najdeme v referenci na konci +, jinak sestupne

    jak=`grep $dir ${BED_DIR}/final_APC_CZE_1.2_anot.txt | head -1 | cut -f8`
    if [ "$jak" == "+" ]
     then
       for xfile in `ls *`
         do
           sort -n -k4 $xfile | nl | sed 's/^[ ]*//' | sed 's/\t/ /g' > ./xxtmp
           mv ./xxtmp $xfile
         done 
     else
       for xfile in `ls *`
         do
           sort -n -r -k4 $xfile | nl | sed 's/^[ ]*//' | sed 's/\t/ /g' > ./xxtmp
           mv ./xxtmp $xfile
         done 
    fi

    XR=`wc -l * | sed 's/^ *//g'| cut -d" " -f1 | sort -nr | head -2 | tail -1`
    XR=`expr $XR + 1`
    
    TN=`echo $GR2_DIR/$dir"_tn.txt"`
    TD=`echo $GR2_DIR/$dir"_td.txt"`

    echo "0 0.5" > $TN
    echo "$XR 0.5" >> $TN
    echo "0 -0.6" > $TD
    echo "$XR -0.6" >> $TD

    lnk=`echo $GR2_DIR/$dir".lnk"`
    out=`echo $GR2_DIR/$dir".plot"`
    outm=`echo $GR2_DIR/$dir"_m.plot"`
    echo "set term png giant size 1400,900" >> $out
    echo "set term png giant size 550,400" >> $outm
    echo "set yrange [-1.5 to 1.5]" >> $out
    echo "set yrange [-1.5 to 1.5]" >> $outm
    echo "set xrange [0 to $XR]" >> $out
    echo "set xrange [0 to $XR]" >> $outm
    echo "set title \"$dir\"" >> $out
    #echo "set title \"$dir\"" >> $outm
    echo "set key out vert" >> $out
    #echo "set key right top" >> $out
    #echo "set nokey" >> $out
    echo "set nokey" >> $outm


# set bmargin 8;
# set xtics rotate ("1.exom" 1,....);
# staci prvni soubor, zbytek ma stejny pocet radek i koordinaty
    xcnt=0
    XTI="set xtics rotate ("
    xfil=`ls ./* | head -1`
    for xlin in `cat $xfil | sed 's/ /|/g'`
      do
        xcnt=`expr $xcnt + 1`
        exon=`echo $xlin | cut -d"|" -f3`
        XTI="$XTI\"e$exon\" $xcnt, "
      done
     XTI="$XTI);"
     echo "set bmargin 4;" >> $out
     echo "set bmargin 4;" >> $outm
     echo $XTI >> $out
     echo $XTI >> $outm

    PLM="plot"
    PLV="plot"
    BARCNT=0
    for fil in `ls ./*`
      do
       RED=0
       # -0.6
       DM=`cat $fil | cut -d" " -f2 | sort -n | grep -v "E" | head -1`
       if [ "$DM" != "" ]
        then
          DM=`echo "($DM-0.1)*10" | bc | cut -d"." -f1`
       fi
       if [ "$DM" == "" ] || [ "$DM" == "-" ]
        then
          echo "paznaky" > /dev/null
        else
          echo " treba porovnat" > /dev/null
          if [ $DM -lt -6 ] 
           then
             RED=1
          fi
       fi

       # 0.5
       HM=`cat $fil | cut -d" " -f2 | sort -n | grep -v "E" | tail -1`
       if [ "$HM" != "" ]
        then
          HM=`echo "($HM+0.1)*10" | bc | cut -d"." -f1`
       fi
       if [ "$HM" == "" ] || [ "$HM" == "-" ]
        then
          echo "paznaky" > /dev/null
        else
          echo " treba porovnat" > /dev/null
          if [ $HM -gt 5 ]
           then
             RED=1
          fi
       fi


       ufil=`basename $fil`
       cfil="$GR1_DIR/$dir/$ufil"
       #PL=`echo "$PL \"$cfil\" with lines title \"$ufil\", "`
       if [ $RED -eq 1 ]
        then

# pokud prelezlo, schovame si do souboru, abychom pak mohli
# udelat stranku jen s prelezlyma 

          echo "$dir" >> ${PRELEZLE}

          BARCNT=`expr $BARCNT + 1`
          PLM=`echo "$PLM \"$cfil\" with lines lw 2 lc \"#ff0000\", "`
          PLV=`echo "$PLV \"$cfil\" with lines lw 3 lc $BARCNT title \"$ufil\", "`
          echo $ufil >> $lnk
        else
          PLM=`echo "$PLM \"$cfil\" with lines lc \"#a0a0a0\", "`
          PLV=`echo "$PLV \"$cfil\" with lines lc \"#a0a0a0\" title \"\", "`
       fi
       #echo $dir $fil

      done
    PLM=`echo "$PLM \"$TD\" with lines lw 3 lc 20 title \"\", \"$TN\" with lines lw 3 lc 20 title \"\""`
    PLV=`echo "$PLV \"$TD\" with lines lw 3 lc 20 title \"\", \"$TN\" with lines lw 3 lc 20 title \"\""`
    echo $PLV >> $out
    echo $PLM >> $outm
    echo "set output" >> $out
    echo "set output" >> $outm
     cd ../..

  done

# jeste prelezle zkratime...

sort ${PRELEZLE} | uniq > ./xtmp
mv ./xtmp ${PRELEZLE}

exit 0
