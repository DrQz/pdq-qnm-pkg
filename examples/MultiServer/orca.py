#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 2007, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

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

