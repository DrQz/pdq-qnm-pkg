\name{Report}
\alias{Report}
\title{ Generate Formatted Report }
\description{
Report generates a formatted report that includes the total number of nodes and workloads created in the model, system level performance measures such as throughput and response time for each workload, and service node performance measures such as node utilization and queue lengths.  A comment field is available to audit input parameter variations across multiple runs of the same model.

}
\usage{
Report()
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

arrivRate    <- 0.75
service_time <- 1.0

Init("OpenCircuit")
CreateNode("server", CEN, FCFS)
CreateOpen("work", arrivRate)
SetDemand("server", "work", service_time)

Solve(CANON)
Report()
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
