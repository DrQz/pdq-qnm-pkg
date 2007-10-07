#!/usr/bin/env python
#
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#
#  fesc.pl -- Flow Equivalent Service Center model
#
#  Composite system is a closed circuit comprising N USERS
#  and a FESC submodel with a single-class workload.
#
#  This model is discussed on p.112 ff. of the book that accompanies
#  PDQ entitled: "The Practical Performance Analyst," by N.J.Gunther
#  and matches the results presented in the book: "Quantitative System
#  Performance," by Lazowska, Zahorjan, Graham, and Sevcik, Prentice-Hall
#  1984.
#
#  Id:
#

#----- Global variables ----------------------------------------------

USERS = 15
sm_x  = []   # [USERS + 1] -  submodel throughput characteristic

#*********************************************************************
#  Model specific variables
#*********************************************************************
#    int             j
#    int             n
#    int             max_pgm = 3
#    float           think = 60.0
#    float           xn
#    float           qlength
#    float           R
#    float           pq[USERS + 1][USERS + 1]
#    void            mem_model()
#
#
#*********************************************************************
#  Memory-limited Submodel
#*********************************************************************

max_pgm = 3
think   = 60.0
pq      = []
sm_x    = [ 0.0 ]

#---------------------------------------------------------------------

def mem_model(n, m):
   x = 0.0

   for i in range(1, n+2):
      if (i <= m):
         pdq.Init("")

         pdq.nodes = pdq.CreateNode("CPU", pdq.CEN, pdq.FCFS)
         pdq.nodes = pdq.CreateNode("DK1", pdq.CEN, pdq.FCFS)
         pdq.nodes = pdq.CreateNode("DK2", pdq.CEN, pdq.FCFS)

         pdq.streams = pdq.CreateClosed("work", pdq.TERM, i, 0.0)

         pdq.SetDemand("CPU", "work", 3.0)
         pdq.SetDemand("DK1", "work", 4.0)
         pdq.SetDemand("DK2", "work", 2.0)

         pdq.Solve(pdq.EXACT)

         x = pdq.GetThruput(pdq.TERM, "work")

         sm_x.append(x)
      else:
         sm_x.append(x) # last computed value

#*********************************************************************
#  Composite Model
#*********************************************************************

mem_model(USERS, max_pgm)

for i in range(0, USERS+1):
   #print "sm_x[%d] = %f" % (i, sm_x[i])
   r = [ 0.0 ]
   for j in range(1, USERS+1):
      r.append(0.0)
   pq.append(r)

pq[0][0] = 1.0

for n in range(1, USERS+1):
   R = 0.0  # reset

   # Response time at the FESC

   for j in range(1, n+1):
      R += (j / (sm_x[j]) * pq[j - 1][n - 1])
   
   # Thruput and queue-length at the FESC

   xn = n / (think + R)
   qlength = xn * R
   
   # Compute queue-length distribution at the FESC


   for j in range(1,n+1):
      pq[j][n] = (xn / sm_x[j]) * pq[j - 1][n - 1]
   
   pq[0][n] = 1.0

   for j in range(1, n+1):
      pq[0][n] -= pq[j][n]

#*********************************************************************
#  Report FESC Measures
#*********************************************************************

print
print "Max Users: %2d" % USERS
print "X at FESC: %3.4f" % xn
print "R at FESC: %3.2f" % R
print "Q at FESC: %3.2f\n" % qlength

# Joint Probability Distribution
print "QLength\t\tP(j | n)"
print "-------\t\t--------"

for n in range(0, USERS+1):
   print " %2d\t\tp(%2d|%2d): %3.4f" % (n, n, USERS, pq[n][USERS])

