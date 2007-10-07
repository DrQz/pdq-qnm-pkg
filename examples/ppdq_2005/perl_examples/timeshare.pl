#!/usr/bin/perl
#  timeshare.pl

$m = 2;
$N = 4;
$D = 5;
$Z = 0.001;

$p = $p0 = 1;
$L = 0;

for ($k = 1; $k <= $N; $k++) {
   $p *= ($N - $k + 1) * $D / $Z;

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
$W   = $L * ($D + $Z) / ($N - $L);
$R   = $W + $D;
$X   = $N / ($R + $Z);
$U   = $X * $D;
$rho = $U / $m;
$Q   = $X * $R;

printf("\n");
printf("  M/M/%ld//%ld Time-Share Model\n", $m, $N);
printf("  --------------------------------\n");
printf("  CPU processors    (m):%4d\n", $m);
printf("  Total processes   (N):%4d\n", $N);
printf("  Execution time    (D):%9.4f\n", $D);
printf("  Suspended time    (Z):%9.4f\n", $Z);
printf("  Execution rate       :%9.4f\n", 1 / $D);
printf("  Utilization       (U):%9.4f\n", $U);
printf("  Utilzn. per CPU (rho):%9.4f\n", $rho);
printf("  \n");
printf("  Average load      (Q):%9.4f\n", $Q);
printf("  Average in service   :%9.4f\n", $U);
printf("  Average enqueued (Qw):%9.4f\n", $Q - $U);
printf("  Throughput        (X):%9.4f\n", $X);
printf("  Waiting time      (W):%9.4f\n", $R - $D);
printf("  Completion time   (R):%9.4f\n", $R);
printf("  \n");

