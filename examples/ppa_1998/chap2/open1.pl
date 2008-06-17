#!/usr/bin/perl
#
#  $Id$
#

use pdq;

$arrivRate    = 0.75;
$service_time = 1.0;


#---- Initialize the system ---------------------------------------------------

pdq::Init("OpenCenter");
pdq::SetComment("This is just a simple M/M/1 queue.");


#---- Define the queueing center ----------------------------------------------

$nodes = pdq::CreateNode("server", $pdq::CEN, $pdq::FCFS);  

#  So the value of $nodes should correspond to the value of $pdq::nodes


#---- Define the workload and circuit type ------------------------------------

$streams = pdq::CreateOpen("work", $arrivRate);  # So $streams == $pdq::streams

pdq::SetWUnit("Customers");
pdq::SetTUnit("Seconds");

#  So the value of $streams should correspond to the value of $pdq::streams


#---- Define service demand due to workload on the queueing center ------------

pdq::SetDemand("server", "work", $service_time);


#---- Solve the model ---------------------------------------------------------
#  Must use the Canonical method for an open circuit

pdq::Solve($pdq::CANON);


#---- Generate a report -------------------------------------------------------

printf "Using: %s\n", $pdq::version;

pdq::Report();

