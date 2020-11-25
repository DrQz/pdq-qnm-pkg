\name{SetComment}
\alias{SetComment}
\title{ Include a comment in a PDQ Report }
\description{
Useful for keeping track of parameter variations across the same or similar PDQ models. Appears near the top of the Report ouput.
}
\usage{
SetComment(comment)
}
\arguments{
  \item{comment}{ A character string. }
}
\author{
Neil J. Gunther
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\examples{
library(pdq)
arate <- 0.75
srate <- 1.0
Init("SetComment Example")
SetComment("This is just an toy example.")
CreateNode("server", CEN, FCFS)
CreateOpen("work", arate)
SetDemand("server", "work", 1/srate)
Solve(STREAMING)
Report()
}
