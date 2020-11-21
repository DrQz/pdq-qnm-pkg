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

# Updated by NJG on Sun Dec 10 10:55:10 2017
# Created by NJG on Fri Feb 27, 2009

library(pdq)

# Plot thruput curves for closed QNM with fixed number of queues 
# while increasing think time Z. cf. PDQ demo: 'moreq.r'
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 4.8 Limited Request (Closed) Queues.

clients <- 300
thinkZ	<- 800 * 1e-3 # ms as seconds
stime	  <- 20  * 1e-3 # ms as seconds
node1	  <- "n1"
node2   <- "n2"
node3	  <- "n3"
work    <- "w"

for(z in 1:3) {
  xc <- 0 # prudent to reset these
  yc <- 0
  
  for (i in 1:clients) {
    pdq::Init("")
    
    if (z == 1) { think <- thinkZ * 0}
    if (z == 2) { think <- thinkZ * 2}
    if (z == 3) { think <- thinkZ * 4}
    
    pdq::CreateClosed(work, TERM, as.double(i), think)
    
    pdq::CreateNode(node1, CEN, FCFS)
    pdq::CreateNode(node2, CEN, FCFS)
    pdq::CreateNode(node3, CEN, FCFS)
    
    pdq::SetDemand(node1, work, stime)
    pdq::SetDemand(node2, work, stime)
    pdq::SetDemand(node3, work, stime)
    
    pdq::Solve(APPROX)
    
    xc[i] <- as.double(i)
    yc[i] <-  pdq::GetThruput(TERM, work)
    nopt  <- (3 * stime + think) / stime
   }
   
  if (z == 1) {
    # establish plot frame and first curve
    plot(xc, yc, type="l", 
         ylim=c(0,1/stime), lwd=2, 
         xlab="N Clients",
         ylab="Throughput X(N)",
         main="Increasing Z Values"
         )
    abline(0, 1 / (nopt*stime), lty="dashed",  col="blue")
    abline(1 / stime, 0, lty="dashed",  col="red")
    abline(v=nopt, lty="dashed", col="gray50")
    text(20 + nopt, 35, paste("Z=", as.numeric(think)))
    text(3 + nopt, 6, paste("N*=", as.numeric(nopt)))
  } else {
    # add the other curves
    points(xc, yc, type="l", lwd=2)
    abline(0, 1 / (nopt*stime), lty="dashed",  col="blue")
    abline(v=nopt, lty="dashed", col="gray50")
    format(think, scientific=TRUE)
    text(4+nopt, 35, paste("Z=", as.numeric(think)))
    text(3+nopt, 6, paste("N*=", as.numeric(nopt)))
  }
}
