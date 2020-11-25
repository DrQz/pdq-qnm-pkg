\name{GetResponse}
\alias{GetResponse}
\title{ Get the system response time  }
\description{
Determine the system response time for the specified workload. 
The response time is the sum of all the residence times spent each of the queueing nodes defined in the network.
}
\usage{
GetResponse(class, wname)
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
GetResponse should only be called after the PDQ model has been solved.
}
\value{
  System response time as a numeric type.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
Init("GetResponse Example")
CreateClosed("DB Users", TERM, 500.0, 30.5)
CreateNode("DB Server", CEN, FCFS)
SetDemand("DB Server", "DB Users", 1.0)
Solve(EXACT)
rt <- GetResponse(TERM, "DB Users")
rt
}
