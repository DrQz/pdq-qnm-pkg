#! /usr/bin/perl
# 
# An old performance gem.
# Solve fast-slow disk I/O optimization problem
# by searching for lowest mean response time.
#
# $Id$

use pdq;

$IOinterval     = 0.006; # seconds 
$IOrate         = 1 / $IOinterval;
$fastService    = 0.005; # seconds 
$slowService    = 0.015; # seconds 

# Start with 3:1 ratio based on speed 15/5 ms
$fastFraction    = 0.75; 

$FastDk         = "FastDisk";
$SlowDk         = "SlowDisk";
$IOReqsF        = "fastIOs";
$IOReqsS        = "slowIOs";

$modelName      = "Disk I/O Optimization";
print "Solving: $modelName ...\n";

while($fastFraction < 0.86) {
    pdq::Init($modelName);
      
    pdq::SetWUnit("IOs");
    pdq::SetTUnit("sec");
    
    $pdq::nodes = pdq::CreateNode($FastDk, $pdq::CEN, $pdq::FCFS);
    $pdq::nodes = pdq::CreateNode($SlowDk, $pdq::CEN, $pdq::FCFS);
    
    $pdq::streams = pdq::CreateOpen($IOReqsF, $IOrate * $fastFraction);
    $pdq::streams = pdq::CreateOpen($IOReqsS, $IOrate * (1 - $fastFraction));
    
    pdq::SetDemand($FastDk, $IOReqsF, $fastService);
    pdq::SetDemand($FastDk, $IOReqsS, 0.0);
    
    pdq::SetDemand($SlowDk, $IOReqsS, $slowService);
    pdq::SetDemand($SlowDk, $IOReqsF, 0.0);
    
    pdq::Solve($pdq::CANON);
    
    $fRT  = pdq::GetResponse($pdq::TRANS, $IOReqsF);
    $sRT  = pdq::GetResponse($pdq::TRANS, $IOReqsS);
    $mRT  = ($fRT * $fastFraction) + ((1 - $fastFraction) * $sRT);

    printf("f:  %6.4f, ", $fastFraction);
    printf("Uf: %6.4f, ", pdq::GetUtilization($FastDk, $IOReqsF, $pdq::TRANS));
    printf("Us: %6.4f, ", pdq::GetUtilization($SlowDk, $IOReqsS, $pdq::TRANS));
    printf("Rf: %6.4f, ", $fRT);
    printf("Rs: %6.4f, ", $sRT);
    printf("Rt: %8.6f\n", $mRT);
    
    $fastFraction += 0.01;
}
