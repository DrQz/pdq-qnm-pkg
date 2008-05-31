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

# Measured performance parameters 
cpusPerServer = 4
emailThruput  = 2376 # emails per hour
scannerTime   = 6.0  # seconds per email

pdq.Init("Spam Farm Model")
# Timebase is SECONDS ...
nstreams = pdq.CreateOpen("Email", float(emailThruput)/3600)
nnodes   = pdq.CreateNode("spamCan", int(cpusPerServer), pdq.MSQ)
pdq.SetDemand("spamCan", "Email", scannerTime)
pdq.Solve(pdq.CANON)
pdq.Report()