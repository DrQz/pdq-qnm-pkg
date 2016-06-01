\name{GetResidenceTime}
\alias{GetResidenceTime}
\title{ Get the residence time spent at a particular node }
\description{
Determine the residence time at the designated service node by the specified workload.
}
\usage{
GetResidenceTime(device, work, class)
}
\arguments{
  \item{device}{ String containing the name of the queueing service node. }
  \item{work}{ String containing the name of the workload. }
  \item{class}{ TRANS, TERM, or BATCH type. }
}
\details{
The classes of workloads are:
\itemize{
\item{ TRANS }{ a workload that is defined by arrival rate, not think time; only valid for an open circuit }
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system; only valid for a closed circuit }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system; only valid for a closed circuit }
}
GetQueueLength should only be called after the PDQ model has been solved.
}
\value{
  Residence time as a numeric type.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
Init("GetResidenceTime Example")
CreateClosed("DB Users", TERM, 500.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT)
reztime <- GetResidenceTime("DB Server", "DB Users", TERM)
reztime
}
