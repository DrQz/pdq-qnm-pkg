#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
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

