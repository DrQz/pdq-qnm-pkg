\name{CreateNode}
\alias{CreateNode}
\title{ Define Node }
\description{
Define a queueing service node for either a closed or open circuit model.  A node is characterized by the type of server and the queue disciplne.  A separate call is required for each queueing node.
}
\usage{
CreateNode(name, device, sched)
}
\arguments{
  \item{name}{ The string used to identify the node in reports and as an argument to other functions }
  \item{device}{ The type of server: CEN or DLY }
  \item{sched}{ The queue discipline: FCFS, ISRV, LCFS, or PSHR }
}
\details{
The two types of servers are:
\describe{
\item{CEN}{ Generic queueing center }
\item{DLY}{ Generic delay center: a delay without a queue }
}
The types of queue discipline are:
\itemize{
\item{FCFS}{ First-come first-served }
\item{ISRV}{ Infinite server; used to represent a delay }
\item{LCFS}{ Last-come first-served }
\item{PSHR}{ Processor sharing }
}
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\author{
Neil Gunther <njgunther@perfdynamics.com, with
}
\note{
}
\seealso{ }
\examples{
library("pdq")
Init("Server")
CreateNode("cpu",  CEN, FCFS)
CreateNode("bus",  CEN, FCFS)
CreateNode("disk", CEN, FCFS)
}
\keyword{CEN}
\keyword{DLY}
\keyword{FCFS}
\keyword{ISRV}
\keyword{LCFS}
\keyword{PSHR}
