\name{GetResponse}
\alias{GetResponse}
\title{ Get Response Time for Workload }
\description{
Determine the system response time for the specified workload.
}
\usage{
GetResponse(class, wname)
}
\arguments{
  \item{class}{ TRANS, TERM, or BATCH type. }
  \item{wname}{ String containing the name of the workload. }
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
  System response time as a decimal number.
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
resptime = GetResponse(TRANS, "IOs")
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
