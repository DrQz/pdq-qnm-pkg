\name{CreateMultiNode}
\alias{CreateMultiNode}
\title{ Create a queueing node with multiple servers  }
\description{
Define a multi-server queueing node for either an open or closed queueing network.  
A multi-server node consists of a single waiting line feeding into more than one server, e.g., 
M/M/m, and is characterized by the number of servers, the device type, and the service schedule.  
The device type can be either MSC for a closed network or MSO for an open network.
A separate function call is required to instantiate each queueing node.
}
\usage{
CreateMultiNode(servers, name, device, sched)
}
\arguments{
  \item{servers}{ The number of servers (usually an integral value) }
  \item{name}{ The character string used to identify the node name in a PDQ report and as an argument to other PDQ functions }
  \item{device}{ The type of multi-server queueing facility: MSO or MSC }
  \item{sched}{ The service schedule }
}
\details{
There are two possible types of multi-server:
\itemize{
\item{MSO}{ multi-server queueing center in an OPEN network }
\item{MSC}{ multi-server queueing center in an CLOSED network  }
}
The only valid type of service schedule is:
\itemize{
\item{FCFS}{ or first-come first-served }
}
Solution methods:
\itemize{
\item{Single OPEN work stream}{ use the CANON or STREAMING solution method with Solve }
\item{Single CLOSED work stream}{ use the EXACT solution method with Solve }
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
\keyword{ Closed }
\keyword{ Queue }
\keyword{ MSO }
\keyword{ MSC }
\keyword{ FCFS }
