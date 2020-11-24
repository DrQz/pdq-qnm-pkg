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
# mclass_closed.R
#
# Test multiple workloads in CLOSED network.
# Based on Arnold Allen's book Example 6.3.4, p.413
# Created by NJG on Sun Nov 22, 2020

library(pdq)

Init("Multiclass CLOSED Model")

CreateClosed("term1", TERM, 5, 20)
CreateClosed("term2", TERM, 10, 30)
CreateClosed("batch", BATCH, 5, 0)

CreateNode("node1", CEN, FCFS)
CreateNode("node2", CEN, FCFS)
CreateNode("node3", CEN, FCFS)

## From Table 6.3.2 on p.412
SetDemand("node1", "term1", 0.50)
SetDemand("node2", "term1", 0.04)
SetDemand("node3", "term1", 0.06)

SetDemand("node1", "term2", 0.40)
SetDemand("node2", "term2", 0.20)
SetDemand("node3", "term2", 0.30)

SetDemand("node1", "batch", 1.20)
SetDemand("node2", "batch", 0.05)
SetDemand("node3", "batch", 0.06)

Solve(EXACT) 

## Format output cf. Table 6.3.3 in Allen
cat(sprintf("\n\tTable 6.3.3 on p.413 of Allen\n"))
cat(sprintf("%1s\t%4s\t%4s\t%6s\t%6s\n", "c", "X", "R", "Utot", "Qtot"))

cat(sprintf("%d\t%6.3f\t%6.3f\t%6.4f\t%6.4f\n", 
	1, 
	GetThruput(TERM, "term1"),
	GetResponse(TERM, "term1"),
	# Total utilization on this node
	GetUtilization("node1", "term1", TERM) + 
	GetUtilization("node1", "term2", TERM) +
	GetUtilization("node1", "batch", BATCH),
	# Total queue-length on this node
	GetQueueLength("node1", "term1", TERM) + 
	GetQueueLength("node1", "term2", TERM) +
	GetQueueLength("node1", "batch", BATCH)
))

cat(sprintf("%d\t%6.3f\t%6.3f\t%6.4f\t%6.4f\n", 
	2, 
	GetThruput(TERM, "term2"),
	GetResponse(TERM, "term2"),
	# Total utilization on this node
	GetUtilization("node2", "term1", TERM) + 
	GetUtilization("node2", "term2", TERM) +
	GetUtilization("node2", "batch", BATCH),
	# Total queue-length on this node
	GetQueueLength("node2", "term1", TERM) + 
	GetQueueLength("node2", "term2", TERM) +
	GetQueueLength("node2", "batch", BATCH)
))

cat(sprintf("%d\t%6.3f\t%6.3f\t%6.4f\t%6.4f\n", 
	3, 
	GetThruput(BATCH, "batch"),
	GetResponse(BATCH, "batch"),
	# Total utilization on this node
	GetUtilization("node3", "term1", TERM) + 
	GetUtilization("node3", "term2", TERM) +
	GetUtilization("node3", "batch", BATCH),
	# Total queue-length on this node
	GetQueueLength("node3", "term1", TERM) + 
	GetQueueLength("node3", "term2", TERM) +
	GetQueueLength("node3", "batch", BATCH)
))
    

