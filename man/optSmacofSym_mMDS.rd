\name{optSmacofSym_mMDS}
\alias{optSmacofSym_mMDS}
\title{Selecting the optimal multidimensional scaling procedure - metric MDS}
\description{Selecting the optimal multidimensional scaling procedure by varying all combinations of normalization methods, distance measures, and metric MDS models}
\usage{
optSmacofSym_mMDS(x,normalizations=NULL,distances=NULL,
mdsmodels=NULL,weights=NULL,spline.degrees=c(2),
outputCsv="",outputCsv2="",...)
}
\arguments{
\item{x}{matrix or dataset}
\item{normalizations}{optional, vector of normalization methods that should be used in procedure}
\item{distances}{optional, vector of distance measures (manhattan, Euclidean, Chebyshew, squared Euclidean, GDM1) that should be used in procedure}
\item{mdsmodels}{optional, vector of multidimensional models (ratio, interval, mspline) that should be used in procedure}
\item{spline.degrees}{optional, vector (e.g. 2:4) of spline.degree parameter values that should be used in procedure for mspline model}
\item{weights}{optional, variable weights used in distance calculation. Each weight takes value from interval [0; 1] and sum of weights equals one}
\item{outputCsv}{optional, name of csv file with results}
\item{outputCsv2}{optional, name of csv (comma as decimal point sign) file with results}
\item{...}{arguments passed to smacofSym, like ndim, itmax, eps and others}
}
\details{
Parameter \code{normalizations} may be the subset of the following values: 

"n1","n2","n3","n3a","n4","n5","n5a","n6","n6a",

"n7","n8","n9","n9a","n10","n11","n12","n12a","n13" 

    (e.g. normalizations=c("n1","n2","n3","n5","n5a",

    "n8","n9","n9a","n11","n12a"))

Parameter \code{distances} may be the subset of the following values: 

"euclidean","manhattan","maximum","seuclidean","GDM1" 

(e.g. distances=c("euclidean","manhattan"))

Parameter \code{mdsmodels} may be the subset of the following values (metric MDS): 

"ratio","interval","mspline" (e.g. c("ratio","interval"))
}
\value{
Data frame ordered by increasing value of Stress-1 fit measure with columns: 
\item{Normalization method}{normalization method used for p-th multidimensional scaling procedure}
\item{MDS model}{MDS model used for p-th multidimensional scaling procedure}
\item{Spline degree}{Additional spline.degree value if mspline model is used for simulation, for other models there is no value in this cell}
\item{Distance measure}{distance measure used for p-th multidimensional scaling procedure}
\item{STRESS 1}{value of Kruskal Stress-1 fit measure for p-th multidimensional scaling procedure}
\item{HHI spp}{Hirschman-Herfindahl HHI index calculated based on stress per point for p-th multidimensional scaling procedure}
}
\author{
Marek Walesiak \email{marek.walesiak@ue.wroc.pl}, Andrzej Dudek \email{andrzej.dudek@ue.wroc.pl} 

Department of Econometrics and Computer Science, University of Economics, Wroclaw, Poland \url{http://keii.ue.wroc.pl/clusterSim}
}
\references{
BORG I., GROENEN P.J.F., (2005), Modern Multidimensional Scaling. Theory and Applications, 2nd Edition, Springer Science+Business Media, New York.

BORG I., GROENEN P.J.F., MAIR P., (2013), Applied Multidimensional Scaling, Springer, Heidelberg, New York, Dordrecht, London.

DE LEEUW J., MAIR P., (2015), Shepard Diagram, Wiley StatsRef: Statistics Reference Online, John Wiley & Sons Ltd.

HERFINDAHL O.C., (1950), Concentration in the Steel Industry, Doctoral thesis, Columbia University.

HIRSCHMAN A.O., (1964). The Paternity of an Index, The American Economic Review, Vol. 54, 761-762.

WALESIAK M., (2014), Przegląd formuł normalizacji wartości zmiennych oraz ich własności w statystycznej analizie wielowymiarowej [Data Normalization in Multivariate Data Analysis. An Overview and Properties], Przegląd Statystyczny, tom 61, z. 4, 363-372.

WALESIAK M., (2016a), Wybór grup metod normalizacji wartości zmiennych w skalowaniu wielowymiarowym [The Choice of Groups of Variable Normalization Methods in Multidimensional Scaling], Przegląd Statystyczny, tom 63, z. 1, 7-18.

WALESIAK M., (2016b), Visualization of Linear Ordering Results for Metric Data with the Application of Multidimensional Scaling, Ekonometria, 2(52), 9-21.

WALESIAK M., DUDEK A., (2016), Selecting the optimal multidimensional scaling procedure for metric data with R environment, Statistics in Transition - new series (in review).
}
\seealso{\code{\link{data.Normalization}}, \code{\link{dist.GDM}}, \code{\link{dist}}, \code{\link{smacofSym}}
}
\examples{
  library(mdsOpt)
  metnor<-c("n1","n2","n3","n5","n5a","n8","n9","n9a","n11","n12a")
  metscale<-c("ratio","interval","mspline")
  metdist<-c("euclidean","manhattan","seuclidean","maximum","GDM1")
  data(data_lower_silesian)
  res<-optSmacofSym_mMDS(data_lower_silesian,,normalizations=metnor,distances=metdist,
    mdsmodels=metscale, spline.degrees=c(2:3))
  stress<-as.numeric(gsub(",",".",res[,"STRESS 1"],fixed=TRUE))
  hhi<-as.numeric(gsub(",",".",res[,"HHI spp"],fixed=TRUE))
  cs<-(min(stress)+max(stress))/2 # critical stress
  t<-findOptimalSmacofSym(res,critical_stress=cs)
  print(t)
  plot(stress[-t$Nr],hhi[-t$Nr], xlab="Stress-1", ylab="HHI",type="n",font.lab=3)
  text(stress[-t$Nr],hhi[-t$Nr],labels=(1:nrow(res))[-t$Nr])
  abline(v=cs,col="red")
  points(stress[t$Nr],hhi[t$Nr], cex=5,col="red")
  text(stress[t$Nr],hhi[t$Nr],labels=(1:nrow(res))[t$Nr],col="red")
}
\keyword{multidimensional scaling}
\keyword{metric MDS}
\keyword{variable normalization methods}
\keyword{distance measures}
\keyword{metric data}
\keyword{optimize}
