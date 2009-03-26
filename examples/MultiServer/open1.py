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

arrivalRate = 0.75
serviceTime = 1.0


#---- Initialize the system ------------------------------------------

pdq.Init("Open Center in PyDQ")
pdq.SetComment("This is just a simple M/M/1 queue.");


pdq.nodes = pdq.CreateNode("server", pdq.CEN, pdq.FCFS)

pdq.streams = pdq.CreateOpen("work", arrivalRate)
   
pdq.SetWUnit("Customers")
pdq.SetTUnit("Seconds")

pdq.SetDemand("server", "work", serviceTime)

pdq.Solve(pdq.CANON)


print "Using: %s" % pdq.cvar.version

pdq.Report()

#---------------------------------------------------------------------

