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

requests <- 400
threads  <- 300
stime    <- 0.444

Init("Tomcat Cloud Model")  
CreateClosed("Requests", BATCH, requests, 0.0)
CreateMultiNode(threads, "TCthreads", MSC, FCFS) 
SetDemand("TCthreads", "Requests", stime) 
SetWUnit("Reqs")
SetTUnit("Sec")
Solve(EXACT)
Report()

