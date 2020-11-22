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
# Solve successive PDQ model instances of 'users' as the independent variable xc 
# to plot the dependent throughput variable yc
library(pdq)
users <- 100
think <- 8e-3   # milliseconds
stime <- 500e-3 # milliseconds
work  <- "DB query"
xc <- 0 # plot vector
yc <- 0 # plot vector
# THe following for-loop solves successive PDQ models
# Each pass requires that the pdq::Init function be called
for (i in 1:users) {
    Init("Multiple Init Example")   # reinitialize PDQ variables
    CreateClosed(work, TERM, as.double(i), think) 
    # create a PDQ queueing network with 20 queueing nodes
    for (j in 1:20) {
        nname <- paste("node", sep="", j)   # add j index to node name
        CreateNode(nname, CEN, FCFS)
        SetDemand(nname, work, stime)
    }
    Solve(EXACT)
    # store PDQ results in plot vectors
    xc[i] <- as.double(i)
    yc[i] <- GetThruput(TERM, work)
}
plot(xc, yc, type="l", col="blue", xlab="Users", ylab="Throughput")
}
