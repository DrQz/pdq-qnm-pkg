#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company                    #
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

# mm1n.pl
require(pdq)

# Model specific variables
requests    <- 100
thinktime   <- 300.0
serviceTime <- 0.63
nodeName    <- "CPU"
workName    <- "compile"

# Initialize the model
Init("M/M/1//N Model")

# Define the queueing circuit and workload   
CreateClosed(workName, TERM, requests, 
	thinktime)

# Define the queueing node 
CreateNode(nodeName, CEN, FCFS)

# Define service time for the work on that node 
SetDemand(nodeName, workName, serviceTime)

# Solve the model
Solve(EXACT)

# Report the PDQ results
Report()
