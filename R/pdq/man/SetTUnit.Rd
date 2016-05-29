\name{SetTUnit}
\alias{SetTUnit}
\title{ Change time unit }
\description{
Change the time unit label that appears in PDQ Report.  The default time unit is seconds.
}
\usage{
SetTUnit(unitName)
}
\arguments{
  \item{unitName}{ Character string containing the name of the time unit as it will appear in  the Report output. }
}
\details{
Cannot be invoked prior to calling CreateOpen or CreateClosed.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
Init("SetTUnit Example")
CreateOpen("Customers", 0.75)
CreateMultiNode(3, "Bank Tellers", CEN, FCFS)
SetDemand("Bank Tellers", "Customers", 1.0)
SetTUnit("Minutes")
Solve(CANON)
Report()
}
