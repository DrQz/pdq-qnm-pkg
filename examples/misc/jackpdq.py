#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company                    #
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
# A Python PDQ model of the SimPy simulator example 
# http://simpy.sourceforge.net/examples/Jackson%20network.htm
# which is a Jackson network comprising  3 queues and a set of branching 
# probabilities for the workflow. 
#
# Created by NJG on Thu Oct 28 10:16:59 PDT 2004
# Updated by NJG on Fri Oct 29 17:53:04 PDT 2004

import pdq
import sys 

class JackNet:
   """ Constructor for the queueing network to be solved """
   def __init__(self, netname, debugFlag):
      """ Globals should be contained :-)  """
      self.name = netname
      self.debugging = debugFlag
      self.arrivRate = 0.50
      self.work = "Traffic"
      self.router = ["Router1", "Router2", "Router3"]
      self.servTime = [1.0, 2.0, 1.0]
      self.routeP =[ # Table of routing probabilities 
	[0.0, 0.5, 0.5], 
	[0.0, 0.0, 0.8], 
	[0.2, 0.0, 0.0]
	]
      self.visitRatio = []
      self.GetVisitRatios()
      self.totalMsgs = 0
   def GetVisitRatios(self):
      """ Compute visit ratios from the traffic equations """
      # Traffic equations 
      lambda0 = self.arrivRate
      lambda3 = (1 + self.routeP[1][2]) * self.routeP[0][1] * lambda0 \
         / (1 - (1 + self.routeP[1][2]) * self.routeP[0][1] * self.routeP[2][0]) 
      lambda1 = lambda0 + (0.2 * lambda3) 
      lambda2 = 0.5 * lambda1 
      # Visit ratios 
      self.visitRatio.append(lambda1 / lambda0)
      self.visitRatio.append(lambda2 / lambda0)
      self.visitRatio.append(lambda3 / lambda0)
      if self.debugging:
         dbstr0 = "GetVisitRatios(self)"
         dbst1 = "Probs:  %5.4f %5.4f %5.4f" % \
            (self.routeP[0][1], self.routeP[1][2], self.routeP[2][0])
         dbstr2 = "Lambdas: %5.4f %5.4f %5.4f %5.4f" % (lambda1, \
            lambda2, lambda3, lambda0)
         dbstr3 = "Visits: %5.4f %5.4f %5.4f" % (self.visitRatio[0], \
            self.visitRatio[1], self.visitRatio[2]) 
         ShowState ("%s\n%s\n%s\n%s" % (dbstr0, dbst1, dbstr2, dbstr3))

def ShowState ( *L ):
    """ L is a list of strings.  Displayed by sys.stderr as concatenated 
        elements of L and then stops execution
    """
    sys.stderr.write ( "*** Trace state *** \n%s\n***\n" % "".join(L) )
    sys.exit(1)


# PDQ modeling code starts here ...
jNet = JackNet("SimPy Jackson Network", 0) # create an instance
pdq.Init(jNet.name)

# Create PDQ context and workload for the network
streams = pdq.CreateOpen(jNet.work, jNet.arrivRate)

# Create PDQ queues 
for i in range(len(jNet.router)):
   nodes = pdq.CreateNode(jNet.router[i], pdq.CEN, pdq.FCFS)
   pdq.SetVisits(jNet.router[i], jNet.work, jNet.visitRatio[i], \
      jNet.servTime[i])

pdq.SetWUnit("Msgs")
pdq.SetTUnit("Time")

# Solve the model and report the peformance measures
pdq.Solve(pdq.CANON)
pdq.Report(); # generic PDQ format

# Collect particular PDQ statistics
print "---------- Selected PDQ Metrics for SimPy Comparison ---------"
for i in range(len(jNet.router)):
   msgs = pdq.GetQueueLength(jNet.router[i], jNet.work, pdq.TRANS)
   print "Mean queue%d: %7.4f (%s)" % (i+1, msgs, "Not in SimPy report")
   jNet.totalMsgs += msgs
print "Mean number: %7.4f" % jNet.totalMsgs
print "Mean delay:  %7.4f %11s" % (pdq.GetResponse(pdq.TRANS, jNet.work), \
	"(Little's law Q = X R holds!)")
print "Mean stime:  %7.4f %11s" % (0, "(Not in this version of PyDQ)")
print "Mean rate:   %7.4f" % pdq.GetThruput(pdq.TRANS, jNet.work) 
#print "Max  rate:   %5.4f" % pdq.GetThruMax(pdq.TRANS, work) 
print "Max  rate:   %7.4f %11s" % (0, "(Not in this version of PyDQ)")

