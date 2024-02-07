ADDVKP(OUTDIR,RUN)
   ; ------------------------------------------------------------------------------------
   ; ^WTP - vystup z gemini:
   ;
   ; ^VIKO - Viktorovy kontroly, vybrane jen -9carrier a unknown. 
   ; ^VIKO("chr1",10093776,10093777)="5|877"
   ;
   ; ^WNK - nase kontroly, vybrane jen???? ted jen WCZE3 se vzorkama
   ; 
   ; Vytvori novy global ^PTMPU, do krereho  na patricna mista vlozi data z ^WTNP, ^VIKO  
   ; ^WNK. Z nej pak vyhrezne soubory pro web OUTDIR/PAC.dat, ktere se shellem 
   ; preformatuji a nasypou do TABS.
   ; 
   ; 17.01.2020
   ; Z globalu ^VCF se pridaji na konec hodnoty WT a ALT.
   ;
   ; 16.03.2020
   ; Pridany global ^ZCLIN - clinvar hodnoty clinvar_sig a clinvar_revstat z clinvar
   ; databaze. Ty se dopsypou do sloupcu clinvar_sig a clinvar_revstat v tabulce BRCA*
   ;  
   ; 19.05.2020
   ; Pridany global ^UNK - hodnota unknown z GVCF/unkn_col.web se prida na konec tabulky
   ; do sloupce gunknown.  
   ; Pridan global XEXO s poctem exonu pro dany gen - prida se do sloupce exon exon/pocet
   ;
   ; 04.03.2021
   ; Do tabulky variant pridan sloupec group, ktery se na webu bude zobrazovat jako
   ; druhy. Plnit se bude tady funkci GROUP(GEN) dle tabulky od Janicky
   ;
   ; 21.03.2020
   ; Do tabulky variant pridany sloupce aaf_gnomad_all,aaf_gnomad_nfe,aaf_gnomad_non_cancer,
   ; gnomad_popmax_AF,gnomad_num_het,gnomad_num_hom_alt,gnomad_num_chroms 
   ;
   ; 26.05.2021
   ; clinvar_sig se bere z gemini, clinvar_revstat z globalu ZCLIN 
   ;
   ; 27.06.2021
   ; clinvar_sig i clinvar_revstat z gemini, potazmo z globalu ^PTMP
   ; Pridane sloupce polyphen_pred,polyphen_score,sift_pred,sift_score
   ; Timto se rusi global ^ZCLIN
   ;
   ; 29.1.2022
   ; 
   ; Zmena polzek v definici tabulky variant:
   ; `gene` varchar(10) -> `gene` varchar(22)
   ; `aa_length` int(7) -> `aa_length` varchar(10)
   ; `rmsk` varchar(100) -> `rmsk` varchar(400)
   ;
   ; 17.01.2023
   ; Zmena skupin a priorit genu. Funkce GROUP a PRIORITY
   ; Zmena codon_change varchar(40) -> varchar(510)
   ; pridane sloupce PTScarr a superCTRLS plni se z globalu ^PTSCARR a ^SCTRLS
   ; Pro ty jsou pripravene importy.
   ; 
   ; -----------------------------------------------------------------------------------
   ;
   K ^PTMPU
   S PAC=""
   F  S PAC=$O(^PTMP(PAC)) Q:PAC=""  D
   . S R="" 
   . F  S R=$O(^PTMP(PAC,R)) Q:R=""  D
   . . S PR=$P(^PTMP(PAC,R),"|",1,8)
   . . S DR=$P(^PTMP(PAC,R),"|",9,11)
   . . S TR=$P(^PTMP(PAC,R),"|",12,39)
   . . S CT=$P(^PTMP(PAC,R),"|",40,47)
   . . ; prvni radek je hlavicka
   . . I R=0  D
   . . . S V9C="VIK-9carrier" S V9U="VIK-unknown" 
   . . . S NK1="01_UBEO_Class" S NK2="Czecanca_kons" 
   . . . S VC1="WT" S VC2="ALT" 
   . . . S UNK="gunknown"
   . . . S PP="Polyphen_pred"
   . . . S PS="Polyphen_score"
   . . . S SP="Sift_pred"
   . . . S SS="Sift_score"
   . . . S PTSC="PTScarrier"
   . . . S SCTR="SupCTRLS"
   . . E  D
   . . . S CHR=$P(^PTMP(PAC,R),"|",28)
   . . . S START=$P(^PTMP(PAC,R),"|",29)
   . . . S END=$P(^PTMP(PAC,R),"|",30)
   . . . S REF=$P(^PTMP(PAC,R),"|",31)
   . . . S ALT=$P(^PTMP(PAC,R),"|",32)
   . . . S V9C="None"
   . . . S V9U="None"
   . . . S NK1=""
   . . . S NK2=""
   . . . S VC1="-1"
   . . . S VC2="-1"
   . . . S UNK="None"
   . . . S PP="None"
   . . . S PS="-1"
   . . . S SP="None"
   . . . S SS="-1"
   . . . S PTSC="-1"
   . . . S SCTR="-1"
   . . . ; pridani Viktorovych kontrol
   . . . ;I $D(^VIKO(CHR,START,END,REF,ALT))  D
   . . . ;. S V9C=$P(^VIKO(CHR,START,END,REF,ALT),"|",1)
   . . . ;. S V9U=$P(^VIKO(CHR,START,END,REF,ALT),"|",2)
   . . . ; pridani nasich kontrol - CZECANCA
   . . . ;I $D(^WCZE3(CHR,START,END,REF,ALT))  D
   . . . ;. S NK1=$P(^WCZE3(CHR,START,END,REF,ALT),"|",1)
   . . . ;. S NK2=$P(^WCZE3(CHR,START,END,REF,ALT),"|",2)
   . . . ; pridani dat z ^VCF
   . . . ;I $D(^VCF(CHR,END,PAC,REF,ALT))  D
   . . . ;. S VC1=$P(^VCF(CHR,END,PAC,REF,ALT),"|",1)
   . . . ;. S VC2=$P(^VCF(CHR,END,PAC,REF,ALT),"|",2)
   . . . ;E  D
   . . . ;. I $D(^VCF(CHR,START+1,PAC,REF,ALT))  D
   . . . ;. . S VC1=$P(^VCF(CHR,START+1,PAC,REF,ALT),"|",1)
   . . . ;. . S VC2=$P(^VCF(CHR,START+1,PAC,REF,ALT),"|",2)
   . . . ; pridani dat z ^UNKN
   . . . ;I $D(^UNKN(CHR,START,END,REF,ALT))  D
   . . . ;. S UNK=$P(^UNKN(CHR,START,END,REF,ALT),"|",1)
   . . . ; pridani dat z ^VEP
   . . . ;I $D(^VEP(PAC,CHR,START,END,REF,ALT))  D
   . . . ;. S PP=$P(^VEP(PAC,CHR,START,END,REF,ALT),"|",1)
   . . . ;. S PS=$P(^VEP(PAC,CHR,START,END,REF,ALT),"|",2)
   . . . ;. S SP=$P(^VEP(PAC,CHR,START,END,REF,ALT),"|",3)
   . . . ;. S SS=$P(^VEP(PAC,CHR,START,END,REF,ALT),"|",4)
   . . . ;. I PS="None" S PS="-1"
   . . . ;. I SS="None" S SS="-1"
   . . . ; pridani dat z ^PTSCARR
   . . . ;I $D(^PTSCARR(CHR,START,END,REF,ALT))  D
   . . . ;. S PTSC=$P(^PTSCARR(CHR,START,END,REF,ALT),"|",1) 
   . . . ; pridani dat z ^SCTRLS
   . . . ;I $D(^SCTRLS(CHR,START,END,REF,ALT))  D
   . . . ;. S SCTR=$P(^SCTRLS(CHR,START,END,REF,ALT),"|",1) 
   . . ; tady mame pohromade vsechna data pro vlozeni...
   . . S REC=PR_"|"_NK1_"|"_NK2_"|"_DR_"|"_V9C_"|"_V9U_"|"_TR_"|"_VC1_"|"_VC2_"|"_UNK_"|"_CT_"|"_PP_"|"_PS_"|"_SP_"|"_SS_"|"_PTSC_"|"_SCTR
   . . S ^PTMPU(PAC,R)=REC
   ; a konecne vysypeme ven co jsme nasyslili
   S PAC=""
   F  S PAC=$O(^PTMPU(PAC)) Q:PAC=""  D
   . S OFILE=OUTDIR_"/"_PAC_".p.dat" 
   . OPEN OFILE:NEWVERSION
   . S R=""
   . USE OFILE
   . F  S R=$O(^PTMPU(PAC,R)) Q:R=""  D
   . . W ^PTMPU(PAC,R),!
   . CLOSE OFILE
   ; i do sql
   S PAC=""
   F  S PAC=$O(^PTMPU(PAC)) Q:PAC=""  D
   . S FPAC=$P(PAC,"_",2)
   . S FPAC=FPAC_"_pin"
   . S OFILE=OUTDIR_"/"_PAC_".p.sql" 
   . OPEN OFILE:NEWVERSION
   . S R=0
   . USE OFILE
   . D CRTABLE(FPAC,RUN)
   . F  S R=$O(^PTMPU(PAC,R)) Q:R=""  D
   . . S gene=$P(^PTMPU(PAC,R),"|",1)
   . . S codonXchange=$P(^PTMPU(PAC,R),"|",2)
   . . S aaXchange=$P(^PTMPU(PAC,R),"|",3)
   . . S xexon=$P(^PTMPU(PAC,R),"|",4)
   . . S exon=$$XEXON(gene,xexon)
   . . S qual=$P(^PTMPU(PAC,R),"|",5)
   . . S depth=$P(^PTMPU(PAC,R),"|",6)
   . . S numXalleles=$P(^PTMPU(PAC,R),"|",7)
   . . S clinvarXsig=$P(^PTMPU(PAC,R),"|",8)
   . . S x01XUBEOXClass=$P(^PTMPU(PAC,R),"|",9)
   . . S CzecancaXkons=$P(^PTMPU(PAC,R),"|",10)
   . . S maxXaafXall=$P(^PTMPU(PAC,R),"|",11)
   . . S aafXespXea=$P(^PTMPU(PAC,R),"|",12)
   . . S impactXso=$P(^PTMPU(PAC,R),"|",13)
   . . S VIKX9carrier=$P(^PTMPU(PAC,R),"|",14)
   . . S VIKXunknown=$P(^PTMPU(PAC,R),"|",15)
   . . S aafXespXall=$P(^PTMPU(PAC,R),"|",16)
   . . S aafX1kgXeur=$P(^PTMPU(PAC,R),"|",17)
   . . S aafX1kgXall=$P(^PTMPU(PAC,R),"|",18)
   . . S gmsXillumina=$P(^PTMPU(PAC,R),"|",19)
   . . S gmsXsolid=$P(^PTMPU(PAC,R),"|",20)
   . . S gmsXiontorrent=$P(^PTMPU(PAC,R),"|",21)
   . . S cosmicXids=$P(^PTMPU(PAC,R),"|",22)
   . . S caddXraw=$P(^PTMPU(PAC,R),"|",23)
   . . S caddXscaled=$P(^PTMPU(PAC,R),"|",24)
   . . S aafXexacXall=$P(^PTMPU(PAC,R),"|",25)
   . . S aafXadjXexacXall=$P(^PTMPU(PAC,R),"|",26)
   . . S aafXadjXexacXnfe=$P(^PTMPU(PAC,R),"|",27)
   . . S exacXnumXhet=$P(^PTMPU(PAC,R),"|",28)
   . . S exacXnumXhomXalt=$P(^PTMPU(PAC,R),"|",29)
   . . S aaXlength=$P(^PTMPU(PAC,R),"|",30)
   . . S transcript=$P(^PTMPU(PAC,R),"|",31)
   . . S chrom=$P(^PTMPU(PAC,R),"|",32)
   . . S start=$P(^PTMPU(PAC,R),"|",33)
   . . S end=$P(^PTMPU(PAC,R),"|",34)
   . . S ref=$P(^PTMPU(PAC,R),"|",35)
   . . S alt=$P(^PTMPU(PAC,R),"|",36)
   . . S numXreadsXwXdels=$P(^PTMPU(PAC,R),"|",37)
   . . S alleleXcount=$P(^PTMPU(PAC,R),"|",38)
   . . S alleleXbal=$P(^PTMPU(PAC,R),"|",39)
   . . S rsXids=$P(^PTMPU(PAC,R),"|",40)
   . . S inXomim=$P(^PTMPU(PAC,R),"|",41)
   . . S clinvarXdiseaseXname=$P(^PTMPU(PAC,R),"|",42)
   . . S rmsk=$P(^PTMPU(PAC,R),"|",43)
   . . S zwt=$P(^PTMPU(PAC,R),"|",44)
   . . S zalt=$P(^PTMPU(PAC,R),"|",45)
   . . S gunk=$P(^PTMPU(PAC,R),"|",46)
   . . S prio=$$PRIORITY(gene)
   . . S group=$$GROUP(gene)
   . . S aafXgnomadXall=$P(^PTMPU(PAC,R),"|",47)
   . . S aafXgnomadXnfe=$P(^PTMPU(PAC,R),"|",48)
   . . S aafXgnomadXnonXcancer=$P(^PTMPU(PAC,R),"|",49)
   . . S gnomadXpopmaxXAF=$P(^PTMPU(PAC,R),"|",50)
   . . S gnomadXnumXhet=$P(^PTMPU(PAC,R),"|",51)
   . . S gnomadXnumXhomXalt=$P(^PTMPU(PAC,R),"|",52)
   . . S gnomadXnumXchroms=$P(^PTMPU(PAC,R),"|",53)
   . . S clinvarXrev=$P(^PTMPU(PAC,R),"|",54)
   . . S pXp=$P(^PTMPU(PAC,R),"|",55)
   . . S pXs=$P(^PTMPU(PAC,R),"|",56)
   . . S sXp=$P(^PTMPU(PAC,R),"|",57)
   . . S sXs=$P(^PTMPU(PAC,R),"|",58)
   . . S pcar=$P(^PTMPU(PAC,R),"|",59)
   . . S sct=$P(^PTMPU(PAC,R),"|",60)
   . . S XR1="INSERT INTO `"""_FPAC_"""` (`id`"
   . . S XR2="`gunknown`,`aaf_gnomad_all`,`superCTRLS`)"
   . . W "INSERT INTO `"_FPAC_"` (`id`,`gene`,`codon_change`,`aa_change`,`exon`,`qual`,`depth`,`num_alleles`,`clinvar_sig`,`clinvar_rev`,`x01_UBEO_Class`,`Czecanca_kons`,`max_aaf_all`,`aaf_esp_ea`,`impact_so`,`VIK_9carrier`,`VIK_unknown`,`aaf_esp_all`,`aaf_1kg_eur`,`aaf_1kg_all`,`gms_illumina`,`gms_solid`,`gms_iontorrent`,`cosmic_ids`,`cadd_raw`,`cadd_scaled`,`aaf_exac_all`,`aaf_adj_exac_all`,`aaf_adj_exac_nfe`,`exac_num_het`,`exac_num_hom_alt`,`aa_length`,`transcript`,`chrom`,`start`,`end`,`ref`,`alt`,`num_reads_w_dels`,`allele_count`,`allele_bal`,`rs_ids`,`in_omim`,`clinvar_disease_name`,`rmsk`,`zwt`,`zalt`,`priority`,`gunknown`,`aaf_gnomad_all`,`aaf_gnomad_nfe`,`aaf_gnomad_non_cancer`,`gnomad_popmax_AF`,`gnomad_num_het`,`gnomad_num_hom_alt`,`gnomad_num_chroms`,`group`,`poly_pred`,`poly_score`,`sift_pred`,`sift_score`,`PTScarr`,`superCTRLS`) "
   . . W "VALUES ("""_R_""","""_gene_""","""_codonXchange_""","""_aaXchange_""","""_exon_""","""_qual_""","""_depth_""","""_numXalleles_""","""_clinvarXsig_""","""_clinvarXrev_""","""_x01XUBEOXClass_""","""_CzecancaXkons_""","""_maxXaafXall_""","""_aafXespXea_""","""_impactXso_""","""_VIKX9carrier_""","""_VIKXunknown_""","""_aafXespXall_""","""_aafX1kgXeur_""","""_aafX1kgXall_""","""_gmsXillumina_""","""_gmsXsolid_""","""_gmsXiontorrent_""","""_cosmicXids_""","""_caddXraw_""","""_caddXscaled_""","""_aafXexacXall_""","""_aafXadjXexacXall_""","""_aafXadjXexacXnfe_""","""_exacXnumXhet_""","""_exacXnumXhomXalt_""","""_aaXlength_""","""_transcript_""","""_chrom_""","""_start_""","""_end_""","""_ref_""","""_alt_""","""_numXreadsXwXdels_""","""_alleleXcount_""","""_alleleXbal_""","""_rsXids_""","""_inXomim_""","""_clinvarXdiseaseXname_""","""_rmsk_""","""_zwt_""","""_zalt_""","""_prio_""","""_gunk_""","""_aafXgnomadXall_""","""_aafXgnomadXnfe_""","""_aafXgnomadXnonXcancer_""","""_gnomadXpopmaxXAF_""","""_gnomadXnumXhet_""","""_gnomadXnumXhomXalt_""","""_gnomadXnumXchroms_""","""_group_""","""_pXp_""","""_pXs_""","""_sXp_""","""_sXs_""","""_pcar_""","""_sct_""");",!
   . ;
   . CLOSE OFILE
   Q
   ;
CRTABLE(TABLE,RUN)
   ;
   W "USE "_RUN_";",!
   W "CREATE TABLE `"_TABLE_"` (",!
   W "      `id` int(11) NOT NULL,",!
   W "      `gene` varchar(22) DEFAULT NULL,",!
   W "      `codon_change` varchar(510) DEFAULT NULL,",!
   W "      `aa_change` varchar(510) DEFAULT NULL,",!
   W "      `exon` varchar(9) DEFAULT NULL,",!
   W "      `qual` decimal(13,8) DEFAULT NULL,",!
   W "      `depth` varchar(10) DEFAULT NULL,",!
   W "      `num_alleles` int(1) DEFAULT NULL,",!
   W "      `clinvar_sig` varchar(160) DEFAULT NULL,",!
   W "      `clinvar_rev` varchar(160) DEFAULT NULL,",!
   W "      `x01_UBEO_Class` varchar(10) DEFAULT NULL,",!
   W "      `Czecanca_kons` varchar(30) DEFAULT NULL,",!
   W "      `max_aaf_all` decimal(16,14) DEFAULT NULL,",!
   W "      `aaf_esp_ea` decimal(16,14) DEFAULT NULL,",!
   W "      `impact_so` varchar(50) DEFAULT NULL,",!
   W "      `VIK_9carrier` varchar(5) DEFAULT NULL,",!
   W "      `VIK_unknown` varchar(5) DEFAULT NULL,",!
   W "      `aaf_esp_all` decimal(16,14) DEFAULT NULL,",!
   W "      `aaf_1kg_eur` decimal(10,8) DEFAULT NULL,",!
   W "      `aaf_1kg_all` decimal(10,8) DEFAULT NULL,",!
   W "      `gms_illumina` varchar(10) DEFAULT NULL,",!
   W "      `gms_solid` varchar(10) DEFAULT NULL,",!
   W "      `gms_iontorrent` varchar(10) DEFAULT NULL,",!
   W "      `cosmic_ids` varchar(200) DEFAULT NULL,",!
   W "      `cadd_raw` varchar(10) DEFAULT NULL,",!
   W "      `cadd_scaled` varchar(10) DEFAULT NULL,",!
   W "      `aaf_exac_all` decimal(9,8) DEFAULT NULL,",!
   W "      `aaf_adj_exac_all` decimal(16,14) DEFAULT NULL,",!
   W "      `aaf_adj_exac_nfe` decimal(16,14) DEFAULT NULL,",!
   W "      `exac_num_het` int(7) DEFAULT NULL,",!
   W "      `exac_num_hom_alt` int(7) DEFAULT NULL,",!
   W "      `aa_length` varchar(10) DEFAULT NULL,",!
   W "      `transcript` varchar(30) DEFAULT NULL,",!
   W "      `chrom` varchar(10) DEFAULT NULL,",!
   W "      `start` int(11) DEFAULT NULL,",!
   W "      `end` int(11) DEFAULT NULL,",!
   W "      `ref` varchar(5000) DEFAULT NULL,",!
   W "      `alt` varchar(5000) DEFAULT NULL,",!
   W "      `num_reads_w_dels` varchar(10) DEFAULT NULL,",!
   W "      `allele_count` int(2) DEFAULT NULL,",!
   W "      `allele_bal` varchar(10) DEFAULT NULL,",!
   W "      `rs_ids` varchar(60) DEFAULT NULL,",!
   W "      `in_omim` int(3) DEFAULT NULL,",!
   W "      `clinvar_disease_name` varchar(1024) DEFAULT NULL,",!
   W "      `rmsk` varchar(400) DEFAULT NULL,",!
   W "      `zwt` int(11) DEFAULT NULL,",!
   W "      `zalt` int(11) DEFAULT NULL,",!
   W "      `priority` int(11) DEFAULT NULL,",!
   W "      `gunknown` varchar(22) DEFAULT NULL,",!
   W "      `aaf_gnomad_all` varchar(400) DEFAULT NULL,",!
   W "      `aaf_gnomad_nfe` varchar(20) DEFAULT NULL,",!
   W "      `aaf_gnomad_non_cancer` varchar(20) DEFAULT NULL,",!
   W "      `gnomad_popmax_AF` varchar(200) DEFAULT NULL,",!
   W "      `gnomad_num_het` int(11) DEFAULT NULL,",!
   W "      `gnomad_num_hom_alt` int(11) DEFAULT NULL,",!
   W "      `gnomad_num_chroms` int(11) DEFAULT NULL,",!
   W "      `group` int(2) DEFAULT NULL,",!
   W "      `poly_pred` varchar(50) DEFAULT NULL,",!
   W "      `poly_score` decimal(16,14) DEFAULT NULL,",!
   W "      `sift_pred` varchar(50) DEFAULT NULL,",!
   W "      `sift_score` decimal(16,14) DEFAULT NULL,",!
   W "      `PTScarr` int(11) DEFAULT NULL,",!
   W "      `superCTRLS` int(11) DEFAULT NULL",!
   W "-- ",!
   W ") ENGINE=InnoDB DEFAULT CHARSET=utf8;",!
   W "-- ",!
   W "ALTER TABLE `"_TABLE_"`",!
   W "      ADD UNIQUE KEY `id` (`id`);",!
   W "-- ",!
   Q
   ;
PRIORITY(XGEN)
   S RET=0

   	I XGEN="BRCA1" S RET=1
	I XGEN="BRCA2" S RET=2
	I XGEN="PALB2" S RET=3
	I XGEN="CHEK2" S RET=4
	I XGEN="ATM" S RET=5
	I XGEN="NBN" S RET=6
	I XGEN="CDH1" S RET=7
	I XGEN="TP53" S RET=8
	I XGEN="PTEN" S RET=9
	I XGEN="RAD51C" S RET=10
	I XGEN="RAD51D" S RET=11
	I XGEN="BRIP1" S RET=12
	I XGEN="BARD1" S RET=13
	I XGEN="STK11" S RET=14
	I XGEN="MLH1" S RET=15
	I XGEN="MSH2" S RET=16
	I XGEN="MSH6" S RET=17
	I XGEN="PMS2" S RET=18
	I XGEN="EPCAM" S RET=19
	I XGEN="APC" S RET=20
	I XGEN="MUTYH" S RET=21
	I XGEN="RAD50" S RET=22
	I XGEN="BMPR1A" S RET=23
	I XGEN="MEN1" S RET=24
	I XGEN="NF2" S RET=25
	I XGEN="RB1" S RET=26
	I XGEN="RET" S RET=27
	I XGEN="SDHAF2" S RET=28
	I XGEN="SDHB" S RET=29
	I XGEN="SDHC" S RET=30
	I XGEN="SDHD" S RET=31
	I XGEN="SMAD4" S RET=32
	I XGEN="TSC1" S RET=33
	I XGEN="TSC2" S RET=34
	I XGEN="VHL" S RET=35
	I XGEN="WT1" S RET=36
	I XGEN="BLM" S RET=37
	I XGEN="FANCA" S RET=38
	I XGEN="FANCC" S RET=39
	I XGEN="WRN" S RET=40
	I XGEN="DPYD" S RET=41
	I XGEN="AIP" S RET=42
	I XGEN="BAP1" S RET=43
	I XGEN="CDK4" S RET=44
	I XGEN="CDKN1B" S RET=45
	I XGEN="CDKN2A" S RET=46
	I XGEN="FH" S RET=47
	I XGEN="FLCN" S RET=48
	I XGEN="HOXB13" S RET=49
	I XGEN="MAX" S RET=50
	I XGEN="MET" S RET=51
	I XGEN="NF1" S RET=52
	I XGEN="POLD1" S RET=53
	I XGEN="POLE" S RET=54
	I XGEN="SDHA" S RET=55
	I XGEN="TERT" S RET=56
	I XGEN="TMEM127" S RET=57
	I XGEN="SBDS" S RET=58
	I XGEN="FANCM" S RET=59
	I XGEN="ALK" S RET=60
	I XGEN="APEX1" S RET=61
	I XGEN="ATMIN" S RET=62
	I XGEN="ATR" S RET=63
	I XGEN="ATRIP" S RET=64
	I XGEN="AURKA" S RET=65
	I XGEN="AXIN1" S RET=66
	I XGEN="BABAM1" S RET=67
	I XGEN="BRAP" S RET=68
	I XGEN="BRCC3" S RET=69
	I XGEN="BRE" S RET=70
	I XGEN="BUB1B" S RET=71
	I XGEN="CASP8" S RET=72
	I XGEN="CCND1" S RET=73
	I XGEN="CDC73" S RET=74
	I XGEN="CDKN1C" S RET=75
	I XGEN="CEBPA" S RET=76
	I XGEN="CEP57" S RET=77
	I XGEN="CLSPN" S RET=78
	I XGEN="CSNK1D" S RET=79
	I XGEN="CSNK1E" S RET=80
	I XGEN="CWF19L2" S RET=81
	I XGEN="CYLD" S RET=82
	I XGEN="DCLRE1C" S RET=83
	I XGEN="DDB2" S RET=84
	I XGEN="DHFR" S RET=85
	I XGEN="DICER1" S RET=86
	I XGEN="DIS3L2" S RET=87
	I XGEN="DMBT1" S RET=88
	I XGEN="DMC1" S RET=89
	I XGEN="DNAJC21" S RET=90
	I XGEN="EGFR" S RET=91
	I XGEN="emsy" S RET=92
	I XGEN="EPHX1" S RET=93
	I XGEN="ERCC1" S RET=94
	I XGEN="ERCC2" S RET=95
	I XGEN="ERCC3" S RET=96
	I XGEN="ERCC4" S RET=97
	I XGEN="ERCC5" S RET=98
	I XGEN="ERCC6" S RET=99
	I XGEN="ESR1" S RET=100
	I XGEN="ESR2" S RET=101
	I XGEN="EXO1" S RET=102
	I XGEN="EXT1" S RET=103
	I XGEN="EXT2" S RET=104
	I XGEN="EYA2" S RET=105
	I XGEN="EZH2" S RET=106
	I XGEN="FAAP24" S RET=107
	I XGEN="FAM175A" S RET=108
	I XGEN="FAM175B" S RET=109
	I XGEN="FAN1" S RET=110
	I XGEN="FANCB" S RET=111
	I XGEN="FANCD2" S RET=112
	I XGEN="FANCE" S RET=113
	I XGEN="FANCF" S RET=114
	I XGEN="FANCG" S RET=115
	I XGEN="FANCI" S RET=116
	I XGEN="FANCL" S RET=117
	I XGEN="FBXW7" S RET=118
	I XGEN="GADD45A" S RET=119
	I XGEN="GATA2" S RET=120
	I XGEN="GPC3" S RET=121
	I XGEN="GRB7" S RET=122
	I XGEN="HELQ" S RET=123
	I XGEN="HNF1A" S RET=124
	I XGEN="HRAS" S RET=125
	I XGEN="HUS1" S RET=126
	I XGEN="CHEK1" S RET=127
	I XGEN="KAT5" S RET=128
	I XGEN="KCNJ5" S RET=129
	I XGEN="KIT" S RET=130
	I XGEN="LIG1" S RET=131
	I XGEN="LIG3" S RET=132
	I XGEN="LIG4" S RET=133
	I XGEN="LMO1" S RET=134
	I XGEN="LRIG1" S RET=135
	I XGEN="MCPH1" S RET=136
	I XGEN="MDC1" S RET=137
	I XGEN="MDM2" S RET=138
	I XGEN="MDM4" S RET=139
	I XGEN="MGMT" S RET=140
	I XGEN="MLH3" S RET=141
	I XGEN="MMP8" S RET=142
	I XGEN="MPL" S RET=143
	I XGEN="MRE11A" S RET=144
	I XGEN="MSH3" S RET=145
	I XGEN="MSH5" S RET=146
	I XGEN="MSR1" S RET=147
	I XGEN="MUS81" S RET=148
	I XGEN="NAT1" S RET=149
	I XGEN="NCAM1" S RET=150
	I XGEN="NELFB" S RET=151
	I XGEN="NFKBIZ" S RET=152
	I XGEN="NHEJ1" S RET=153
	I XGEN="NSD1" S RET=154
	I XGEN="OGG1" S RET=155
	I XGEN="PARP1" S RET=156
	I XGEN="PCNA" S RET=157
	I XGEN="PHB" S RET=158
	I XGEN="PHOX2B" S RET=159
	I XGEN="PIK3CG" S RET=160
	I XGEN="PLA2G2A" S RET=161
	I XGEN="PMS1" S RET=162
	I XGEN="POLB" S RET=163
	I XGEN="PPM1D" S RET=164
	I XGEN="PREX2" S RET=165
	I XGEN="PRF1" S RET=166
	I XGEN="PRKAR1A" S RET=167
	I XGEN="PRKDC" S RET=168
	I XGEN="PTCH1" S RET=169
	I XGEN="PTTG2" S RET=170
	I XGEN="RAD1" S RET=171
	I XGEN="RAD17" S RET=172
	I XGEN="RAD18" S RET=173
	I XGEN="RAD23B" S RET=174
	I XGEN="RAD51" S RET=175
	I XGEN="RAD51AP1" S RET=176
	I XGEN="RAD51B" S RET=177
	I XGEN="RAD52" S RET=178
	I XGEN="RAD54B" S RET=179
	I XGEN="RAD54L" S RET=180
	I XGEN="RAD9A" S RET=181
	I XGEN="RBBP8" S RET=182
	I XGEN="RECQL" S RET=183
	I XGEN="RECQL4" S RET=184
	I XGEN="RECQL5" S RET=185
	I XGEN="RFC1" S RET=186
	I XGEN="RFC2" S RET=187
	I XGEN="RFC4" S RET=188
	I XGEN="RHBDF2" S RET=189
	I XGEN="RNF146" S RET=190
	I XGEN="RNF168" S RET=191
	I XGEN="RNF8" S RET=192
	I XGEN="RPA1" S RET=193
	I XGEN="RUNX1" S RET=194
	I XGEN="SETBP1" S RET=195
	I XGEN="SETX" S RET=196
	I XGEN="SHPRH" S RET=197
	I XGEN="SLX4" S RET=198
	I XGEN="SMARCA4" S RET=199
	I XGEN="SMARCB1" S RET=200
	I XGEN="SMARCE1" S RET=201
	I XGEN="SUFU" S RET=202
	I XGEN="TCL1A" S RET=203
	I XGEN="TELO2" S RET=204
	I XGEN="TERF2" S RET=205
	I XGEN="TLR2" S RET=206
	I XGEN="TLR4" S RET=207
	I XGEN="TOPBP1" S RET=208
	I XGEN="TP53BP1" S RET=209
	I XGEN="TSHR" S RET=210
	I XGEN="UBE2A" S RET=211
	I XGEN="UBE2B" S RET=212
	I XGEN="UBE2I" S RET=213
	I XGEN="UBE2V2" S RET=214
	I XGEN="UBE4B" S RET=215
	I XGEN="UIMC1" S RET=216
	I XGEN="XPA" S RET=217
	I XGEN="XPC" S RET=218
	I XGEN="XRCC1" S RET=219
	I XGEN="XRCC2" S RET=220
	I XGEN="XRCC3" S RET=221
	I XGEN="XRCC4" S RET=222
	I XGEN="XRCC5" S RET=223
	I XGEN="XRCC6" S RET=224
	I XGEN="ZNF350" S RET=225
	I XGEN="ZNF365" S RET=226
   Q RET
   ;
XEXON(XGEN,XEX)
   S RET=XEX_"/?"
   I $D(^XEXO(XGEN)) S RET=XEX_"/"_^XEXO(XGEN)
   Q RET
   ; 
GROUP(XGEN)
   S RET=0
	I XGEN="BRCA1" S RET=1
	I XGEN="BRCA2" S RET=1
	I XGEN="PALB2" S RET=1
	I XGEN="CHEK2" S RET=1
	I XGEN="ATM" S RET=1
	I XGEN="NBN" S RET=1
	I XGEN="CDH1" S RET=1
	I XGEN="TP53" S RET=1
	I XGEN="PTEN" S RET=1
	I XGEN="RAD51C" S RET=1
	I XGEN="RAD51D" S RET=1
	I XGEN="BRIP1" S RET=1
	I XGEN="BARD1" S RET=1
	I XGEN="STK11" S RET=1
	I XGEN="MLH1" S RET=1
	I XGEN="MSH2" S RET=1
	I XGEN="MSH6" S RET=1
	I XGEN="PMS2" S RET=1
	I XGEN="EPCAM" S RET=1
	I XGEN="APC" S RET=1
	I XGEN="MUTYH" S RET=1
	I XGEN="RAD50" S RET=1
	I XGEN="BMPR1A" S RET=2
	I XGEN="MEN1" S RET=2
	I XGEN="NF2" S RET=2
	I XGEN="RB1" S RET=2
	I XGEN="RET" S RET=2
	I XGEN="SDHAF2" S RET=2
	I XGEN="SDHB" S RET=2
	I XGEN="SDHC" S RET=2
	I XGEN="SDHD" S RET=2
	I XGEN="SMAD4" S RET=2
	I XGEN="TSC1" S RET=2
	I XGEN="TSC2" S RET=2
	I XGEN="VHL" S RET=2
	I XGEN="WT1" S RET=2
	I XGEN="BLM" S RET=2
	I XGEN="FANCA" S RET=2
	I XGEN="FANCC" S RET=2
	I XGEN="WRN" S RET=2
	I XGEN="DPYD" S RET=2
	I XGEN="BAP1" S RET=2
	I XGEN="CDK4" S RET=2
	I XGEN="CDKN1B" S RET=2
	I XGEN="CDKN2A" S RET=2
	I XGEN="FH" S RET=2
	I XGEN="FLCN" S RET=2
	I XGEN="HOXB13" S RET=2
	I XGEN="MAX" S RET=2
	I XGEN="MET" S RET=2
	I XGEN="NF1" S RET=2
	I XGEN="POLD1" S RET=2
	I XGEN="POLE" S RET=2
	I XGEN="SDHA" S RET=2
	I XGEN="TERT" S RET=2
	I XGEN="TMEM127" S RET=2
	I XGEN="SBDS" S RET=3
	I XGEN="FANCM" S RET=3
	I XGEN="RAD51" S RET=3
	I XGEN="PTCH1" S RET=3
	I XGEN="SMARCB1" S RET=3
	I XGEN="SUFU" S RET=3
	I XGEN="AIP" S RET=3
	I XGEN="ALK" S RET=3
	I XGEN="APEX1" S RET=3
	I XGEN="ATMIN" S RET=3
	I XGEN="ATR" S RET=3
	I XGEN="ATRIP" S RET=3
	I XGEN="AURKA" S RET=3
	I XGEN="AXIN1" S RET=3
	I XGEN="BABAM1" S RET=3
	I XGEN="BRAP" S RET=3
	I XGEN="BRCC3" S RET=3
	I XGEN="BRE" S RET=3
	I XGEN="BUB1B" S RET=3
	I XGEN="CASP8" S RET=3
	I XGEN="CCND1" S RET=3
	I XGEN="CDC73" S RET=3
	I XGEN="CDKN1C" S RET=3
	I XGEN="CEBPA" S RET=3
	I XGEN="CEP57" S RET=3
	I XGEN="CLSPN" S RET=3
	I XGEN="CSNK1D" S RET=3
	I XGEN="CSNK1E" S RET=3
	I XGEN="CWF19L2" S RET=3
	I XGEN="CYLD" S RET=3
	I XGEN="DCLRE1C" S RET=3
	I XGEN="DDB2" S RET=3
	I XGEN="DHFR" S RET=3
	I XGEN="DICER1" S RET=3
	I XGEN="DIS3L2" S RET=3
	I XGEN="DMBT1" S RET=3
	I XGEN="DMC1" S RET=3
	I XGEN="DNAJC21" S RET=3
	I XGEN="EGFR" S RET=3
	I XGEN="EMSY" S RET=3
	I XGEN="EPHX1" S RET=3
	I XGEN="ERCC1" S RET=3
	I XGEN="ERCC2" S RET=3
	I XGEN="ERCC3" S RET=3
	I XGEN="ERCC4" S RET=3
	I XGEN="ERCC5" S RET=3
	I XGEN="ERCC6" S RET=3
	I XGEN="ESR1" S RET=3
	I XGEN="ESR2" S RET=3
	I XGEN="EXO1" S RET=3
	I XGEN="EXT1" S RET=3
	I XGEN="EXT2" S RET=3
	I XGEN="EYA2" S RET=3
	I XGEN="EZH2" S RET=3
	I XGEN="FAAP24" S RET=3
	I XGEN="FAM175A" S RET=3
	I XGEN="FAM175B" S RET=3
	I XGEN="FAN1" S RET=3
	I XGEN="FANCB" S RET=3
	I XGEN="FANCD2" S RET=3
	I XGEN="FANCE" S RET=3
	I XGEN="FANCF" S RET=3
	I XGEN="FANCG" S RET=3
	I XGEN="FANCI" S RET=3
	I XGEN="FANCL" S RET=3
	I XGEN="FBXW7" S RET=3
	I XGEN="GADD45A" S RET=3
	I XGEN="GATA2" S RET=3
	I XGEN="GPC3" S RET=3
	I XGEN="GRB7" S RET=3
	I XGEN="HELQ" S RET=3
	I XGEN="HNF1A" S RET=3
	I XGEN="HRAS" S RET=3
	I XGEN="HUS1" S RET=3
	I XGEN="CHEK1" S RET=3
	I XGEN="KAT5" S RET=3
	I XGEN="KCNJ5" S RET=3
	I XGEN="KIT" S RET=3
	I XGEN="LIG1" S RET=3
	I XGEN="LIG3" S RET=3
	I XGEN="LIG4" S RET=3
	I XGEN="LMO1" S RET=3
	I XGEN="LRIG1" S RET=3
	I XGEN="MCPH1" S RET=3
	I XGEN="MDC1" S RET=3
	I XGEN="MDM2" S RET=3
	I XGEN="MDM4" S RET=3
	I XGEN="MGMT" S RET=3
	I XGEN="MLH3" S RET=3
	I XGEN="MMP8" S RET=3
	I XGEN="MPL" S RET=3
	I XGEN="MRE11A" S RET=3
	I XGEN="MSH3" S RET=3
	I XGEN="MSH5" S RET=3
	I XGEN="MSR1" S RET=3
	I XGEN="MUS81" S RET=3
	I XGEN="NAT1" S RET=3
	I XGEN="NCAM1" S RET=3
	I XGEN="NELFB" S RET=3
	I XGEN="NFKBIZ" S RET=3
	I XGEN="NHEJ1" S RET=3
	I XGEN="NSD1" S RET=3
	I XGEN="OGG1" S RET=3
	I XGEN="PARP1" S RET=3
	I XGEN="PCNA" S RET=3
	I XGEN="PHB" S RET=3
	I XGEN="PHOX2B" S RET=3
	I XGEN="PIK3CG" S RET=3
	I XGEN="PLA2G2A" S RET=3
	I XGEN="PMS1" S RET=3
	I XGEN="POLB" S RET=3
	I XGEN="PPM1D" S RET=3
	I XGEN="PREX2" S RET=3
	I XGEN="PRF1" S RET=3
	I XGEN="PRKAR1A" S RET=3
	I XGEN="PRKDC" S RET=3
	I XGEN="PTTG2" S RET=3
	I XGEN="RAD1" S RET=3
	I XGEN="RAD17" S RET=3
	I XGEN="RAD18" S RET=3
	I XGEN="RAD23B" S RET=3
	I XGEN="RAD51AP1" S RET=3
	I XGEN="RAD51B" S RET=3
	I XGEN="RAD52" S RET=3
	I XGEN="RAD54B" S RET=3
	I XGEN="RAD54L" S RET=3
	I XGEN="RAD9A" S RET=3
	I XGEN="RBBP8" S RET=3
	I XGEN="RECQL" S RET=3
	I XGEN="RECQL4" S RET=3
	I XGEN="RECQL5" S RET=3
	I XGEN="RFC1" S RET=3
	I XGEN="RFC2" S RET=3
	I XGEN="RFC4" S RET=3
	I XGEN="RHBDF2" S RET=3
	I XGEN="RNF146" S RET=3
	I XGEN="RNF168" S RET=3
	I XGEN="RNF8" S RET=3
	I XGEN="RPA1" S RET=3
	I XGEN="RUNX1" S RET=3
	I XGEN="SETBP1" S RET=3
	I XGEN="SETX" S RET=3
	I XGEN="SHPRH" S RET=3
	I XGEN="SLX4" S RET=3
	I XGEN="SMARCA4" S RET=3
	I XGEN="SMARCE1" S RET=3
	I XGEN="TCL1A" S RET=3
	I XGEN="TELO2" S RET=3
	I XGEN="TERF2" S RET=3
	I XGEN="TLR2" S RET=3
	I XGEN="TLR4" S RET=3
	I XGEN="TOPBP1" S RET=3
	I XGEN="TP53BP1" S RET=3
	I XGEN="TSHR" S RET=3
	I XGEN="UBE2A" S RET=3
	I XGEN="UBE2B" S RET=3
	I XGEN="UBE2I" S RET=3
	I XGEN="UBE2V2" S RET=3
	I XGEN="UBE4B" S RET=3
	I XGEN="UIMC1" S RET=3
	I XGEN="XPA" S RET=3
	I XGEN="XPC" S RET=3
	I XGEN="XRCC1" S RET=3
	I XGEN="XRCC2" S RET=3
	I XGEN="XRCC3" S RET=3
	I XGEN="XRCC4" S RET=3
	I XGEN="XRCC5" S RET=3
	I XGEN="XRCC6" S RET=3
	I XGEN="ZNF350" S RET=3
	I XGEN="ZNF365" S RET=3
   ; 
   Q RET
   ;
