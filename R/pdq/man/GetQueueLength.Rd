\name{GetQueueLength}
\alias{GetQueueLength}
\title{ Get the queue length at a particular node }
\description{
Determine the queue length (number of requests waiting plus the number in service) of the designated node servicing a specified workload.
}
\usage{
GetQueueLength(device, work, class)
}
\arguments{
  \item{device}{ String containing the name of the service node. }
  \item{work}{ String containing the name of the workload. }
  \item{class}{ Type of workload: TRANS, TERM, or BATCH}
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
  Queue length as a numeric type.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)

Init("GetQueueLength Example")
CreateClosed("DB Users", TERM, 500.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT)

qsize <- GetQueueLength("DB Server", "DB Users", TERM)
qsize
}
