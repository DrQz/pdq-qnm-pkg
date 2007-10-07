#!/usr/bin/perl
# 
#  repair.c
#  
#  Exact solution for M/M/m/N/N repairmen model.
#  
#  Created by NJG: 17:45:47  12-19-94 Updated by NJG: 16:45:35  02-26-96
#  
#  $Id$
#
#-------------------------------------------------------------------------------


#   double          L;      /* mean number of broken machines in line */
#   double          Q;      /* mean number of broken machines in
#                            * system */
#   double          R;      /* mean response time */
#   double          S;      /* mean service time */
#   double          U;      /* total mean utilization */
#   double          rho;    /* per server utilization */
#   double          W;      /* mean time waiting for repair */
#   double          X;      /* mean throughput */
#   double          Z;      /* mean time to failure (MTTF) */
#   double          p;      /* temp variable for prob calc. */
#   double          p0;     /* prob if zero breakdowns */
#
#   long            m;      /* Number of servicemen */
#   long            N;      /* Number of machines */
#   long            k;      /* loop index */
#
#   Example:
# 
#     repair.pl 5 1 20 50
#


if ($#ARGV != 3) {
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

