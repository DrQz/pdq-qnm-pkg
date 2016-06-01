\name{GetLoadOpt}
\alias{GetLoadOpt}
\title{ Get the optimal user load }
\description{
Returns the calculated optimal user load for a specified workload in a closed queueing circuit.
}
\usage{
GetLoadOpt(class, wname)
}
\arguments{
  \item{class}{ Type of workload: BATCH or TERM }
  \item{wname}{ Character string containing the name of the workload }
}
\details{
The two types of closed-circuit workloads are:
\itemize{
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system }
}
GetLoadOpt should only be called after the PDQ model has been solved.
}
\value{
  Optimal user load as a numeric type
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)

Init("GetLoadOpt Example")
CreateClosed("DB Users", TERM, 500.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT)

nopt <- GetLoadOpt(TERM, "DB Users")
nopt
}
