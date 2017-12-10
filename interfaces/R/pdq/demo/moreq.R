###########################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company
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

# Updated by NJG on Sun Dec 10 12:19:58 2017
# Created by NJG on Fri Feb 27, 2009

library(pdq)

# Plot thruput curves for closed QNM with fixed Z and more queues.
# cf. PDQ demo: 'morez.r'
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 4.8 Limited Request (Closed) Queues

clients  <- 200
think    <- 8   * 1e-3 # ms as seconds
stime    <- 500 * 1e-3 # ms as seconds
work     <- "w"

for(k in c(1, 20, 50)) {
  xc <- 0 # prudent to reset these
  yc <- 0
  
  for (i in 1:clients) {
    pdq::Init("")
    pdq::CreateClosed(work, TERM, as.double(i), think)
    # create k queueing nodes in PDQ
    for (j in 1:k) {
      nname <- paste("n",sep="",j) # concat j to node name
      pdq::CreateNode(nname,CEN,FCFS)
      pdq::SetDemand(nname,work,stime)
    }
    
    pdq::Solve(APPROX)
    # vars for plotting in R
    xc[i] <- as.double(i)
    yc[i] <- pdq::GetThruput(TERM, work)
    nopt  <- (k * stime + think) / stime
  }
  if (k == 1) {
    # establish plot frame and first curve
    plot(xc, yc, type="l", 
         ylim=c(0,1 / stime), lwd=2, 
         main="Increasing Number (K) of Queues",
         xlab="N Clients",
         ylab="Throughput X(N)"
    )
    abline(0, 1 / (nopt * stime), lty="dashed",  col="blue")
    abline(1 / stime, 0, lty="dashed",  col = "red")
    abline(v=nopt, lty="dashed", col="gray50") # grid line
    text(150, 1.95, paste("K =", k))
    text(5 + k, 1.4, paste("N* =", nopt), adj=c(0,0))
  } else {
    # add the other curves
    points(xc, yc, type="l", lwd=2)
    abline(0, 1 / (nopt*stime), lty="dashed",	col="blue")
    abline(v=nopt, lty="dashed", col="gray50")
    text(150, 1.85 - 0.085 * k / 10, paste("K =", k))
    text(k + 5, 0.5 - 0.1 * k / 10, paste("N* =",nopt),adj=c(0,0))
  }
}


