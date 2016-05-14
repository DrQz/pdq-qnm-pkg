###############################################################################
#  Copyright (c) 1994 - 2013, Performance Dynamics Company
#
#  This software is licensed as described in the file COPYING, which
#  you should have received as part of this distribution. The terms
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.
#
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell
#  copies of the Software, and permit persons to whom the Software is
#  furnished to do so, under the terms of the COPYING file.
#
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
#  KIND, either express or implied.
###############################################################################

#
# An old performance gem.
# Solve fast-slow disk I/O optimization problem
# by searching for lowest mean response time.
#
# $Id$

require(pdq)

IOinterval  <- 0.006; # seconds
IOrate	    <- 1 / IOinterval
fastService <- 0.005 # seconds
slowService <- 0.015 # seconds

# Start with 3:1 ratio based on speed 15/5 ms
fastFraction <- 0.65

FastDk	<- "FastDisk"
SlowDk	<- "SlowDisk"
IOReqsF <- "fastIOs"
IOReqsS <- "slowIOs"

modelName <- "Disk IO Optimization"
cat(sprintf("Solving: %s ...\n", modelName))

dkf <- data.frame()

while(fastFraction < 1.0) {
    Init(modelName)

    CreateNode(FastDk, CEN, FCFS)
    CreateNode(SlowDk, CEN, FCFS)

    CreateOpen(IOReqsF, IOrate * fastFraction)
    CreateOpen(IOReqsS, IOrate * (1 - fastFraction))

    SetDemand(FastDk, IOReqsF, fastService)
    SetDemand(FastDk, IOReqsS, 0.0)

    SetDemand(SlowDk, IOReqsF, 0.0)
    SetDemand(SlowDk, IOReqsS, slowService)

    Solve(CANON)

    fRT  <- GetResponse(TRANS, IOReqsF)
    sRT  <- GetResponse(TRANS, IOReqsS)
    mRT  <- (fRT * fastFraction) + ((1 - fastFraction) * sRT)

#    cat(sprintf("f:  %6.4f, ", fastFraction))
#    cat(sprintf("Uf: %6.4f, ", GetUtilization(FastDk, IOReqsF, TRANS)))
#    cat(sprintf("Us: %6.4f, ", GetUtilization(SlowDk, IOReqsS, TRANS)))
#    cat(sprintf("Rf: %6.4f, ", fRT))
#    cat(sprintf("Rs: %6.4f, ", sRT))
#    cat(sprintf("Rt: %8.6f\n", mRT))

     dkmets <- c(
     	fastFraction,
     	GetUtilization(FastDk, IOReqsF, TRANS),
     	GetUtilization(SlowDk, IOReqsS, TRANS),
     	fRT * fastFraction * 100,
     	sRT * (1 - fastFraction) * 100,
     	mRT  * 100  
     )
     
     dkf <- rbind(dkf, dkmets)

    fastFraction <- fastFraction +  0.01
}

names(dkf) <- c("f", "Uf", "Us", "Rf", "Rs", "Rt")
print(dkf)
cat("\n")
print("Find the row with minimum RT")
minRow <- dkf[which(dkf$Rt == min(dkf$Rt)),]
print(minRow)

# Now see why...
plot(dkf$f,dkf$Rt,type="b",main=modelName,ylim=c(0,ceiling(max(dkf$Rt))),
	xlab="Fast fraction (f)",ylab="Response Times (Seconds)")
abline(v=minRow$f, lty="dashed")
lines(dkf$f,dkf$Rs,col="green")
lines(dkf$f,dkf$Rf,col="red")


