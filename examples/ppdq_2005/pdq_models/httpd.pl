#!/usr/bin/perl
# httpd.pl

use pdq;

$clients = 5; 
$smaster = 0.0109; #seconds
$sdemon = 0.0044; #seconds
$work = "homepage";
@slave = ("slave1", "slave2", "slave3", "slave4", "slave5",
"slave6", "slave7", "slave8", "slave9", "slave10",
"slave11", "slave12", "slave13", "slave14", "slave15",
"slave16");

pdq::Init("HTTPd Prefork");

$pdq::streams = pdq::CreateClosed($work, $pdq::TERM, $clients, 0.0);
$pdq::nodes = pdq::CreateNode("master", $pdq::CEN, $pdq::FCFS);
pdq::SetDemand("master", $work, $smaster);

$nslaves = @slave;
foreach $sname (@slave) {
   $pdq::nodes = pdq::CreateNode($sname, $pdq::CEN, $pdq::FCFS);
   pdq::SetDemand($sname, $work, $sdemon / $nslaves);
}

pdq::Solve($pdq::EXACT);
pdq::Report();
