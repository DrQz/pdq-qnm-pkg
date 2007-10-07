#!/usr/bin/env python
#
# M/M/1 in PyDQ 

import pdq

pdq.Init("Python Test Script")
pdq.SetWUnit("Cust")
pdq.SetTUnit("Min")
pdq.nodes = pdq.CreateNode("Deadhorse", pdq.CEN, pdq.FCFS)
pdq.streams = pdq.CreateOpen("Floggit", 0.75)
pdq.SetDemand("Deadhorse", "Floggit", 1.0)
pdq.Solve(pdq.CANON)
pdq.Report()

