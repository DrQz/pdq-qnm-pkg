#! /usr/bin/env python
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
# erlang.py
#
# Created by NJG on Mon, Aug 27, 2007


def ErlangR(arate, stime, servers):
	"Calculate the exact response time for an M/M/m node"
	erlangs  = arate * stime
	if (erlangs >= servers):
		print "Error: %4.2f Erlangs > %d servers" % (erlangs, servers)
		sys.exit()

	rho     = erlangs / servers
	erlangB = erlangs / (1 + erlangs)
	
	for mm in range(2, servers+1):
		eb  = erlangB
		erlangB = eb * erlangs / (mm + (eb * erlangs))
	
	erlangC  = erlangB / (1 - rho + (rho * erlangB))	
	wtE = stime * erlangC / (servers * (1 - rho))
	rtE = stime + wtE	
	return(rtE)
	


