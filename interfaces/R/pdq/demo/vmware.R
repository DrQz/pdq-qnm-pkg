###########################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company
#  
#  This software is licensed as described in the file COPYING, which
#  you should have received as part of this distribution. The terms
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.
#
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell 
#  copies of the Software, and permit persons to whom the Software is
#  furnished to do so, under the terms of the COPYING file.
#
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF 
# ANY KIND, either express or implied.
###########################################################################

# Updated by NJG on Sun Dec 10 13:39:56 2017
# Updated by NJG on Monday, November 12, 2012
# Ported to R PJP on Wed, Aug 1, 2012
# $Id: allocs2.R,v 1.2 2012/11/13 05:22:31 earl-lang Exp $
# Created by NJG on Wed, May 17, 2006


# Share allocation performance model based on measurements
# of VMWare ESX Server 2 running the SPEC CPU2000 gzip benchmark on 
# a single physical CPU with each VM guest defaulted to 1000 shares.
#
# See PPDQ book http://www.perfdynamics.com/books.html
# Section 5.9.2 Fair-Share Scheduler

VMguests    <- 8
VMguestsHi  <- 3
sharesHiPri <- 5000
sharesLoPri <- 1000
VMguestsLo  <- (VMguests - VMguestsHi)
sharesDefault <- 1000
vmInst <- "VMid"
workHi <- "gzipHi"
workLo <- "gzipLo"

scenarioName <- "VMWare ESX Benchmark"

# Do the allocations ...
sharesPool <- VMguestsHi * sharesHiPri
for( vm in seq(VMguestsLo) ){
     sharesPool <- sharesPool + sharesLoPri
}

# share proportions or entitlements
propHi <- sharesHiPri / sharesPool
propLo <- sharesLoPri / sharesPool

cpuTime <- 288; # seconds

# The PDQ model
pdq::Init(scenarioName)

vmID = 0;
for( vm in seq(VMguestsHi)) {
	vmhn <- sprintf("%s%d", vmInst, vmID)
	pdq::CreateNode(vmhn, CEN, FCFS)
	
	whi <- sprintf("%s%d", workHi, vm)
	pdq::CreateClosed(whi, TERM, 1, 0.0)
	pdq::SetDemand(vmhn, whi, cpuTime / propHi)
	vmID <- vmID + 1
}

for(vm in VMguestsLo) {
	vmln <- sprintf("%s%d", vmInst, vmID)
	pdq::CreateNode(vmln, CEN, FCFS)

	wlo <- sprintf("%s%d", workLo, vm)
	pdq::CreateClosed(wlo, TERM, 1, 0.0)
	pdq::SetDemand(vmln, wlo, cpuTime / propLo)
	pdq::SetDemand(vmln, whi, 0.0)
	pdq::SetDemand(vmhn, wlo, 0.0)
	vmID <- vmID + 1
}

pdq::Solve(APPROX);

hiResT <- pdq::GetResponse(TERM, whi)
hiTput <- pdq::GetThruput(TERM, whi) * 3600
loResT <- pdq::GetResponse(TERM, wlo)
loTput <- pdq::GetThruput(TERM, wlo)  * 3600;

cat(sprintf(
  "VMs: %2d, Pool: %5d, Xavg: %6.4f updates/hour\n", 
            VMguests, 
            sharesPool,
            VMguests * (hiTput + loTput) / 2
            )
    )
cat(sprintf(
 "HiPri: %2d, shares: %5d, F/N: %6.4f, F: %6.4f, R: %8.2f, X/hr: %6.4f\n", 
            VMguestsHi, 
            sharesHiPri, 
            propHi, 
            VMguestsHi * propHi,
            hiResT,
            hiTput
            )
    )
cat(sprintf(
 "LoPri: %2d, shares: %5d, F/N: %6.4f, F: %6.4f, R: %8.2f, X/hr: %6.4f\n",
            VMguestsLo,
            sharesLoPri, 
            propLo, 
            VMguestsLo * propLo, 
            loResT, 
            loTput
            )
    )

