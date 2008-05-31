#!/usr/bin/env python
#
# open1msq.py
#
# Created by NJG on Fri, Apr 13, 2007 (test MSQ vs. M/M/1 in PyDQ)
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

arrivalRate = 0.75
serviceTime = 1.0

pdq.Init("Open1 MSQ Test")
pdq.SetComment("Cf. M/M/1/FCFS against MSQ with m=1 in PyDQ.");
   
pdq.streams = pdq.CreateOpen("work", arrivalRate)

pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")

pdq.nodes = pdq.CreateNode("MM1", pdq.CEN, pdq.FCFS)
pdq.nodes = pdq.CreateNode("MMm", 1, pdq.MSQ)

pdq.SetDemand("MM1", "work", serviceTime)
pdq.SetDemand("MMm", "work", serviceTime)

pdq.Solve(pdq.CANON)


print "Using: %s" % pdq.version

pdq.Report()

#---------------------------------------------------------------------

