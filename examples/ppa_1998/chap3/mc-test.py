#!/usr/bin/env python
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
