#! /usr/bin/perl
#
# ebiz_final.pl

use pdq;
use constant MAXDUMMIES => 12;

# Hash AV pairs: (load in vusers, thruput in gets/sec)
%tpdata   = ( (1,24), (2,48), (4,85), (7,100), (10,99), (20,94) );
@vusers   = keys(%tpdata);

$model = "e-Commerce Final Model";
$work  = "ebiz-tx";
$node1 = "WebServer";
$node2 = "AppServer";
$node3 = "DBMServer";
$think = 0.0 * 1e-3;  # same as in test rig
$dtime = 2.2 * 1e-3;  # dummy service time 

# Header for custom report
printf("Dummmy queues = %4d\n", MAXDUMMIES);
printf("%2s\t%4s\t%4s\n", "N", "Xdat", "Xpdq");
    
foreach $users (sort {$a <=> $b} @vusers) {
    pdq::Init($model);
    
    pdq::CreateClosed($work, $pdq::TERM, $users, $think);
    
    pdq::CreateNode($node1, $pdq::CEN, $pdq::FCFS);
    pdq::CreateNode($node2, $pdq::CEN, $pdq::FCFS);
    pdq::CreateNode($node3, $pdq::CEN, $pdq::FCFS);
    
    # Timebase in seconds expressed as milliseconds
    pdq::SetDemand($node1, $work, 8.0 * 1e-3 * ($users ** 0.085));
    pdq::SetDemand($node2, $work, 2.8 * 1e-3);
    pdq::SetDemand($node3, $work, 0.9 * 1e-3);
    
    # Create dummy nodes with their service times ... 
    for ($i = 0; $i < MAXDUMMIES; $i++) {
        $dnode = "Dummy" . ($i < 10 ? "0$i" : "$i");
        pdq::CreateNode($dnode, $pdq::CEN, $pdq::FCFS);
        pdq::SetDemand($dnode, $work, $dtime);
    }
    
    pdq::Solve($pdq::EXACT);
    
    printf("%2d\t%4d\t%6.2f\n", $users, $tpdata{$users}, 
            pdq::GetThruput($pdq::TERM, $work));
}

