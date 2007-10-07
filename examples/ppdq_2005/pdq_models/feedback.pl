#! /usr/bin/perl
# feedback.pl

use pdq;

$rx_prob          = 0.30;
$inter_arriv_rate = 0.5;
$service_time     = 0.75;
$mean_visits      = 1.0 / (1.0 - $rx_prob);

# Initialize the model
pdq::Init("Open Feedback");

# Define the queueing center
$pdq::nodes = pdq::CreateNode("channel", $pdq::CEN, $pdq::FCFS);

# Define the workload and circuit type
$pdq::streams = pdq::CreateOpen("message", $inter_arriv_rate);

# Define service demand due to workload 
pdq::SetVisits("channel", "message", $mean_visits, $service_time);

# Solve and generate a PDQ report 
pdq::Solve($pdq::CANON);
pdq::Report();
