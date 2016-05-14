#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 2007, Performance Dynamics Company                    #
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
# mmm.py
#
# Created by NJG on Fri, Apr 13, 2007
#

import pdq

# Parameters taken from mmm_sim.py file
arrivalRate = 2.0
serviceTime = 1.0

pdq.Init("M/M/m in PyDQ")
pdq.SetComment("Cf. SimPy Results.");
   
pdq.streams = pdq.CreateOpen("work", arrivalRate)
pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")


pdq.nodes = pdq.CreateNode("server", 3, pdq.MSQ)

pdq.SetDemand("server", "work", serviceTime)

pdq.Solve(pdq.CANON)

pdq.Report()


