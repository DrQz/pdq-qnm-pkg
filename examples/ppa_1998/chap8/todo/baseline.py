#!/usr/bin/env python
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
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
#  $Id$
#
#---------------------------------------------------------------------

import pdq

#****************************************************
#       Model Parameters
#****************************************************/

#  Name of this model ...
scenario = "C/S Baseline"

#  Useful constants ...

K        = 1024
MIPS     =  1E6
Mbps     =  1E6

#  Model parameters ...

USERS    =   125
FS_DISKS =     1
MF_DISKS =     4
PC_MIPS  =   (27 * MIPS)
FS_MIPS  =   (41 * MIPS)
GW_MIPS  =   (10 * MIPS)
MF_MIPS  =   (21 * MIPS)
TR_Mbps  =    (4 * Mbps)
TR_fact  =    (2.5)        #  fudge factor

MAXPROC  =    20
MAXDEV   =    50

#  Computing Device IDs

PC       =     0
FS       =     1
GW       =     2
MF       =     3
TR       =     4
FDA      =    10
MDA      =    20

#  Transaction IDs

CD       =     0  #  Category Display
RQ       =     1  #  Remote Query
SU       =     2  #  Status Update

#  Process IDs  from 1993 paper

CD_Req   =     1
CD_Rpy   =    15
RQ_Req   =     2
RQ_Rpy   =    16
SU_Req   =     3
SU_Rpy   =    17
Req_CD   =     4
Req_RQ   =     5
Req_SU   =     6
CD_Msg   =    12
RQ_Msg   =    13
SU_Msg   =    14
GT_Snd   =     7
GT_Rcv   =    11
MF_CD    =     8
MF_RQ    =     9
MF_SU    =    10
LAN_Tx   =    18

#-------------------------------------------------------------------------------

class Device:
   pass

   def __init__(self, id, label):
      self.id     = id
      self.label  = label

#-------------------------------------------------------------------------------

class Demand:
   NO_ROWS    = 20
   NO_COLS    = 50

   def __init__(self):
      self.arr = [None] * self.NO_ROWS
      self.row = [0] * self.NO_COLS

   def __getitem__(self, (i, j)):
      return (self.arr[i] or self.row)[j]

   def __setitem__(self, (i, j), value):
      if self.arr[i] == None:
         self.arr[i] = [0] * self.NO_COLS
      self.arr[i][j] = value

   def dump(self):
      for i in range(self.NO_ROWS):
        print 'Row %s == [' % i,
        if self.arr[i] == None:
           pass
        else:
           for j in range(self.NO_COLS):
              print self.arr[i][j],
        print "]"

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------

FDarray      = []
MDarray      = []

for i in range(FS_DISKS):
   print i
   FDarray.append(Device(FDA + i, "FD%d" % i))

for i in range(MF_DISKS):
   MDarray.append(Device(MDA + i, "MD%d" % i))

#  CPU service times are calculated from MIPS Instruction counts in
#  tables presented in original 1993 CMG paper. */

demand = Demand()

demand[(CD_Req, PC)] = 200 * K / PC_MIPS
demand[(CD_Rpy, PC)] = 100 * K / PC_MIPS
demand[(RQ_Req, PC)] = 150 * K / PC_MIPS
demand[(RQ_Rpy, PC)] = 200 * K / PC_MIPS
demand[(SU_Req, PC)] = 300 * K / PC_MIPS
demand[(SU_Rpy, PC)] = 300 * K / PC_MIPS

demand[(Req_CD, FS)] =  50 * K / FS_MIPS
demand[(Req_RQ, FS)] =  70 * K / FS_MIPS
demand[(Req_SU, FS)] =  10 * K / FS_MIPS
demand[(CD_Msg, FS)] =  35 * K / FS_MIPS
demand[(RQ_Msg, FS)] =  35 * K / FS_MIPS
demand[(SU_Msg, FS)] =  35 * K / FS_MIPS

demand[(GT_Snd, GW)] =  50 * K / GW_MIPS
demand[(GT_Rcv, GW)] =  50 * K / GW_MIPS

demand[(MF_CD, MF)]  =  50 * K / MF_MIPS
demand[(MF_RQ, MF)]  = 150 * K / MF_MIPS
demand[(MF_SU, MF)]  =  20 * K / MF_MIPS

#  packets generated at each of the following sources ...

demand[(LAN_Tx, PC)] = 2 * K * TR_fact / TR_Mbps
demand[(LAN_Tx, FS)] = 2 * K * TR_fact / TR_Mbps
demand[(LAN_Tx, GW)] = 2 * K * TR_fact / TR_Mbps

#  File server Disk I/Os = #accesses x caching / (max IOs/Sec)

for i in range(FS_DISKS):
   demand[(Req_CD, FDarray[i].id)] = (1.0 * 0.5 / 128.9) / FS_DISKS
   demand[(Req_RQ, FDarray[i].id)] = (1.5 * 0.5 / 128.9) / FS_DISKS
   demand[(Req_SU, FDarray[i].id)] = (0.2 * 0.5 / 128.9) / FS_DISKS
   demand[(CD_Msg, FDarray[i].id)] = (1.0 * 0.5 / 128.9) / FS_DISKS
   demand[(RQ_Msg, FDarray[i].id)] = (1.5 * 0.5 / 128.9) / FS_DISKS
   demand[(SU_Msg, FDarray[i].id)] = (0.5 * 0.5 / 128.9) / FS_DISKS

#  Mainframe DASD I/Os = (#accesses / (max IOs/Sec)) / #disks

for i in range(MF_DISKS):
   demand[(MF_CD, MDarray[i].id)] = (2.0 / 60.24) / MF_DISKS
   demand[(MF_RQ, MDarray[i].id)] = (4.0 / 60.24) / MF_DISKS
   demand[(MF_SU, MDarray[i].id)] = (1.0 / 60.24) / MF_DISKS

# demand.dump()


#----- Start building the PDQ model --------------------------------------------

pdq.Init(scenario)

#  Define physical resources as queues ...

no_nodes = pdq.CreateNode("PC", pdq.CEN, pdq.FCFS)
no_nodes = pdq.CreateNode("FS", pdq.CEN, pdq.FCFS)

for i in range(FS_DISKS):
   no_nodes = pdq.CreateNode(FDarray[i].label, pdq.CEN, pdq.FCFS)

no_nodes = pdq.CreateNode("GW", pdq.CEN, pdq.FCFS)
no_nodes = pdq.CreateNode("MF", pdq.CEN, pdq.FCFS)

for i in range(MF_DISKS):
   no_nodes = pdq.CreateNode(MDarray[i].label, pdq.CEN, pdq.FCFS)

no_nodes = pdq.CreateNode("TR", pdq.CEN, pdq.FCFS)

#  NOTE: Althought the Token Ring LAN is a passive computational device,
#  it is treated as a separate node so as to agree to the results
#  presented in the original CMG'93 paper.

#----- Assign transaction names ------------------------------------------------

txCD =  "CatDsply"
txRQ =  "RemQuote"
txSU =  "StatusUp"

#----- Define an OPEN circuit aggregate workload -------------------------------

no_streams = pdq.CreateOpen(txCD, USERS * 4.0 / 60.0)
no_streams = pdq.CreateOpen(txRQ, USERS * 8.0 / 60.0)
no_streams = pdq.CreateOpen(txSU, USERS * 1.0 / 60.0)

#-------------------------------------------------------------------------------
#  Define the service demands on each physical resource ...
#  CD request + reply chain  from workflow diagram
#-------------------------------------------------------------------------------

pdq.SetDemand("PC", txCD, demand[(CD_Req, PC)] + (5 * demand[(CD_Rpy, PC)]))
pdq.SetDemand("FS", txCD, demand[(Req_CD, FS)] + (5 * demand[(CD_Msg, FS)]))

for i in range(FS_DISKS):
   pdq.SetDemand(FDarray[i].label, txCD,
      demand[(Req_CD, FDarray[i].id)] + (5 * demand[(CD_Msg, FDarray[i].id)]))

pdq.SetDemand("GW", txCD, demand[(GT_Snd, GW)] + (5 * demand[(GT_Rcv, GW)]))
pdq.SetDemand("MF", txCD, demand[(MF_CD, MF)])

for i in range(MF_DISKS):
   pdq.SetDemand(MDarray[i].label, txCD, demand[(MF_CD, MDarray[i].id)])

#-------------------------------------------------------------------------------
#  NOTE: Synchronous process execution caimports data for the CD
#  transaction to cross the LAN 12 times as depicted in the following
#  parameterization of pdq.SetDemand.
#-------------------------------------------------------------------------------

pdq.SetDemand("TR", txCD,
      (1 * demand[(LAN_Tx, PC)]) + (1 * demand[(LAN_Tx, FS)])
    + (5 * demand[(LAN_Tx, GW)]) + (5 * demand[(LAN_Tx, FS)]))

#----- RQ request + reply chain ------------------------------------------------

pdq.SetDemand("PC", txRQ, demand[(RQ_Req, PC)] + (3 * demand[(RQ_Rpy, PC)]))
pdq.SetDemand("FS", txRQ, demand[(Req_RQ, FS)] + (3 * demand[(RQ_Msg, FS)]))

for i in range(FS_DISKS):
   pdq.SetDemand(FDarray[i].label, txRQ,
      demand[(Req_RQ, FDarray[i].id)] + (3 * demand[(RQ_Msg, FDarray[i].id)]))

pdq.SetDemand("GW", txRQ, demand[(GT_Snd, GW)] + (3 * demand[(GT_Rcv, GW)]))
pdq.SetDemand("MF", txRQ, demand[(MF_RQ, MF)])

for i in range(MF_DISKS):
   pdq.SetDemand(MDarray[i].label, txRQ, demand[(MF_RQ, MDarray[i].id)])

pdq.SetDemand("TR", txRQ,
     (1 * demand[(LAN_Tx, PC)]) + (1 * demand[(LAN_Tx, FS)])
   + (3 * demand[(LAN_Tx, GW)]) + (3 * demand[(LAN_Tx, FS)]))

#----- SU request + reply chain  -----------------------------------------------

pdq.SetDemand("PC", txSU, demand[(SU_Req, PC)] + demand[(SU_Rpy, PC)])
pdq.SetDemand("TR", txSU, demand[(LAN_Tx, PC)])
pdq.SetDemand("FS", txSU, demand[(Req_SU, FS)] + demand[(SU_Msg, FS)])

for i in range(FS_DISKS):
   pdq.SetDemand(FDarray[i].label, txSU,
      demand[(Req_SU, FDarray[i].id)] + demand[(SU_Msg, FDarray[i].id)])

pdq.SetDemand("TR", txSU, demand[(LAN_Tx, FS)])
pdq.SetDemand("GW", txSU, demand[(GT_Snd, GW)] + demand[(GT_Rcv, GW)])
pdq.SetDemand("MF", txSU, demand[(MF_SU, MF)])

for i in range(MF_DISKS):
   pdq.SetDemand(MDarray[i].label, txSU, demand[(MF_SU, MDarray[i].id)])

pdq.SetDemand("TR", txSU,
      (1 * demand[(LAN_Tx, PC)]) + (1 * demand[(LAN_Tx, FS)])
    + (1 * demand[(LAN_Tx, GW)]) + (1 * demand[(LAN_Tx, FS)]))

DEBUG = False

pdq.Solve(pdq.CANON)

pdq.Report()

#----- Break out Tx response times and device utilizations ---------------------

print "*** PDQ Breakout \"%s\" (%d clients) ***\n\n" % (scenario, USERS)


ulan         = 0.0
ufs          = 0.0
uws          = 0.0
ugw          = 0.0
umf          = 0.0

udsk         = [0.0] * FS_DISKS
udasd        = [0.0] * MF_DISKS

util         = [0.0] * no_nodes  # Reset array

for device_idx in range(no_nodes):
   node    = pdq.GetNode(device_idx)
   devname = node["devname"]
   # print "Devname  ", devname
   for work_idx in range(no_streams):
      job               = pdq.GetJob(work_idx)
      trans_name        = job["TransName"]
      util[device_idx] += 100 * pdq.GetUtilization(devname, trans_name, pdq.TRANS)

#----- Order of print out follows that in 1993 CMG paper -----------------------

print "Transaction  \tLatency(Secs)"
print "-----------  \t-----------"

for idx in range(no_streams):
   job = pdq.GetJob(idx)
   print "%s\t%7.4f" % (job["TransName"], job["TransSysResponse"])

print "\n"

for idx in range(no_nodes):
   node = pdq.GetNode(idx)
   # print idx, node["devname"]

   if node["devname"] == "PC":
       uws += util[idx];

   elif node["devname"] == "GW":
      ugw += util[idx]

   elif node["devname"] == "FS":
      ufs += util[idx]

   elif node["devname"] == "MF":
      umf += util[idx]

   elif (node["devname"] == "TR"):
      ulan += util[idx]

   else:
      for i in range(FS_DISKS):
         # print "[%s]" % FDarray[i].label
         if (node["devname"] == FDarray[i].label):
            udsk[i] += util[idx]

      for i in range(MF_DISKS):
         # print "[%s]" % MDarray[i].label
         if (node["devname"] == MDarray[i].label):
            udasd[i] += util[idx]

print "Node      \t%  Utilization"
print "----      \t--------------"
print "%s\t%7.4f" % ("Token Ring ", ulan)
print "%s\t%7.4f" % ("Desktop PC ", uws / USERS)
print "%s\t%7.4f" % ("FileServer ", ufs)

for i in range(FS_DISKS):
   print "%s%d\t%7.4f" % ("FS Disk", FDarray[i].id, udsk[i])

print "%s\t%7.4f" % ("Gateway SNA", ugw)
print "%s\t%7.4f" % ("Mainframe  ", umf)

for i in range(MF_DISKS):
   print "%s%d\t%7.4f" % ("MFrame DASD", MDarray[i].id, udasd[i])

#-------------------------------------------------------------------------------
