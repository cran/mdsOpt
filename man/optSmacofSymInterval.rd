\name{optSmacofSymInterval}
\alias{optSmacofSymInterval}
\title{Selecting the optimal multidimensional scaling procedure for symbolic interval-valued data}
\description{Selecting the optimal multidimensional scaling procedure by varying all combinations of normalization methods, distance measures for symbolic interval-valued data, and metric MDS models}
\usage{
optSmacofSymInterval(x,dataType="simple",normalizations=NULL,
distances=NULL,mdsmodels=NULL,spline.degrees=c(2),outputCsv="",outputCsv2="",y=NULL,...)
}
\arguments{
\item{x}{symbolic interval-valued data table or matrix or dataset}
\item{dataType}{Type of symbolic data table passed to function:

'sda' - full symbolicDA format object; 

'simple' - three dimensional array with lower and upper bound of intervals in third dimension;

'separate_tables' - lower bound of intervals in \code{x}, upper bound of intervals in  \code{y};

'rows' - lower and upper bound of intervals in neighbouring rows;

'columns' - lower and upper bound of intervals in neighbouring columns}
\item{normalizations}{optional, vector of normalization methods that should be used in procedure}
\item{distances}{optional, vector of distance measures (Hausdorf, Ichino-Yaguchi) that should be used in procedure}
\item{mdsmodels}{optional, vector of multidimensional models (ratio, interval, mspline) that should be used in procedure}
\item{spline.degrees}{optional, vector (e.g. 2:4) of spline.degree parameter values that should be used in procedure for mspline model}
\item{outputCsv}{optional, name of csv file with results}
\item{outputCsv2}{optional, name of csv (comma as decimal point sign) file with results}
\item{y}{matrix or dataset with upper bounds of intervals if argument \code{dataType} is uuqual to "separate_tables"}
\item{...}{arguments passed to smacofSym, like ndim, itmax, eps and others}
}
\details{
Parameter \code{normalizations} may be the subset of the following values: 

"n1","n2","n3","n3a","n4","n5","n5a","n6","n6a",

"n7","n8","n9","n9a","n10","n11","n12","n12a","n13" 

    (e.g. normalizations=c("n1","n2","n3","n5","n5a",

    "n8","n9","n9a","n11","n12a"))

if \code{normalizations} is set to "n0" no normalization is applied

Parameter \code{distances} may be the subset of the following values: 

"H_q1","H_q2","U_2_q1","U_2_q2" (In following order: Hausdorff distance with q=1, Euclidean Hausdorff distance with q=2, Ichino-Yaguchi distance with q=1; Euclidean Ichino-Yaguchi distance with q=2)

(e.g. distances=c("H_q1","U_2_q1"))

Parameter \code{mdsmodels} may be the subset of the following values (metric MDS): 

"ratio","interval","mspline" (e.g. c("ratio","interval"))
}
\value{
Data frame ordered by increasing value of Stress-1 fit measure with columns: 
\item{Normalization method}{normalization method used for p-th multidimensional scaling procedure}
\item{MDS model}{MDS model used for p-th multidimensional scaling procedure}
\item{Spline degree}{Additional spline.degree value if mspline model is used for simulation, for other models there is no value in this cell}
\item{Distance measure}{distance measures for symbolic interval-valued data used for p-th multidimensional scaling procedure}
\item{STRESS 1}{value of Kruskal Stress-1 fit measure for p-th multidimensional scaling procedure}
\item{HHI spp}{Hirschman-Herfindahl HHI index calculated based on stress per point for p-th multidimensional scaling procedure}
}
\author{
Marek Walesiak \email{marek.walesiak@ue.wroc.pl}, Andrzej Dudek \email{andrzej.dudek@ue.wroc.pl} 

Department of Econometrics and Computer Science, University of Economics, Wroclaw, Poland \url{http://keii.ue.wroc.pl/mdsOpt}
}
\references{
Borg, I., Groenen, P.J.F. (2005), Modern Multidimensional Scaling. Theory and Applications, 2nd Edition, Springer Science+Business Media, New York. ISBN: 978-0387-25150-9. Available at: \url{http://www.springeronline.com/0-387-25150-2}.

Borg, I., Groenen, P.J.F., Mair, P. (2013), Applied Multidimensional Scaling, Springer, Heidelberg, New York, Dordrecht, London. Available at: \url{http://dx.doi.org/10.1007/978-3-642-31848-1}.

De Leeuw, J., Mair, P. (2015), Shepard Diagram, Wiley StatsRef: Statistics Reference Online, John Wiley & Sons Ltd. Available at: \url{http://dx.doi.org/10.1002/9781118445112.stat06268.pub2}.

Herfindahl, O.C. (1950), Concentration in the Steel Industry, Doctoral thesis, Columbia University.

Hirschman, A.O. (1964), The Paternity of an Index, The American Economic Review, Vol. 54, 761-762.

Walesiak, M. (2014), Przegląd formuł normalizacji wartości zmiennych oraz ich własności w statystycznej analizie wielowymiarowej [Data Normalization in Multivariate Data Analysis. An Overview and Properties], Przegląd Statystyczny, tom 61, z. 4, 363-372. Available at: \url{http://keii.ue.wroc.pl/pracownicy/mw/2014_Walesiak_Przeglad_Statystyczny_z_4.pdf}

Walesiak, M., Dudek, A. (2017), \emph{Selecting the Optimal Multidimensional Scaling Procedure for Metric Data with R Environment}, „STATISTICS IN TRANSITION new series”, September, Vol. 18, No. 3, pp. 521-540. Available at: \url{http://stat.gov.pl/en/sit-en/issues-and-articles-sit/}.
}
\seealso{\code{\link{data.Normalization}}, \code{\link{interval_normalization}}, \code{\link{dist.Symbolic}}, \code{\link{smacofSym}}
}
\examples{
library(mdsOpt)
library(clusterSim)
data(data_symbolic_interval_polish_voivodships)
metnor<-c("n1","n2","n3","n5","n5a","n8","n9","n9a","n11","n12a")
metscale<-c("ratio","interval","mspline")
metdist<-c("H_q1","H_q2","U_2_q1","U_2_q2")
res<-optSmacofSymInterval(data_symbolic_interval_polish_voivodships,dataType="simple",
normalizations=metnor,distances=metdist,mdsmodels=metscale,spline.degrees=c(2,3))
stress<-as.numeric(gsub(",",".",res[,"STRESS 1"],fixed=TRUE))
hhi<-as.numeric(gsub(",",".",res[,"HHI spp"],fixed=TRUE))
t<-findOptimalSmacofSym(res)
cs<-(min(stress)+max(stress))/2 # critical stress
plot(stress[-t$Nr],hhi[-t$Nr], xlab="Stress-1", ylab="HHI",type="n",font.lab=3)
text(stress[-t$Nr],hhi[-t$Nr],labels=(1:nrow(res))[-t$Nr])
abline(v=cs,col="red")
points(stress[t$Nr],hhi[t$Nr], cex=5,col="red")
text(stress[t$Nr],hhi[t$Nr],labels=(1:nrow(res))[t$Nr],col="red")
print(t)
}
\keyword{multidimensional scaling}
\keyword{metric MDS}
\keyword{variable normalization methods}
\keyword{distance measures for interval-valued data}
\keyword{interval-valued data}
\keyword{optimize}
