#!/usr/bin/perl
# passport.pl

use pdq;

#### Input parameters
$ArrivalRate = 15.0 / 3600;
$WorkName = "Applicant";
$NodeName1 = "Window1";
$NodeName2 = "Window2";
$NodeName3 = "Window3";
$NodeName4 = "Window4";

#### Branching probabilities and weights 
$p12 = 0.30;
$p13 = 0.70;
$p23 = 0.20;
$p32 = 0.10;

$L3 = ($p13 + $p23 * $p12) / (1 - $p23 * $p32);
$L2 = $p12 + $p32 * $w3;

#### Initialize and solve the PDQ model
pdq::Init("Passport Office");

$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);

$pdq::nodes   = pdq::CreateNode($NodeName1, $pdq::CEN, $pdq::FCFS);
$pdq::nodes   = pdq::CreateNode($NodeName2, $pdq::CEN, $pdq::FCFS);
$pdq::nodes   = pdq::CreateNode($NodeName3, $pdq::CEN, $pdq::FCFS);
$pdq::nodes   = pdq::CreateNode($NodeName4, $pdq::CEN, $pdq::FCFS);

pdq::SetDemand($NodeName1, $WorkName, 20);
pdq::SetDemand($NodeName2, $WorkName, 600 * $L2);
pdq::SetDemand($NodeName3, $WorkName, 300 * $L3);
pdq::SetDemand($NodeName4, $WorkName, 60);

pdq::Solve($pdq::CANON);

pdq::Report();
