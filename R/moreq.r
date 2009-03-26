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
# Thruput bounds for closed tandem QNM with fixed Z
# Created by NJG on Fri Feb 27, 2009
clients = 200
think   = 8   * 10^(-3) # ms as seconds
stime   = 500 * 10^(-3) # ms as seconds
work    = "w"
for(k in list(1,20,50)) {
    xc<-0 # prudent to reset these
    yc<-0
    for (i in 1:clients) {
        Init("")
        CreateClosed(work, TERM, as.double(i), think) 
        # create k queueing nodes in PDQ
        for (j in 1:k) {
       	    nname = paste("n",sep="",j) # concat j to node name
            CreateNode(nname,CEN,FCFS)
            SetDemand(nname,work,stime)
        }
        Solve(APPROX)
        # set up for plotting in R
        xc[i]<-as.double(i)
        yc[i]<-GetThruput(TERM,work)
        nopt<-(k*stime+think)/stime
     }
     if (k==1) {
     	# establish plot frame and first curve
        plot(xc, yc, type="l", ylim=c(0,1/stime), lwd=2, xlab="N Clients", 
             ylab="Throughput X(N)")
        title("Increasing Number (K) of Queues")
      	abline(0, 1/(nopt*stime), lty="dashed",  col="blue")
      	abline(1/stime, 0, lty="dashed",  col = "red")
      	abline(v=nopt, lty="dashed", col="gray50") # grid line
        text(150,1.95,paste("K =", k))
      	text(5+k,1.4,paste("N* =",nopt),adj=c(0,0))            
     } else {
    	# add the other curves
      	points(xc, yc, type="l", lwd=2)
      	abline(0,1/(nopt*stime), lty="dashed",  col="blue")
      	abline(v=nopt, lty="dashed", col="gray50")
       	text(150,1.85-0.085*k/10, paste("K =", k))
      	text(k+5,0.5-0.1*k/10,paste("N* =",nopt),adj=c(0,0))
     }
}


