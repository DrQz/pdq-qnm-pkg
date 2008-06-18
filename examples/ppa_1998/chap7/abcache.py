#!/usr/bin/env python
#
#  abcache.py  -  Cache protocol scaling
#  
#  Created by NJG: 13:03:53  07-19-96 Revised by NJG: 18:58:44  04-02-99
#  
#  $Id$
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

   # reverse order of bytes

   l = len(s)
   j = l - 1

   for i in range(l):
      c = s[i]
      s[i] = s[j]
      s[j] = c
      i += 1
      j -= 1
      if (i > j):
         break

#---------------------------------------------------------------------

def intwt(N):
   if (N < 1.0):
      i = 1
      W = N

   if (N >= 1.0):
      i = int(N)
      W = 1.0

   return (i, W)

#---------------------------------------------------------------------

# Main memory update policy

WBACK   =  1

# Globals

MAXCPU  =   15
ZX      =  2.5

# Cache parameters

RD      =  0.85
WR      =  (1 - RD)

HT      =  0.95
WUMD    =  0.0526
MD      =  0.35

# Bus and L2 cache ids

L2C     = "L2C"
BUS     = "MBus"

# Aggregate cache traffic

RWHT    = "RWhit"
gen     =  1.0

# Bus Ops

RDOP    = "Read"
WROP    = "Write"
INVL    = "Inval"

model   = "abcache"

# per CPU intruction stream intensity

Prhit = (RD * HT)
Pwhit = (WR * HT * (1 - WUMD)) + (WR * (1 - HT) * (1 - MD))
Prdop = RD * (1 - HT)
Pwbop = WR * (1 - HT) * MD
Pwthr = WR
Pinvl = WR * HT * WUMD

Nrwht = 0.8075 * MAXCPU
Nrdop = 0.0850 * MAXCPU
Nwthr = 0.15 * MAXCPU

Nwbop = 0.0003 * MAXCPU * 100
Ninvl = 0.015 * MAXCPU

Srdop = (20.0)
Swthr = (25.0)
Swbop = (20.0)

Wrwht = 0.0
Wrdop = 0.0
Wwthr = 0.0
Wwbop = 0.0
Winvl = 0.0

Zrwht = ZX
Zrdop = ZX
Zwbop = ZX
Zinvl = ZX
Zwthr = ZX

Xcpu = 0.0
Pcpu = 0.0
Ubrd = 0.0
Ubwr = 0.0
Ubin = 0.0
Ucht = 0.0
Ucrd = 0.0
Ucwr = 0.0
Ucin = 0.0


#---------------------------------------------------------------------

pdq.Init("ABC Model")

#----- Create single bus queueing center -----------------------------

nodes = pdq.CreateNode(BUS, pdq.CEN, pdq.FCFS)

#----- Create per CPU cache queueing centers -------------------------

for i in range(MAXCPU):
   cname = "%s%d" % (L2C, i)
   nodes = pdq.CreateNode(cname, pdq.CEN, pdq.FCFS)

#----- Create CPU nodes, workloads, and demands ----------------------

(no, Wrwht) = intwt(Nrwht)

print "no %d %f  Nrwht %d, Wrwht %d" % (no, no, Nrwht, Wrwht)

for i in range(no):
   wname   = "%s%d" % (RWHT, i)

   streams = pdq.CreateClosed(wname, pdq.TERM, Nrwht, Zrwht)

   cname   = "%s%d" % (L2C, i)

   pdq.SetDemand(cname, wname, 1.0)
   pdq.SetDemand(BUS, wname, 0.0)       # no bus activity

   print "i %2d  cname %10s  nodes %2d  streams %d" % (i, cname, nodes, streams)

(no, Wrdop) = intwt(Nrdop)

print "no %d  Nrdop %d, Wrdop %d" % (no, Nrdop, Wrdop)

for i in range(no):
   wname   = "%s%d" % (RDOP, i)

   streams = pdq.CreateClosed(wname, pdq.TERM, Nrdop, Zrdop)

   cname   = "%s%d" % (L2C, i)

   pdq.SetDemand(cname, wname, gen)    # generate bus request
   pdq.SetDemand(BUS, wname, Srdop)    # req + async data return

   print "i %2d  cname %10s  nodes %2d  streams %d" % (i, cname, nodes, streams)

if (WBACK):
   (no, Wwbop) = intwt(Nwbop)

   for i in range(no):
      wname   = "%s%d" % (WROP, i)

      streams = pdq.CreateClosed(wname, pdq.TERM, Nwbop, Zwbop)

      cname   = "%s%d" % (L2C, i)

      pdq.SetDemand(cname, wname, gen)
      pdq.SetDemand(BUS, wname, Swbop)      # asych write to memory ?
else:  # write-thru
   (no, Wwthr) = intwt(Nwthr)

   for i in range(no):
      wname   = "%s%d" % (WROP, i)

      streams = pdq.CreateClosed(wname, pdq.TERM, Nwthr, Zwthr)

      cname   = "%s%d" % (L2C, i)

      pdq.SetDemand(cname, wname, gen)
      pdq.SetDemand(BUS, wname, Swthr)

if (WBACK):
   (no, Winvl) = intwt(Ninvl)

   for i in range(no):
      wname   = "%s%d" % (INVL, i)

      streams = pdq.CreateClosed(wname, pdq.TERM, Ninvl, Zinvl)

      cname   = "%s%d" % (L2C, i)

      pdq.SetDemand(cname, wname, gen)   # gen + intervene
      pdq.SetDemand(BUS, wname, 1.0)

#---------------------------------------------------------------------

pdq.Solve(pdq.APPROX)

#----- Bus utilizations ----------------------------------------------

(no, Wrdop) = intwt(Nrdop)

for i in range(no):
   wname   = "%s%d" % (RDOP, i)

   Ubrd += pdq.GetUtilization(BUS, wname, pdq.TERM)

Ubrd *= Wrdop

if (WBACK):
   (no, Wwbop) = intwt(Nwbop)

   for i in range(no):
      wname   = "%s%d" % (WROP, i)

      Ubwr += pdq.GetUtilization(BUS, wname, pdq.TERM)

   Ubwr *= Wwbop

   (no, Winvl) = intwt(Ninvl)

   for i in range(no):
      wname   = "%s%d" % (INVL, i)

      Ubin += pdq.GetUtilization(BUS, wname, pdq.TERM)

   Ubin *= Winvl
else:  # write-thru
   (no, Wwthr) = intwt(Nwthr)

   for i in range(no):
      wname   = "%s%d" % (WROP, i)

      Ubwr += pdq.GetUtilization(BUS, wname, pdq.TERM)

   Ubwr *= Wwthr

#----- Cache measures at CPU[0] only ---------------------------------

i     = 0
cname = "%s%d" % (L2C, i)

wname = "%s%d" % (RWHT, i)
Xcpu  = pdq.GetThruput(pdq.TERM, wname) * Wrwht
Pcpu += Xcpu * Zrwht
Ucht  = pdq.GetUtilization(cname, wname, pdq.TERM) * Wrwht

wname = "%s%d" % (RDOP, i)
Xcpu  = pdq.GetThruput(pdq.TERM, wname) * Wrdop
Pcpu += Xcpu * Zrdop
Ucrd  = pdq.GetUtilization(cname, wname, pdq.TERM) * Wrdop

Pcpu *= 1.88

if (WBACK):
   wname = "%s%d" % (WROP, i)

   Ucwr = pdq.GetUtilization(cname, wname, pdq.TERM) * Wwbop

   wname = "%s%d" % (INVL, i)

   Ucin = pdq.GetUtilization(cname, wname, pdq.TERM) * Winvl
else:  # write-thru
   wname = "%s%d" % (WROP, i)

   Ucwr = pdq.GetUtilization(cname, wname, pdq.TERM) * Wwthr

#---------------------------------------------------------------------

print "\n**** %s Results ****" % model
print "PDQ nodes: %d  PDQ streams: %d"% (nodes, streams)

if (WBACK):
   s = "WriteBack"
else:
   s = "WriteThru"

print "Memory Mode: %s" % s
print "Ncpu:  %2d" % MAXCPU
(no, Wrwht) = intwt(Nrwht)
print "no %d Nrwht %d, Wrwht %d" % (no, Nrwht, Wrwht)
print "Nrwht: %5.2f (N:%2d  W:%5.2f)" % (Nrwht, no, Wrwht)

(no, Wrdop) = intwt(Nrdop)
print "Nrdop: %5.2f (N:%2d  W:%5.2f)" % (Nrdop, no, Wrdop)

if (WBACK):
   (no, Wwbop) = intwt(Nwbop)
   print "Nwbop: %5.2f (N:%2d  W:%5.2f)" % (Nwbop, no, Wwbop)
   (no, Winvl) = intwt(Ninvl)
   print "Ninvl: %5.2f (N:%2d  W:%5.2f)" % (Ninvl, no, Winvl)
else:
   (no, Wwthr) = intwt(Nwthr)
   print "Nwthr: %5.2f (N:%2d  W:%5.2f)" % (Nwthr, no, Wwthr)

print ""
print "Hit Ratio:   %5.2f %%" % (HT * 100.0)
print "Read Miss:   %5.2f %%" % (RD * (1 - HT) * 100.0)
print "WriteMiss:   %5.2f %%" % (WR * (1 - HT) * 100.0)
print "Ucpu:        %5.2f %%" % ((Pcpu * 100.0) / MAXCPU)
print "Pcpu:        %5.2f"    % Pcpu
print ""
print "Ubus[reads]: %5.2f %%" % (Ubrd * 100.0)
print "Ubus[write]: %5.2f %%" % (Ubwr * 100.0)
print "Ubus[inval]: %5.2f %%" % (Ubin * 100.0)
print "Ubus[total]: %5.2f %%" % ((Ubrd + Ubwr + Ubin) * 100.0)
print ""
print "Uca%d[hits]:  %5.2f %%" % (i, Ucht * 100.0)
print "Uca%d[reads]: %5.2f %%" % (i, Ucrd * 100.0)
print "Uca%d[write]: %5.2f %%" % (i, Ucwr * 100.0)
print "Uca%d[inval]: %5.2f %%" % (i, Ucin * 100.0)
print "Uca%d[total]: %5.2f %%" % (i, (Ucht + Ucrd + Ucwr + Ucin) * 100.0)

#---------------------------------------------------------------------

