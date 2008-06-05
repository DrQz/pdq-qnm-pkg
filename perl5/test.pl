#!/usr/bin/perl
#
#  $Id$
#

use pdq;

$arrivRate    = 0.75;
$service_time = 1.0;


#---- Initialize --------------------------------------------------------------

pdq::Init("OpenCenter");
pdq::SetComment("A simple M/M/1 queue");


#---- Define the queueing center ----------------------------------------------

$noNodes = pdq::CreateNode("server", $pdq::CEN, $pdq::FCFS);


#---- Define the workload and circuit type ------------------------------------

$noStreams = pdq::CreateOpen("work", $arrivRate);
   
pdq::SetWUnit("Customers");
pdq::SetTUnit("Seconds");


#---- Define service demand due to workload on the queueing center ------------

pdq::SetDemand("server", "work", $service_time);


#---- Solve the model ---------------------------------------------------------
#  Must use the CANONical method for an open circuit

pdq::Solve($pdq::CANON);


#---- Generate a report -------------------------------------------------------

pdq::Report();


#printf "[print_nodes] Before 2\n";
#pdq::PrintNodes();
#printf "[print_nodes] After 2\n";

#printf "pdq::nodes = %d\n", $pdq::nodes;
#$node = pdq::GetNode(0);
#printf "Node->{devname}\n", $node->{devname};

