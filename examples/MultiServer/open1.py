#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

arrivalRate = 0.75
serviceTime = 1.0


#---- Initialize the system ------------------------------------------

pdq.Init("Open Center in PyDQ")
pdq.SetComment("This is just a simple M/M/1 queue.");
   
pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")


pdq.nodes = pdq.CreateNode("server", pdq.CEN, pdq.FCFS)

pdq.streams = pdq.CreateOpen("work", arrivalRate)

pdq.SetDemand("server", "work", serviceTime)

pdq.Solve(pdq.CANON)


print "Using: %s" % pdq.version

pdq.Report()

#---------------------------------------------------------------------

