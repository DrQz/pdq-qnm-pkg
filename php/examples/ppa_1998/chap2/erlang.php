<?php
/*
 * erlang.php
 * 
 * Iterative computation of Erlang B and C functions.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

//----------------------------------------------------------------------------------
// This example was also added to the PDQ_Lib as function erlang($servers, $traffic)
//----------------------------------------------------------------------------------
//main

   $erlangB = 0.0;
   $erlangC = 0.0;
   $traffic = 0.0;
   $eb = 0.0;
   $rho = 0.0;
   $nrt = 0.0;
   $ql = 0.0;

   $m = 0;
   $servers = 0;


   /* inputs */
   echo "\n";
   if ($argc < 3) {
      printf("Usage: php %s <servers> <traffic>\n", $argv[0]);
      printf("NOTE:\n\tPer server load = traffic/servers\n");
      exit(1);
   };
   /* initialize variables */
   $servers = (integer) $argv[1];
   $traffic = (float) $argv[2];
   $rho = $traffic / $servers;
   $erlangB = $traffic / (1 + $traffic);

   /* Jagerman's algorithm */
   for ($m = 2; $m <= $servers; $m++) {
      $eb = $erlangB;
      $erlangB = $eb * $traffic / ($m + $eb * $traffic);
   };

   $erlangC = $erlangB / (1 - $rho + $rho * $erlangB);
   $nrt = 1 + $erlangC / ($servers * (1 - $rho));
   $ql = $traffic * $nrt;

   /* outputs */
   printf("  %ld Server System\n", $servers);
   printf("  -----------------\n");
   printf("  Traffic intensity:  %5.5lf\n", $traffic);
   printf("  Server utilization: %5.5lf\n", $rho);
   printf("  \n");
   printf("  Erlang B  (loss  prob): %5.5lf\n", $erlangB);
   printf("  Erlang C  (queue prob): %5.5lf\n", $erlangC);
   printf("  M/M/m    Normalized RT: %5.5lf\n", $nrt);
   printf("  M/M/m    No. in System: %5.5lf\n", $ql);

// main
?>