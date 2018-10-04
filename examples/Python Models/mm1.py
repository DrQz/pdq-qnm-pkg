#!/usr/bin/env python
#
# M/M/1 queue in PyDQ 

###############################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company                    #
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

import pdq

pdq.Init("Grox Store Model")

pdq.CreateOpen("Customers", 0.75)
pdq.CreateNode("Checkout", pdq.CEN, pdq.FCFS)
pdq.SetDemand("Checkout", "Customers", 1.0)

pdq.SetWUnit("Cust")
pdq.SetTUnit("Mins")

pdq.Solve(pdq.CANON)
pdq.Report()

