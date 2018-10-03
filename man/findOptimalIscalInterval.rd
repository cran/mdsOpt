\name{findOptimalIscalInterval}
\alias{findOptimalIscalInterval}
\title{Selecting the optimal I-Scal multidimensional scaling procedure for interval-valued data}
\description{Selecting the optimal multidimensional scaling procedure - I-Scal (by varying all combinations of normalization and optimization methods)}
\usage{
findOptimalIscalInterval(table,critical_stress=
(max(as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=T)))+
min(as.numeric(gsub(",",".",table[,"I-STRESS"],fixed=T))))/2)}
\arguments{
\item{table}{
result from \code{\link{optSmacofSym_nMDS}}. Data frame ordered by increasing value of I-Stress fit measure with columns:

\code{Normalization method}

\code{Optimization method}

\code{I-STRESS}

\code{HHI spb}

}
\item{critical_stress}{threshold value of I-Stress fit measure. Default - mid-range of I-Stress fit measures calculated for all MDS procedures}
}
\value{
\item{Nr}{number of row in \code{table} with optimal multidimensional scaling procedure}
\item{Normalization_method}{normalization method used for optimal multidimensional scaling procedure}
\item{Opt_method}{optimization method in I-Scal procedure: "MM" - the majorization minimization algortihm,"BFGS" - Broyden–Fletcher–Goldfarb–Shanno algorithm}
\item{I_STRESS}{value I-Stress fit measure for optimal multidimensional scaling procedure}
\item{HHI_spb}{Herfindahl-Hirschman HHI index, calculated based on stress per box, for optimal multidimensional scaling procedure}
}
\author{
Marek Walesiak \email{marek.walesiak@ue.wroc.pl}, Andrzej Dudek \email{andrzej.dudek@ue.wroc.pl} 

Department of Econometrics and Computer Science, University of Economics, Wroclaw, Poland \url{http://keii.ue.wroc.pl/mdsOpt}
}
\references{
Borg, I., Groenen, P.J.F. (2005), Modern Multidimensional Scaling. Theory and Applications, 2nd Edition, Springer Science+Business Media, New York. ISBN: 978-0387-25150-9. Available at: \url{https://www.springer.com/la/book/9780387251509}.

Borg, I., Groenen, P.J.F., Mair, P. (2013), Applied Multidimensional Scaling, Springer, Heidelberg, New York, Dordrecht, London. Available at: \url{http://dx.doi.org/10.1007/978-3-642-31848-1}.

Groenen, P.J.F. Winsberg, S., Rodriguez, O., Diday, E. (2006), I-Scal: Multidimensional scaling of interval dissimilarities, Computational Statistics & Data Analysis, 51(1), 360–378. Available at: \url{http://dx.doi.org/10.1016/j.csda.2006.04.003}.

Herfindahl, O.C. (1950), Concentration in the Steel Industry, Doctoral thesis, Columbia University.

Hirschman, A.O. (1964), The Paternity of an Index, The American Economic Review, Vol. 54, 761-762.

Walesiak, M. (2014), Przegląd formuł normalizacji wartości zmiennych oraz ich własności w statystycznej analizie wielowymiarowej [Data Normalization in Multivariate Data Analysis. An Overview and Properties], Przegląd Statystyczny, tom 61, z. 4, 363-372. Available at: \url{http://keii.ue.wroc.pl/pracownicy/mw/2014_Walesiak_Przeglad_Statystyczny_z_4.pdf}

Walesiak, M. (2016), Visualization of Linear Ordering Results for Metric Data with the Application of Multidimensional Scaling, Ekonometria, 2(52), 9-21. Available at: \url{http://dx.doi.org/10.15611/ekt.2016.2.01}.

Walesiak, M., Dudek, A. (2017), \emph{Selecting the Optimal Multidimensional Scaling Procedure for Metric Data with R Environment}, STATISTICS IN TRANSITION new series, September, Vol. 18, No. 3, pp. 521-540. Available at: \url{http://dx.doi.org/10.21307/stattrans-2016-084}.
}
\seealso{\code{\link{data.Normalization}}, \code{\link{interval_normalization}}, \code{\link{IMDS}}
}
\examples{
print("uncomment to run - approximately a few seconds runtime")
#library(clusterSim)
#library(mdsOpt)
#data(data_symbolic_interval_polish_voivodships)
#x<-data_symbolic_interval_polish_voivodships
#metnor<-c("n1","n2","n3","n5","n5a","n8","n9","n9a","n11","n12a")
#methods<-c("MM","BFGS")
#w<-optIscalInterval(x,dataType="simple",normalizations=metnor,optMethods=methods,outDec=".")
#print(findOptimalIscalInterval(w))
}
\keyword{multidimensional scaling}
\keyword{I-stress}
\keyword{stress per box}
\keyword{normalization methods}
\keyword{interval-valued data}
\keyword{optimize}
