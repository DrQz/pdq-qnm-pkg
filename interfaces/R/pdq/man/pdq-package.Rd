\name{pdq-package}
\alias{pdq-package}
\alias{pdq}
\docType{package}
\title{PDQ (Pretty Damn Quick) Queueing Network Analyzer}
\description{
The PDQ performance analyzer uses queueing-theory concepts to represent computer systems and analyze their performance characteristics.  It is a queueing model solver, not a simulator. PDQ models consist of workloads or PDQ streams and queueing faciities or PDQ nodes.  Workloads are characterized by whether they are part of an open or closed network (i.e., whether or not new customers enter and leave the system) and by their volume (arrival rate for open networks or number and think time for closed networks). PDQ nodes are the places in the network where requests are serviced and where queues can form. Nodes are characterized by their scheduling discipline, e.g., FCFS, the number of servers available, and the average service time or inverse service rate. The results of solving a particular queueing network can be displayed n the R console either, as selected performance metrics or, as a complete summary of the entire network.
}
\details{
\tabular{ll}{
Package: \tab pdq\cr
Version: \tab \Sexpr[stage=render]{utils:::packageDescription("pdq")$Version}\cr
Date: \tab \Sexpr[stage=render]{utils:::packageDescription("pdq")$Date}\cr
License: \tab MIT\cr
URL: \tab \url{http://www.perfdynamics.com/Tools/PDQ.html}\cr
\tab \url{https://github.com/DrQz/pdq-qnm-pkg/}\cr
Built: \tab \Sexpr[stage=render]{utils:::packageDescription("pdq")$Built}\cr
}
}


\author{
Neil Gunther with contributions from Paul Puglia and Phil Feller for R versions.

Maintainer: Neil Gunther <info@perfdynamics.com>
}
\references{
Gunther, N. J. (2000) \emph{The Practical Performance Analyst }. Lincoln, Nebraska: iUniverse Press. \url{http://www.perfdynamics.com/iBook/ppa.html}

Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ (2nd edn.)}. Heidelberg, Germany: Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\keyword{ package }
\examples{
library(pdq)

# Define and solve a PDQ model
Init("Grocery Checkout")               # Initialize PDQ and name the model
CreateOpen("Customers", 0.75)          # Defines an open queueing network
CreateNode("Cashier", CEN, FCFS)       # Single checkout queue serviced in FIFO order
SetDemand("Cashier", "Customers", 1.0) # Assign the average service time
SetWUnit("Bags")                       # Change reported work units
SetTUnit("Min")                        # Change reported timebase units
Solve(STREAMING)                       # Solve the open continuous workflow model
Report()                               # Display performance metrics in the R console
}

