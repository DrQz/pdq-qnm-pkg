#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#
# Based on time_share.c
#
# Illustrates PDQ solver for closed uni-server queue.  Compare with repair.c
#

##### Model specific variables #######################################

#pop   = 200.0
pop   = 100.0
think = 300.0
servt = 0.63

##### Initialize the model giving it a name ##########################

pdq.Init("Time Share Computer")
pdq.SetComment("This is just a simple M/M/1 queue.");

##### Define the workload and circuit type ###########################

pdq.streams = pdq.CreateClosed("compile", pdq.TERM, pop, think)

##### Define the queueing center #####################################

pdq.nodes  = pdq.CreateNode("CPU", pdq.CEN, pdq.FCFS)

##### Define service demand ##########################################

pdq.SetDemand("CPU", "compile", servt)

##### Solve the model ################################################

pdq.Solve(pdq.EXACT)

pdq.Report()

#---------------------------------------------------------------------

