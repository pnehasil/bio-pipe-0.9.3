#!/usr/bin/env ksh93
# The max number of processes runing at one time is defined
# in the MAX_JOBS shell variable

load_params "$@"
. ${WOR_LIB}/bioenv

typeset -i MAX_JOBS

MAX_JOBS=${NPIN_PROC}
MULTIPROCESS=1                          # set to 0 for debugging


proc() {

    fil=$1
    suf=$2

     log "Start $1"

     bf=`basename -s .txt_D $fil`
     nf=$bf$d
     cp ${FPIN_DIR}/$bf*_D ${BPIN_DIR}/$nf
     nf=$bf$si
     cp ${FPIN_DIR}/$bf*_SI ${BPIN_DIR}/$nf
     nf=$bf$rp
     cp ${FPIN_DIR}/$bf*_RP ${BPIN_DIR}/$nf
     nf=$bf$li
     cp ${FPIN_DIR}/$bf*_LI ${BPIN_DIR}/$nf
     nf=$bf$td
     cp ${FPIN_DIR}/$bf*_TD ${BPIN_DIR}/$nf
     nf=$bf$inv
     cp ${FPIN_DIR}/$bf*_INV ${BPIN_DIR}/$nf

     ${BIN_DIR}/pindel2vcf -P ${BPIN_DIR}/$bf -r ${REF_DIR}/HG19uscs.fa -R HG19UCSC -d 20100830 -G -mc 10 -v ${BPIN_DIR}/$bf.vcf >> $FLOG 2>&1

   #log "Bgzip, tabix, bcftools"
   bgzip ${BPIN_DIR}/$bf.vcf

   tabix ${BPIN_DIR}/$bf.vcf.gz

   ${BCFTOOLS_13_DIR}/bcftools annotate -x FMT/PL  ${BPIN_DIR}/$bf.vcf.gz > ${BPIN_DIR}/$bf.PL.vcf

   bgzip ${BPIN_DIR}/$bf.PL.vcf

   tabix ${BPIN_DIR}/$bf.PL.vcf.gz

   ${BCFTOOLS_13_DIR}/bcftools view -i 'INFO/SVLEN < -10 | INFO/SVLEN > 10'  ${BPIN_DIR}/$bf.PL.vcf.gz > ${BPIN_DIR}/$bf.PL_filtr20.vcf

   cat ${BPIN_DIR}/$bf.PL_filtr20.vcf | awk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k2,2n"}' >  ${BPIN_DIR}/$bf.PL_filtr20_sort.vcf

   #log "Bgzip, tabix"
   bgzip ${BPIN_DIR}/$bf.PL_filtr20_sort.vcf

   tabix ${BPIN_DIR}/$bf.PL_filtr20_sort.vcf.gz

VCF=${BPIN_DIR}/$bf.PL_filtr20_sort.vcf.gz
tmp1=${BPIN_DIR}/$bf.tmp1
tmp2=${BPIN_DIR}/$bf.tmp2
NORMVCF=${BPIN_DIR}/$bf.norm.vcf
REF=${DATABASE_GATK_DIR}/ucsc.hg19.fasta


zless $VCF | sed 's/ID=AD,Number=./ID=AD,Number=R/' | ${VT_DIR}/vt decompose -s - > $tmp1 2>>${FLOG}
cat $tmp1  | ${VT_DIR}/vt normalize -n -r $REF - > $tmp2 2>>${FLOG}
cat $tmp2 | java -Xmx${NPIN_RAM} -jar ${SNPEFF_DIR}/snpEff.jar -classic -formatEff -noShiftHgvs -hgvs \
    -spliceSiteSize 12 -v hg19 -onlyTr ${BED_DIR}/mytranscripts_NM.txt > $NORMVCF 2>>${FLOG}

#echo "copy $NORMVCF $NORMVCF.zal"

cp $NORMVCF $NORMVCF.zal

#lines for delete - 5th column contain *
lines=`grep -P -n "\t\*\t" $NORMVCF | cut -d":" -f1`
TMP_FIL="/tmp/src_tmp_$$_$suf"
log "Create ad hoc script ${TMP_FIL}"

todel="'"
for xline in `echo $lines`
   do
     pom="d"
     todel=`echo "$todel$xline$pom;"`
   done
   echo "sed -i $todel' $NORMVCF" > ${TMP_FIL}

log "Run script ${TMP_FIL}"
ksh ${TMP_FIL}
rm ${TMP_FIL}

f1p=${BPIN_DIR}/$bf.final_norm.f1p.vcf
fixp=${BPIN_DIR}/$bf.final_norm.FS.fixp.vcf
normfinal=${BPIN_DIR}/$bf.final_norm.final.vcf

${BCFTOOLS_13_DIR}/bcftools filter -i 'FMT/AD[1] / (FMT/AD[0] + FMT/AD[1]) > 0.1 && FMT/AD[1] > 2' $NORMVCF > $f1p
${BCFTOOLS_DIR}/vcffixup $f1p > $normfinal 2>>${FLOG}

   dbfile=${BPIN_DIR}/$bf.pindel.db
   tfile=${BPIN_DIR}/$bf.pindel.txt
   wfile=${BPIN_DIR}/$bf.pindel.web
   vcf_file=${GEMINI_DATA}/clinvar_20190102.tidy.vcf.gz
   export PATH=${GEMINI_DIR}:$PATH

   log "Start gemini load $ifile -> $dbfile"
   ${GEMINI_DIR}/gemini load -v $normfinal -t snpEff --cores 1 $dbfile >>${FLOG} 2>>${FLOG}

   log "Start gemini select $dbfile -> $tfile"
   ${GEMINI_DIR}/gemini query --header  -q "select * from variants" $dbfile > $tfile 2>>${FLOG}


pod="_"
for line in `cat $tfile | cut -f1-3,7,8,12,21,53,54,61,66 | sed 's/\t/#/g' | sed '1d'`
  do
      chr=`echo $line | cut -d"#" -f1`
      sta=`echo $line | cut -d"#" -f2`
      end=`echo $line | cut -d"#" -f3`
      ref=`echo $line | cut -d"#" -f4`
      alt=`echo $line | cut -d"#" -f5`
      typ=`echo $line | cut -d"#" -f6 | sed 's/DUP:TANDEM/TD/' | sed 's/DEL/D/' | sed 's/INS/I/'`
      len=`echo $line | cut -d"#" -f7 | sed 's/-//'`
      gen=`echo $line | cut -d"#" -f8`
      tra=`echo $line | cut -d"#" -f9 | cut -d"." -f1`
      cha=`echo $line | cut -d"#" -f10`

      xsta=`expr $sta + 1`
      xend=`expr $end + 1`

      grep ^$chr $normfinal | sed 's/\t/#/g' > /tmp/pom_$CNT
      hl="$chr#$xsta#.#$ref#$alt#"
      rd=`grep $hl /tmp/pom_$CNT | cut -d"#" -f 10 | cut -d"," -f2`
      wt=`grep $hl /tmp/pom_$CNT | cut -d"#" -f 10 | cut -d"," -f1 | cut -d":" -f2`

      fra=`echo "scale=3; 100*($rd/($wt + $rd))" | bc | cut -d"." -f1`

      echo "$chr$pod$sta$pod$end$pod$typ$pod$len#$chr#$sta#$end#$typ#$len#$rd#$bf#$gen#$tra#$fra#$cha" >> ${BPIN_DIR}/$bf.brno 


  done


    
   log "End $1"

    }


###############################MAIN########################################


FLOG=${WOR_LOGDIR}/${phase}_990_$(date +%y%m%d-%H%M%S).log


log "Create New pindel parallel in ${NPIN_PROC} processes"

d="_D"
si="_SI"
rp="_RP"
li="_LI"
td="_TD"
inv="_INV"

#execute max n jobs at once
JOBMAX=${MAX_JOBS}
export JOBMAX

BPIN_DIR=${FPIN_DIR}/brno
mkdir ${BPIN_DIR}

CNT=0
for f in `ls ${FPIN_DIR}/*_D | grep -v dohromady`
 do
   CNT=`expr $CNT + 1`	  
   if [ ${MULTIPROCESS:-0} -eq 1 ]
     then
       proc ${f} $CNT &
     else
       proc ${f} $CNT
   fi     
 done
wait


rm -f ${BPIN_DIR}/dohromady.brno
for file in `ls ${BPIN_DIR}/*brno`
do
     cat $file >> ${BPIN_DIR}/dohromady.brno
done

cat ${BPIN_DIR}/dohromady.brno | cut -d"#" -f1 | sort | uniq  > ${BPIN_DIR}/klic

rm -f pocet
for kk in `cat ${BPIN_DIR}/klic`
do
   xx=`grep $kk ${BPIN_DIR}/dohromady.brno | wc -l`
   echo $xx#$kk >> pocet

done

echo "koordinaty#pocet#chr#start#end#typ_mutace#delka#pocet_mut_cteni#pacient#gen#transkripcni_varianta#frakce_%" > ${BPIN_DIR}/final_brno.csv
for line in `cat ${BPIN_DIR}/dohromady.brno`
do
    klic=`echo $line | cut -d"#" -f1`
    hod=`grep "#$klic" pocet | cut -d"#" -f1`
    echo $hod#$line | awk -F# 'BEGIN{OFS="#";} {print $2,$1,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' >> ${BPIN_DIR}/final_brno.csv
done

zip ${BPIN_DIR}/gemini_brno.zip ${BPIN_DIR}/*pindel.txt

log "New pindel end"
