#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2007, Performance Dynamics Company                    #
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
# erlang.pl
#
# Modifed by NJG on Mon, Apr 2, 2007
# to match gdswithxsl.c

# Input parameters 
$arrivals = 149.99; # original was 75
$servers  = 30;
$servtime = 0.20;
$erlangs  = $arrivals * $servtime;

if($erlangs >= $servers) {
    print "Error: $erlangs Erlangs saturates $servers servers\n";
    exit;
}

$rho     = $erlangs / $servers;
$erlangB = $erlangs / (1 + $erlangs);
for ($m  = 2; $m <= $servers; $m++) {
    $eb  = $erlangB;
    $erlangB = $eb * $erlangs / ($m + ($eb * $erlangs));
}

$erlangC  = $erlangB / (1 - $rho + ($rho * $erlangB));

$wtE = $servtime * $erlangC / ($servers * (1 - $rho));
$rtE = $servtime + $wtE;             		 # Exact
$rtA = $servtime / (1 - $rho**$servers);   	 # Approx

# Output parameters 
printf("--------------------------------\n");
printf("Results for an M/M/%2d queue\n", $servers);
printf("--------------------------------\n");
printf("Offered load  (Erlangs): %8.4f\n", $erlangs);
printf("Utilization       (rho): %8.4f\n", $rho);
printf("Erlang B    (Loss prob): %8.4f\n", $erlangB);
printf("Erlang C (Waiting prob): %8.4f\n", $erlangC);
printf("Mean       Arrival rate: %8.4f\n", $arrivals);
printf("Mean       Service time: %8.4f\n", $servtime);
printf("Mean       Waiting time: %8.4f\n", $wtE);
printf("Mean       Waiting line: %8.4f\n", $arrivals * $wtE);
printf("Mean       Queue length: %8.4f\n", $arrivals * $rtE);
printf("Mean      Response time: %8.4f\n", $rtE);
printf("Approx    Response time: %8.4f\n", $rtA);
