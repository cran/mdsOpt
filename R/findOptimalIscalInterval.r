findOptimalIscalInterval<-function(table,critical_stress=(max(as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=TRUE)))+min(as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=TRUE))))/2,critical_HHI=NA){
  if(is.na(critical_stress) && is.na(critical_stress)){
  stop("One of the criterions critical_Stress or critical_HHI shoul be set")
  }
  if(is.na(critical_HHI)){
    opt<-"HHI spb"
    cut<-"I-STRESS"
    critical=critical_stress
  }
  else{
    opt<-"I-STRESS"
    cut<-"HHI spb"
    critical=critical_HHI
  }
  print(opt)
  number<-(1:nrow(table))[order(as.numeric(gsub(",",".",table[,opt])))]
  table<-table[order(as.numeric(gsub(",",".",table[,opt]))),]
  number<-number[as.numeric(gsub(",",".",table[,cut],fixed=TRUE))<=critical]
  table<-table[as.numeric(gsub(",",".",table[,cut],fixed=TRUE))<=critical,]
  if(nrow(table)==0){
    stop("No mds procedure for given constraints")
  }
    res<-list(
      Nr=as.vector(number[1]),
      Normalization_method=as.vector(table[1,"Normalization method"]),
      Opt_method=as.vector(table[1,"Opt method"]),
      I_STRESS=as.numeric(gsub(",",".",table[1,"I-STRESS"],fixed=TRUE)),HHI_spb=as.numeric(gsub(",",".",table[1,"HHI spb"],fixed=TRUE)))
  return(res)
}
