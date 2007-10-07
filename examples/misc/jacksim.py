#!/usr/bin/env python
#
# Modifications by NJG on Mon Oct 25 10:17:23 PDT 2004
# - Run for 10000 steps
# - Monitor queue lengths
#
# jacksonnetwork.py:  Jackson network Littles law (pyt090b.py)
# see sms090b.tex for simscript version
#        $Author$              $Revision$
#        $Date$ 

__version__= '$Revision$ $Date$'
"""
  Messages arrive randomly at rate $\lambda=1.5$ per unit time at a
  communication network with 3 nodes (computers). Each computer can
  queue messages and service-times are exponential with mean $m_i$ at
  node $i$. These values are given in the column headed $n_i$ in the
  table below.  On service at a node a message transfers to one of the
  other nodes or leaves the system. The probability of a transfer from
  node $i$ to node $j$ is $p_ij$. Node $4$ means outside the system so
  a message will transfer out of the system from node $i$ with
  probability $pi4$.

 LATEX PICTURE HERE
   
These probabilities are given in the following table.
  \begin{center}
     \begin{tabular}[t]{cccccc}
    Node   &  $m_i$ & $p_i1$  & $p_i2$ & $p_i3$  &  $p_i4$  \\
     $i$   &        &         &        &         & (leave)   \\
     1     &  1.0   &   0     & 0.5    &   0.5   &  0     \\
     2     &  2.0   &   0     & 0      &   0.8   &  0.2   \\
     3     &  1.0   &   0.2   & 0      &   0     &  0.8  
  \end{tabular}
  \end{center}
   
  Your task is to estimate the average time taken for jobs going
  through the system and the average number of jobs in the system.
  Does Little's Law hold for the network?  Run 10000 messages through
  the system to make these observations.  
"""


from __future__ import generators
from SimPy.Simulation import *
from random import Random,expovariate,uniform
import unittest
from random import Random,expovariate,uniform


def sum(P):
    """ Sum of the real vector P """
    sumP = 0.0
    for i in range(len(P)): sumP += P[i]
    return (sumP)


def choose1d(P,g):
    """  return a random choice from a set j = 0..n-1
       with probs held in list P[j]
       g = random variable
       call:  next = choose1d(P,g)
    """
    U = g.random()
    sumP = 0.0
    for j in range(len(P)):  # j = 0..n-1
        sumP +=  P[j]
        if U < sumP: break
    return(j)

def choose2dA(i,P,g):
    """  return a random choice from a set j = 0..n-1
       with probs held in list of lists P[j] (n by n)
       using row i
       g = random variable
       call:  next = choose2d(i,P,g)
    """
    U = g.random()
    sumP = 0.0
    for j in range(len(P[i])):  # j = 0..n-1
        sumP +=  P[i][j]
        if U < sumP: break
    return(j)

def choose2d(i,P,g):
    """  return a random choice from a set j = 0..n-1
       with probs held in list of lists P[j] (n by n)
       using row i
       g = random variable
       call:  next = choose2d(i,P,g)
    """
    return(choose1d(P[i],g))

## -----------------------------------------------
class Msg(Process):
    """a message"""
    def __init__(self,i,node):
        Process.__init__(self)
        self.i = i
        self.node = node

    def execute(self):
        """ executing a message """
        global noInSystem
        startTime = now()
        noInSystem += 1
        ##print "DEBUG noInSystm = ",noInSystem
        NoInSystem.accum(noInSystem)
        self.trace("Arrived node  %d"%(self.node,))
        while self.node <> 3:
            yield request,self,processor[self.node]
            self.trace("Got processor %d"%(self.node,))
            st = Mrv.expovariate(1.0/mean[self.node])
            Stime.tally(st)
            yield hold,self,st
            yield release,self,processor[self.node]
            self.trace("Finished with %d"%(self.node,))
            self.node = choose2dA(self.node,P,Mrv)
            self.trace("Transfer to   %d"%(self.node,))
        TimeInSystem.tally(now()-startTime)        
        self.trace(    "leaving       %d"%(self.node,),noInSystem)
        noInSystem -= 1
        NoInSystem.accum(noInSystem)
        
    def trace(self,message,nn=0):
        if MTRACING: print "%7.4f %3d %10s %3d"%(now(),self.i, message,nn)
            

## -----------------------------------------------
class Generator(Process):
 """ generates a sequence of msgs """    
 def __init__(self, rate,maxT,maxN):
     Process.__init__(self)
     self.name = "Generator"
     self.rate = rate
     self.maxN = maxN
     self.maxT = maxT
     self.g = Random(11335577)
     self.i = 0
     
 def execute(self):
     while (now() < self.maxT)  & (self.i < self.maxN):
         self.i+=1
         p = Msg(self.i,startNode)
         activate(p,p.execute())
         ## self.trace("starting "+p.name)
         yield hold,self,self.g.expovariate(self.rate)
     self.trace("generator finished with "+`self.i`+" ========")
     self.stopSim()
     
 def trace(self,message):
     if GTRACING: print "%7.4f \t%s"%(now(), message)

## -----------------------------------------------
print __version__
# generator:
GTRACING = 0
# messages:
rate = 0.5
noInSystem = 0
MTRACING = 1
startNode = 0
maxNumber = 10000
maxTime = 100000.0
Mrv = Random(77777)
TimeInSystem=Monitor()
NoInSystem= Monitor()
Stime = Monitor()

#processor = [Resource(1),Resource(1),Resource(1)]
processor = [
   Resource(capacity=1, monitored=True),
   Resource(capacity=1, monitored=True), 
   Resource(capacity=1, monitored=True)
]
mean=[1.0, 2.0, 1.0]
P = [[0, 0.5, 0.5, 0],[0,0,0.8,0.2], [0.2,0,0,0.8]]

initialize()
g = Generator(rate,maxTime,maxNumber)
activate(g,g.execute())
## NJG time
simulate(until=20000.0)

print "Mean queue1 = %8.4f"%(processor[0].actMon.timeAverage() + 
   processor[0].waitMon.timeAverage(),)
print "Mean queue2 = %8.4f"%(processor[1].actMon.timeAverage() +  
  processor[1].waitMon.timeAverage(),)
print "Mean queue3 = %8.4f"%(processor[2].actMon.timeAverage() +  
  processor[2].waitMon.timeAverage(),)
print "Mean number = %8.4f"%(NoInSystem.timeAverage(),)
print "Mean delay  = %8.4f"%(TimeInSystem.mean(),)
print "Mean stime  = %8.4f"%(Stime.mean(),)
print "Mean thrupt = %8.4f"%(TimeInSystem.count()/now(),)

print "Total jobs  = %8d"%(TimeInSystem.count(),)
print "Total time  = %8.4f"%(now(),)
