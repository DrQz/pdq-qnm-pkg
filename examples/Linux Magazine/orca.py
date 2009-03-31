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
# Created by NJG on Thu, May 31, 2007
#
# Blair Zajac, author of Orca states:
# "If long term trends indicate increasing figures, more or faster CPUs
# will eventually be necessary unless load can be displaced. For ideal
# utilization of your CPU, the maximum value here should be equal to the
# number of CPUs in the box."
#
# Zajac's comment implies any waiting line is bad.
# PDQ steady-state model for HPC/batch workload with 
# stretch factor == 1 (no waiting line).
# Very low arrival rate over 10 hour period.

import pdq

processors  = 4
arrivalRate = 0.099 # jobs per hour (very low arrivals)
crunchTime  = 10.0  # hours (very long service time)

pdq.Init("ORCA LA Model")
s = pdq.CreateOpen("Crunch", arrivalRate)
n = pdq.CreateNode("HPCnode", int(processors), pdq.MSQ)
pdq.SetDemand("HPCnode", "Crunch", crunchTime)
pdq.SetWUnit("Jobs")
pdq.SetTUnit("Hour")
pdq.Solve(pdq.CANON)
pdq.Report()

