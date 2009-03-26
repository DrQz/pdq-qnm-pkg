#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 1996, Performance Dynamics Company                    #
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
#  erlang.c
#
#  Created in C by NJG: 15:06:09  06-27-96
#
#  $Id$
#

use Getopt::Std;

%opt = ();

getopts('s:t:v', \%opt);

#-------------------------------------------------------------------------------

sub usage
{
 	printf("Usage:  serverlng.pl traffic\n");
 	printf("NOTE:   Per server load = traffic/servers\n");
 	exit(1);
}

#---- inputs -------------------------------------------------------------------

if (defined($opt{"s"})) {
   $servers = $opt{"s"}
} else {
   usage()
}

if (defined($opt{"t"})) {
   $traffic = $opt{"t"}
} else {
   usage()
}

#----- initialize variables ----------------------------------------------------

$rho     = $traffic / $servers;
$erlangB = $traffic / (1 + $traffic);

#----- Jagerman's algorithm ----------------------------------------------------

for ($m = 2; $m <= $servers; $m++) {
	$eb = $erlangB;
	$erlangB = $eb * $traffic / ($m + $eb * $traffic);
}

$erlangC = $erlangB / (1 - $rho + $rho * $erlangB);
$nrt     = 1 + $erlangC / ($servers * (1 - $rho));
$ql      = $traffic * $nrt;

#----- outputs -----------------------------------------------------------------

printf("  %ld Server System\n", $servers);
printf("  -----------------\n");
printf("  Traffic intensity:  %5.5f\n", $traffic);
printf("  Server utilization: %5.5f\n", $rho);
printf("  \n");
printf("  Erlang B  (loss  prob): %5.5f\n", $erlangB);
printf("  Erlang C  (queue prob): %5.5f\n", $erlangC);
printf("  M/M/m    Normalized RT: %5.5f\n", $nrt);
printf("  M/M/m    No. in System: %5.5f\n", $ql);

#-------------------------------------------------------------------------------

