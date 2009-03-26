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
# gross_te43.py
#
# Exercise 4.3 on p. 182 of Gross & Harris
# Same parameters as Ex. 4.2 but with 2 workload classes
# Solve traffic eqns using NumPy, rather than PDQ-MSQ
#
# Created by NJG on Sun, Aug 26, 2007
# Updated by NJG on Mon, Aug 27, 2007

import sys
from numpy import *
from numpy.linalg import solve
	

def ErlangC(servers, erlangs):
	if (erlangs >= servers):
		print "Error: %4.2f Erlangs > %d servers" % (erlangs, servers)
		sys.exit()

	rho     = erlangs / servers
	erlangB = erlangs / (1 + erlangs)
	
	for mm in range(2, servers+1):
		eb  = erlangB
		erlangB = eb * erlangs / (mm + (eb * erlangs))
	
	erlangC  = erlangB / (1 - rho + (rho * erlangB))	
	return(erlangC)


# Traffic equations
"""
Let subscript 'a' denote type-1 customers and 'b' type-2 customers.
L = 35    ... external arrival rate per HOUR

The traffic equations can be obtained from the R matrices in G&H by 
reading each column vertically in the order 1,2,3. 

From the R_(1) matrix we get:
La1 = 0.00 La1 + 0.00 La2 + 0.00 La3 = 0.55 L
La2 = 1.00 La1 + 0.00 La2 + 0.00 La3
La3 = 0.00 La1 + 0.02 La2 + 0.00 La3

Rearrange terms to produce the Aa coefficient matrix below:
1.00 La1 + 0.00 La2 + 0.00 La3 = 0.55 L
1.00 La1 - 1.00 La2 + 0.00 La3 = 0.0
0.00 La1 + 0.02 La2 - 1.00 La3 = 0.0

Similary, from the R_(2) matrix we get:
La1 = 0.00 La1 + 0.00 La2 + 0.00 La3 = 0.45 L
La2 = 0.00 La1 + 0.00 La2 + 0.01 La3
La3 = 1.00 La1 + 0.02 La2 + 0.00 La3

which, on rearragement gives for Ab below:
1.00 La1 + 0.00 La2 + 0.00 La3 = 0.45 L
0.00 La1 - 1.00 La2 + 0.01 La3 = 0.0
1.00 La1 + 0.02 La2 - 1.00 La3 = 0.0

"""
# Matices of coeffs 
Aa = array([[1.00,  0.00,  0.00], 
            [1.00, -1.00,  0.00],
            [0.00,  0.02, -1.00]])

Ab = array([[1.00,  0.00,  0.00], 
            [0.00, -1.00,  0.01],
            [1.00,  0.00, -1.00]])

# Fraction of total traffic L going to 'a' and 'b' streams
fLa = 0.55 * 35 
fLb = 0.45 * 35            

# RHS of the traffic eqns
Ba = array([fLa, 0.0, 0.0])
Bb = array([fLb, 0.0, 0.0])

# Solve the traffic eqns for the local arrivals
La = solve(Aa, Ba)
Lb = solve(Ab, Bb)

print "Arrival ratesA: %7.4f %7.4f %7.4f" % (La[0], La[1], La[2])
print "Arrival ratesB: %7.4f %7.4f %7.4f" % (Lb[0], Lb[1], Lb[2])

# Server capacity
m = array([1, 3, 7])
print "Server cap:   %7d %7d %7d" % (m[0], m[1], m[2])

# Visit ratios (v_kc = L_kc / Lc)
va = array([La[0]/fLa, La[1]/fLa, La[2]/fLa])
vb = array([Lb[0]/fLb, Lb[1]/fLb, Lb[2]/fLb])
print "Visit ratioA:   %7.4f %7.4f %7.4f" % (va[0], va[1], va[2])
print "Expected V_a:   %7.4f %7.4f %7.4f" % (19.25/fLa, 19.25/fLa, 0.385/fLa)
print "Visit ratioB:   %7.4f %7.4f %7.4f" % (vb[0], vb[1], vb[2])
print "Expected V_b:   %7.4f %7.4f %7.4f" % (15.75/fLb, 0.1575/fLb, 15.75/fLb)

# Service demands in HOURS (same for both classes at each node)
S = array([0.5/60, 6.0/60, 20.0/60])
Da = array([va[0] * S[0], va[1] * S[1], va[2] * S[2]])
Db = array([vb[0] * S[0], vb[1] * S[1], vb[2] * S[2]])

# Total utilization per server
rho = array([La[0]*Da[0] + Lb[0]*Db[0], (La[1]*Da[1] + Lb[1]*Db[1])/m[1], (La[2]*Da[2] + Lb[2]*Db[2])/m[2]])
print "Utilizations:   %7.4f %7.4f %7.4f" % (rho[0], rho[1], rho[2])

# Queue lengths
Q0 = m[0]*rho[0] + ErlangC(m[0], m[0]*rho[0]) * (rho[0]/(1 - rho[0]))
Q1 = m[1]*rho[1] + ErlangC(m[1], m[1]*rho[1]) * (rho[1]/(1 - rho[1]))
Q2 = m[2]*rho[2] + ErlangC(m[2], m[2]*rho[2]) * (rho[2]/(1 - rho[2]))

#print "Queue length1 : %7.4f (Expected: 0.412)" % (rho[0] / (1 - rho[0]))
#print "Queue length1a: %7.4f (Expected: 0.227)" % (La[0] * Da[0] / (1 - rho[0]))
print "Queue length1 : %7.4f (Expected: 0.412)" % (Q0)
print "Queue length2 : %7.4f (Expected: 2.705)" % (Q1)
print "Queue length3 : %7.4f (Expected: 6.777)" % (Q2)

print "Queue length1a: %7.4f (Expected: 0.227)" % (Q0 * (La[0]/(La[0]+Lb[0])))
print "Queue length2a: %7.4f (Expected: 2.683)" % (Q1 * (La[1]/(La[1]+Lb[1])))
print "Queue length3a: %7.4f (Expected: 0.162)" % (Q2 * (La[2]/(La[2]+Lb[2])))

print "Queue length1b: %7.4f (Expected: 0.185)" % (Q0 * (Lb[0]/(La[0]+Lb[0])))
print "Queue length2b: %7.4f (Expected: 0.022)" % (Q1 * (Lb[1]/(La[1]+Lb[1])))
print "Queue length3b: %7.4f (Expected: 6.616)" % (Q2 * (Lb[2]/(La[2]+Lb[2])))



