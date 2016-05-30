\name{Solve}
\alias{Solve}
\title{ Solve the Model }
\description{
Solve is called after the PDQ model has been created.   An appropriate solution method must be passed as an argument or an error will reported at runtime.
}
\usage{
Solve(method)
}
\arguments{
  \item{method}{ Solution method: CANON for an open circuit; APPROX or EXACT for a closed circuit }
}
\details{
The solution methods are:
\describe{
\item{APPROX}{ Uses the approximate MVA solution technique.  See chapter 2 for details. Only valid for solving a closed queueing circuit.  An approximation to the EXACT or iterative MVA solution method. }
\item{CANON}{ Uses the canonical solution technique.  See Chapter 2 (and the online PDQ User Manual) for more details.  Only valid for a open queueing circuit. }
\item{EXACT}{ Uses the iterative MVA (Mean Value Analysis) method for up to three workload classes.  Only valid for a closed queueing circuit. }
}
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\examples{
library("pdq")
Init("Server")
think <- 8 * 10^(-3) # ms as seconds
CreateNode("disk", CEN, FCFS)
CreateClosed("IOs", TERM, 100, think)
SetDemand("disk","IOs",0.5)
Solve(APPROX)
}
