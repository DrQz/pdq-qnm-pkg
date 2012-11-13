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

# $Id$

# An old performance gem.
# Solve fast-slow disk I/O optimization problem
# by searching for lowest mean response time.
# Updated by NJG on Tuesday, November 13, 2012

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
print "Iterating: $modelName ... (times in seconds)\n";

# Header for output
printf("%6s\t%6s\t%6s\t%6s\t%6s\t%6s\n", "f","Uf","Us","Rf","Rs","Rt");

while($fastFraction < 1.0) {
    pdq::Init($modelName);
    
    pdq::CreateNode($FastDk, $pdq::CEN, $pdq::FCFS);
    pdq::CreateNode($SlowDk, $pdq::CEN, $pdq::FCFS);
    
    pdq::CreateOpen($IOReqsF, $IOrate * $fastFraction);
    pdq::CreateOpen($IOReqsS, $IOrate * (1 - $fastFraction));
      
    pdq::SetDemand($FastDk, $IOReqsF, $fastService);
    pdq::SetDemand($FastDk, $IOReqsS, 0.0);
    pdq::SetDemand($SlowDk, $IOReqsS, $slowService);
    pdq::SetDemand($SlowDk, $IOReqsF, 0.0);
    
    pdq::Solve($pdq::CANON);
    
    $fRT  = pdq::GetResponse($pdq::TRANS, $IOReqsF);
    $sRT  = pdq::GetResponse($pdq::TRANS, $IOReqsS);
    $mRT  = ($fRT * $fastFraction) + ((1 - $fastFraction) * $sRT);

	# Print a row of metrics
    printf("%6.4f\t%6.4f\t%6.4f\t%6.2f\t%6.2f\t%6.2f\n", 
    	$fastFraction,
    	pdq::GetUtilization($FastDk, $IOReqsF, $pdq::TRANS),
    	pdq::GetUtilization($SlowDk, $IOReqsS, $pdq::TRANS),
    	($fRT * $fastFraction) * 1000,
    	((1 - $fastFraction) * $sRT) * 1000,
    	$mRT * 1000   
    );

    $fastFraction += 0.01;
}
