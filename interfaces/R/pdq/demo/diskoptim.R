###########################################################################
#  Copyright (c) 1994--2021, Performance Dynamics Company
#  
#  This software is licensed as described in the file COPYING, which
#  you should have received as part of this distribution. The terms
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.
#
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell 
#  copies of the Software, and permit persons to whom the Software is
#  furnished to do so, under the terms of the COPYING file.
#
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF 
# ANY KIND, either express or implied.
###########################################################################

# $Id: diskoptim.R,v 1.3 2012/11/13 18:36:42 earl-lang Exp $
# Updated by NJG on Sun Dec 10 10:44:11 2017

# An performance gem. Optimize the flow of IO requests between a fast and 
# a slow disk. This code also produces a plot of the solution.

library(pdq)

IOdelta     <- 0.006; # seconds
IOrate	    <- 1 / IOdelta
fastService <- 0.005 # seconds
slowService <- 0.015 # seconds

# Start with a 2:1 ratio
fastFraction <- 0.67

FastDk	<- "FastDisk"
SlowDk	<- "SlowDisk"
IOReqsF <- "fastIOs"
IOReqsS <- "slowIOs"

modelName <- "Disk IO Optimization"
dkf <- data.frame()

while (fastFraction < 1.0) {
  pdq::Init(modelName)
  
  pdq::CreateNode(FastDk, CEN, FCFS)
  pdq::CreateNode(SlowDk, CEN, FCFS)
  
  pdq::CreateOpen(IOReqsF, IOrate * fastFraction)
  pdq::CreateOpen(IOReqsS, IOrate * (1 - fastFraction))
  
  pdq::SetDemand(FastDk, IOReqsF, fastService)
  pdq::SetDemand(SlowDk, IOReqsS, slowService)
  
  pdq::Solve(CANON)
  
  fRT <- pdq::GetResponse(TRANS, IOReqsF)
  sRT <- pdq::GetResponse(TRANS, IOReqsS)
  mRT <- (fRT * fastFraction) + ((1 - fastFraction) * sRT)
  
  dkmets <- c(
    fastFraction,
    pdq::GetUtilization(FastDk, IOReqsF, TRANS),
    pdq::GetUtilization(SlowDk, IOReqsS, TRANS),
    fRT * fastFraction * 100,
    sRT * (1 - fastFraction) * 100,
    mRT  * 100  
  )
  
  dkf <- rbind(dkf, dkmets)
  
  fastFraction <- fastFraction +  0.01
}

pdq::Report()

names(dkf) <- c("f", "Uf", "Us", "Rf", "Rs", "Rt")
head(dkf)

cat("Row with minimum time is:\n")
minRow <- dkf[which(dkf$Rt == min(dkf$Rt)), ]
print(minRow)

# Plot results to see why ...
plot(dkf$f, dkf$Rt, type="b",
     main=modelName,
     ylim=c(0,ceiling(max(dkf$Rt))),
     xlab="Fast fraction (f)",
     ylab="Response Times (Seconds)"
     )
abline(v=minRow$f, lty="dashed")
lines(dkf$f, dkf$Rs, col="green")
lines(dkf$f, dkf$Rf, col="red")


