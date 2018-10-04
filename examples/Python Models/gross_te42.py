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


# gross_te42.py
#
# Exercise 4.2 on p. 181 of Gross & Harris
# Solved using traffic eqns and NumPy, rather than PDQ-MSQ
#
# Created by NJG on Sun, Aug 26, 2007

import sys
from numpy import *
from numpy.linalg import solve


def ErlangR(arrivrate, servtime, servers):
	"Calculate the exact response time for an M/M/m node"
	erlangs  = arrivrate * servtime
	if (erlangs >= servers):
		print "%4.2f Erlangs saturates %d servers" % (erlangs, servers)
		sys.exit()

	rho     = erlangs / servers
	erlangB = erlangs / (1 + erlangs)
	
	for mm in range(2, servers+1):
		eb  = erlangB
		erlangB = eb * erlangs / (mm + (eb * erlangs))
	
	erlangC  = erlangB / (1 - rho + (rho * erlangB))	
	wtE = servtime * erlangC / (servers * (1 - rho))
	rtE = servtime + wtE	
	return(rtE)
	

# Traffic equations from Gross & Harris
"""
L0 = 35.0/60    ... external arrival rate in MINUTES into system
L1 = 0.55 L0 + 0.01 L2
L2 = 0.45 L0 + 0.02 L1

Rearrange terms to produce matrix form:
1.00 L0 + 0.00 L1 + 0.00 L2 = 35.0/60
0.55 L0 - 1.00 L1 + 0.01 L2 = 0.0
0.45 L0 + 0.02 L1 - 1.00 L2 = 0.0
  
All diagonal coeffs should be 1.0
"""

# Don't need line continuation in arrays
a = array([[1.00,  0.00,  0.00], 
           [0.55, -1.00,  0.01],
           [0.45,  0.02, -1.00]])

# RHS of the traffic eqns
b = array([35.0/60, 0.0, 0.0])

# Solve the traffic eqns
L = solve(a,b)
print "Solution:   ", L
print "Components: ", L[0],L[1],L[2]
print "Check RHS:  ", dot(a,L)
print "Check: L0=%6.4f == %6.4f\n" % (L[0], 0.98 * L[1] + 0.99 * L[2])

# Number of servers
m = array([1, 3, 7])
print "No. Servers:  %6d %6d %6d" % (m[0], m[1], m[2])

# Visit ratios
v = array([L[0]/L[0], L[1]/L[0], L[2]/L[0]])
print "Visit ratios:  %6.4f %6.4f %6.4f" % (v[0], v[1], v[2])

# Service times in minutes
S = array([0.5, 6, 20])

# Service demands in minutes
D = array([v[0] * S[0], v[1] * S[1], v[2] * S[2]])

# Utilizations: L_0 * D_k
r = array([L[0] * D[0] / m[0], L[0] * D[1] / m[1], L[0] * D[2] / m[2]])
print "Utilizations:  %6.4f %6.4f %6.4f" % (r[0], r[1], r[2])
print "Routing flows: %6.4f %6.4f %6.4f" % (m[0] * r[0], m[1] * r[1], m[2] * r[2])

# Queue lengths
print "Queue length1: %6.4f (Expected: 0.412)" % (L[0] * ErlangR(L[0], S[0], m[0]))
print "Queue length2: %6.4f (Expected: 2.706)" % (L[1] * ErlangR(L[1], S[1], m[1]))
print "Queue length3: %6.4f (Expected: 6.781)" % (L[2] * ErlangR(L[2], S[2], m[2]))
