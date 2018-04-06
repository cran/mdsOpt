\name{optSmacofSym_nMDS}
\alias{optSmacofSym_nMDS}
\title{Selecting the optimal multidimensional scaling procedure - nonmetric MDS}
\description{Selecting the optimal multidimensional scaling procedure by varying all combinations of normalization methods and distance measures}
\usage{
optSmacofSym_nMDS(x,normalizations=NULL,distances=NULL,
mdsmodels=c("ordinal"),weights=NULL,
outputCsv="",outputCsv2="",...)
}
\arguments{
\item{x}{matrix or dataset}
\item{normalizations}{optional, vector of normalization methods that should be used in procedure}
\item{distances}{optional, vector of distance measures (manhattan, Euclidean, Chebyshew, squared Euclidean, GDM1) that should be used in procedure}
\item{mdsmodels}{"ordinal" (nonmetric MDS)}
\item{weights}{optional, variable weights used in distance calculation. Each weight takes value from interval [0; 1] and sum of weights equals one}
\item{outputCsv}{optional, name of csv file with results}
\item{outputCsv2}{optional, name of csv (comma as decimal point sign) file with results}
\item{...}{arguments passed to smacofSym}
}
\details{
Parameter \code{normalizations} may be the subset of the following values: 

"n1","n2","n3","n3a","n4","n5","n5a","n6","n6a",

"n7","n8","n9","n9a","n10","n11","n12","n12a","n13" 

    (e.g. normalizations=c("n1","n2","n3","n5","n5a",

    "n8","n9","n9a","n11","n12a"))

if \code{normalizations} is set to "n0" no normalization is applied

Parameter \code{distances} may be the subset of the following values: 

"euclidean", "manhattan","maximum","seuclidean","GDM1" 

(e.g. distances=c("euclidean","manhattan"))

Parameter \code{mdsmodels} "ordinal" MDS model (nonmetric MDS)
}
\value{
Data frame ordered by increasing value of Stress-1 fit measure with columns: 
\item{Normalization method}{normalization method used for p-th multidimensional scaling procedure}
\item{MDS model}{"ordinal" MDS model (nonmetric MDS) for p-th multidimensional scaling procedure}
\item{Distance measure}{distance measure used for p-th multidimensional scaling procedure}
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

Walesiak, M. (2016a), Wybór grup metod normalizacji wartości zmiennych w skalowaniu wielowymiarowym [The Choice of Groups of Variable Normalization Methods in Multidimensional Scaling], Przegląd Statystyczny, tom 63, z. 1, 7-18. Available at: \url{http://keii.ue.wroc.pl/pracownicy/mw/2016_Walesiak_Przeglad_Statystyczny_z_1.pdf}

Walesiak, M. (2016b), Visualization of Linear Ordering Results for Metric Data with the Application of Multidimensional Scaling, Ekonometria, 2(52), 9-21. Available at: \url{http://dx.doi.org/10.15611/ekt.2016.2.01}.

Walesiak, M., Dudek, A. (2017), \emph{Selecting the Optimal Multidimensional Scaling Procedure for Metric Data with R Environment}, STATISTICS IN TRANSITION new series, September, Vol. 18, No. 3, pp. 521-540. Available at: \url{http://stat.gov.pl/en/sit-en/issues-and-articles-sit/}.
}
\seealso{\code{\link{data.Normalization}}, \code{\link{dist.GDM}}, \code{\link{dist}}, \code{\link{smacofSym}}
}
\examples{
print("uncomment to run - approximately 30 seconds runtime")
# uncomment to run - approximately 30 seconds runtime#  library(mdsOpt)
#  metnor<-c("n1","n2","n3","n5","n5a","n8","n9","n9a","n11","n12a")
#  metscale<-"ordinal"
#  metdist<-c("euclidean","manhattan","maximum","seuclidean","GDM1")
#  data(data_lower_silesian)
#  res<-optSmacofSym_nMDS(data_lower_silesian,normalizations=metnor,
#    distances=metdist,mdsmodels=metscale)
#  stress<-as.numeric(gsub(",",".",res[,"STRESS 1"],fixed=TRUE))
#  hhi<-as.numeric(gsub(",",".",res[,"HHI spp"],fixed=TRUE))
#  cs<-(min(stress)+max(stress))/2 # critical stress
#  t<-findOptimalSmacofSym(res,critical_stress=cs)
#  print(t)
#  plot(stress[-t$Nr],hhi[-t$Nr], xlab="Stress-1", ylab="HHI",type="n",font.lab=3)
#  text(stress[-t$Nr],hhi[-t$Nr],labels=(1:nrow(res))[-t$Nr])
#  abline(v=cs,col="red")
#  points(stress[t$Nr],hhi[t$Nr], cex=5,col="red")
#  text(stress[t$Nr],hhi[t$Nr],labels=(1:nrow(res))[t$Nr],col="red")
}
\keyword{multidimensional scaling}
\keyword{nonmetric MDS}
\keyword{variable normalization methods}
\keyword{distance measures}
\keyword{metric data}
\keyword{optimize}
