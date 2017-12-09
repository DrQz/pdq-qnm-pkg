# Copyright (C) 1994 - 2018, Performance Dynamics Company  
# This software is licensed as described in the file COPYING, which 
# you should have received as part of this distribution. The terms
# are also available at http://www.perfdynamics.com/Tools/copyright.html.    
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY 
# OF ANY KIND, either express or implied.      


# Parameters taken from mmm_sim.py file
arrivalRate <- 2.0
serviceTime <- 1.0

Init("M/M/m model")
SetComment("Cf. SimPy Results.");

CreateOpen("work", arrivalRate)

CreateMultiNode(3, "server", CEN, FCFS)
SetDemand("server", "work", serviceTime)
SetWUnit("Customers")
SetTUnit("Seconds")

Solve(CANON)

Report()
