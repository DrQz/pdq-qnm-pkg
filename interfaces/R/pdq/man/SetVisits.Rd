\name{SetVisits}
\alias{SetVisits}
\title{ Define the service demand in terms of visits }
\description{
An alternative to SetDemand where a workload is defined in terms of the explicit service time as well as a visit count.  The named node and workload must exist. A separate call is required for each workload stream that accesses the same node.  SetVisits is different from SetDemand in the way node-level performance metrics are formatted in the Report output. The number of visits shows up in the Report INPUTS section. The throughput in the RESOURCE Performance section shows up as counts per unit time.
}
\usage{
SetVisits(nodename, workname, visits, service)
}
\arguments{
  \item{nodename}{ The string name of the queueing node. }
  \item{workname}{ The string name of the workload. }
  \item{visits}{ Number of visits to that node. }
  \item{service}{ Service time the workload demands at that node (in time units). }
}
\seealso{ 
  \code{\link{SetDemand}}
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
Init("SetVisits Example")
CreateClosed("DB Users", TERM, 10.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetVisits("DB Server", "DB Users", 10.0, 0.13)
Solve(EXACT)
Report()
}
