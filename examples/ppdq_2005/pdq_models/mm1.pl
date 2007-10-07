#! /usr/bin/perl
# mm1.pl
# Updated by NJG on Sat, Apr 8, 2006 per erratum for p. 220

use pdq;

## INPUTS ##
# Measured parameters
$MeasurePeriod = 3600; # seconds
$ArrivalCount = 1800;
$ServiceVisits = 10;

# Derived parameters
$ArrivalRate = $ArrivalCount / $MeasurePeriod;
$ServiceTime = 0.10; # seconds
$ServiceDemand = $ServiceVisits * $ServiceTime; # seconds

# Check the queue meets stability condition
$ServiceCap = 1 / $ServiceDemand;
if($ArrivalRate >= $ServiceCap) {
    print "Error: Arrival rate $ArrivalRate ";
    print "exceeds service capacity ServiceCap !!\n";
    exit;
}

$NodeName = "FIFO";
$WorkName = "Work";

# Initialize PDQ internal variables
pdq::Init("FIFO Example");
  
# Change the units used by PDQ::Report()
pdq::SetWUnit("Requests");
pdq::SetTUnit("Seconds");

# Define the FIFO queue 
$pdq::nodes = pdq::CreateNode($NodeName, $pdq::CEN, $pdq::FCFS);

# Define the queueing circuit type and workload 
$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);

# Define service demand due to the workload at FIFO 
pdq::SetDemand($NodeName, $WorkName, $ServiceDemand);

# Solve the PDQ model 
pdq::Solve($pdq::CANON);
# NOTE: Must use CANON-ical method since this is an open circuit

## OUTPUTS ##
# Generate a report 
pdq::Report();
