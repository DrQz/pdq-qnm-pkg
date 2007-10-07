<?php
/*
 * repair.php
 * 
 * Exact solution for M/M/m/N/N repairmen model.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

//----------------------------------------------------------------------------------
// This example was also added to the PDQ_Lib as function repair($m, $S, $N, $Z)
//----------------------------------------------------------------------------------

// main

    $L = 0.0;		/* mean number of broken machines in line */
    $Q = 0.0;		/* mean number of broken machines in system */
    $R = 0.0;		/* mean response time */
    $U = 0.0;		/* total mean utilization */
    $rho = 0.0;		/* per server utilization */
    $W = 0.0;		/* mean time waiting for repair */
    $X = 0.0;		/* mean throughput */
    $p = 0.0;		/* temp variable for prob calc. */
    $p0 = 0.0;		/* prob if zero breakdowns */
    $k = 0;		    /* loop index */

    $m = 0;		    /* Number of servicemen */
    $S = 0.0;		/* mean service time */
    $N = 0;		    /* Number of machines */
    $Z = 0.0;		/* mean time to failure (MTTF) */

    function atol($s)
    {
        $i = (integer) $s;
        return $i;
    };

    function atof($s)
    {
        $f = (float) $s;
        return $f;
    };


   if ($argc < 5) {
      printf("Usage: %s m S N Z\n", $argv[0]);
      printf("Where:\n");
      printf("\tm = Number of servicemem\n");
      printf("\tS = Mean service time\n");
      printf("\tN = Number of machine\n");
      printf("\tZ = Mean time to failure (MTTF)\n");
      printf("\n");
      exit(1);
   };
   
   $m = atol($argv[1]);
   $S = atof($argv[2]);
   $N = atol($argv[3]);
   $Z = atof($argv[4]);

   $p = 1;
   $p0 = 1;
   $L = 0;

   for ($k = 1; $k <= $N; $k++) {
      $p *= ($N - $k + 1) * $S / $Z;

      if ($k <= $m) {
	       $p /= $k;
      } else {
	       $p /= $m;
      };
      $p0 += $p;

      if ($k > $m) {
	       $L += $p * ($k - $m);
      };
   }; /* k loop */

   $p0 = 1.0 / $p0;
   $L *= $p0;
   $W = $L * ($S + $Z) / ($N - $L);
   $R = $W + $S;
   $X = $N / ($R + $Z);
   $U = $X * $S;
   $rho = $U / $m;
   $Q = $X * $R;

   printf("\n");
   printf("  M/M/%ld/%ld/%ld Repair Model\n", $m, $N, $N);
   printf("  ----------------------------\n");
   printf("  Machine pop:      %4ld\n", $N);
   printf("  MT to failure:    %9.4lf\n", $Z);
   printf("  Service time:     %9.4lf\n", $S);
   printf("  Breakage rate:    %9.4lf\n", 1 / $Z);
   printf("  Service rate:     %9.4lf\n", 1 / $S);
   printf("  Utilization:      %9.4lf\n", $U);
   printf("  Per Server:       %9.4lf\n", $rho);
   printf("  \n");
   printf("  No. in system:    %9.4lf\n", $Q);
   printf("  No. in service:   %9.4lf\n", $U);
   printf("  No. enqueued:     %9.4lf\n", $Q - $U);
   printf("  Waiting time:     %9.4lf\n", $R - $S);
   printf("  Throughput:       %9.4lf\n", $X);
   printf("  Response time:    %9.4lf\n", $R);
   printf("  Normalized RT:    %9.4lf\n", $R / $S);
   printf("  \n");

// main
?>