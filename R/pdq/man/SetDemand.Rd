\name{SetDemand}
\alias{SetDemand}
\title{ Define Workload Service Demand }
\description{
Define the service demand of a specific workload.  The named node and workload must have been defined previously.  A separate call is required for each workload stream that accesses the same node.
}
\usage{
SetDemand(nodename, workname, time)
}
\arguments{
  \item{nodename}{ The string name of the queueing node. }
  \item{workname}{ The string name of the workload. }
  \item{time}{ Service demand (in units of time) required by the workload at
that node. }
}
\details{
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
library(pdq)
Init("ClosedCircuit")
CreateClosed("DB_Workers", TERM, 57.4, 31.6);
CreateClosed("Fax_Report", BATCH, 10.0, 240);
   
CreateNode("cpu", CEN, FCFS);

SetDemand("cpu", "DB_Workers", 0.130);
SetDemand("cpu", "Fax_Report", 3.122);
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
