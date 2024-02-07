PRNAB1
  S CHR=""
  F  S CHR=$O(^RNA07X1(CHR)) Q:CHR=""  D
  . S K1=""
  . F  S K1=$O(^RNA07X1(CHR,K1)) Q:K1=""  D
  . . W CHR_"|"_K1_"|"_K1_"|A|T",!
  Q
