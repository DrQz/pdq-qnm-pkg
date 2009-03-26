#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
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

# erlang.pl

## Input parameters 
$servers = 8;
$erlangs = 4;

if($erlangs > $servers) {
    print "Error: Erlangs exceeds servers\n";
    exit;
}

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
