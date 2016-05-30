\name{SetTUnit}
\alias{SetTUnit}
\title{ Change Name of Time Unit }
\description{
Change the name of the time unit that appears in the PDQ report.  The default time unit is Seconds.
}
\usage{
SetTUnit(unitName)
}
\arguments{
  \item{unitName}{ String with the name of the time unit to appear on the report. }
}
\details{
Cannot be invoked prior to calling CreateOpen or CreateClosed.
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library(pdq)
Init("PDQ Model")
CreateOpen("work", 0.75)
SetTUnit("Minutes")
}
