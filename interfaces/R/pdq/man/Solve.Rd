\name{Solve}
\alias{Solve}
\title{ Solve the PDQ model }
\description{
Solve is called after the PDQ queueing network model has been defined. An appropriate solution method must be supplied as an argument.
}
\usage{
Solve(method)
}
\arguments{
Available methods are:
\item{APPROX}{ An approximation to the EXACT solution method when there is a large number of requests in the system. Only valid for solving a closed queueing circuit. }
\item{APPROXMSQ}{ Required for solving a multiple server queueing center(using CreateMultiNode)  with multiple open-circuit workloads. }
\item{CANON}{ Canonical solution technique. Only valid for an open queueing circuit. }
\item{EXACT}{ Iterative mean value analysis (MVA) solution technique.  Only valid for a closed queueing circuit. }
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\seealso{ 
  \code{\link{CreateClosed}}, \code{\link{CreateMultiNode}}, \code{\link{CreateNode}}
}
\examples{
library(pdq)
Init("Solve Example")
CreateOpen("Customers", 0.75)
CreateMultiNode(3, "Bank Tellers", CEN, FCFS)
SetDemand("Bank Tellers", "Customers", 1.0)
Solve(STREAMING)
Report()
}
\keyword{ EXACT }
\keyword{ APPROX }
\keyword{ STREAMING }
\keyword{ CANON } % __ONLY ONE__ keyword per line
