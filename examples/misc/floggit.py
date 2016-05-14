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
# M/M/1 in PyDQ 

import pdq

pdq.Init("Python Test Script")
pdq.nodes = pdq.CreateNode("Deadhorse", pdq.CEN, pdq.FCFS)
pdq.streams = pdq.CreateOpen("Floggit", 0.75)
pdq.SetWUnit("Cust")
pdq.SetTUnit("Min")
pdq.SetDemand("Deadhorse", "Floggit", 1.0)
pdq.Solve(pdq.CANON)
pdq.Report()

