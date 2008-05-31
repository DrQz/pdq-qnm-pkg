#! /usr/bin/perl
# mm1.pl
# Updated by NJG on Sat, Apr 8, 2006  (per PPDQ erratum for p. 220)
# Updated by NJG on Thu, Apr 12, 2007  (MSQ extension)

use pdq;

$ArrivalRate 	= 0.75;
$ServiceDemand 	= 1.00;

$NodeName = "FIFO";
$WorkName = "Work";

# Initialize PDQ internal variables
pdq::Init("M/M/1 Comparison");
  
# Define the queueing circuit type and workload 
$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);

# Change the units used by PDQ::Report()
pdq::SetWUnit("Requests");
pdq::SetTUnit("Seconds");

# Define the FIFO queue 
$pdq::nodes = pdq::CreateNode($NodeName, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode("Multinode", 1, $pdq::MSQ);

# Define service demand due to the workload  
pdq::SetDemand($NodeName, $WorkName, $ServiceDemand);
pdq::SetDemand("Multinode", $WorkName, $ServiceDemand);

# Solve the PDQ model 
pdq::Solve($pdq::CANON);

# Generate a report 
pdq::Report(); 


