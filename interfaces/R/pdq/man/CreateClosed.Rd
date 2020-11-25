\name{CreateClosed}
\alias{CreateClosed}
\title{ Create a source of work for a closed queueing network }
\description{
Define the workload for a closed queueing network. A closed circuit has a fixed population of customers: no new customers enter the system and none exit. The workload is characterized by the number of customers and the amount of time between requests (the "think time"). Separate calls are required for workload streams having different characteristics.
}
\usage{
CreateClosed(name, class, pop, think)
}
\arguments{
  \item{name}{ A character string used to identify the workload by name in a PDQ Report and as an argument to other PDQ functions }
  \item{class}{ The type of PDQ workload: TERM or BATCH }
  \item{pop}{ The customer "population" or total number of requests in the closed circuit. Since pop can be a statistical average arising from measurements, it is a numeric type. Often used to represent users in a time-share computer system or load generators in a load-test system. }
  \item{think}{ The user or generator delay known as the "think time" that occurs between the completion of the previous request and the start of the next request in a TERM workload. Set to zero for a BATCH workload. Numeric type. }
}
\details{
CreateClosed should be invoked before defining any queueing nodes. 

There are two types of closed-circuit workloads:
\describe{
\item{ TERM }{ A workload with non-zero think time that causes a \code{think} delay to occur before a new request enters the closed system }
\item{ BATCH }{ A workload without any think time. Requests immediately re-enter the closed system }
}
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\seealso{ 
  \code{\link{CreateOpen}}, \code{\link{CreateMultiNode}}
}
\examples{
library(pdq)
Init("CreateClosed Example")
CreateClosed("DB Users", TERM, 500.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT)
Report()
}
\keyword{ Closed }
\keyword{ Queue }
\keyword{ TERM }
\keyword{ BATCH } % __ONLY ONE__ keyword per line
