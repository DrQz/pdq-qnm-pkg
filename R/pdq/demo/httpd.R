###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company		      #
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

# httpd.pl

require(pdq)

clients <- 5
smaster <- 0.0109 #seconds
sdemon <- 0.0044 #seconds
work <- "homepage"
slave <- c("slave1", "slave2", "slave3", "slave4", "slave5",
"slave6", "slave7", "slave8", "slave9", "slave10",
"slave11", "slave12", "slave13", "slave14", "slave15",
"slave16")

Init("HTTPd Prefork")

CreateClosed(work, TERM, clients, 0.0)
CreateNode("master", CEN, FCFS)
SetDemand("master", work, smaster)

nslaves <- length(slave)
for( sname in slave) {
   CreateNode(sname, CEN, FCFS)
   SetDemand(sname, work, sdemon / nslaves)
}

Solve(EXACT)
Report()
