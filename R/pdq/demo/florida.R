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

#  $Id$

# florida.pl
require(pdq)

STEP <- 100
MAXUSERS <- 3000
think <- 10	   #seconds
srvt1 <- 0.0050    #seconds
srvt2 <- 0.0035    #seconds
srvt3 <- 0.0020    #seconds
Dmax <- srvt1
Rmin <- srvt1 + srvt2 + srvt3

# print the header ...
cat(sprintf("%5s\t%6s\t%6s\t%6s\t%5s\t%6s\t%6s\t%6s\n",
    "  N  ", "	X  ", "  Xlin ", " Xmax ",
    "  N  ", "	R  ", "  Rmin ", " Rinf "))

# iterate up to $MAXUSERS ...
for (users in as.numeric(seq(1,MAXUSERS))) {
    Init("Florida Model")
    CreateClosed("benchload", TERM, users, think)
    CreateNode("Node1", CEN, FCFS)
    CreateNode("Node2", CEN, FCFS)
    CreateNode("Node3", CEN, FCFS)
    SetDemand("Node1", "benchload", srvt1)
    SetDemand("Node2", "benchload", srvt2)
    SetDemand("Node3", "benchload", srvt3)

    Solve(APPROX)

    if ( (users == 1) || (users %% STEP == 0) ) {
	# print as TAB separated columns ...

	cat(sprintf("%5d\t%6.2f\t%6.2f\t%6.2f\t%5d\t%6.2f\t%6.2f\t%6.2f\n",
	    users,
	    GetThruput(TERM, "benchload"),
	    users / (Rmin + think),
	    1 / Dmax,
	    users,
	    GetResponse(TERM, "benchload"),
	    Rmin,
	    (users * Dmax) - think
	))
    }
}
