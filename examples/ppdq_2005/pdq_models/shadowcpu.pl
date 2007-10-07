#!/usr/bin/perl
#
# shadowcpu.pl
#
# Updated by NJG on Tue, May 2, 2006
# 	Corrected scalar 'PRIORITY' to '$PRIORITY' 
# Updated by NJG on Sat, May 6, 2006
# 	Simplified Perl code relative to PPDQ book
#   Write $Ucpu_prod value after Report() for diagnostic

use pdq;

$PRIORITY = 1;  # Flag priority queueing (1) or FIFO (0)


#---------------------- Initialize PDQ ----------------------
$noPri = "No Production Priority";
$priOn = "Production has Priority";
pdq::Init($PRIORITY ? $priOn : $noPri);

#---------------------- Create 2 workloads ----------------------
$pdq::streams = pdq::CreateClosed("Production", $pdq::TERM, 20.0, 20.0);
$pdq::streams = pdq::CreateClosed("Developmnt", $pdq::TERM, 15.0, 15.0);


#---------------------- Create queueuing nodes ----------------------
$pdq::nodes = pdq::CreateNode("CPU", $pdq::CEN, $pdq::FCFS);
if ($PRIORITY) { 
	# Create shadow CPU queue
    $pdq::nodes = pdq::CreateNode("shadCPU", $pdq::CEN, $pdq::FCFS);
}
$pdq::nodes = pdq::CreateNode("DK1", $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode("DK2", $pdq::CEN, $pdq::FCFS);


#---------------------- Set service times ----------------------
pdq::SetDemand("DK1", "Production", 0.08);
pdq::SetDemand("DK1", "Developmnt", 0.05);
pdq::SetDemand("DK2", "Production", 0.10);
pdq::SetDemand("DK2", "Developmnt", 0.06);
pdq::SetDemand("CPU", "Production", 0.30);

if ($PRIORITY) { 
    $Ucpu_prod = GetProdU();
    # Inflate shadow CPU service time
    pdq::SetDemand("shadCPU", "Developmnt", 1 / (1 - $Ucpu_prod));
} else { 
    pdq::SetDemand("CPU", "Developmnt", 1.0);
}


pdq::Solve($pdq::APPROX); 
pdq::Report();
printf("Ucpu_prod: %6.4f\n", $Ucpu_prod); # diagnostic


#---------------------- Subroutines ----------------------
sub GetProdU {
   pdq::Solve($pdq::APPROX);
   return(pdq::GetUtilization("CPU", "Production", $pdq::TERM));
}
