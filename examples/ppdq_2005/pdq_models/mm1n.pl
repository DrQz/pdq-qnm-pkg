#!/usr/bin/perl
# mm1n.pl
use pdq;

# Model specific variables
$requests    = 100;
$thinktime   = 300.0;
$serviceTime = 0.63;
$nodeName    = "CPU";
$workName    = "compile";

# Initialize the model
pdq::Init("M/M/1//N Model");

# Define the queueing circuit and workload   
$pdq::streams = pdq::CreateClosed($workName, $pdq::TERM, $requests, 
	$thinktime);

# Define the queueing node 
$pdq::nodes  = pdq::CreateNode($nodeName, $pdq::CEN, $pdq::FCFS);

# Define service time for the work on that node 
pdq::SetDemand($nodeName, $workName, $serviceTime);

# Solve the model
pdq::Solve($pdq::EXACT);

# Report the PDQ results
pdq::Report();
