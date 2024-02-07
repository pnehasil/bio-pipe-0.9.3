PRNA3
   K ^RNA07S
   S CNT=0
   S CHR=""
   S PAC=""
   W "chr|start|end||||||||||||||"
   F  S PAC=$O(^RNA07X3(PAC)) Q:PAC=""  D
   . S ^RNA07S(PAC)=0
   . W "|"_PAC
   W !
   F  S CHR=$O(^RNA07X1(CHR)) Q:CHR=""  D
   . S K1=""
   . F  S K1=$O(^RNA07X1(CHR,K1)) Q:K1=""  D
   . . S K2=""
   . . F  S K2=$O(^RNA07X1(CHR,K1,K2)) Q:K2=""  D
   . . . S CNT=CNT+1
   . . . W CHR_"|"_K1_"|"_K2
   . . . I $D(^RNA07X5(CHR,K1))  D
   . . . . W "|"_^RNA07X5(CHR,K1)
   . . . E  D
   . . . . W "|||||||" 
   . . . I $D(^RNA07X6(CHR,K2))  D
   . . . . W "|"_^RNA07X6(CHR,K2)
   . . . E  D
   . . . . W "|||||||" 
   . . . S PAC=""
   . . . F  S PAC=$O(^RNA07X3(PAC)) Q:PAC=""  D
   . . . . W "|"_^RNA07X3(PAC,CNT)
   . . . . S ^RNA07S(PAC)=^RNA07S(PAC)+^RNA07X3(PAC,CNT)
   . . . W !
   Q
