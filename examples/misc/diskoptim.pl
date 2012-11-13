#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

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
$fastFraction    = 0.65; 

$FastDk         = "FastDisk";
$SlowDk         = "SlowDisk";
$IOReqsF        = "fastIOs";
$IOReqsS        = "slowIOs";

$modelName      = "Disk I/O Optimization";
print "Solving: $modelName ...\n";

while($fastFraction < 1.0) {
    pdq::Init($modelName);
    
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
