#!/usr/bin/env python
#
# Created by NJG on Wed, Apr 18, 2007
#
# Queueing model of an email-spam analyzer system comprising a 
# battery of SMP servers essentially running in batch mode. 
# Each node was a 4-way SMP server.
# The performance metric of interest was the mean queue length.
#
# This simple M/M/4 model gave results that were in surprisingly 
# good agreement with monitored queue lengths.
#
# $Id$

import pdq

# Measured parameters 
servers  = 4
arivrate = 0.66 # per min
servtime = 6.0  # seconds

pdq.Init("SPAM Analyzer")
nstreams = pdq.CreateOpen("Email", arivrate)
nnodes   = pdq.CreateNode("spamCan", int(servers), pdq.MSQ)
pdq.SetDemand("spamCan", "Email", servtime)
pdq.Solve(pdq.CANON)
pdq.Report()

