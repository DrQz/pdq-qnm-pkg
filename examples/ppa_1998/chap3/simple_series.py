#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#---------------------------------------------------------------------
# Based on simple_series_circuit.c
# 
# An open queueing circuit with 3 centers.

arrivals_per_second = 0.10

pdq.Init("Simple Series Circuit")

pdq.streams = pdq.CreateOpen("Work", arrivals_per_second)

pdq.nodes = pdq.CreateNode("Center1", pdq.CEN, pdq.FCFS)
pdq.nodes = pdq.CreateNode("Center2", pdq.CEN, pdq.FCFS)
pdq.nodes = pdq.CreateNode("Center3", pdq.CEN, pdq.FCFS)

pdq.SetDemand("Center1", "Work", 1.0)
pdq.SetDemand("Center2", "Work", 2.0)
pdq.SetDemand("Center3", "Work", 3.0)

pdq.Solve(pdq.CANON)

pdq.Report()

#---------------------------------------------------------------------

