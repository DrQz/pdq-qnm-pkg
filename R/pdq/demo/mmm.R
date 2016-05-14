###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company
#
#  This software is licensed as described in the file COPYING, which
#  you should have received as part of this distribution. The terms	
#  are also available at http://www.perfdynamics.com/Tools/copyright.html. 
#
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell
#  copies of the Software, and permit persons to whom the Software is
#  furnished to do so, under the terms of the COPYING file.
#
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
#  KIND, either express or implied.
###############################################################################

#
# mmm.R
#
#  ported by PJP from mmm.py
#


# Parameters taken from mmm_sim.py file
arrivalRate <- 2.0
serviceTime <- 1.0

Init("M/M/m in PyDQ")
SetComment("Cf. SimPy Results.");

streams <- CreateOpen("work", arrivalRate)
SetWUnit("Customers")
SetTUnit("Seconds")


nodes <- CreateNode("server", 3, MSQ)

SetDemand("server", "work", serviceTime)

Solve(CANON)

Report()
