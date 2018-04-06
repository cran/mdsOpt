drawIsoquants<-function(x,y=NULL,number=6,steps=NULL){
  ile=number   
  if(is.null(steps) && is.null(y)){
    stop("neither x or steps cann not be empty") 
  }
  if(is.null(steps)){
    d<-rbind(x,y)
    steps<-dist(d)[1]/number
  }
  if(length(steps)==1){
    steps<-rep(steps,number);
  }else
  if(length(steps)<number){
    steps<-c(steps,rep(steps[length(steps)-1],number-length(steps)));
  }
  print(steps)
  for(i in 1:number){
    draw.circle(x[1],x[2],sum(steps[1:i]))
  }
}
