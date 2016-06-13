\name{GetNodesCount}
\alias{GetNodesCount}
\title{ Get the number of nodes  }
\description{
Determine the number of queueing nodes that have been assigned in the PDQ model.
}
\usage{
GetNodesCount()
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
\donttest{
library(pdq)
Init("GetNodesCount Example") 
CreateClosed("work", TERM, 100, 10) 
for (k in 1:4) {
    nname <- paste("node", k, sep="")
    CreateNode(nname, CEN, FCFS)
    SetDemand(nname, "work", 500)
}
if(GetNodesCount() > 3) { 
   stop("This model has too many nodes!") 
} else {
   Solve(EXACT)
   Report()
}
}

}
