#!/usr/bin/perl
#
# ebiz_naive.pl

use pdq;

$users = 20;
$model = "e-Commerce Naive Model";
$work  = "eBiz-tx";
$node1 = "WebServer";
$node2 = "AppServer";
$node3 = "DBMServer";
$think = 0.0 * 1e-3;  # treat as free param

pdq::Init($model);

pdq::CreateClosed($work, $pdq::TERM, $users, $think);

pdq::CreateNode($node1, $pdq::CEN, $pdq::FCFS);
pdq::CreateNode($node2, $pdq::CEN, $pdq::FCFS);
pdq::CreateNode($node3, $pdq::CEN, $pdq::FCFS);

#  Timebase is seconds expressed as milliseconds
pdq::SetDemand($node1, $work, 9.3 * 1e-3);
pdq::SetDemand($node2, $work, 2.8 * 1e-3);
pdq::SetDemand($node3, $work, 0.9 * 1e-3);

pdq::SetWUnit("Gets");

pdq::Solve($pdq::EXACT);
pdq::Report();

