###########################################################################
#  Copyright (C) 1994--2021, Performance Dynamics Company
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
#
# cloud.r
#
# PQD model of an AWS cloud application running on a Linux/Tomcat server.
# This example exercises the new MSC solver in the PDQ 7 release.
# Background for the development of this model can be found in the paper entitled,  
# "Linux-Tomcat Application Performance on Amazon AWS" (2016)
# PDF available online at https://arxiv.org/abs/1811.12341
# Created by NJG on Sun Nov 23, 2020

library(pdq)

requests <- seq(10, 500, 20) # from the Internet
threads  <- 300   # max threads under auto-scale policy
stime    <- 0.444 # measured service time in seconds
xx       <- NULL  # modeled load point for plot
yx       <- NULL  # corresponding throughput 

for (i in 1:length(requests)) {
  pdq::Init("")  
  pdq::CreateClosed("Requests", BATCH, requests[i], 0.0)
  pdq::CreateMultiNode(threads, "Threads", MSC, FCFS) 
  pdq::SetDemand("Threads", "Requests", stime) 
  pdq::SetWUnit("Reqs")
  pdq::Solve(EXACT)
  
  xx[i] <- requests[i]
  yx[i] <- pdq::GetThruput(BATCH, "Requests")
}

plot(xx, yx, type="b", col="blue",
     ylim=c(0,800), 
     main="AWS-Tomcat Cloud Model",
     xlab="Tomcat threads", ylab="Throughput (RPS"
)
abline(v=max(threads), h=max(yx), col="red")
text(150, max(yx)+25, 
     paste(format(max(yx), digits=5), "RPS at AWS Auto Scaling"), 
     cex=0.85
     )

