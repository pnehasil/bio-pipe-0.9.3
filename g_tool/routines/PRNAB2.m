PRNAB2
  S CHR=""
  F  S CHR=$O(^RNA07X1(CHR)) Q:CHR=""  D
  . S K1=""
  . F  S K1=$O(^RNA07X1(CHR,K1)) Q:K1=""  D
  . . S K2=""
  . . F  S K2=$O(^RNA07X1(CHR,K1,K2)) Q:K2=""  D
  . . . W CHR_"|"_K2_"|"_K2_"|A|T",!
  Q
