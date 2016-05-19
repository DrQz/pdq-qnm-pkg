#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2005, Performance Dynamics Company                    #
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
#  Threaded application model
#
#  Not yet integrated into PDQ lib.
# 
#  Created by Neil Gunther on Mon Dec 19 19:06:23 PST 2005
#
# $Id$

use pdq;

#-----------------------------------------------------------
# Various parameters
#-----------------------------------------------------------
$VUsers      = 12;
$VUthink     = 1e-6;    # non-zero to avoid numerical uglies
$nCPUs       = 4;       # Number of processors in platform
$jiTime      = 2044e-6; # as measured
$webTime     = 1600e-6; # as measured
$thrdPerCPU  = 2;       # assumption


#-----------------------------------------------------------
# Calculate threaded server thruput by calling the subroutine
# Results go into global array called @threadX
#-----------------------------------------------------------
@threadX     = (1); # put a non-zero in zeroth position
	
$dbTime      =  Get_DBTime(5871.0e-6, 893.0e-6, 10.0e-6);

$appTime     = $jiTime - $dbTime;
$authentTime = $webTime + $appTime + $dbTime;
$thrdPool    = $nCPUs * $thrdPerCPU;

Thread_Server($VUsers, $thrdPool, $authentTime);



#-----------------------------------------------------------
#  Top-level composite model of Application
#-----------------------------------------------------------
my $j;

$pq[0][0] = 1.0;

for ($n = 1; $n <= $VUsers; $n++) {
    $R = 0.0; #  reset

    #  Application response time
    for ($j = 1; $j <= $n; $j++) {
        $R += ($j / $threadX[$j]) * $pq[$j - 1][$n - 1];
    }

    #  Application thruput and qlength
    $X = $n / ($VUthink + $R);
    $Q = $X * $R;

    #  Compute qlength dsn 
    for ($j = 1; $j <= $n; $j++) {
        $pq[$j][$n] = ($X / $threadX[$j]) * $pq[$j - 1][$n - 1];
    }

    #  Treat j = 0 case ... 
    $pq[0][$n] = 1.0;
    for ($j = 1; $j <= $n; $j++) {
        $pq[0][$n] -= $pq[$j][$n];
    }
}

$U = $X * $authentTime; # total utilization
Print_Results();




#-----------------------------------------------------------
# Subroutines 
#-----------------------------------------------------------

sub Get_DBTime
# Time in the database from various measurements
{
    my ($miss1Time, $miss2Time, $cacheTime) = @_;

    $totalCalls = 30;
    $db1Calls = 20;
    $db2Calls = 10;
    $cache1Misses = 2;
    $cache2Misses = 1;

    $probMiss1 = $cache1Misses/$totalCalls;
    $probHit1  = 1 - ($ldap1Calls - $cache1Miss)/$totalCalls; 

    $probMiss2 = $cache2Misses/$totalCalls;
    $probHit2  = 1 - ($ldap2Calls - $cache2Miss)/$totalCalls; 

    $ldapTime = ($probMiss1 * $miss1Time) + ($probHit1 * $cacheTime)  +
                ($probMiss2 * $miss2Time) + ($probHit2 * $cacheTime);
                  
    return($dbTime);

}


sub Thread_Server
{
    my ($nmax, $threads, $serviceTime) = @_;

    for ($i = 1; $i <= $nmax; $i++) {
        if ($i <= $threads) {
            push(@threadX, $i / $serviceTime);
        } else {
            push(@threadX, $threads / $serviceTime);
        }
    }
}


sub Print_Results
{
    printf("\n");
    printf("  Threaded Server Model\n", $thrdPool, $VUsers);
    printf("  -------------------------\n");
    printf("         >>INPUTS<<\n");
    printf("  LR virtual users:    %5d\n", $VUsers);
    printf("  Active threads:      %5d\n", $thrdPool);
    printf("  Number  of CPUs:     %5d\n", $nCPUs);
    printf("  Think time:          %12.6lf\n", $VUthink);
    printf("  Service time:        %12.6lf\n", $authentTime);
    printf("  -------------------------\n");
    printf("         >>OUTPUTS<<\n");
    printf("  Total utilization:   %12.6lf\n", $U);
    printf("  Utilization/thread:  %12.6lf\n", $U / $thrdPool);
    printf("  Requests in system:  %12.6lf\n", $Q);
    printf("  Requests in service: %12.6lf\n", $U);
    printf("  Requests waiting:    %12.6lf\n", $Q - $U);
    printf("  Avg. waiting time:   %12.6lf\n", $R - $authentTime);
    printf("  Mean thruput (TPS):  %12.6lf\n", $X);
    printf("  Response time (Sec): %12.6lf\n", $R);
    printf("  Stretch factor:      %12.6lf\n", $R / $authentTime);
    printf("  \n");
} 
