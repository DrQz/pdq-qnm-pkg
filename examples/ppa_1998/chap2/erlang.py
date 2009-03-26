#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 1996, Performance Dynamics Company                    #
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
#  erlang.c
#
#  Created by NJG: 15:06:09  06-27-96
#
#  $Id$
#
#---------------------------------------------------------------------

# double          erlangB;
# double          erlangC;
# double          traffic;
# double          eb, rho, nrt, ql;
# long            m, servers;


#---- inputs ---------------------------------------------------------

# if ($argc < 3) {
# 	printf("Usage: %s servers traffic\n", argv[0]);
# 	printf("NOTE:Per server load = traffic/servers\n");
# 	exit(1);
# }

#----- initialize variables ------------------------------------------

# servers = atol(*++argv);
# traffic = atof(*++argv);

servers    = 5;
traffic    = 123.39;
rho        = traffic / servers;
erlangB    = traffic / (1 + traffic);

#----- Jagerman's algorithm ------------------------------------------

for m in range(2, servers+1):
   eb      = erlangB
   erlangB = eb * traffic / (m + eb * traffic)

erlangC    = erlangB / (1 - rho + rho * erlangB)
nrt        = 1 + erlangC / (servers * (1 - rho))
ql         = traffic * nrt

#----- outputs -------------------------------------------------------

print "  %ld Server System" % servers
print "  -----------------"
print "  Traffic intensity:  %5.5lf" % traffic
print "  Server utilization: %5.5lf" % rho
print "  "
print "  Erlang B  (loss  prob): %5.5lf" % erlangB
print "  Erlang C  (queue prob): %5.5lf" % erlangC
print "  M/M/m    Normalized RT: %5.5lf" % nrt
print "  M/M/m    No. in System: %5.5lf" % ql

#---------------------------------------------------------------------

