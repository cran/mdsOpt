\name{findOptimalSmacofSym}
\alias{findOptimalSmacofSym}
\title{Selecting the optimal multidimensional scaling (MDS) procedure}
\description{Selecting the optimal multidimensional scaling procedure - metric MDS (by varying all combinations of normalization methods, distance measures, and metric MDS models)
and nonmetric MDS (by varying all combinations of normalization methods and distance measures)}
\usage{
findOptimalSmacofSym(table,
critical_stress=(max(as.numeric(gsub(",",".",table[,"STRESS 1"],fixed=T)))+
min(as.numeric(gsub(",",".",table[,"STRESS 1"],fixed=T))))/2)
}
\arguments{
\item{table}{
result from \code{\link{optSmacofSym_nMDS}} or \code{\link{optSmacofSym_mMDS}}. Data frame ordered by increasing value of Stress-1 fit measure with columns:

\code{Normalization method}

\code{Distance measure}

\code{MDS model}

\code{Spline degree} {(valid only for optSmacofSym_mMDS results)}

\code{STRESS 1}

\code{HHI spp}

}
\item{critical_stress}{threshold value of Kruskal's Stress-1 fit measure. Default - mid-range of Kruskal's Stress-1 fit measures calculated for all MDS procedures}
}
\value{
\item{Nr}{number of row in \code{table} with optimal multidimensional scaling procedure}
\item{Normalization_method}{normalization method used for optimal multidimensional scaling procedure}
\item{MDS_model}{MDS model used for optimal multidimensional scaling procedure}
\item{Spline_degree}{Additional spline.degree value for optimal procedure, if mspline model is used for simulation. For other models there is no value for this field}
\item{Distance_measure}{distance measure used for optimal multidimensional scaling procedure}
\item{STRESS_1}{value of Kruskal Stress-1 fit measure for optimal multidimensional scaling procedure}
\item{HHI_spp}{Hirschman-Herfindahl HHI index, calculated based on stress per point, for optimal multidimensional scaling procedure}
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
  metscale<-c("ratio","interval")
  metdist<-c("euclidean","manhattan","maximum","seuclidean","GDM1")
  data(data_lower_silesian)
  res<-optSmacofSym_mMDS(data_lower_silesian,normalizations=metnor,
  distances=metdist,mdsmodels=metscale)
  print(findOptimalSmacofSym(res))
}
\keyword{multidimensional scaling}
\keyword{nonmetric MDS}
\keyword{variable normalization methods}
\keyword{distance measures}
\keyword{metric data}
\keyword{optimize}
