\name{ispb}
\alias{ispb}
\title{Calculation of I-stress per box indices for multidimensional scaling procedure for symbolic interval-valued data}
\description{Calculation of I-stress per box indices for multidimensional scaling procedure for symbolic interval-valued data}
\usage{ispb(EIDM,idiss)}
\arguments{
\item{EIDM}{the interval-valued dissimilarity matrix IDM (an object of class "array": IDM[1,,]: the lower dissmilarity matrix; IDM[2,,]: the upper dissmilarity matrix) in reduced space}
\item{idiss}{the primary interval-valued dissimilarity matrix }
}
\value{The vector of i-stress per box percentage values}
\author{
Marek Walesiak \email{marek.walesiak@ue.wroc.pl}, Andrzej Dudek \email{andrzej.dudek@ue.wroc.pl} 

Department of Econometrics and Computer Science, University of Economics, Wroclaw, Poland \url{http://keii.ue.wroc.pl/mdsOpt}
}
\references{
Borg, I., Groenen, P.J.F. (2005), Modern Multidimensional Scaling. Theory and Applications, 2nd Edition, Springer Science+Business Media, New York. ISBN: 978-0387-25150-9. Available at: \url{http://www.springeronline.com/0-387-25150-2}.

Borg, I., Groenen, P.J.F., Mair, P. (2013), Applied Multidimensional Scaling, Springer, Heidelberg, New York, Dordrecht, London. Available at: \url{http://dx.doi.org/10.1007/978-3-642-31848-1}.

Groenen, P.J.F. Winsberg, S., Rodriguez, O., Diday, E. (2006), I-Scal: Multidimensional scaling of interval dissimilarities, Computational Statistics & Data Analysis, 51(1), 360–378. Available at: \url{http://dx.doi.org/10.1016/j.csda.2006.04.003}.

Walesiak, M. (2014), Przegląd formuł normalizacji wartości zmiennych oraz ich własności w statystycznej analizie wielowymiarowej [Data Normalization in Multivariate Data Analysis. An Overview and Properties], Przegląd Statystyczny, tom 61, z. 4, 363-372. Available at: \url{http://keii.ue.wroc.pl/pracownicy/mw/2014_Walesiak_Przeglad_Statystyczny_z_4.pdf}

Walesiak, M., Dudek, A. (2017), \emph{Selecting the Optimal Multidimensional Scaling Procedure for Metric Data with R Environment}, STATISTICS IN TRANSITION new series, September, Vol. 18, No. 3, pp. 521-540. Available at: \url{http://stat.gov.pl/en/sit-en/issues-and-articles-sit/}.
}
\seealso{\code{\link{data.Normalization}}, \code{\link{interval_normalization}}, \code{\link{IMDS}}
}
\examples{
library(mdsOpt)
library(clusterSim)
library(smds)
data(data_symbolic_interval_polish_voivodships)
x1<-data_symbolic_interval_polish_voivodships[,,1]
y1<-data_symbolic_interval_polish_voivodships[,,2]
norm_type="n2" 
normalized<-interval_normalization(x=x1,y=y1,dataType="separate_tables",type=norm_type)
x<-normalized$simple[,,1]
y<-normalized$simple[,,2]
my.idiss<-idistBox(X=(x+y)/2,R=(y-x)/2)
#Apply the hyperbox model via the MM algorithm
cmat<-(my.idiss[2, , ] + my.idiss[1, , ])/2
iniX<-cmdscale(as.dist(cmat), k = 2)
n=dim(my.idiss)[2]
iniR<-matrix(rep(1,n * 2), nrow = n, ncol = 2)
res.mm_box<-IMDS(IDM=my.idiss, p=2,model="box",opt.method="MM", ini=list(iniX,iniR))
plot(res.mm_box)
title(main="box_MM")
#windows()
spb<-ispb(res.mm_box$EIDM,my.idiss)
w<-sort(spb,decreasing=TRUE)
print(spb)
names(w)<-order(spb,decreasing = TRUE)
plot(w, xlab="Object", ylab="spb in \%")
text(w,pos=1,names(w))
}
\keyword{multidimensional scaling}
\keyword{stress per box}
\keyword{normalization methods}
\keyword{interval-valued data}
