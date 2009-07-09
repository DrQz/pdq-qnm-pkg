\name{CreateClosed}
\alias{CreateClosed}
\title{ Define Workload for Closed Queuing Circuit }
\description{
Define the workload for a closed queueing circuit. A closed circuit has a fixed population of customers: no new customers enter the system and none exit. The workload is characterized by the number of customers and the amount of time between requests (the "think time"). Separate calls are required for workload streams having different characteristics.
}
\usage{
CreateClosed(name, class, pop, think)
}
\arguments{
  \item{name}{ The string used to identify the workload in reports and as an argument to other functions }
  \item{class}{ The type of workload: either TERM or BATCH }
  \item{pop}{ The number of active user processes in the closed circuit. This argument is a float to accommodate  measured activity e.g., 57.4 average active users. }
  \item{think}{ The user delay or "think time" before a request re-enters the queueing system; not needed for a BATCH workload. }
}
\details{
The two types of closed-circuit workloads are:
\describe{
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system }
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
CreateClosed("DB_workers", TERM, 57.4, 31.6)
CreateClosed("fax_tasks", BATCH, 10.0)
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
