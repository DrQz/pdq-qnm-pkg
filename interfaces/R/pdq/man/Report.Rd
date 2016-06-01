\name{Report}
\alias{Report}
\title{ Generate a PDQ report }
\description{
Report produces a formatted summary of all modeling results. }
\details{
\describe{
A PDQ report is comprised of several sections.
\item{Model INPUTS}{
\itemize{
\item{Name of the PDQ model.}
\item{Date when the model was executed.}
\item{Version of PDQ used.}
\item{A comment field is included if SetComment is called. }
\item{A summary of all workload parameters. }
}
}
\item{Model OUTPUTS}{
\itemize{
\item{Solution method used.}
\item{System-level performance metrics. }
\item{Node-level performance metrics such as: Capacity, Utilization, and Waiting time. }
}
}
}
}
\usage{
Report() displays the formatted text in the R console.
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\seealso{ 
  \code{\link{SetComment}}
}
\examples{
library(pdq)
arate <- 0.75
srate <- 1.0
Init("Report Example")
SetComment("This is just an toy example.")
CreateNode("server", CEN, FCFS)
CreateOpen("work", arate)
SetDemand("server", "work", 1/srate)
Solve(CANON)
Report()
}
