#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#---- Define globals -------------------------------------------------

arrivRate    = 0.75
service_time = 1.0

#---- Initialize -----------------------------------------------------

pdq.Init("OpenCenter")
pdq.SetComment("A simple M/M/1 queue")



#---- Define the workload and circuit type ---------------------------

pdq.streams = pdq.CreateOpen("work", arrivRate)

pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")


#---- Define the queueing center -------------------------------------

pdq.nodes = pdq.CreateNode("server", pdq.CEN, pdq.FCFS)

#---- Define service demand due to workload on the queueing center ---

pdq.SetDemand("server", "work", service_time)

#---- Solve the model ------------------------------------------------
#  Must use the CANONical method for an open circuit

pdq.Solve(pdq.CANON)

#---- Generate a report ----------------------------------------------

pdq.Report()

#---------------------------------------------------------------------

comment = pdq.GetComment()

print 'pdq.GetComment -> \"%s\"' % comment

#---------------------------------------------------------------------

