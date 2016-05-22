\name{SetWUnit}
\alias{SetWUnit}
\title{ Change Name of Work Unit }
\description{
Change the name of the work unit that appears in the PDQ report. The default work unit is Job.
}
\usage{
SetWUnit(unitName)
}
\arguments{
  \item{unitName}{ ~~Describe \code{unitName} here~~ }
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library(pdq)
Init("OpenCircuit")
CreateOpen("SAN_controller", 200)
SetWUnit("I/O_Reqs")
}
