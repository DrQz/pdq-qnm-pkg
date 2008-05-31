#! /usr/bin/perl
# mm1.pl
# Updated by NJG on Sat, Apr 8, 2006  (per PPDQ erratum for p. 220)

use pdq;

$ArrivalRate 	= 0.75;
$ServiceDemand 	= 1.00;

$NodeName = "FIFO";
$WorkName = "Work";

# Initialize PDQ internal variables
pdq::Init("FIFO Example");
  


# Define the queueing circuit type and workload 
$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);

# Change the units used by PDQ::Report()
pdq::SetWUnit("Requests");
pdq::SetTUnit("Seconds");

# Define the FIFO queue 
$pdq::nodes = pdq::CreateNode($NodeName, $pdq::CEN, $pdq::FCFS);

# Define service demand due to the workload  
pdq::SetDemand($NodeName, $WorkName, $ServiceDemand);

# Solve the PDQ model 
pdq::Solve($pdq::CANON);

# Generate a report 
pdq::Report(); 
