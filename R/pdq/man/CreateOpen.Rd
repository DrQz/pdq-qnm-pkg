\name{CreateOpen}
\alias{CreateOpen}
\title{ Define Workload for Open Queuing Circuit }
\description{
Define the workload for a open queueing circuit. A open circuit has an unbounded population of customers: new customers enter the system at a defined rate and exit. once processed The workload is characterized by the arrival rate of new customers.  Separate calls are required for workload streams having different characteristics.
}
\usage{
CreateOpen(name, lambda)
}
\arguments{
  \item{name}{ The string used to identify the workload in reports and as an argument to other functions }
  \item{lambda}{ The arrival rate per unit time into the queueing circuit. }
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\author{
Neil Gunther <njgunther@perfdynamics.com, with
}
\examples{
library("pdq")
Init("CreateOpen Example")
CreateOpen("Customers", 0.75)
CreateMultiNode(3, "Bank Tellers", CEN, FCFS)
SetDemand("Bank Tellers", "Customers", 1.0)
Solve(CANON)
Report()
}
