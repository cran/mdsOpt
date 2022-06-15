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
    my.idiss<-.idistBox(X=(x+y)/2,R=(y-x)/2)
    cmat <- (my.idiss[2, , ] + my.idiss[1, , ])/2
    iniX <- cmdscale(as.dist(cmat), k = 2)
    n=dim(my.idiss)[2]
    iniR <- matrix(rep(1,n * 2), nrow = n, ncol = 2)
    opt.method=strsplit(metall[j],"   ")[[1]][2]

    
    def_args <- list(IDM=my.idiss,p=p,model="box",opt.method=opt.method, ini=list(iniX,iniR),eps=eps,maxit=maxit)
    res<-do.call(".IMDS",c(cl,def_args[!names(def_args) %in% names(cl)]))
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



".IMDS" <-
function(IDM, p=2,eps= 1e-5 ,maxit =1000,model=c("sphere","box"),opt.method=c("MM","BFGS"), ini = "auto",report=100,grad.num=FALSE,rel=0,dil=1){
						nvec <- dim(IDM)
						n <- nvec[2]
						if(model[1]=="sphere"){
							if(ini[1]=="auto"){
								cmat <- (IDM[2,,] + IDM[1,,])/2
								iniX <- cmdscale(as.dist(cmat),k=p)
								inir <- runif(n,min = 0.1, max = 1)
								inixr <- c(iniX,sqrt(inir))
							}else{
								iniX <- ini[[1]]
									inir <- ini[[2]]
								inixr <- c(ini[[1]],sqrt(ini[[2]]))
							}
							if(opt.method[1]=="BFGS"){
								if(grad.num==FALSE){
									result.opt <- optim(par=inixr, fn = .obj.sph, gr=.Grad.sph, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,abstol=eps,REPORT=report,maxit=maxit))
								}else if(grad.num==TRUE){
									result.opt <- optim(par=inixr, fn = .obj.sph, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,REPORT=report,abstol=eps,maxit=maxit))
								}else if(grad.num=="hyb"){
									tmp <- optim(par=inixr, fn = .obj.sph, gr=.Grad.sph, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,REPORT=report,abstol=eps,maxit=maxit))
									result.opt <- optim(par=tmp$par, fn = .obj.sph, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,REPORT=report,abstol=eps,maxit=maxit))
								}
								X <- matrix(result.opt$par[1:(n*p)],nrow=n)
								r <- result.opt$par[(n*p)+1:n]^2
								str <- result.opt$value
								result <- list(X=X,r = r, str = str, str.vec=NA,IDM=IDM, EIDM = .idistSph(X,r))
								class(result) <- c("imds","sph")
								return(result)
							}else if(opt.method[1]=="MM"){
								str.vec <- rep(-1,maxit+1)
								result.mmSph <- .C("mmSph",
																arg1 = as.double(iniX),
																arg2 = as.double(inir),
																arg3 = as.double(str.vec),
																arg4 = as.double( array( 0,dim=c(n,n) ) ),#ldist
																arg5 = as.double( array( 0,dim=c(n,n) ) ),#udist
																arg6 = as.double(IDM[1,,]),
																arg7 = as.double(IDM[2,,]),
																arg8 =as.double(eps),
																arg9 = as.integer(rel),
																arg10 = as.integer(dil),
																arg11 = as.integer(n),
																arg12 = as.integer(p),
																arg13 = as.integer(maxit),
																arg14 = as.integer(report),
																PACKAGE="mdsOpt"
																) 
								EIDM <- array(0,dim=c(2,n,n))
								EIDM[1,,] <- result.mmSph$arg4
								EIDM[2,,] <- result.mmSph$arg5
								X <- matrix(result.mmSph$arg1,nrow=n,ncol=2)
								tmp.vec <- result.mmSph$arg3
								str.vec <- tmp.vec[which(tmp.vec>-0.5)]
								str <- str.vec[length(str.vec)]
								result <- list(X=X,r= result.mmSph$arg2, str = str, str.vec=str.vec,IDM=IDM,EIDM = EIDM)
								class(result) <- c("imds","sph")
								return(result)
							}
						}else if(model[1]=="box"){
							if(ini[1]=="auto"){
								cmat <- (IDM[2,,] + IDM[1,,])/2
								iniX <- cmdscale(as.dist(cmat),k=p)
								iniR <- matrix(runif(n*p,min = 0.1, max = 1),nrow=n,ncol=p)
								inixr <- c(iniX,sqrt(iniR))
							}else{
								iniX <- ini[[1]]
								iniR <- ini[[2]]
								inixr <- c(ini[[1]],sqrt(ini[[2]]))
							}
							if(opt.method[1]=="BFGS"){
								if(grad.num==FALSE){
									result.opt <- optim(par=inixr, fn = .obj.box, gr=.Grad.box, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,abstol=eps,REPORT=report,maxit=maxit))
								}else if(grad.num==TRUE){
									result.opt <- optim(par=inixr, fn = .obj.box, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,abstol=eps,REPORT=report,maxit=maxit))
								}else if(grad.num=="hyb"){
									tmp <- optim(par=inixr, fn = .obj.box, gr=.Grad.box, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,abstol=eps,REPORT=report,maxit=maxit))
									result.opt <- optim(par=tmp$par, fn = .obj.box, ldiss=IDM[1,,],udiss=IDM[2,,], P=p,method ="BFGS",control = list( trace = TRUE,abstol=eps,REPORT=report,maxit=maxit))
								}
								X <- matrix(result.opt$par[1:(n*p)],nrow=n)
								R <- matrix(result.opt$par[(n*p)+1:(n*p)]^2,nrow=n)
								str <- result.opt$value
								result <- list(X=X,R = R, str = str, str.vec=NA,IDM=IDM, EIDM = .idistBox(X,R))
								class(result) <- c("imds","box")
								return(result)
							}else if(opt.method[1]=="MM"){
								str.vec <- rep(-1,maxit+1)
								result.mmBox <- .C("mmBox",
																arg1 = as.double(iniX),
																arg2 = as.double(iniR),
																arg3 = as.double(str.vec),
																arg4 = as.double( array( 0,dim=c(n,n) ) ),#ldist
																arg5 = as.double( array( 0,dim=c(n,n) ) ),#udist
																arg6 = as.double(IDM[1,,]),
																arg7 = as.double(IDM[2,,]),
																arg8 =as.double(eps),
																arg9 = as.integer(rel),
																arg10 = as.integer(dil),
																arg11 = as.integer(n),
																arg12 = as.integer(p),
																arg13 = as.integer(maxit),
																arg14 = as.integer(report),
																PACKAGE="mdsOpt"
																) 
								EIDM <- array(0,dim=c(2,n,n))
								EIDM[1,,] <- result.mmBox$arg4
								EIDM[2,,] <- result.mmBox$arg5
								X <- matrix(result.mmBox$arg1,nrow=n,ncol=2)
								R <- matrix(result.mmBox$arg2,nrow=n,ncol=2)
								tmp.vec <- result.mmBox$arg3
								str.vec <- tmp.vec[which(tmp.vec>-0.5)]
								str <- str.vec[length(str.vec)]
								result <- list(X=X,R= R, str = str, str.vec=str.vec,IDM=IDM,EIDM = EIDM)
								class(result) <- c("imds","box")
								return(result)
							}
						}
					}

".idistBox" <-
function(X,R){
					N <- nrow(X)
					P <- ncol(X)
					tmp <-	.C("bidist",
										arg1 = as.double(X), 
										arg2 = as.double(R), 
										arg3 = as.double(array(0,dim=c(N,N))), 
										arg4 = as.double(array(0,dim=c(N,N))), 
										arg5 = as.integer(N), 
										arg6 = as.integer(P),
										PACKAGE="mdsOpt"
									)
					tmpidist <- array(0,dim=c(2,N,N))
					tmpidist[1,,] <- tmp$arg3
					tmpidist[2,,] <- tmp$arg4
					return(tmpidist)
				}
				
".Grad.box" <-
function(vecxr,ldiss,udiss, P){
					N <- nrow(ldiss)
					X <- matrix(vecxr[1:(N*P)],nrow=N,ncol=P)
					R <- vecxr[(N*P)+1:(N*P)]
					igrad <- rep(0,2*N*P)
					.C("boxgrad",
						arg1=as.double(igrad),
						arg2=as.double(X),
						arg3=as.double(R),
						arg4=as.double(ldiss),
						arg5=as.double(udiss),
						arg6=as.integer(N),
						arg7=as.integer(P),
						PACKAGE="mdsOpt"
					)$arg1
				}

".Grad.sph" <-
function(vecxr,ldiss,udiss, P){
					N <- nrow(ldiss)
					X <- matrix(vecxr[1:(N*P)],nrow=N,ncol=P)
					r <- vecxr[(N*P)+1:N]
					D <- as.matrix(dist(X))
					IDM <- .idistSph(X,r^2)
					ldm <- IDM[1,,]
					udm <- IDM[2,,]
					igrad <- rep(0,N*P+N)
					.C("sphgrad",
						arg1=as.double(igrad),
						arg2=as.double(X),
						arg3=as.double(r),
						arg4=as.double(D),
						arg5=as.double(ldm),
						arg6=as.double(udm),
						arg7=as.double(ldiss),
						arg8=as.double(udiss),
						arg9=as.integer(N),
						arg10=as.integer(P),
						PACKAGE="mdsOpt"
					)$arg1
				}

".idistSph" <-
function(X,r){
					N <- nrow(X)
					P <- ncol(X)
					D <- as.matrix(dist(X))
					ldist <- D - r%*%t(rep(1,N)) - rep(1,N)%*%t(r)
					ldist[which(ldist<0)] <- 0
					udist <- D + r%*%t(rep(1,N)) + rep(1,N)%*%t(r)
					diag(udist) <- 0
					tmpidist <- array(0,dim=c(2,N,N))
					tmpidist[1,,] <- ldist
					tmpidist[2,,] <- udist
					return(tmpidist)
				}
".obj.box" <-
function(vecxr,ldiss,udiss, P){
					N <- nrow(ldiss)
					X <- matrix(vecxr[1:(N*P)],nrow=N,ncol=P)
					R <- matrix(vecxr[(N*P)+1:(N*P)]^2,nrow=N)
					IDM <- .idistBox(X,R)
					tmp <- array(0,dim=c(2,N,N))
					tmp[1,,] <- ldiss
					tmp[2,,] <- udiss
					return(sum( (tmp-IDM)^2 )/2)
				}
".obj.sph" <-
function(vecxr,ldiss,udiss, P){
					N <- nrow(ldiss)
					X <- matrix(vecxr[1:(N*P)],nrow=N,ncol=P)
					r <- vecxr[(N*P)+1:N]^2
					D <- dist(X)
					IDM <- .idistSph(X,r)
					tmp <- array(0,dim=c(2,N,N))
					tmp[1,,] <- ldiss
					tmp[2,,] <- udiss
					return(sum( (tmp-IDM)^2 )/2)
				}
".plot.imds"<-
function(x, xylim="auto",clab=1:nrow(X),lab.cex=1,lab.col="black",...){
		if(class(x)[2]=="sph"){
			X <- x$X
			r <- x$r
			start=0
			end=360
			length=100
			func=lines
			theta <- c(seq(start/180*pi, end/180*pi, length=length), end/180*pi)
			n <- nrow(X)
			if(xylim=="auto"){
				xmax <- max(X[,1] + r)
				xmin <- min(X[,1] - r)
				ymax <- max(X[,2] + r)
				ymin <- min(X[,2] - r)
				xrange <- xmax - xmin
				yrange <- ymax - ymin
				range <- max(c(xrange,yrange))
				xmar <- (range - xrange)/2
				ymar <- (range - yrange)/2
				xylim <- matrix(0,2,2)
				xylim[1,] <- c(xmin-xmar,xmax+xmar)
				xylim[2,] <- c(ymin-ymar,ymax+ymar)
			}
			plot(X,xlim=xylim[1,],ylim=xylim[2,],type="n",xlab="",ylab="",main="")
			text(X,labels=clab,cex=lab.cex,xlim=xylim[1,],ylim=xylim[2,])
			for(i in 1:n){
				func(r[i]*cos(theta)+X[i,1], r[i]*sin(theta)+X[i,2], ...)
			}
		}else if(class(x)[2]=="box"){
			X <- x$X
			R <- x$R
			n <- nrow(X)
			if(xylim=="auto"){
				xmax <- max(X[,1] + R[,1])
				xmin <- min(X[,1] - R[,1])
				ymax <- max(X[,2] + R[,2])
				ymin <- min(X[,2] - R[,2])
				xrange <- xmax - xmin
				yrange <- ymax - ymin
				range <- max(c(xrange,yrange))
				xmar <- (range - xrange)/2
				ymar <- (range - yrange)/2
				xylim <- matrix(0,2,2)
				xylim[1,] <- c(xmin-xmar,xmax+xmar)
				xylim[2,] <- c(ymin-ymar,ymax+ymar)
			}
			plot(X,xlim=xylim[1,],ylim=xylim[2,],type="n",xlab="",ylab="",main="")
			text(X,labels=clab,cex=lab.cex,xlim=xylim[1,],ylim=xylim[2,],col=lab.col)
			for(i in 1:n){
				xleft <- X[i,1] - R[i,1]
				ybottom <-  X[i,2] - R[i,2]
				xright <- X[i,1] + R[i,1]
				ytop <- X[i,2] + R[i,2]
				rect(xleft,ybottom,xright,ytop,...)
			}
		}
		}