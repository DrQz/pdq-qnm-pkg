#! /usr/bin/perl -w

use pdq;

$cpusPerServer = 4;
$emailThruput  = 0.66; # emails per second
$scannerTime   = 6.0;  # seconds per email

pdq::Init("Spam Farm Model");
$s = pdq::CreateOpen("Email", $emailThruput);
$n = pdq::CreateMultiNode($cpusPerServer, "spamCan", 
	$pdq::CEN, $pdq::FCFS);
pdq::SetDemand("spamCan", "Email", $scannerTime);
pdq::Solve($pdq::CANON);
pdq::Report();
$q = pdq::GetQueueLength("spamCan", "Email", $pdq::TRANS);
$u = pdq::GetUtilization("spamCan", "Email", $pdq::TRANS);
printf("Stretch factor: %6.4f\n", $q / ($u * $cpusPerServer));