<?php
/*
 * repairfunc.php
 * 
 * Exact solution for M/M/m/N/N repairmen model.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//----------------------------------------------------------------------------------

function main($argc, $argv)
{

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

   repair($m, $S, $N, $Z);
    
};// main

main($argc, $argv);

?>