\name{GetLoadOpt}
\alias{GetLoadOpt}
\title{ Get Optimal User Load }
\description{
Get the optimal user load for a specified workload in a closed circuit.
}
\usage{
GetLoadOpt(class, wname)
}
\arguments{
  \item{class}{ Type of workload: BATCH or TERM. }
  \item{wname}{ String containing the name of the workload. }
}
\details{
The two types of closed-circuit workloads are:
\describe{
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system }
}
}
\value{
  Optimal user load as a decimal number.
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\note{
}
\seealso{ }
\examples{
library("pdq")
clients <- 200
think <- 8 * 10^(-3) # ms as seconds
Init("")
CreateClosed("work", TERM, clients, think)
nopt <- GetLoadOpt(TERM, "work")
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
