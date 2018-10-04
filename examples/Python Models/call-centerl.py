#!/usr/bin/env python
#
# Created by NJG on Saturday, June 30, 2018

import pdq

agents  = 4     # available to take calls
aRate   = 0.35  # customers per minute
sTime   = 10.0  # minutes per customer

pdq.Init("Call Center")

pdq.CreateOpen("Customers", aRate)

pdq.CreateMultiNode(agents, "Agents", pdq.CEN, pdq.FCFS)

pdq.SetDemand("Agents", "Customers", sTime)

pdq.SetWUnit("Customers")
pdq.SetTUnit("Minute")

pdq.Solve(pdq.CANON)
pdq.Report()

