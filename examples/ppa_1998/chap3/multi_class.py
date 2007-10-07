#!/usr/bin/env python

import pdq

# Based on closed_center.c
# 
# Illustrate import of PDQ solver for multiclass workload.


#---- Model specific variables -------------------------------------------------

think = 0.0


#---- Initialize the model -----------------------------------------------------

tech = pdq.APPROX

if (tech == pdq.EXACT):
   technique = "EXACT"
else:
   technique = "APPROX"

print "**** %s Solution ****:\n" % technique
print "  N      R (w1)    R (w2)"

for pop in range(1, 10):
   pdq.Init("Test_Exact_calc")

   #---- Define the workload and circuit type ----------------------------------

   pdq.streams = pdq.CreateClosed("w1", pdq.TERM, 1.0 * pop, think)
   pdq.streams = pdq.CreateClosed("w2", pdq.TERM, 1.0 * pop, think)

   #---- Define the queueing center --------------------------------------------

   pdq.nodes = pdq.CreateNode("node", pdq.CEN, pdq.FCFS)

   #---- service demand --------------------------------------------------------

   pdq.SetDemand("node", "w1", 1.0)
   pdq.SetDemand("node", "w2", 0.5)

   #---- Solve the model -------------------------------------------------------

   pdq.Solve(tech)

   print "%3.0f    %8.4f  %8.4f" % (pop,
    pdq.GetResponse(pdq.TERM, "w1"),
    pdq.GetResponse(pdq.TERM, "w2"));


