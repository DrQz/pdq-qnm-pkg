#!/usr/bin/env python
#
#  mva.pl - Mean Value Analysis algorithm for single class workload
# 
#  $Id$
#
#  Example:
#
#---------------------------------------------------------------------

MAXK = 6  # max. service centers + 1   

# double          D[MAXK]        // service demand at center k
# double          R[MAXK]        // residence time at center k
# double          Q[MAXK]        // no. customers at center k
# double          Z              // think time (0 for batch system)
# int             K              // no. of queueing centers 
# int             N              // no. of customers

#---------------------------------------------------------------------

K = 0
N = 0
Z = 0

D = []

#---------------------------------------------------------------------

def mva():
   Q = []
   R = []

   for k in range(K):
      Q.append(0.0)
      R.append(0.0)

   for n in range(N):
      for k in range(K):
         R[k] = D[k] * (1.0 + Q[k])

      s = Z

      for k in range(K):
         s += R[k]

      X = (n+1 / s)

      for k in range(K):
         Q[k] = X * R[k]

   print " k    Rk     Qk    Uk"

   for k in range(K):
      print "%2d%9.3f%7.3f%7.3f" % (k+1, R[k], Q[k], X * D[k])

   print "N %d  X %f  Z %f" % (N, X, Z)
   print "X = %7.4f, R = %9.3f" % (X, ((N / X) - Z))

#---------------------------------------------------------------------

while (1):
   print "\n(Hit RETURN to exit)\n"
   line = raw_input("Enter no. of centers (K): ")

   line.strip()

   if len(line) == 0:
      break
   else:
      K = int(line)

   for k in range(K):
      s = "Enter demand at center %d (D[%d]): " % (k+1, k+1)

      line = raw_input(s)

      D.append(int(line.strip()))

   line = raw_input("Enter think time (Z):")

   Z = int(line.strip())

   while (1):
      print "\n(Hit RETURN to stop)\n"
      line = raw_input("Enter no. of terminals (N): ")

      if len(line) == 0:
         break
      else:
         N = int(line.strip())
         mva()

#---------------------------------------------------------------------

