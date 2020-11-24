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
# multiwo.r
#
# Demo of multiple open workloads in PDQ 7.0
# Taken from Example 7.2 in QSP book p.138
# Created by NJG on Sun Nov 22, 2020

library(pdq)

# Visit counts
Va_cpu <- 10
Va_dsk <-  9
Vb_cpu <-  5
Vb_dsk <-  4

Init("Multiwork Open")

# Define 2 workloads
CreateOpen("WflowA", 3/19)
CreateOpen("WflowB", 2/19)

CreateNode("CPU", CEN, FCFS)
CreateNode("DSK", CEN, FCFS)

SetVisits("CPU", "WflowA", Va_cpu, 1/10)
SetVisits("DSK", "WflowA", Va_dsk, 1/3)
SetVisits("CPU", "WflowB", Vb_cpu, 2/5)
SetVisits("DSK", "WflowB", Vb_dsk, 1.0)

Solve(STREAMING)
Report()

# Compare selected outputs
s1 <- sprintf("%s\n", "Selected PDQ outputs for WflowA:")
s2 <- sprintf("X_cpu = %6.3f (QSP model: 1.58)\n", 
              GetThruput(TRANS, "WflowA") * Va_cpu)
s3 <- sprintf("U_cpu = %6.3f (QSP model: 0.158)\n", 
              GetUtilization("CPU", "WflowA", TRANS))
s4 <- sprintf("R_cpu = %6.3f (QSP model: 1.58)\n", 
              GetResidenceTime("CPU", "WflowA", TRANS))
s5 <- sprintf("Q_cpu = %6.3f (QSP model: 0.25)\n", 
              GetQueueLength("CPU", "WflowA", TRANS))
s6 <- sprintf("RT_cpu = %6.3f (QSP model: 30.08)\n",  
              GetResponse(TRANS, "WflowA"))
cat(paste(s1, s2, s3, s4, s5, s6))

