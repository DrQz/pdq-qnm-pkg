###############################################################################
#  Copyright (C) 2006 - 2013, Performance Dynamics Company                    #
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
# allocs.R
#
# Share allocation performance model based on measurements
# of VMWare ESX Server 2 running the SPEC CPU2000 gzip benchmark on 
# a single physical CPU with each VM guest defaulted to 1000 shares.
#
# Created by NJG on Wed, May 17, 2006
# Updated by NJG on Wed, May 17, 2006
# Ported to R PJP on Wed, Aug 1, 2012
# Updated by NJG on Monday, November 12, 2012

# $Id: allocs2.R,v 1.2 2012/11/13 05:22:31 earl-lang Exp $


guests <- 8
guestsHi <- 3
sharesHiPri <- 5000
sharesLoPri <- 1000

guestsLo <- guests - guestsHi;
sharesDefault <- 1000
vmInst <- "VMid"
workHi = "gzipHi"
workLo = "gzipLo"

scenarioName <- "VMWare ESX Benchmark"

# do the allocations ...
sharesPool <- guestsHi * sharesHiPri
#for($vm = 0; $vm < $guestsLo; $vm++) {
#	$sharesPool += $sharesLoPri;
#}
   
for( vm in seq(guestsLo) ){
     sharesPool <- sharesPool + sharesLoPri
}

# share proportions
propHi <- sharesHiPri / sharesPool
propLo <- sharesLoPri / sharesPool

cpuTime <- 288; # seconds

Init(scenarioName)

vmID = 0;
for( vm in seq(guestsHi)) {
	vmhn <- sprintf("%s%d", vmInst, vmID)
	CreateNode(vmhn, CEN, FCFS)
	
	whi <- sprintf("%s%d", workHi, vm)
	CreateClosed(whi, TERM, 1, 0.0)
	SetDemand(vmhn, whi, cpuTime / propHi)
	vmID <- vmID + 1
}

for( vm in seq(guestsLo)) {
	vmln <- sprintf("%s%d", vmInst, vmID)
	CreateNode(vmln, CEN, FCFS)

	wlo <- sprintf("%s%d", workLo, vm)
	CreateClosed(wlo, TERM, 1, 0.0)
	SetDemand(vmln, wlo, cpuTime / propLo)
	SetDemand(vmln, whi, 0.0)
	SetDemand(vmhn, wlo, 0.0)
	vmID <- vmID + 1
}

Solve(APPROX);
#pdq::Report();

hiResT <- GetResponse(TERM, whi)
hiTput <- GetThruput(TERM, whi) * 3600
loResT <- GetResponse(TERM, wlo)
loTput =  GetThruput(TERM, wlo)  * 3600;

cat(sprintf("VMs: %2d, Pool: %5d, Xavg: %6.4f its/hr\n", guests, sharesPool, 
	guests * (hiTput + loTput)/2))
cat(sprintf("HiPri: %2d, $: %5d,  F/N: %6.4f, F: %6.4f, R: %8.2f, X/hr: %6.4f\n", guestsHi, sharesHiPri, propHi, guestsHi * propHi, hiResT, hiTput))
cat(sprintf("LoPri: %2d, $: %5d,  F/N: %6.4f, F: %6.4f, R: %8.2f, X/hr: %6.4f\n", guestsLo, sharesLoPri, propLo, guestsLo * propLo, loResT, loTput))
