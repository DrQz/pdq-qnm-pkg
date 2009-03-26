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

import sys
import pdq

#---------------------------------------------------------------------
# 
#  repair.c
#  
#  Exact solution for M/M/m/N/N repairmen model.
#  
#  Created by NJG: 17:45:47  12-19-94 Updated by NJG: 16:45:35  02-26-96
#  
#  Id: repair.c,v 1.1.1.1 2002/09/26 07:48:49 njg Exp 
#


#---------------------------------------------------------------------
#   double          L      /* mean number of broken machines in line */
#   double          Q      /* mean number of broken machines in
#                            * system */
#   double          R      /* mean response time */
#   double          S      /* mean service time */
#   double          U      /* total mean utilization */
#   double          rho    /* per server utilization */
#   double          W      /* mean time waiting for repair */
#   double          X      /* mean throughput */
#   double          Z      /* mean time to failure (MTTF) */
#   double          p      /* temp variable for prob calc. */
#   double          p0     /* prob if zero breakdowns */
#
#   long            m      /* Number of servicemen */
#   long            N      /* Number of machines */
#   long            k      /* loop index */
#
#   Example:
# 
#     repair.pl 5 1 20 50
#


if len(sys.argv) != 5:
   print "Usage: repair m S N Z"
   sys.exit(1)

m = int(sys.argv[1])
S = float(sys.argv[2])
N = int(sys.argv[3])
Z = float(sys.argv[4])

p = p0 = 1.0
L = 0.0

Q = 0.0
X = 0.0
U = 0.0

for k in range(1, N+1):
   p *= (N - k + 1) * S / Z

   if (k <= m):
      p /= k
   else:
      p /= m

   p0 += p

   if (k > m):
      L += p * (k - m)

p0  = 1.0 / p0
L  *= p0
W   = L * (S + Z) / (N - L)
R   = W + S
X   = N / (R + Z)
U   = X * S
rho = U / m
Q   = X * R

#---------------------------------------------------------------------

print "\n"
print "  M/M/%ld/%ld/%ld Repair Model" % (m, N, N)
print "  ----------------------------"
print "  Machine pop:      %4d" % N
print "  MT to failure:    %9.4f" % Z
print "  Service time:     %9.4f" % S
print "  Breakage rate:    %9.4f" % (1.0 / Z)
print "  Service rate:     %9.4f" % (1.0 / S)
print "  Utilization:      %9.4f" % U
print "  Per Server:       %9.4f" % rho
print "  \n"
print "  No. in system:    %9.4f" % Q
print "  No in service:    %9.4f" % U
print "  No.  enqueued:    %9.4f" % (Q - U)
print "  Waiting time:     %9.4f" % (R - S)
print "  Throughput:       %9.4f" % X
print "  Response time:    %9.4f" % R
print "  Normalized RT:    %9.4f" % (R / S)
print "  \n"

#---------------------------------------------------------------------

