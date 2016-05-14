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

#
# traffeqnsPPA.py
#
# Created by NJG on Thu, Apr 19, 2007


from numpy import *
from numpy.linalg import solve


# Traffic equations from PPA p.95:
"""
L0 = 15.36/3600    ... external arrival rate into system
L1 = 0.3L0 + 0.1L3
L2 = 0.7L0 + 0.2L1
L3 = 0.8L1 + 0.9L2

Rearrange terms to produce matrix form:
  1.0L0 + 0.0L1 + 0.0L2 + 0.0L3 = 15.36/3600
- 0.3L0 + 1.0L1 - 0.1L2 + 0.0L3 = 0.0
- 0.7L0 - 0.2L1 + 1.0L2 + 0.0L3 = 0.0
  0.0L0 - 0.8L1 - 0.9L2 + 1.0L3 = 0.0
  
All diagonal coeffs should be 1.0
"""

# Don't need line continuation in arrays
a = array([[ 1.0, 0.0, 0.0, 0.0], 
           [-0.3, 1.0,-0.1, 0.0],
           [-0.7,-0.2, 1.0, 0.0],
           [ 0.0,-0.8,-0.9, 1.0]])

# RHS of the traffic eqns
b = array([15.36/3600,0.0,0.0,0.0])

# Solve the traffic eqns
L = solve(a,b)
print "Solution: ", L
print "Solution: ", L[0],L[1],L[2],L[3]
print "Check RHS:", dot(a,L)
print "Check L4: ", (0.8*L[1] + 0.9*L[2])

# Visit ratios
v = array([L[0]/L[0], L[1]/L[0], L[2]/L[0], L[3]/L[0]])
print "Visit ratios: ", v[0], v[1], v[2], v[3]

# Service times in seconds
S = array([20, 600, 300, 60])

# Service demands in seconds
D = array([v[0]*S[0], v[1]*S[1], v[2]*S[2], v[3]*S[3]])

# Utilizations: L_0 * D_k
r = array([L[0]*D[0], L[0]*D[1], L[0]*D[2], L[0]*D[3]])
print "Utilization:  ", r[0], r[1], r[2], r[3]

# Queue lengths
print "Q1: %6.2f" % (r[0] / (1 - r[0]))
print "Q2: %6.2f" % (r[1] / (1 - r[1]))
print "Q3: %6.2f" % (r[2] / (1 - r[2]))
print "Q4: %6.2f" % (r[3] / (1 - r[3]))
