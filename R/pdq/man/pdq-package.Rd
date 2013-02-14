\name{pdq-package}
\alias{pdq-package}
\alias{pdq}
\docType{package}
\title{PDQ (Pretty Damn Quick) Queueing Network Analyzer}
\description{
The PDQ performance analyzer uses queueing-theory concepts to represent computer systems and analyze their performance characteristics.  It is a queueing model solver, not a simulator. PDQ models consist of workloads or PDQ streams and queueing faciities or PDQ nodes.  Workloads are characterized by whether they are part of an open or closed network (i.e., whether or not new customers enter and leave the system) and by their volume (arrival rate for open networks or number and think time for closed networks).  PDQ nodes are the places in the network where requests are serviced and where queues can form. Nodes are characterized by their queue discipline, e.g., FIFO or LIFO, the number of servers available, and the average service time or inverse service rate.
}
\details{
\tabular{ll}{
Package: \tab pdq\cr
Version: \tab \Sexpr[stage=render]{packageVersion("pdq")}\cr
Date: \tab \Sexpr[stage=render]{packageDescription("pdq")$Date}\cr
License: \tab MIT\cr
URL: \tab http://www.perfdynamics.com/Tools/PDQ.html\cr
\tab http://sourceforge.net/projects/pdq-qnm-pkg/\cr
Built: \tab \Sexpr[stage=render]{packageDescription("pdq")$Built}\cr
}
}


\author{
Neil Gunther <njgunther@perfdynamics.com, with
contributions from Phil Feller <phil@philfeller.com>, Paul Puglia <pjpuglia@earthlink.net> and Denny Chen <metasoft@yahoo.com>.

Maintainer: Paul Puglia <pjpuglia@earthlink.net>
}
\references{
Gunther, N. J. (2000) \emph{The Practical Performance Analyst }. Lincoln, Nebraska: iUniverse Press.

Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ (2nd edn.)}. Berlin, Heidelberg: Springer.
}
\keyword{ package }
\seealso{
}
\examples{
library(pdq)
# Model globals
arrivalRate <- 0.75
serviceRate <- 1.0
## Build and solve the PDQ model
Init("M/M/1 queue")                # initialize PDQ
CreateOpen("Work", arrivalRate)    # open network
CreateNode("Server", CEN, FCFS)    # single server in FIFO order
SetDemand("Server", "Work", 1/serviceRate)
Solve(CANON)    # Solve the model
Report() # generic format
}
