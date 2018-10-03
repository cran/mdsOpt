optIscalInterval<-function(x,dataType="simple",normalizations=NULL,
                           optMethods=NULL,outputCsv="",outputCsv2="",y=NULL,outDec=","
                           ,stressDigits=6,HHIDigits=2,...){
  
  eps=1e-06
  p=2
  maxit=1000
  
  z <- list(...)
  if(!is.null(z$eps)) eps<-z$eps
  if(!is.null(z$p)) p<-z$p
  if(!is.null(z$maxit)) maxit<-z$maxit
  # Data set

  options(OutDec=outDec)
  # MDS parameters

  metnor<-c("n1","n2","n3","n3a","n4","n5","n5a","n6","n6a","n7","n8","n9","n9a","n10","n11","n12","n12a","n13")  
  metopt<-c("MM","BFGS")

  if(!is.null(normalizations)){
    if (!is.vector(normalizations)) stop (paste("Optional parameter \"normalizations\" must be a vector containing only values from the following list: \n",paste(metnor,collapse=" ; ")))
    for (i in 1:length(normalizations))
    {
      if (sum(metnor==normalizations[i])!=1 && normalizations[i]!="n0"){
        stop (paste("Optional parameter \"normalizations\" must be a vector containing only values from the following list: \n",paste(metnor,collapse=" ; ")))
      }
    }
    metnor<-normalizations
  }
  if(!is.null(optMethods)){
    if (!is.vector(optMethods)) stop (paste("Optional parameter \"optMethods\" must be a vector containing only values from the following list: \n",paste(metopt,collapse=" ; ")))
    for (i in 1:length(optMethods))
    {
      if (sum(metopt==optMethods[i])!=1){
        stop (paste("Optional parameter \"optMethods\" must be a vector containing only values from the following list: \n",paste(metopt,collapse=" ; ")))
      }
    }
    metopt<-optMethods
  }

  
  colnor<-NULL
  colmethod<-NULL
  results<-rep(0,length(metnor)*length(metopt))
  HHI<-rep(0,length(metnor)*length(metopt))
  
  metall<-NULL
  
  for(a in metnor){
    for(b in metopt){
      metall<-c(metall,paste(a," ",b))
      colnor<-c(colnor,a)
      colmethod<-c(colmethod,b)
    }
  }
  minstress<-1e10
  minstressj<--1
  mn<-length(metall)
  cl <- as.list(match.call())[-1]
  cl[["x"]]<-NULL
  cl[["normalizations"]]<-NULL
  cl[["optMethods"]]<-NULL
  cl[["outputCsv"]]<-NULL
  cl[["outputCsv2"]]<-NULL
  cl[["dataType"]]<-NULL
  cl[["y"]]<-NULL
  cl[["outDec"]]<-NULL
  cl[["stressDigits"]]<-NULL
  cl[["HHIDigits"]]<-NULL
  x1<-x
  y1<-y
  for(j in 1:mn){
    #print(metall)
    #print(strsplit(metall[j]," ")[[1]][1])
    #print(strsplit(metall[j]," ")[[1]][2])
    normalized<-interval_normalization(x=x1,y=y1,dataType=dataType,type=strsplit(metall[j],"   ")[[1]][1])
    x<-normalized$simple[,,1]
    y<-normalized$simple[,,2]
    my.idiss<-idistBox(X=(x+y)/2,R=(y-x)/2)
    cmat <- (my.idiss[2, , ] + my.idiss[1, , ])/2
    iniX <- cmdscale(as.dist(cmat), k = 2)
    n=dim(my.idiss)[2]
    iniR <- matrix(rep(1,n * 2), nrow = n, ncol = 2)
    opt.method=strsplit(metall[j],"   ")[[1]][2]

    
    def_args <- list(IDM=my.idiss,p=p,model="box",opt.method=opt.method, ini=list(iniX,iniR),eps=eps,maxit=maxit)
    res<-do.call("IMDS",c(cl,def_args[!names(def_args) %in% names(cl)]))
    #argss<<-c(cl,def_args[!names(def_args) %in% names(cl)])
    #ress<<-res
    if(minstress>res$str){
      minstress<-res$str
      minstressj<-j
    }
    #I-stress - formula(4), Groenen, Winsberg, Rodriquez, Diday, 2006, pp. 363
    l<-(res$EIDM[1,,] - my.idiss[1,,])^2
    u<-(res$EIDM[2,,] - my.idiss[2,,])^2
    ll<-(res$EIDM[1,,])^2
    uu<-(res$EIDM[2,,])^2
    Istress<- (sum(l)+sum(u))/(sum(ll) + sum(uu))
    results[j]<-Istress
    HHI[j]<-sum((ispb(res$EIDM,my.idiss))^2)
  }
  resultsFull<-cbind(colnor,colmethod,format(round(results,stressDigits),scientific = FALSE),format(round(HHI,HHIDigits),scientific = FALSE))[order(results),]
  colnames(resultsFull)<-c("Normalization method", "Opt method","I-STRESS","HHI spb")
  if(outputCsv!=""){
    write.table(resultsFull, file=outputCsv,row.names=TRUE,col.names=NA)
  }
  if(outputCsv2!=""){
    write.table(resultsFull, file=outputCsv2,sep=";",dec=",",row.names=TRUE,col.names=NA)
  }
  return (resultsFull)
}
