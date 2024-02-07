PRNA2
  K ^RNA07X3 
  S CNT=0
  S CHR=""
  F  S CHR=$O(^RNA07X1(CHR)) Q:CHR=""  D
  . S K1=""
  . F  S K1=$O(^RNA07X1(CHR,K1)) Q:K1=""  D
  . . S K2=""
  . . F  S K2=$O(^RNA07X1(CHR,K1,K2)) Q:K2=""  D
  . . . S CNT=CNT+1
  . . . ;W CNT,!
  . . . S PAC=""
  . . . F  S PAC=$O(^RNA07X2(PAC)) Q:PAC=""  D
  . . . . I $D(^RNA07X1(CHR,K1,K2,PAC))  D
  . . . . . S ^RNA07X3(PAC,CNT)=^RNA07X1(CHR,K1,K2,PAC)
  . . . . E  D
  . . . . . S ^RNA07X3(PAC,CNT)="0"
  ;S CNT=0 ; generuje soubor export1, patrne neni potreba
  ;S CHR=""
  ;S PAC=""
  ;W "chr|start|end"
  ;F  S PAC=$O(^RNA07X3(PAC)) Q:PAC=""  D
  ;. W "|"_PAC
  ;W !
  ;F  S CHR=$O(^RNA07X1(CHR)) Q:CHR=""  D
  ;. S K1=""
  ;. F  S K1=$O(^RNA07X1(CHR,K1)) Q:K1=""  D
  ;. . S K2=""
  ;. . F  S K2=$O(^RNA07X1(CHR,K1,K2)) Q:K2=""  D
  ;. . . S CNT=CNT+1
  ;. . . W CHR_"|"_K1_"|"_K2
  ;. . . S PAC=""
  ;. . . F  S PAC=$O(^RNA07X3(PAC)) Q:PAC=""  D
  ;. . . . W "|"_^RNA07X3(PAC,CNT)
  ;. . . W !
  Q
