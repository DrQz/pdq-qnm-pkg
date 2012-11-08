###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company		      #
#									      #
#  This software is licensed as described in the file COPYING, which	      #
#  you should have received as part of this distribution. The terms	      #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#									      #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is	      #
#  furnished to do so, under the terms of the COPYING file.		      #
#									      #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.					      #
###############################################################################

#
# An old performance gem.
# Solve fast-slow disk I/O optimization problem
# by searching for lowest mean response time.
#
# $Id$

require(pdq)

IOinterval     <- 0.006; # seconds
IOrate	       <- 1 / IOinterval
fastService   <-  0.005 # seconds
slowService    <- 0.015 # seconds

# Start with 3:1 ratio based on speed 15/5 ms
fastFraction	<- 0.75

FastDk	       <- "FastDisk"
SlowDk	      <-  "SlowDisk"
IOReqsF       <-  "fastIOs"
IOReqsS      <-   "slowIOs"

modelName      <- "Disk I/O Optimization"
cat(sprintf("Solving: %s ...\n", modelName))

while(fastFraction < 0.86) {
    Init(modelName)

    CreateNode(FastDk, CEN, FCFS)
    CreateNode(SlowDk, CEN, FCFS)

    CreateOpen(IOReqsF, IOrate * fastFraction)
    CreateOpen(IOReqsS, IOrate * (1 - fastFraction))

    SetDemand(FastDk, IOReqsF, fastService)
    SetDemand(FastDk, IOReqsS, 0.0)

    SetDemand(SlowDk, IOReqsS, slowService)
    SetDemand(SlowDk, IOReqsF, 0.0)

    Solve(CANON)

    fRT  <- GetResponse(TRANS, IOReqsF)
    sRT  <- GetResponse(TRANS, IOReqsS)
    mRT  <- (fRT * fastFraction) + ((1 - fastFraction) * sRT)

    cat(sprintf("f:  %6.4f, ", fastFraction))
    cat(sprintf("Uf: %6.4f, ", GetUtilization(FastDk, IOReqsF, TRANS)))
    cat(sprintf("Us: %6.4f, ", GetUtilization(SlowDk, IOReqsS, TRANS)))
    cat(sprintf("Rf: %6.4f, ", fRT))
    cat(sprintf("Rs: %6.4f, ", sRT))
    cat(sprintf("Rt: %8.6f\n", mRT))

    fastFraction <- fastFraction +  0.01
}
