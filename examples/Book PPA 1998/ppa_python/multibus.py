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
#  multibus.c
#  
#  Created by NJG: 13:03:53  07-19-96 Updated by NJG: 19:31:12  07-31-96
#  
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#---------------------------------------------------------------------

# System parameters

BUSES  =   9
CPUS   =  64
STIME  =   1.0
COMPT  =  10.0

# submodel throughput characteristic

pq   = []
sm_x = [ 0.0 ]

#---------------------------------------------------------------------

def multiserver(m, stime):
   work = "reqs"
   node = "bus"

   x = 0.0

   for i in range(1, CPUS+1):
      if (i <= m):
         pdq.Init("multibus")

         streams = pdq.CreateClosed(work, pdq.TERM, i, 0.0)
         nodes   = pdq.CreateNode(node, pdq.CEN, pdq.ISRV)

         pdq.SetDemand(node, work, stime)
         pdq.Solve(pdq.EXACT)

         x = pdq.GetThruput(pdq.TERM, work)

         sm_x[i] = x
      else:
         sm_x[i] = x
      # print "*>> %2d  %f" % (i, x)

#---------------------------------------------------------------------

# print "multibus.out"

for i in range(0, CPUS+1):
   sm_x.append(0.0)
   r = [ 0.0 ]
   for j in range(1, CPUS+1):
      r.append(0.0)
   pq.append(r)
   # print "sm_x[%d] = %f" % (i, sm_x[i])

#----- Multibus submodel ---------------------------------------------

multiserver(BUSES, STIME)

#----- Composite model -----------------------------------------------

pq[0][0] = 1.0

for n in range(1, CPUS+1):
   R = 0.0         # reset

   for j in range(1, n+1):
      h  = (float(j) / sm_x[j]) * pq[j - 1][n - 1]
      R += h
      # print "%2d  sm_x[%d] %f  h %f  R %f" % (j, j, sm_x[j], h, R)

   xn = float(n) / (COMPT + R)

   # print "xn %f  n %2d  COMPT+R %f" % (xn, n, (COMPT + R))

   qlength = xn * R

   # print "qlength %f" % qlength

   for j in range(1, n+1):
      pq[j][n] = (xn / sm_x[j]) * pq[j - 1][n - 1]
      # print "pq[%02d][%02d] %f" % (j, n, pq[j][n])

   pq[0][n] = 1.0

   for j in range(1, n+1):
      pq[0][n] -= pq[j][n]
      # print "pq[0][%02d] %f  pq[%02d][%02d] %f" % (n, pq[0][n], j, n, pq[j][n])

#----- Processing Power ----------------------------------------------

print "Bimports:%2d, CPUs:%2d" % (BUSES, CPUS)
print "Load %3.4f" % (STIME / COMPT)
print "X at FESC: %3.4f" % xn
print "P %3.4f" % (xn * COMPT)

#---------------------------------------------------------------------

