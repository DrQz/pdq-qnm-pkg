#!/usr/bin/env python
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


