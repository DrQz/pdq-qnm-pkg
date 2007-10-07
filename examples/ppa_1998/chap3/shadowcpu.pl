#!/usr/bin/perl
#
# Based on shadowcpu.c
#
# Created by NJG: Fri May  3 18:41:04  2002
#
# Taken from p.254 of "Capacity Planning and Performance Modeling," 
# by Menasce, Almeida, and Dowdy, Prentice-Hall, 1994. 
#  
#  $Id$
#
#-------------------------------------------------------------------------------

use pdq;

$PRIORITY = 1;  # Turn priority on or off here


$noPri = "CPU Scheduler - No Pri";
$priOn = "CPU Scheduler - Pri On";


#-------------------------------------------------------------------------------

sub GetProdU
{
   pdq::Init("");

   $noStreams = pdq::CreateClosed("Production", $pdq::TERM, 20.0, 20.0);

   $noNodes   = pdq::CreateNode("CPU", $pdq::CEN, $pdq::FCFS);
   $noNodes   = pdq::CreateNode("DK1", $pdq::CEN, $pdq::FCFS);
   $noNodes   = pdq::CreateNode("DK2", $pdq::CEN, $pdq::FCFS);

   pdq::SetDemand("CPU", "Production", 0.30);
   pdq::SetDemand("DK1", "Production", 0.08);
   pdq::SetDemand("DK2", "Production", 0.10);

   pdq::Solve($pdq::APPROX); 

   return(pdq::GetUtilization("CPU", "Production", $pdq::TERM));
}


#-------------------------------------------------------------------------------

if ( $PRIORITY ) { 
	$Ucpu_prod = GetProdU();
}


#-------------------------------------------------------------------------------

pdq::Init(PRIORITY ? $priOn : $noPri);


#---- Workloads ----------------------------------------------------------------

$noStreams = pdq::CreateClosed("Production", $pdq::TERM, 20.0, 20.0);
$noStreams = pdq::CreateClosed("Developmnt", $pdq::TERM, 15.0, 15.0);


#---- Nodes --------------------------------------------------------------------

$noNodes = pdq::CreateNode("CPU", $pdq::CEN, $pdq::FCFS);

if (PRIORITY) { 
	$noNodes = pdq::CreateNode("shadCPU", $pdq::CEN, $pdq::FCFS);
}

$noNodes = pdq::CreateNode("DK1", $pdq::CEN, $pdq::FCFS);
$noNodes = pdq::CreateNode("DK2", $pdq::CEN, $pdq::FCFS);


#---- Service demands at each node ---------------------------------------------

pdq::SetDemand("CPU", "Production", 0.30);

if ($PRIORITY) { 
	pdq::SetDemand("shadCPU", "Developmnt", 1.00/(1 - $Ucpu_prod));
} else { 
	pdq::SetDemand("CPU", "Developmnt", 1.00);
}

pdq::SetDemand("DK1", "Production", 0.08);
pdq::SetDemand("DK1", "Developmnt", 0.05);

pdq::SetDemand("DK2", "Production", 0.10);
pdq::SetDemand("DK2", "Developmnt", 0.06);

#---- We use APPROX rather than EXACT to match the numbers in the book ---------

pdq::Solve($pdq::APPROX); 

pdq::Report();

