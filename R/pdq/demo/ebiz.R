###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company		      #
#									      #
#  This software is licensed as described in the file COPYING, which	      #
#  you should have received as part of this distribution. The terms	      #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#									      #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is	      #
#  furnished to do so, under the terms of the COPYING file.		      #
#									      #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.					      #
###############################################################################

# From ebiz.pl
#
# $Id$

require(pdq)

model <- "Middleware"
work  <- "eBiz-tx"
node1 <- "WebServer"
node2 <- "AppServer"
node3 <- "DBMServer"
think <-  0.0 * 1e-3  # treat as free param

# Add dummy node names here
node4 <- "DummySvr"
users <- 10

Init(model)

CreateClosed(work, TERM, users, think)

CreateNode(node1, CEN, FCFS)
CreateNode(node2, CEN, FCFS)
CreateNode(node3, CEN, FCFS)
CreateNode(node4, CEN, FCFS)

#  NOTE: timebase is seconds
SetDemand(node1, work, 9.8 * 1e-3)
SetDemand(node2, work, 2.5 * 1e-3)
SetDemand(node3, work, 0.72 * 1e-3)

#  dummy (network) service demand
SetDemand(node4, work, 9.8 * 1e-3)

Solve(EXACT)
Report()
