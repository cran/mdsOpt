ispb<-function(EIDM,idiss){
  l<-(EIDM[1,,] - idiss[1,,])^2
  u<-(EIDM[2,,] - idiss[2,,])^2
  ser<-l+u
  raw<-apply(as.matrix(ser),1, mean)
  column<-apply(as.matrix(ser),2, mean)
  spb<-as.vector(100*(raw/sum(raw)))
  spb
}
