\name{GetQueueLength}
\alias{GetQueueLength}
\title{ Get Length of Queue at Node }
\description{
Determine the queue length (number of requests waiting plus the number in service) of the designated service node by the specified workload.  It should only be called after the PDQ model has been solved.

}
\usage{
GetQueueLength(device, work, class)
}
\arguments{
  \item{device}{ String containing the name of the service node. }
  \item{work}{ String containing the name of the workload. }
  \item{class}{ Type of workload: TRANS, TERM, or BATCH}
}
\details{
The classes of workloads are:
\describe{
\item{ TRANS }{ a workload that is defined by arrival rate, not think time; only valid for an open circuit }
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system; only valid for a closed circuit }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system; only valid for a closed circuit }
}
}
\value{
  Queue length as a decimal number.
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
Solve(APPROX)
qlength = GetQueueLength("disk", "IOs", TERM)
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
