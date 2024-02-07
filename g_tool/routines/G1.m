G1
	S GPF=""
	S GPF=$O(^GR1(GPF))
	W "GP>>"_GPF,!
	S CNT=0
	S GP=""
	F  S GP=$O(^GR1(GP)) Q:GP=""  D
	. S K1=""
	. F  S K1=$O(^GR1(GP,K1)) Q:K1=""  D
	. . S CNT=CNT+1
	. . ;W "GP>"_GP_" GPF>>"_GPF_"  "
	. . I GP=GPF W CNT_" "_^GR1(GP,K1),!
	. . E  D
	. . . W "GP>"_GP,!
	. . . S CNT=1
	. . . S GPF=GP
	. . . W CNT_"_"_^GR1(GP,K1),!
	Q

