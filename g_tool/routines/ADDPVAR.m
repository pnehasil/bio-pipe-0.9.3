ADDPVAR(OUTDIR,RUN)
   ; ------------------------------------------------------------------------------------
   ;
   ; Z ^WNK vyhrezne soubor pro tabulku pacientky -> nalezene varianty
   ; tabulka `pac_ref` ma sloupce: 
   ;      `pac` varchar(10) DEFAULT NULL,
   ;      `run` int(5) DEFAULT NULL,
   ;      `chrom` varchar(10) DEFAULT NULL,
   ;      `start` int(11) DEFAULT NULL,
   ;      `end` int(11) DEFAULT NULL,
   ;      `alt` varchar(30) DEFAULT NULL,
   ;      `ref` varchar(30) DEFAULT NULL,
   ;      `clas_czecanca` varchar(10) DEFAULT NULL,
   ;      `clas_ubeo` varchar(10) DEFAULT NULL,
   ;      `clinvar_sig` varchar(30) DEFAULT NULL
   ;
   S DATABASE="nase_ref"
   S TABLE="pac_var"
   ;
   S OFILE=OUTDIR_"/"_RUN_"_addvar.sql" 
   OPEN OFILE:NEWVERSION
   USE OFILE;
   W "USE "_DATABASE_";",!
   W " --",!
   ;
   S PAC=""
   F  S PAC=$O(^WTMPU(PAC)) Q:PAC=""  D
   . S FPAC=$P(PAC,"_",2)
   . S R=0
   . F  S R=$O(^WTMPU(PAC,R)) Q:R=""  D
   . . S clinvarXsig=$P(^WTMPU(PAC,R),"|",8)
   . . S x01XUBEOXClass=$P(^WTMPU(PAC,R),"|",9)
   . . S CzecancaXkons=$P(^WTMPU(PAC,R),"|",10)
   . . S chrom=$P(^WTMPU(PAC,R),"|",32)
   . . S start=$P(^WTMPU(PAC,R),"|",33)
   . . S end=$P(^WTMPU(PAC,R),"|",34)
   . . S ref=$P(^WTMPU(PAC,R),"|",35)
   . . S alt=$P(^WTMPU(PAC,R),"|",36)
   . . W "INSERT INTO `"_TABLE_"` (`pac`,`run`,`chrom`,`start`,`end`,`ref`,`alt`,`clas_czecanca`,`clas_ubeo`,`clinvar_sig`) "
   . . W "VALUES ("""_FPAC_""","""_RUN_""","""_chrom_""","""_start_""","""_end_""","""_ref_""","""_alt_""","""_x01XUBEOXClass_""","""_CzecancaXkons_""","""_clinvarXsig_""");",!
   CLOSE OFILE
   Q
   ;
