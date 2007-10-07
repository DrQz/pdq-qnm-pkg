#!/usr/bin/perl
#  
# Based on open_feedback
#  
#  $Id$
#
#-------------------------------------------------------------------------------

use pdq;

$rx_prob          = 0.30;
$inter_arriv_rate = 0.5;
$service_time     = 0.75;
$mean_visits      = 1.0 / (1.0 - $rx_prob);

#----- Initialize the model ----------------------------------------------------

pdq::Init("Open Feedback");


#---- Define the queueing center -----------------------------------------------

$noNodes = pdq::CreateNode("channel", $pdq::CEN, $pdq::FCFS);


#---- Define the workload and circuit type -------------------------------------

$noStreams = pdq::CreateOpen("message", $inter_arriv_rate);


#---- Define service demand due to workload on the queueing center -------------

pdq::SetVisits("channel", "message", $mean_visits, $service_time);


#---- Must use the CANONical method for an open circuit ------------------------

pdq::Solve($pdq::CANON);

pdq::Report();

