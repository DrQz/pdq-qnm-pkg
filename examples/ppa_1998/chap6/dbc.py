#!/usr/bin/env python
# 
#  dbc.c - Teradata DBC-10/12 performance model
#  
#  PDQ calculation of optimal parallel configuration.
#  
#   $Id$
#
#---------------------------------------------------------------------

import pdq

#---------------------------------------------------------------------

def itoa(n, s):
   sign = n

   if (sign < 0):
      n = -n

   i = 0

   while (n > 0):
      # generate digits in reverse order
      s[i] = '0' + (n % 10)
      i += 1
      n /= 10

   if (sign < 0):
      s[i] = '-'
      i += 1

   s[i] = '\0'

   # reverse

   l = len(s)
   j = l - 1

   for i in range(l):
      c = s[i]
      s[i] = s[j]
      s[j] = c
      i += 1
      j -= 1
      if i >= j:
         break

#---------------------------------------------------------------------

think = 10.0
importrs = 300

Sifp  = 0.10
Samp  = 0.60
Sdsu  = 1.20
Nifp  = 15
Namp  = 50
Ndsu  = 100


pdq.Init("Teradata DBC-10/12")

# Create parallel centers

for k in range(Nifp):
   name = "IFP%d" % k
   nodes = pdq.CreateNode(name, pdq.CEN, pdq.FCFS)

for k in range(Namp):
   name = "AMP%d" % k
   nodes = pdq.CreateNode(name, pdq.CEN, pdq.FCFS)

for k in range(Ndsu):
   name = "DSU%d" % k
   nodes = pdq.CreateNode(name, pdq.CEN, pdq.FCFS)

streams = pdq.CreateClosed("query", pdq.TERM, importrs, think)

# pdq.SetGraph("query", 100) - unsupported call

for k in range(Nifp):
   name = "IFP%d" % k
   pdq.SetDemand(name, "query", Sifp / Nifp)

for k in range(Namp):
   name = "AMP%d" % k
   pdq.SetDemand(name, "query", Samp / Namp)

for k in range(Ndsu):
   name = "DSU%d" % k
   pdq.SetDemand(name, "query", Sdsu / Ndsu)

# 300 nodes takes about a minute to solve on a PowerMac

print("Solving ... ")

pdq.Solve(pdq.EXACT)

print("Done.\n")

# pdq.PrintXLS()

pdq.Report()

