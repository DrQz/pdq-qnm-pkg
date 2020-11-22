\name{CreateMultiNode}
\alias{CreateMultiNode}
\title{ Create a multiple server queueing node }
\description{
Define a multi-server queueing service node for either a closed or open circuit model.  A multi-server node consists of a single queue feeding into more than one server, and is characterized by the number of servers, their type, and the queue disciplne.  A separate call is required for each queueing node.
}
\usage{
CreateMultiNode(servers, name, device, sched)
}
\arguments{
  \item{servers}{ The number of servers (treated as an integer) }
  \item{name}{ The character string used to identify the node name in a PDQ report and as an argument to other PDQ functions }
  \item{device}{ The type of queueing facility }
  \item{sched}{ The queueing discipline }
}
\details{
There are possibe  types of servers:
\itemize{
\item{CEN}{ or generic queueing center }
\item{DLY}{ or  delay center, i.e.,  no waiting line (not applicable for CreateMultiNode) }
}
The only valid type of queue discipline is:
\itemize{
\item{FCFS}{ or first-come first-served }
}
Solution methods:
\itemize{
\item{Single PDQ workstream}{ use the CANON or STREAMING solution method with Solve }
\item{Multiple PDQ workstreams}{ use the APPROXMSO solution method with Solve}
}
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\author{
Neil J. Gunther
}
\seealso{ 
  \code{\link{CreateNode}, \link{Solve}}
}
\examples{
library(pdq)
Init("Banking Example")
CreateOpen("Customers", 0.75)
CreateMultiNode(3, "Tellers", MSO, FCFS)
SetDemand("Tellers", "Customers", 1.0)
Solve(STREAMING)
Report()
}
\keyword{ Open }
\keyword{ Queue }
\keyword{ CEN }
\keyword{ DLY }
\keyword{ MSQ }
