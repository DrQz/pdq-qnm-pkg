\name{SetDemand}
\alias{SetDemand}
\title{ Assign a service demand to a workload  }
\description{
Define the service demand (or service time) for a workload serviced by a given node.  The named node and workload must have been defined previously.  A separate call is required for each workload stream that accesses the same node.
}
\usage{
SetDemand(nodename, workname, time)
}
\arguments{
  \item{nodename}{ Character string to name the queueing node. }
  \item{workname}{ Character string to name the workload. }
  \item{time}{ Service demand (in the appropriate time units) required by the workload at
that node. }
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
Init("SetDemand Example")
CreateClosed("processA", TERM, 57.4, 31.6)
CreateClosed("processB", BATCH, 10, 0)
CreateNode("CPU", CEN, FCFS)
SetDemand("CPU", "processA", 0.130)
SetDemand("CPU", "processB", 3.122)
Solve(EXACT)
Report()
}
