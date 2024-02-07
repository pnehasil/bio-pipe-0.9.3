GL(GLOB,PAC)
	; D ^GL(1,23)
	S SEQ=""
	I GLOB=1  D
	. F  S SEQ=$O(^CLI1(PAC,SEQ)) Q:SEQ=""  D
	. . W "^CLI1("_PAC_","_SEQ_")="_^CLI1(PAC,SEQ),!
	;
	S SEQ=""
	I GLOB=2  D
	. F  S SEQ=$O(^CLI2(PAC,SEQ)) Q:SEQ=""  D
	. . W "^CLI2("_PAC_","_SEQ_")="_^CLI2(PAC,SEQ),!
	;
	S SEQ=""
	I GLOB=3  D
	. F  S SEQ=$O(^CLI3(PAC,SEQ)) Q:SEQ=""  D
	. . W "^CLI3("_PAC_","_SEQ_")="_^CLI3(PAC,SEQ),!
	;
	S SEQ=""
	I GLOB=4  D
	. F  S SEQ=$O(^CLI4(PAC,SEQ)) Q:SEQ=""  D
	. . W "^CLI4("_PAC_","_SEQ_")="_^CLI4(PAC,SEQ),!
	;
	S SEQ=""
	I GLOB=5  D
	. F  S SEQ=$O(^CLI5(PAC,SEQ)) Q:SEQ=""  D
	. . W "^CLI5("_PAC_","_SEQ_")="_^CLI5(PAC,SEQ),!
	;
	S SEQ=""
	I GLOB="P"  D
	. F  S SEQ=$O(^PAC(PAC,SEQ)) Q:SEQ=""  D
	. . W "^PAC("_PAC_","_SEQ_")="_^PAC(PAC,SEQ),!
	;
	;
	S SEQ=""
	I GLOB="X"  D
	. F  S SEQ=$O(^XPAC(PAC,SEQ)) Q:SEQ=""  D
	. . W "^XPAC("_PAC_","_SEQ_")="_^XPAC(PAC,SEQ),!
	;
	Q


