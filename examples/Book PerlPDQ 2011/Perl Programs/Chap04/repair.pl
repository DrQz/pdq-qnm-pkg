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

# repair.pl

if ($#ARGV != 4) {
   printf "Usage: repair m S N Z\n";
   exit(1);
}
$m = $ARGV[0];
$S = $ARGV[1];
$N = $ARGV[2];
$Z = $ARGV[3];
$p = $p0 = 1;
$L = 0;

for ($k = 1; $k <= $N; $k++) {
   $p *= ($N - $k + 1) * $S / $Z;
   if ($k <= $m) {
      $p /= $k;
   } else {
      $p /= $m;
   }
   $p0 += $p;
   if ($k > $m) {
      $L += $p * ($k - $m);
   }
}

$p0  = 1.0 / $p0;
$L  *= $p0;
$W   = $L * ($S + $Z) / ($N - $L);
$R   = $W + $S;
$X   = $N / ($R + $Z);
$U   = $X * $S;
$rho = $U / $m;
$Q   = $X * $R;

printf("\n");
printf("  M/M/%ld/%ld/%ld Repair Model\n", $m, $N, $N);
printf("  ----------------------------\n");
printf("  Machine pop:      %4d\n", $N);
printf("  MT to failure:    %9.4f\n", $Z);
printf("  Service time:     %9.4f\n", $S);
printf("  Breakage rate:    %9.4f\n", 1 / $Z);
printf("  Service rate:     %9.4f\n", 1 / $S);
printf("  Utilization:      %9.4f\n", $U);
printf("  Per Server:       %9.4f\n", $rho);
printf("  \n");
printf("  No. in system:    %9.4f\n", $Q);
printf("  No in service:    %9.4f\n", $U);
printf("  No.  enqueued:    %9.4f\n", $Q - $U);
printf("  Waiting time:     %9.4f\n", $R - $S);
printf("  Throughput:       %9.4f\n", $X);
printf("  Response time:    %9.4f\n", $R);
printf("  Normalized RT:    %9.4f\n", $R / $S);
printf("  \n");
