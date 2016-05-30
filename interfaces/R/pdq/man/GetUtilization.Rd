\name{GetUtilization}
\alias{GetUtilization}
\title{ Get the utilization of a node }
\description{
Determine the utilization of the designated service node by the specified workload.  It should only be called after the PDQ model has been solved.
}
\usage{
GetUtilization(device, work, class)
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
  Utilization as a decimal fraction in the range 0.0 to 1.0.
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library("pdq")
Init("server")
think <- 8 * 10^(-3)
CreateClosed("IO_Cmds", TERM, 100, think)
CreateNode("disk", CEN, FCFS)
SetDemand("disk","IO_Cmds",0.5)
Solve(EXACT);
ut <- GetUtilization("disk", "IO_Cmds", TERM)
}
