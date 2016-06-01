\name{GetThruput}
\alias{GetThruput}
\title{ Get the system throughput }
\description{
Determine the system throughput for the specified workload.
}
\usage{
GetThruput(class, wname)
}
\arguments{
  \item{class}{ TRANS, TERM, or BATCH type. }
  \item{wname}{ Character string containing the name of the workload. }
}
\details{
The classes of workloads are:
\itemize{
\item{ TRANS }{ a workload that is defined by arrival rate, not think time; only valid for an open circuit }
\item{ TERM }{ a workload with non-zero think time: there will be \code{think} delay before requests re-enter the system; only valid for a closed circuit }
\item{ BATCH }{ a workload with no think time: requests immediately re-enter the system; only valid for a closed circuit }
}
}
\value{
  System throughput as a decimal number.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
Init("GetThruput Example")
CreateClosed("DB Users", TERM, 500.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT)
tp <- GetThruput(TRANS, "DB Users")
tp
}
