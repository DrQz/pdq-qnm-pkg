\name{SetWUnit}
\alias{SetWUnit}
\title{ Change work unit }
\description{
Change the work unit label that appears in PDQ Report.
}
\usage{
SetWUnit(unitName)
}
\arguments{
  \item{unitName}{ Character string containing the name of the work unit as it will appear in  the Report output. }
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
library(pdq)
Init("SetWUnit Example")
CreateOpen("Customers", 0.75)
CreateMultiNode(3, "Bank Tellers", CEN, FCFS)
SetDemand("Bank Tellers", "Customers", 1.0)
SetWUnit("Cheques")
Solve(CANON)
Report()
}
