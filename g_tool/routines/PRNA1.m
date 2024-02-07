PRNA1
  K ^RNA07X1
  K ^RNA07X2
  S K=""
  F  S K=$O(^RNA07(K)) Q:K=""  D
  . ;W K,!
  . S BEG=$P(^RNA07(K),"|",3)
  . S END=$P(^RNA07(K),"|",4)
  . S CX=$P(^RNA07(K),"|",12)
  . S C1=$P(CX,",",1)
  . S C2=$P(CX,",",2)
  . S CHR=$P(^RNA07(K),"|",2)
  . S XH=$P(^RNA07(K),"|",6)
  . S PAC=$P(^RNA07(K),"|",14)
  . S NK1=BEG+C1
  . S NK2=END-C2+1
  . S ^RNA07X1(CHR,NK1,NK2,PAC)=XH
  . S ^RNA07X2(PAC)=""
  Q
