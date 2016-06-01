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
  \item{method}{ An appropriate solution name. }
}
\details{
The available solution methods are:
\describe{
\item{APPROX}{ Approximate MVA technique.  Only valid for solving a closed queueing circuit.  An approximation to the EXACT solution method. }
\item{APPROXMSQ}{ Required for solving a multi-node queueing center with multiple workloads. }
\item{CANON}{ Canonical solution technique. Only valid for a open queueing circuit. }
\item{EXACT}{ Iterative MVA (Mean Value Analysis) solution technique.  Only valid for a closed queueing circuit. }
}
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\seealso{ 
  \code{\link{CreateClosed, CreateMultiNode, CreateNode }}
}
\examples{
library(pdq)
Init("Solve Example")
CreateOpen("Customers", 0.75)
CreateMultiNode(3, "Bank Tellers", CEN, FCFS)
SetDemand("Bank Tellers", "Customers", 1.0)
Solve(CANON)
Report()
}
\keyword{ EXACT }
\keyword{ APPROX }
\keyword{ APPROXMSQ }
\keyword{ CANON } % __ONLY ONE__ keyword per line
