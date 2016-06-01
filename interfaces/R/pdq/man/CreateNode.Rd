\name{CreateNode}
\alias{CreateNode}
\title{ Create a single-server queueing node }
\description{
Define a queueing service node for either a closed or open circuit model.  A node is characterized by the type of server and the queue disciplne.  A separate invocation is required to create each queueing node in the model.
}
\usage{
CreateNode(name, device, sched)
}
\arguments{
  \item{name}{ The string used to identify the node in reports and as an argument to other functions }
  \item{device}{ The type of server }
  \item{sched}{ The queue discipline }
}
\details{
The two types of servers are:
\itemize{
\item{CEN}{ Generic queueing center }
\item{DLY}{ Generic delay center: a delay without a queue }
}
The only valid type of queue discipline is:
\itemize{
\item{FCFS}{ or first-come first-served }
}
Solution methods:
\itemize{
\item{Single PDQ workstream}{ use the CANON solution method with Solve }
\item{Multiple PDQ workstreams}{ use the CANON solution method with Solve}
}
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\author{
Neil J. Gunther
}
\seealso{ 
  \code{\link{CreateMultiNode}, \link{Solve}}
}
\examples{
library(pdq)
Init("CreateNode Example")
CreateOpen("httpGet", 0.75)
CreateNode("cpu",  CEN, FCFS)
CreateNode("disk", CEN, FCFS)
SetDemand("cpu", "httpGet", 0.1)
SetDemand("disk", "httpGet", 1.0)
Solve(CANON)
Report()
}
\keyword{CEN}
\keyword{DLY}
\keyword{Open}
\keyword{Closed}
