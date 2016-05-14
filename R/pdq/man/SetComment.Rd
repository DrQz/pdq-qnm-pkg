\name{SetComment}
\alias{SetComment}
\title{ Define Report Comment }
\description{
Define a comment to be printed at the top of the report.
}
\usage{
SetComment(comment)
}
\arguments{
  \item{comment}{ Comment to be printed at the top of the report. }
}
\details{
}
\author{
Neil Gunther <njgunther@perfdynamics.com
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\note{
}
\seealso{ }
\examples{
library(pdq)
Init("OpenCircuit")
SetComment("A simple M/M/1 queue")
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
