\name{GetUtilization}
\alias{GetUtilization}
\title{ Get the utilization of a service node }
\description{
Determine the utilization of the designated service node by the specified workload.  It should only be called after the PDQ model has been solved.
}
\usage{
GetUtilization(device, work, class)
}
\arguments{
  \item{device}{ String containing the name of the service node. }
  \item{work}{ String containing the name of the workload. }
  \item{class}{ TRANS, TERM, or BATCH type. }
}
\details{
The classes of workloads are:
\describe{
\item{ TRANS }{ a workload that is defined by arrival rate, not think time; only valid for an open circuit }
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system; only valid for a closed circuit }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system; only valid for a closed circuit }
}
}
\value{
  Utilization as a decimal fraction in the range 0.0 to 1.0 (i.e. 100\%).
}
\author{
Neil Gunther
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library(pdq)
Init("GetUtilization Example")
CreateClosed("DB Users", TERM, 10.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT);
ut <- GetUtilization("DB Server", "DB Users", TERM)
ut
}
