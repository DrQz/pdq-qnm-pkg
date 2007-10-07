#! /usr/bin/perl
# elephant.pl

use pdq;

$clients = 50;     # load generators
$think   = 0.0149; # hours  
$Dmax    = 0.0005; # hours

pdq::Init("SPEC SDET Model");

$pdq::streams = pdq::CreateClosed("BenchWork", $pdq::TERM, $clients, $think);
$pdq::nodes   = pdq::CreateNode("BenchSUT", $pdq::CEN, $pdq::FCFS);

pdq::SetDemand("BenchSUT", "BenchWork", $Dmax);

pdq::SetWUnit("Scripts");
pdq::SetTUnit("Hour");

pdq::Solve($pdq::EXACT);
pdq::Report();

