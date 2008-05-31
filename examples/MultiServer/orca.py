#!/usr/bin/env python
#
# Created by NJG on Wed, Apr 18, 2007
#
#
# $Id$

import pdq

# Measured parameters 
servers  = 4
arivrate = 0.099  # per hr
servtime = 10.0   # hrs

pdq.Init("ORCA Batch")
nstreams = pdq.CreateOpen("Crunch", arivrate)
pdq.SetWUnit("Jobs")
pdq.SetTUnit("Hours")

nnodes   = pdq.CreateNode("HPC", int(servers), pdq.MSQ)

pdq.SetDemand("HPC", "Crunch", servtime)
pdq.Solve(pdq.CANON)
pdq.Report()

