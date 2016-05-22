\name{SetVisits}
\alias{SetVisits}
\title{ Define Workload Service Demand in Terms of Visits }
\description{
Define the service demand of a specific workload in terms of the explicit service time and visit count.  The named node and workload must exist. A separate call is required for each workload stream that accesses the same node.  SetVisits is different from SetDemand in the way node-level performance metrics are formatted in the Report output. The number of visits shows up in the Report INPUTS section. The throughput in the RESOURCE Performance section shows up as counts per unit time.
}
\usage{
SetVisits(nodename, workname, visits, service)
}
\arguments{
  \item{nodename}{ The string name of the queueing node. }
  \item{workname}{ The string name of the workload. }
  \item{visits}{ Number of visits to that node. }
  \item{service}{ Service time the workload requires at that node (in timebase units). }
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library(pdq)
Init("ClosedCircuit")
CreateClosed("DB_Workers", TERM, 57.4, 31.6)
CreateNode("cpu", CEN, FCFS)
SetVisits("cpu", "DB_Workers", 10.0, 0.013)
}
