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

MAXNODES = 1024
MAXBUF = 128
MAXSTREAMS = 64
MAXCHARS = 64
VOID = 0
OPEN = 1
CLOSED = 2

# Nodes
CEN = 3
DLY = 4
MSO = 5
MSC = 6
# Service disciplines
ISRV = 7
FCFS = 8
PSHR = 9
LCFS = 10
# Workload streams
TERM = 11
TRANS = 12
BATCH = 13
# Solution methods
EXACT = 14
APPROX = 15
CANON = 16
APPROXMSO=17

#Service Time and Demand Types
VISITS = 18
DEMAND = 19

#Solver Methods
EXACTMVA =  20 
APPROXMVA =  21 
STREAMING = 22
#Tolerance
TOL = 0.0010

loadModule("pdq",TRUE)
