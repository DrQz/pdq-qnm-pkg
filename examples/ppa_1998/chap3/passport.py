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
# Based on passpt_office.c
#
# Illustration of an open queueing circuit with feedback.

arrivals = 16.0 / 3600	## 16 applications per hour


#---- Branching probabilities and weights ----------------------------

p12 = 0.30
p13 = 0.70
p23 = 0.20
p32 = 0.10

w3 = (p13 + p23 * p12) / (1 - p23 * p32)
w2 = p12 + p32 * w3


#---- Initialize and solve the model ---------------------------------

pdq.Init("Passport Office")

pdq.streams = pdq.CreateOpen("Applicant", 0.00427)

pdq.nodes   = pdq.CreateNode("Window1", pdq.CEN, pdq.FCFS)
pdq.nodes   = pdq.CreateNode("Window2", pdq.CEN, pdq.FCFS)
pdq.nodes   = pdq.CreateNode("Window3", pdq.CEN, pdq.FCFS)
pdq.nodes   = pdq.CreateNode("Window4", pdq.CEN, pdq.FCFS)

pdq.SetDemand("Window1", "Applicant", 20.0)
pdq.SetDemand("Window2", "Applicant", 600.0 * w2)
pdq.SetDemand("Window3", "Applicant", 300.0 * w3)
pdq.SetDemand("Window4", "Applicant", 60.0)

pdq.Solve(pdq.CANON)

pdq.Report()

#---------------------------------------------------------------------
