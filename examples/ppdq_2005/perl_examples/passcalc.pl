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

# passcalc.pl

$appsPerHour =  15;
$lambda = $appsPerHour / 3600;

#### Branching ratios 
$p12 = 0.30;
$p13 = 0.70;
$p23 = 0.20;
$p32 = 0.10;
printf(" Arrival: %10.4f per Hr.\n", $appsPerHour);
printf(" lambda : %10.4f per Sec.\n", $lambda);
printf("----------------------------\n");

$L2 = $lambda * ($p12 + ($p32 * $p13)) / (1 - ($p32 * $p23));
$L3 = ($p13 * $lambda) + ($p23 * $L2);
printf(" lambda1: %10.4f * lambda\n", 1.0);
printf(" lambda2: %10.4f * lambda\n", $L2 / $lambda);
printf(" lambda3: %10.4f * lambda\n", $L3 / $lambda);
printf(" lambda4: %10.4f * lambda\n", 1.0);
printf("----------------------------\n");

$rho1 = $lambda * 20;
$rho2 = $L2 * 600;
$rho3 = $L3 * 300;
$rho4 = $lambda * 60;
printf("Uwindow1: %10.4f * lambda\n", $rho1 / $lambda);
printf("Uwindow2: %10.4f * lambda\n", $rho2 / $lambda);
printf("Uwindow3: %10.4f * lambda\n", $rho3 / $lambda);
printf("Uwindow4: %10.4f * lambda\n", $rho4 / $lambda);
printf("----------------------------\n");
$Q1 = $rho1 / (1 - $rho1);
$Q2 = $rho2 / (1 - $rho2);
$Q3 = $rho3 / (1 - $rho3);
$Q4 = $rho4 / (1 - $rho4);

printf("Qwindow1: %10.4f\n", $Q1);
printf("Qwindow2: %10.4f\n", $Q2);
printf("Qwindow3: %10.4f\n", $Q3);
printf("Qwindow4: %10.4f\n", $Q4);
printf("----------------------------\n");
$R = ($Q1 + $Q2 + $Q3 + $Q4) / $lambda;

printf("Rpassprt: %10.4f Secs.\n", $R);
printf("Rpassprt: %10.4f Hrs.\n", $R / 3600);
printf("----------------------------\n");
