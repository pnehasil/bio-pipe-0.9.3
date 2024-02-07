R07
  S CNT=0
  S K=""
  F  S K=$O(^RNA07(K)) Q:K=""  D
  . S CNT=CNT+1
  . W ^RNA07(K),!
  W CNT,!
  Q

