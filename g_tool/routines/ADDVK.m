ADDVK(OUTDIR)
   ; ------------------------------------------------------------------------------------
   ; ^WTP - vystup z gemini:
   ;
   ; ^VIKO - Viktorovy kontroly, vybrane jen -9carrier a unknown. 
   ; ^VIKO("chr1",10093776,10093777)="5|877"
   ;
   ; ^WNK - nase kontroly, vybrane jen???? ted jen WCZE3 se vzorkama
   ; 
   ; Vytvori novy global ^WTMPU, do krereho  na patricna mista vlozi data z ^WTNP, ^VIKO  
   ; ^WNK. Z nej pak vyhrezne soubory pro web OUTDIR/PAC.dat, ktere se shellem 
   ; preformatuji a nasypou do TABS
   ;
   K ^WTMPU
   S PAC=""
   F  S PAC=$O(^WTMP(PAC)) Q:PAC=""  D
   . S R="" 
   . F  S R=$O(^WTMP(PAC,R)) Q:R=""  D
   . . S PR=$P(^WTMP(PAC,R),"|",1,11)
   . . S DR=$P(^WTMP(PAC,R),"|",12,39)
   . . ; prvni radek je hlavicka
   . . I R=0 S V9C="VIK-9carrier" S V9U="VIK-unknown" S NK1="01_UBEO_Class" S NK2="Czecanca_kons" 
   . . E  D
   . . . S CHR=$P(^WTMP(PAC,R),"|",28)
   . . . S START=$P(^WTMP(PAC,R),"|",29)
   . . . S END=$P(^WTMP(PAC,R),"|",30)
   . . . S REF=$P(^WTMP(PAC,R),"|",31)
   . . . S ALT=$P(^WTMP(PAC,R),"|",32)
   . . . S V9C="None"
   . . . S V9U="None"
   . . . S NK1="None"
   . . . S NK2="None"
   . . . ; pridani Viktorovych kontrol
   . . . I $D(^VIKO(CHR,START,END,REF,ALT))  D
   . . . . S V9C=$P(^VIKO(CHR,START,END,REF,ALT),"|",1)
   . . . . S V9U=$P(^VIKO(CHR,START,END,REF,ALT),"|",2)
   . . . ; pridani nasich kontrol
   . . . I $D(^WCZE3(CHR,START,END,REF,ALT))  D
   . . . . S NK1=$P(^WCZE3(CHR,START,END,REF,ALT),"|",1)
   . . . . S NK2=$P(^WCZE3(CHR,START,END,REF,ALT),"|",2)
   . . ; tady mame pohromade vsechna data pro vlozeni...
   . . S REC=PR_"|"_V9C_"|"_V9U_"|"_NK1_"|"_NK2_"|"_DR
   . . S ^WTMPU(PAC,R)=REC
   ; a konecne vysypeme ven co jsme nasyslili
   S PAC=""
   F  S PAC=$O(^WTMPU(PAC)) Q:PAC=""  D
   . S OFILE=OUTDIR_"/"_PAC_".dat" 
   . OPEN OFILE:NEWVERSION
   . S R=""
   . USE OFILE
   . F  S R=$O(^WTMPU(PAC,R)) Q:R=""  D
   . . W ^WTMPU(PAC,R),!
   . CLOSE OFILE
   Q
