findOptimalIscalInterval<-function(table,critical_stress=(max(as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=T)))+min(as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=T))))/2){
  number<-(1:nrow(table))[order(as.numeric(gsub(",",".",table[,"HHI spb"])))]
  table<-table[order(as.numeric(gsub(",",".",table[,"HHI spb"]))),]
  number<-number[as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=T))<=critical_stress]
  table<-table[as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=T))<=critical_stress,]
  if(nrow(table)==0){
    stop("No mds procedure for given constraints")
  }
    res<-list(
      Nr=as.vector(number[1]),
      Normalization_method=as.vector(table[1,"Normalization method"]),
      Opt_method=as.vector(table[1,"Opt method"]),
      I_STRESS=as.numeric(gsub(",",".",table[1,"I-STRESS"],fixed=T)),HHI_spb=as.numeric(gsub(",",".",table[1,"HHI spb"],fixed=T)))
  return(res)
}
