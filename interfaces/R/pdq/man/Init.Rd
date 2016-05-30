\name{Init}
\alias{Init}
\title{ Initialize the PDQ model }
\description{
Initializes all internal PDQ variables.  Must be called prior to any other PDQ function. It also resets all internal PDQ variables so that no separate cleanup function call is required.
}
\usage{
Init(name)
}
\arguments{
  \item{name}{ A string containing the name of the queueing model that will appear in the PDQ Report banner.  To maintain cosmetic appearances, the model name should not exceed 24 characters (including spaces). }
}
\details{
Init must be called for each model in the same script.
}
\references{
Gunther, N. J. (2011) \emph{Analyzing computer systems performance with PERL::PDQ}, 2nd edn., Heidelberg, Germany, Springer-Verlag. \url{http://www.perfdynamics.com/iBook/ppa_new.html}
}
\author{
Neil J. Gunther
}

\examples{
library(pdq)
users <- 100
think <- 8e-3   # milliseconds as seconds
stime <- 500e-3 # milliseconds as seconds
work    = "SQL query"
xc <- 0
yc <- 0
for (i in 1:users) {
    Init("Multiple Init Example")   # re-initialize PDQ variables
    CreateClosed(work, TERM, as.double(i), think) 
    # create a 20-node PDQ queueing network
    for (j in 1:20) {
        nname <- paste("n", sep="", j)   # add j index onto node name
        CreateNode(nname, CEN, FCFS)
        SetDemand(nname, work, stime)
    }
    Solve(EXACT)
    # set up to plot throughput
    xc[i] <- as.double(i)
    yc[i] <- GetThruput(TERM, work)
}
plot(xc, yc, type="l", col="blue", xlab="Users", ylab="Throughput")
}
