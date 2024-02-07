
load_params "$@"
. ${WOR_LIB}/bioenv

  FLOG=${WOR_LOGDIR}/${phase}_117_$(date +%y%m%d-%H%M%S).log

  log "Vep processing start"

   normfinal=${GATK_VCF_JED}/$bf.n.final_norm.final.vcf
   vepfinal=${GATK_VCF_JED}/$bf.n.final_norm.final_vep.vcf

   normfinal=${GVCF_DIR}/dohromady.final_norm.final.vcf
   vepfinal=${GVCF_DIR}/dohromady.final_norm.final.vep.vcf
   dbfile=${GVCF_DIR}/dohromady.vep.g.db
   vfile=${GVCF_DIR}/nase.vep.txt

   ${VEP_DIR}/vep --offline --dir_cache ${VEP_CACHE} --sift b --polyphen b --vcf -i $normfinal -o $vepfinal

   export PATH=${GEMINI_DIR}:$PATH

   log "Start gemini load $vepfinal -> $dbfile"
   ${GEMINI_DIR}/gemini load -v $vepfinal -t all --cores 12 $dbfile >>${FLOG} 2>>${FLOG}

   log "Start gemini extract vep $dbfile $vfile"

      ${GEMINI_DIR}/gemini query --header -q "select chrom,start,end,ref,alt,polyphen_pred,polyphen_score,sift_pred,sift_score from variants" $dbfile > $vfile 2>>${FLOG}

    log "Vep done"

    log "Start repare input for spip"

   ifile=${GVCF_DIR}/nase.txt
   ofile=${GVCF_DIR}/spip_in.txt
   tmpfile=${GVCF_DIR}/tmp_$$

   # spip input format
   #gene    varID   chrom   start   end     ref     alt
   #OR4F5   NM_001005484.1:c.338T>G chr1    69427   69428   T       G

   # tmpfile
   #chrom	start	end	ref	alt	gene	transcript	aa_change
   #chr1	10093456	10093457	C	T	UBE4B	NM_001105562.2	c.-272C>T

     
     echo "gene#varID#chrom#start#end#ref#alt" > $ofile

     cat $ifile | cut -f1-3,7,8,53,54,61 | sed 's/\t/#/g' > $tmpfile

     for line in `cat $tmpfile`
       do
          prv=`echo $line | cut -d"#" -f1-5`
	  gene=`echo $line | cut -d"#" -f6`
	  tran=`echo $line | cut -d"#" -f7`
	  chan=`echo $line | cut -d"#" -f8 | cut -d"/" -f2`

	  echo "$gene#$tran:$chan#$prv" >> $ofile
       done

    rm $tmpfile 
    sed -i 's/#/\t/g' $ofile

    log "End repare input for spip"

    grep -i ERROR ${FLOG}
    if [ $? -eq 0 ]
     then
       error_exit "Error found in ${FLOG}"
    fi
:
