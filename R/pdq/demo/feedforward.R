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

# feedforward.pl
require(pdq)

ArrivalRate <- 0.10
WorkName <- "Requests"
NodeName1 <- "Queue1"
NodeName2 <- "Queue2"
NodeName3 <- "Queue3"

Init("Feedforward Circuit")
CreateOpen(WorkName, ArrivalRate)
CreateNode(NodeName1, CEN, FCFS)
CreateNode(NodeName2, CEN, FCFS)
CreateNode(NodeName3, CEN, FCFS)
SetDemand(NodeName1, WorkName, 1.0)
SetDemand(NodeName2, WorkName, 2.0)
SetDemand(NodeName3, WorkName, 3.0)
Solve(CANON)
Report()
