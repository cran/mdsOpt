\name{optIscalInterval}
\alias{optIscalInterval}
\title{Selecting the optimal multidimensional scaling procedure for symbolic interval-valued data}
\description{Selecting the optimal multidimensional scaling procedure by varying all combinations of normalization and optimization method models}
\usage{
optIscalInterval(x,dataType="simple",normalizations=NULL,
                           optMethods=NULL,outputCsv="",outputCsv2="",y=NULL,...)}
\arguments{
\item{x}{symbolic interval-valued data table or matrix or dataset}
\item{dataType}{Type of symbolic data table passed to function:

'sda' - full symbolicDA format object; 

'simple' - three dimensional array with lower and upper bound of intervals in third dimension;

'separate_tables' - lower bound of intervals in \code{x}, upper bound of intervals in  \code{y} (formula y=... needed in argument list);

'rows' - lower and upper bound of intervals in neighbouring rows;

'columns' - lower and upper bound of intervals in neighbouring columns}
\item{normalizations}{optional, vector of normalization methods that should be used in procedure}
\item{optMethods}{optional, vector of optimization methods}
\item{outputCsv}{optional, name of csv file with results}
\item{outputCsv2}{optional, name of csv (comma as decimal point sign) file with results}
\item{y}{matrix or dataset with upper bounds of intervals if argument \code{dataType} is uuqual to "separate_tables"}
\item{...}{arguments passed to smds I-scal implementation (function IMDS), like p, maxit, eps and others}
}
\details{
Parameter \code{normalizations} may be the subset of the following values: 

"n1","n2","n3","n3a","n4","n5","n5a","n6","n6a",

"n7","n8","n9","n9a","n10","n11","n12","n12a","n13" 

    (e.g. normalizations=c("n1","n2","n3","n5","n5a",

    "n8","n9","n9a","n11","n12a"))

if \code{normalizations} is set to "n0" no normalization is applied

Parameter \code{optMethods} may be the subset of the following values (IMDS): 

("MM","BFGS")
}
\value{
Data frame ordered by increasing value of Stress-1 fit measure with columns: 
\item{Normalization method}{normalization method used for p-th multidimensional scaling procedure}
\item{Opt method}{Optimization method used IMDS I-Scal implememtatiomn}
\item{Spline degree}{Additional spline.degree value if mspline model is used for simulation, for other models there is no value in this cell}
\item{I-STRESS}{value of I-Stress fit measure for p-th multidimensional scaling procedure}
\item{HHI spb}{Hirschman-Herfindahl HHI index calculated based on stress per boc for p-th multidimensional scaling procedure}
}
\author{
Marek Walesiak \email{marek.walesiak@ue.wroc.pl}, Andrzej Dudek \email{andrzej.dudek@ue.wroc.pl} 

Department of Econometrics and Computer Science, University of Economics, Wroclaw, Poland \url{http://keii.ue.wroc.pl/mdsOpt}
}
\references{
Borg I., Groenen P.J.F., (2005), Modern Multidimensional Scaling. Theory and Applications, 2nd Edition, Springer Science+Business Media, New York. ISBN: 978-0387-25150-9. Available at: \url{http://www.springeronline.com/0-387-25150-2}.

Borg, I., Groenen, P.J.F., Mair, P. (2013), Applied Multidimensional Scaling, Springer, Heidelberg, New York, Dordrecht, London. Available at: \url{http://dx.doi.org/10.1007/978-3-642-31848-1}.

Groenen, P.J.F. Winsberg, S., Rodriguez, O., Diday, E. (2006), I-Scal: Multidimensional scaling of interval dissimilarities, Computational Statistics & Data Analysis, 51(1), 360–378. Available at: \url{http://dx.doi.org/10.1016/j.csda.2006.04.003}.

Herfindahl, O.C. (1950), Concentration in the Steel Industry, Doctoral thesis, Columbia University.

Hirschman, A.O. (1964), The Paternity of an Index, The American Economic Review, Vol. 54, 761-762.

Walesiak, M. (2014), Przegląd formuł normalizacji wartości zmiennych oraz ich własności w statystycznej analizie wielowymiarowej [Data Normalization in Multivariate Data Analysis. An Overview and Properties], Przegląd Statystyczny, tom 61, z. 4, 363-372. Available at: \url{http://keii.ue.wroc.pl/pracownicy/mw/2014_Walesiak_Przeglad_Statystyczny_z_4.pdf}

Walesiak, M. (2016), Visualization of Linear Ordering Results for Metric Data with the Application of Multidimensional Scaling, Ekonometria, 2(52), 9-21. Available at: \url{http://dx.doi.org/10.15611/ekt.2016.2.01}.

Walesiak, M., Dudek, A. (2017), \emph{Selecting the Optimal Multidimensional Scaling Procedure for Metric Data with R Environment}, STATISTICS IN TRANSITION new series, September, Vol. 18, No. 3, pp. 521-540. Available at: \url{http://stat.gov.pl/en/sit-en/issues-and-articles-sit/}.
}
\seealso{\code{\link{data.Normalization}}, \code{\link{interval_normalization}}, \code{\link{IMDS}}
}
\examples{
#print("uncomment to run - approximately 7 seconds runtime")
#library(mdsOpt)
#library(clusterSim)
#data(data_symbolic_interval_polish_voivodships)
#x<-data_symbolic_interval_polish_voivodships
#metnor<-c("n1","n2","n3","n5","n5a","n8","n9","n9a","n11","n12a")
#methods<-c("MM","BFGS")
#res<-optIscalInterval(x,dataType="simple",normalizations=metnor,optMethods=methods)
#Istress<-as.numeric(gsub(",",".",res[,"I-STRESS"],fixed=TRUE))
#hhi<-as.numeric(gsub(",",".",res[,"HHI spb"],fixed=TRUE))
#t<-findOptimalIscalInterval(res)
#cs<-(min(Istress)+max(Istress))/2 # critical I-stress
#write.table(res,file="smds_HHI.csv",sep=";",dec=",",row.names=TRUE,col.names=NA)
#plot(Istress[-t$Nr],hhi[-t$Nr], xlab="I-Stress", ylab="HHI",type="n",font.lab=3)
#text(Istress[-t$Nr],hhi[-t$Nr],labels=(1:nrow(res))[-t$Nr])
#abline(v=cs,col="red")
#points(Istress[t$Nr],hhi[t$Nr], cex=5,col="red")
#text(Istress[t$Nr],hhi[t$Nr],labels=(1:nrow(res))[t$Nr],col="red")
#print(t)
}
\keyword{multidimensional scaling}
\keyword{I-stress}
\keyword{stress per box}
\keyword{normalization methods}
\keyword{interval-valued data}
\keyword{optimize}
