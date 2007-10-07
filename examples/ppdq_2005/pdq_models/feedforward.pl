#!/usr/bin/perl
# feedforward.pl
use pdq;

$ArrivalRate = 0.10;
$WorkName = "Requests";
$NodeName1 = "Queue1";
$NodeName2 = "Queue2";
$NodeName3 = "Queue3";

pdq::Init("Feedforward Circuit");
$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);
$pdq::nodes = pdq::CreateNode($NodeName1, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($NodeName2, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($NodeName3, $pdq::CEN, $pdq::FCFS);
pdq::SetDemand($NodeName1, $WorkName, 1.0);
pdq::SetDemand($NodeName2, $WorkName, 2.0);
pdq::SetDemand($NodeName3, $WorkName, 3.0);
pdq::Solve($pdq::CANON);
pdq::Report();
