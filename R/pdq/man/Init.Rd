\name{Init}
\alias{Init}
\title{ Initialize Model }
\description{
Initializes all internal PDQ variables.  Must be called prior to any other PDQ function. It also resets all internal PDQ variables so that no separate cleanup function call required.
}
\usage{
Init(name)
}
\arguments{
  \item{name}{ A string containing the name of the performance model that will appear in the PDQ report banner.  To maintain cosmetic appearances, the model name should not exceed 24 characters (including spaces). }
}
\details{
Init can be called an arbitrary number of times from within the same model.
}
\references{
Gunther, N. J. 2005 \emph{Analyzing computer systems performance with PERL::PDQ}. Berlin, Heidelberg: Springer.
}
\author{
Neil Gunther <njgunther@perfdynamics.com, with
}
\note{ 
}
\seealso{ }
\examples{
Init("Application Model 1");
}
\keyword{ }
\keyword{ }% __ONLY ONE__ keyword per line
