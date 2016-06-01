###############################################################################
#  Copyright (C) 2007 - 2013, Performance Dynamics Company                    #
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

# $Id: orca.R,v 1.2 2012/11/13 07:13:20 earl-lang Exp $

# Created by NJG on Thu, May 31, 2007
#
# Blair Zajac, author of Orca states:
# "If long term trends indicate increasing figures, more or faster CPUs
# will eventually be necessary unless load can be displaced. For ideal
# utilization of your CPU, the maximum value here should be equal to the
# number of CPUs in the box."
#
# Zajac's comment implies any waiting line is bad.
# PDQ steady-state model for HPC/batch workload with 
# stretch factor == 1 (no waiting line).
# Very low arrival rate over 10 hour period.


processors  <- 4
# jobs per hour (very low arrivals)
arrivalRate <- 0.099 
# hours (very long service time)
crunchTime  <- 10.0  

Init("ORCA LA Model")
CreateOpen("Crunch", arrivalRate)
CreateNode("HPCnode", processors, MSQ)
SetDemand("HPCnode", "Crunch", crunchTime)
SetWUnit("Jobs")
SetTUnit("Hour")
Solve(CANON)
Report()

