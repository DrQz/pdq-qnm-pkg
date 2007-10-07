#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#---------------------------------------------------------------------
#  Based on multiclass-test.c
#  
#  Test Exact.c lib
#  
#  From A.Allen Example 6.3.4, p.413
#---------------------------------------------------------------------

pdq.Init("Multiclass Test")

#---- Define the workload and circuit type ---------------------------

pdq.streams = pdq.CreateClosed("term1", pdq.TERM, 5.0, 20.0)
pdq.streams = pdq.CreateClosed("term2", pdq.TERM, 15.0, 30.0)
pdq.streams = pdq.CreateClosed("batch", pdq.BATCH, 5.0, 0.0)

#---- Define the queueing center -------------------------------------

pdq.nodes = pdq.CreateNode("node1", pdq.CEN, pdq.FCFS)
pdq.nodes = pdq.CreateNode("node2", pdq.CEN, pdq.FCFS)
pdq.nodes = pdq.CreateNode("node3", pdq.CEN, pdq.FCFS)

#---- Define service demand ------------------------------------------

pdq.SetDemand("node1", "term1", 0.50)
pdq.SetDemand("node1", "term2", 0.04)
pdq.SetDemand("node1", "batch", 0.06)

pdq.SetDemand("node2", "term1", 0.40)
pdq.SetDemand("node2", "term2", 0.20)
pdq.SetDemand("node2", "batch", 0.30)

pdq.SetDemand("node3", "term1", 1.20)
pdq.SetDemand("node3", "term2", 0.05)
pdq.SetDemand("node3", "batch", 0.06)

#---- Solve it -------------------------------------------------------

pdq.Solve(pdq.EXACT)

pdq.Report()

#---------------------------------------------------------------------
