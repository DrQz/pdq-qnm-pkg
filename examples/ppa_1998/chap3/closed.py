#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#  Based on closed.c
#  
#  Illustrate use of PDQ solver for a closed circuit queue.

#---- Model specific variables ---------------------------------------

pop      = 3.0
think    = 0.1


#---- Initialize the model -------------------------------------------
# Give model a name and initialize internal PDQ variables

pdq.Init("Closed Queue")

#print "**** %s ****:" % (solve_as == pdq.EXACT ? "EXACT" : "APPROX")


#--- Define the workload and circuit type ----------------------------

pdq.streams = pdq.CreateClosed("w1", pdq.TERM, 1.0 * pop, think)


#--- Define the queueing center --------------------------------------

pdq.nodes   = pdq.CreateNode("node", pdq.CEN, pdq.FCFS)


#---- Define service demand ------------------------------------------

pdq.SetDemand("node", "w1", 0.10)

pdq.Solve(pdq.APPROX)

pdq.Report()

#---------------------------------------------------------------------
