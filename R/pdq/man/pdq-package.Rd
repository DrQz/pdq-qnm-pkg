\name{pdq-package}
\alias{pdq-package}
\alias{pdq}
\docType{package}
\title{
PDQ
Pretty Damn Quick Queueing Model
}
\description{
The PDQ performance analyzer uses queueing-theory concepts to represent computer systems and analyze their performance characteristics.  It is a queueing model solver, not a simulator.  The queueing-theory models discussed in \emph{Analyzing Computer System Performance with Perl::PDQ} are incorporated into the solution methods used by PDQ.
}
\details{
\tabular{ll}{
Package: \tab pdq\cr
Version: \tab 5.0-2\cr
Date: \tab 2009-07-04\cr
License: \tab MIT\cr
URL: \tab http://www.perfdynamics.com/Tools/PDQ.html\cr
\tab http://sourceforge.net/projects/pdq-qnm-pkg/\cr
Built: \tab R 2.8.1; x86_64-pc-linux-gnu; 2009-07-04 17:45:09; unix\cr
}

Index:
\preformatted{
pdq-package             PDQ Pretty Damn Quick Queueing Model
}
PDQ models consist of workloads and nodes (or queueing centers).  Workloads are characterized by whether they are part of an open or closed circuit (whether or not new customers enter and leave the system) and by their volume (arrival rate for open circuits, size and "think time" for closed).  Nodes are the places in the model where customer requests are serviced and where queues will develop.  Nodes are characterized by their queue discipline (the policy that governs which request is the next to be serviced off the queue), the number of servers available, and the average service time.  PDQ assumes that service times follow an exponential distribution and that the number of arrivals in a period follows a Poisson distribution.

Every PDQ program will use the Init function to initialize all internal variables and the Solve function to calculate the system's key characteristics.  It will have one or more CreateOpen or CreateClosed function calls, to define the system's workload, and one or more CreateNode (or CreateMultiNode) and SetDemand (or SetVisits) function calls to define the system's nodes (queues and servers).  The SetDemand function also serves to associate a given node with a given workload.  Most programs will use the Report function to create a human-readable report of the system's key characteristics.  Some programs will use any of the GetLoadOpt, GetQueueLength, GetResidenceTime, GetResponse, GetThruput, or GetUtilization functions in order to perform further calculations on these data. The SetComment, SetTUnit, and SetWUnit functions can be used to make the report more comprehensible.

}
\author{
Neil Gunther <njgunther@perfdynamics.com, with
contributions from Phil Feller <phil@philfeller.com>.

Maintainer: Phil Feller <phil@philfeller.com>
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\keyword{ package }
\seealso{
}
\examples{
library(pdq)

arrivRate    <- 0.75    # on average 0.75 requests arrive each second
service_time <- 1.0     # the server averages 1 second for each request

#---- Initialize -----------------------------------------------------

Init("OpenCircuit")
SetComment("A simple M/M/1 queue")

#---- Define the queueing center -------------------------------------

CreateNode("server", CEN, FCFS)  # single-server, first-come-first-served

#---- Define the workload and circuit type ---------------------------

CreateOpen("work", arrivRate)    # open circuit: customers enter and leave

SetWUnit("Customers")
SetTUnit("Seconds")

#---- Define service demand due to workload on the queueing center ---

SetDemand("server", "work", service_time)

#---- Solve the model ------------------------------------------------
#  Must use the CANONical method for an open circuit

Solve(CANON)

#---- Generate a report ----------------------------------------------

Report()
}
