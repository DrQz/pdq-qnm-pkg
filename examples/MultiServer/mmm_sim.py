#!/usr/bin/env python

"""MMC.py

An M/M/c queue

Jobs arrive at random into a c-server queue with
exponential service-time distribution. Simulate to
determine the average  number and the average time
in the system. 

- c = Number of servers = 3
- rate = Arrival rate = 2.0
- stime = mean service time = 1.0

"""
from SimPy.Simulation import *
from random import expovariate,seed

## Model components ------------------------

class Generator(Process):
    """ generates Jobs at random """

    def execute(self,maxNumber,rate,stime):
        ''' generate Jobs at exponential intervals '''
        for i in range(maxNumber):
            L = Job("Job "+`i`)
            activate(L,L.execute(stime),delay=0)
            yield hold,self,expovariate(rate)
 

class Job(Process):
    ''' Jobs request a gatekeeper and hold
        it for an exponential time '''
        
    NoInSystem=0
    def execute(self,stime):       
        arrTime=now()
        self.trace("Hello World")
        Job.NoInSystem +=1
        m.observe(Job.NoInSystem)
        yield request,self,server
        self.trace("At last    ")
        t = expovariate(1.0/stime)
        msT.observe(t)
        yield hold,self,t
        yield release,self,server
        Job.NoInSystem -=1
        m.observe(Job.NoInSystem)
        mT.observe(now()-arrTime)
        self.trace("Geronimo   ")
       
    def trace(self,message):
        FMT="%7.4f %6s %10s (%2d)"
        if TRACING:
            print FMT%(now(),self.name,message,Job.NoInSystem)

## Experiment data -------------------------

TRACING = False
c = 3           ## number of servers in M/M/c system
stime = 1.0     ## mean service time
rate  = 2.0     ## mean arrival rate 
maxNumber= 1000
m   =Monitor()  ## monitor for the number of jobs
mT  =Monitor()  ## monitor for the time in system
msT =Monitor()  ## monitor for the generated service times

seed(333555777) ## seed for random numbers


server=Resource(capacity=c,name='Gatekeeper')


## Model/Experiment ------------------------------

initialize()
g = Generator('gen')
activate(g,g.execute(maxNumber=maxNumber, rate=rate, stime=stime))
simulate(until=3000.0)


## Analysis/output -------------------------

print 'mmm_sim'
print "Num. servers: %d" % (c)
print "Arrival rate: %6.4f" % (rate)
print "service time: %6.4f" % (stime)
print "Average number in the system: %6.4f"%(m.timeAverage(),)
print "Average time in the system:   %6.4f"%(mT.mean(),)
print "Actual average service-time:  %6.4f"%(msT.mean(),)

