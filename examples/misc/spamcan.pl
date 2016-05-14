#! /usr/bin/perl
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
# Created by NJG Tue Jun 14 15:14:29 PDT 2005
#
# Queueing model of an email-spam analyzer system comprising a 
# battery of SMP servers essentially running in batch mode. 
# Each node was a 4-way SMP server.
# The performance metric of interest was the mean queue length.
# (Hmmm ... This could be a good time to make a queueing model!!!)
#
# This simple M/M/4 model gave results that were in surprisingly 
# good agreement with monitored queue lengths.
#
# $Id$

## Input parameters 
$servers  = 4;
$pcntBusy = 0.99;
$erlangs  = $pcntBusy * $servers;

if($erlangs > $servers) {
    print "Error: Erlangs cannot exceed servers\n";
    exit;
}

# Jagerman's algorithm 
# from p. 85 of book "Analyzing ... with Perl::PDQ")
$rho     = $erlangs / $servers;
$erlangB = $erlangs / (1 + $erlangs);
for ($m  = 2; $m <= $servers; $m++) {
    $eb  = $erlangB;
    $erlangB = $eb * $erlangs / ($m + ($eb * $erlangs));
}

$erlangC  = $erlangB / (1 - $rho + ($rho * $erlangB));
$normdwtE = $erlangC / ($servers * (1 - $rho));
$normdrtE = 1 + $normdwtE;              # Exact
$normdrtA = 1 / (1 - $rho**$servers);   # Approx
$queueLen = ($rho * $erlangC / (1 - $rho)) + $erlangs;

## Output results 
printf("%2d-server Queue\n", $servers);
printf("--------------------------------\n");
printf("Offered load    (Erlangs): %8.4f\n", $erlangs);
printf("Server utilization  (rho): %8.4f\n", $rho);
printf("Erlang B      (Loss prob): %8.4f\n", $erlangB);
printf("Erlang C   (Waiting prob): %8.4f\n", $erlangC);
printf("Normalized   Waiting Time: %8.4f\n", $normdwtE);
printf("Normalized  Response Time: %8.4f\n", $normdrtE);
printf("Approximate Response Time: %8.4f\n", $normdrtA);
printf("Mean queue length:         %8.4f\n", $queueLen);
