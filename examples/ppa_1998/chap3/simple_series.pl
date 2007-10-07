#!/usr/bin/perl
#  
# Based on simple_series_circuit.c
# 
# An open queueing circuit with 3 centers.
#  
#  $Id$
#
#-------------------------------------------------------------------------------

use pdq;

$arrivals_per_second = 0.10;

#-------------------------------------------------------------------------------

pdq::Init("Simple Series Circuit");

$noStreams = pdq::CreateOpen("Work", $arrivals_per_second);

$noNodes = pdq::CreateNode("Center1", $pdq::CEN, $pdq::FCFS);
$noNodes = pdq::CreateNode("Center2", $pdq::CEN, $pdq::FCFS);
$noNodes = pdq::CreateNode("Center3", $pdq::CEN, $pdq::FCFS);

pdq::SetDemand("Center1", "Work", 1.0);
pdq::SetDemand("Center2", "Work", 2.0);
pdq::SetDemand("Center3", "Work", 3.0);

pdq::Solve($pdq::CANON);

pdq::Report();

#-------------------------------------------------------------------------------

