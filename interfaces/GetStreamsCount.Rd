\name{GetStreamsCount}
\alias{GetStreamsCount}
\title{ Get the number of streams  }
\description{
Determine the number of workload streams that have been assigned in the PDQ model.
}
\usage{
GetStreamsCount()
}
}
\value{
  Integer value of numeric type.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)

Init("GetNodesCount Example") 
CreateNode("node", CEN, FCFS) 
for (strm in 1:4) {
    wname <- paste("work", strm, sep="")
    CreateClosed(wname, TERM, 10, 30)
    SetDemand("node", wname, strm)
}

if(GetStreamsCount() > 3) { 
   stop("This model has too much work to do!") 
} else {
   Solve(APPROX)
   Report()
}


