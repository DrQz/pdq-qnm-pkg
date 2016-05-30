\name{CreateMultiNode}
\alias{CreateMultiNode}
\title{ Define Multi-server Node }
\description{
Define a multi-server queueing service node for either a closed or open circuit model.  A multi-server node consists of a single queue feeding into more than one server, and is characterized by the number of servers, their type, and the queue disciplne.  A separate call is required for each queueing node.
}
\usage{
CreateMultiNode(servers, name, device, sched)
}
\arguments{
  \item{servers}{ The integer number of servers }
  \item{name}{ The string used to identify the node in reports and as an argument to other functions }
  \item{device}{ The type of server: CEN or DLY }
  \item{sched}{ The queue discipline: MSQ }
}
\details{
The two types of servers are:
\itemize{
\item{CEN}{ Generic queueing center }
\item{DLY}{ Generic delay center: a delay without a queue }
}
The only valid type of queue discipline is:
\itemize{
\item{MSQ}{ Multi-server queue }
}
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\author{
Neil Gunther <njgunther@perfdynamics.com, with
}
\examples{
library("pdq")
Init("Airport")
CreateMultiNode(3, "Tickets", CEN, MSQ)
}
\keyword{ CEN }
\keyword{ DLY }
\keyword{ MSQ }
