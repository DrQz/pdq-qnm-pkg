#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

arrivRate    = 0.75
service_time = 1.0


#---- Initialize the system ------------------------------------------

pdq.Init("OpenCenter")
pdq.SetComment("This is just a simple M/M/1 queue.");
   
pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")


#---- Define the queueing center -------------------------------------

pdq.nodes = pdq.CreateNode("server", pdq.CEN, pdq.FCFS)


#---- Define the workload and circuit type ---------------------------

pdq.streams = pdq.CreateOpen("work", arrivRate)


#---- Define service demand due to workload on the queueing center ---

pdq.SetDemand("server", "work", service_time)


#---- Solve the model ------------------------------------------------
#  Must use the CanonIcal method for an open circuit

pdq.Solve(pdq.CANON)


#---- Generate a report ----------------------------------------------

print "Using: %s" % pdq.version

pdq.Report()

#---------------------------------------------------------------------

