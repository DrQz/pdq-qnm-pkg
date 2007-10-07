#!/usr/bin/env perl
#
# ebiz.pl
#
#---------------------------------------------------------------------

use pdq;

$model    = "Middleware";
$work     = "eBiz-tx";
$node1    = "WebServer";
$node2    = "AppServer";
$node3    = "DBMServer";
$think    = 0.0 * 1e-3;  # treat as free param

#  Add dummy node names here
$node4 = "DummySvr";

$users = 10;

pdq::Init($model);

$pdq::streams = pdq::CreateClosed($work, $pdq::TERM, $users, $think);

$pdq::nodes = pdq::CreateNode($node1, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($node2, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($node3, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($node4, $pdq::CEN, $pdq::FCFS);

#  NOTE: timebase is seconds
pdq::SetDemand($node1, $work, 9.8 * 1e-3);
pdq::SetDemand($node2, $work, 2.5 * 1e-3);
pdq::SetDemand($node3, $work, 0.72 * 1e-3);

#  dummy (network) service demand 
pdq::SetDemand($node4, $work, 9.8 * 1e-3);

pdq::Solve($pdq::EXACT);
pdq::Report();
