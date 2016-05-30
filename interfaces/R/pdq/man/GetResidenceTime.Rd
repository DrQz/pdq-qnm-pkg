\name{GetResidenceTime}
\alias{GetResidenceTime}
\title{ Get Residence Time at Node }
\description{
Determine the residence time at the designated service node by the specified workload.  It should only be called after the PDQ model has been solved.
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
\describe{
\item{ TRANS }{ a workload that is defined by arrival rate, not think time; only valid for an open circuit }
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system; only valid for a closed circuit }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system; only valid for a closed circuit }
}
}
\value{
  Residence time as a decimal number.
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library("pdq")
Init("Server")
think <- 8 * 10^(-3) # ms as seconds
CreateNode("disk", CEN, FCFS)
CreateClosed("IOs", TERM, 100, think)
SetDemand("disk","IOs",0.5)
Solve(APPROX)
reztime <- GetResidenceTime("disk", "IOs", TERM)
}
