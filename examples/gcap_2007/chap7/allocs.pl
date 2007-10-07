#!/usr/bin/perl
#
# allocs.pl
#
# Share allocation performance model based on measurements
# of VMWare ESX Server 2 running the SPEC CPU2000 gzip benchmark on 
# a single physical CPU with each VM guest defaulted to 1000 shares.
#
# Created by NJG on Wed, May 17, 2006
# Updated by NJG on Wed, May 17, 2006
#
# $Id$

use pdq;

$guests = 8;
$guestsHi = 3;
$sharesHiPri = 5000;
$sharesLoPri = 1000;

$guestsLo = $guests - $guestsHi;
$sharesDefault = 1000;
$vmInst = "VMid";
$workHi = "gzipHi";
$workLo = "gzipLo";

$scenarioName = "VMWare ESX Benchmark";

# do the allocations ...
$sharesPool = $guestsHi * $sharesHiPri;
for($vm = 0; $vm < $guestsLo; $vm++) {
	$sharesPool += $sharesLoPri;
}

# share proportions
$propHi = $sharesHiPri / $sharesPool;
$propLo = $sharesLoPri / $sharesPool;

$cpuTime = 288; # seconds

pdq::Init($scenarioName);

$vmID = 0;
for($vm = 0; $vm < $guestsHi; $vm++) {
	$vmhn = sprintf("%s%d", $vmInst, $vmID);
	$pdq::nodes = pdq::CreateNode($vmhn, $pdq::CEN, $pdq::FCFS);
	
	$whi = sprintf("%s%d", $workHi, $vm);
	$pdq::streams = pdq::CreateClosed($whi, $pdq::TERM, 1, 0.0);
	pdq::SetDemand($vmhn, $whi, $cpuTime / $propHi);
	$vmID++;
}

for($vm = 0; $vm < $guestsLo; $vm++) {
	$vmln = sprintf("%s%d", $vmInst, $vmID);
	$pdq::nodes = pdq::CreateNode($vmln, $pdq::CEN, $pdq::FCFS);

	$wlo = sprintf("%s%d", $workLo, $vm);
	$pdq::streams = pdq::CreateClosed($wlo, $pdq::TERM, 1, 0.0);
	pdq::SetDemand($vmln, $wlo, $cpuTime / $propLo);
	pdq::SetDemand($vmln, $whi, 0.0);
	pdq::SetDemand($vmhn, $wlo, 0.0);
	$vmID++;
}

pdq::Solve($pdq::APPROX);
#pdq::Report();

$hiResT = pdq::GetResponse($pdq::TERM, $whi);
$hiTput = pdq::GetThruput($pdq::TERM, $whi) * 3600;
$loResT = pdq::GetResponse($pdq::TERM, $wlo);
$loTput = pdq::GetThruput($pdq::TERM, $wlo)  * 3600;

printf("VMs: %2d, Pool: %5d, Xavg: %6.4f its/hr\n", $guests, $sharesPool, 
	$guests * ($hiTput + $loTput)/2);
printf("HiPri: %2d, \$: %5d,  F/N: %6.4f, F: %6.4f, R: %8.2f, X/hr: %6.4f\n", 
	$guestsHi, $sharesHiPri, $propHi, $guestsHi * $propHi, $hiResT, $hiTput);
printf("LoPri: %2d, \$: %5d,  F/N: %6.4f, F: %6.4f, R: %8.2f, X/hr: %6.4f\n", 
	$guestsLo, $sharesLoPri, $propLo, $guestsLo * $propLo, $loResT, $loTput);


