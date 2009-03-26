###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

# Load the library
library("pdq")
#
# T/put bounds for closed tandem QNM with increasing Z
# Created by NJG on Fri Feb 27, 2009
#
clients = 300
thinkZ  = 800 * 10^(-3) # ms as seconds
stime   = 20  * 10^(-3) # ms as seconds
node1   = "n1"
node2   = "n2"
node3   = "n3"
work    = "w"
for(z in 1:3) {
   xc<-0 # prudent to reset these
   yc<-0
   for (i in 1:clients) {
      Init("")
      if (z==1) {think<-thinkZ * 0}
      if (z==2) {think<-thinkZ * 2}
      if (z==3) {think<-thinkZ * 4}
      CreateClosed(work, TERM, as.double(i), think) 
      CreateNode(node1, CEN, FCFS)
      CreateNode(node2, CEN, FCFS)
      CreateNode(node3, CEN, FCFS)
      SetDemand(node1, work, stime)
      SetDemand(node2, work, stime)
      SetDemand(node3, work, stime)   
      Solve(APPROX)
      xc[i]<-as.double(i)
      yc[i]<-GetThruput(TERM, work)
      nopt<-(3*stime + think)/stime
     }
    if (z==1) {
    	# establish plot frame and first curve
        plot(xc, yc, type="l", ylim=c(0,1/stime), lwd=2, xlab="N Clients", 
             ylab="Throughput X(N)")
        title("Increasing Z Values")
      	abline(0, 1/(nopt*stime), lty="dashed",  col = "blue")
      	abline(1/stime, 0, lty="dashed",  col = "red")
      	abline(v=nopt, lty="dashed", col="gray50")
        text(20+nopt, 35, paste("Z=", as.numeric(think)))
      	text(3+nopt, 6, paste("N*=", as.numeric(nopt)))
    } else {
    	# add the other curves
      	points(xc, yc, type="l", lwd=2)
      	abline(0, 1/(nopt*stime), lty="dashed",  col = "blue")
      	abline(v=nopt, lty="dashed", col="gray50")
      	format(think, scientific = TRUE)
      	text(4+nopt, 35, paste("Z=", as.numeric(think)))
      	text(3+nopt, 6, paste("N*=", as.numeric(nopt)))
    }
}


