findOptimalSmacofSym<-function(table,critical_stress=(max(as.numeric(gsub(",",".",table[,"STRESS 1"],fixed=T)))+min(as.numeric(gsub(",",".",table[,"STRESS 1"],fixed=T))))/2,critical_HHI=NA){
  if(is.na(critical_stress) && is.na(critical_stress)){
  stop("One of the criterions critical_Stress or critical_HHI shoul be set")
  }
  if(is.na(critical_HHI)){
    opt<-"HHI spp"
    cut<-"STRESS 1"
    critical=critical_stress
  }
  else{
    opt<-"STRESS 1"
    cut<-"HHI spp"
    critical=critical_HHI
  }
  number<-(1:nrow(table))[order(as.numeric(gsub(",",".",table[,opt])))]
  table<-table[order(as.numeric(gsub(",",".",table[,opt]))),]
  number<-number[as.numeric(gsub(",",".",table[,cut],fixed=T))<=critical]
  table<-table[as.numeric(gsub(",",".",table[,cut],fixed=T))<=critical,]
  if(nrow(table)==0){
    stop("No mds procedure for given constraints")
  }
  if(sum(colnames(table)=="Spline degree")!=0){
    res<-list(
    Nr=as.vector(number[1]),
    Normalization_method=as.vector(table[1,"Normalization method"]),
    MDS_model=as.vector(table[1,"MDS model"]),
    Spline_degree=as.vector(table[1,"Spline degree"]),
    Distance_measure=as.vector(table[1,"Distance measure"]),
    STRESS_1=as.numeric(gsub(",",".",table[1,"STRESS 1"],fixed=T)),HHI_spp=as.numeric(gsub(",",".",table[1,"HHI spp"],fixed=T)))
  }
  else{
    res<-list(
    Nr=as.vector(number[1]),
    Normalization_method=as.vector(table[1,"Normalization method"]),
    MDS_model=as.vector(table[1,"MDS model"]),
    Distance_measure=as.vector(table[1,"Distance measure"]),
    STRESS_1=as.numeric(gsub(",",".",table[1,"STRESS 1"],fixed=T)),HHI_spp=as.numeric(gsub(",",".",table[1,"HHI spp"],fixed=T)))
  }
  return(res)
  
}

