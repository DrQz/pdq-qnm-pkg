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
# open1msq.py
#
# Created by NJG on Fri, Apr 13, 2007 (test MSQ vs. M/M/1 in PyDQ)
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

arrivalRate = 0.75
serviceTime = 1.0

pdq.Init("Open1 MSQ Test")
pdq.SetComment("Cf. M/M/1/FCFS against MSQ with m=1 in PyDQ.");
   
pdq.streams = pdq.CreateOpen("work", arrivalRate)

pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")

pdq.nodes = pdq.CreateNode("MM1", pdq.CEN, pdq.FCFS)
pdq.nodes = pdq.CreateNode("MMm", 1, pdq.MSQ)

pdq.SetDemand("MM1", "work", serviceTime)
pdq.SetDemand("MMm", "work", serviceTime)

pdq.Solve(pdq.CANON)


print "Using: %s" % pdq.version

pdq.Report()

#---------------------------------------------------------------------

