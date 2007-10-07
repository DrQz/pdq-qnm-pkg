<?php
/*
 * dbc.php - Teradata DBC-10/12 performance model
 * 
 * PDQ calculation of optimal parallel configuration.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

function main($argc, $argv) // use this function to make all used variable private and local
{
   global $nodes, $streams; // this are global to PDQ_Lib

   $k = 0; // Waring!! k is a global variable in the PDQ_Lib!!!
   $sol_mode = APPROX;
   $sol_name = "APPROX";
   $name = "";
   $nstr = "";

   /* input parameters */
   $think = 10.0;
   $users = 300; // 800;
   $Sifp = 0.10;
   $Samp = 0.60;
   $Sdsu = 1.20;
   $Nifp = 15;
   $Namp = 50;
   $Ndsu = 100;

   if ($argc == 2) {
       if ($argv[1] == "APPROX") {
          $sol_name = $argv[1];
          $sol_mode = APPROX;
       } else if ($argv[1] == "EXACT") {
          $sol_name = $argv[1];
          $sol_mode = EXACT;
       };
   };
   
   //PDQ_SetDebug(TRUE);
   PDQ_Init("Teradata DBC-10/12");

   /* Create parallel centers */

   for ($k = 0; $k < $Nifp; $k++) {
      $name = sprintf("IFP%d", $k);
      $nodes = PDQ_CreateNode($name, CEN, FCFS);
   };

   for ($k = 0; $k < $Namp; $k++) {
      $name = sprintf("AMP%d", $k);
      $nodes = PDQ_CreateNode($name, CEN, FCFS);
   };

   for ($k = 0; $k < $Ndsu; $k++) {
      $name = sprintf("DSU%d", $k);
      $nodes = PDQ_CreateNode($name, CEN, FCFS);
   };

   $streams = PDQ_CreateClosed("query", TERM, (double) $users, $think);

   /*PDQ_SetGraph("query", 100); - unsupported call */

   for ($k = 0; $k < $Nifp; $k++) {
      $name = sprintf("IFP%d", $k);
      PDQ_SetDemand($name, "query", $Sifp / $Nifp);
   };

   for ($k = 0; $k < $Namp; $k++) {
      $name = sprintf("AMP%d", $k);
      PDQ_SetDemand($name, "query", $Samp / $Namp);
   };

   for ($k = 0; $k < $Ndsu; $k++) {
      $name = sprintf("DSU%d", $k);
      PDQ_SetDemand($name, "query", $Sdsu / $Ndsu);
   };

   /* 300 nodes takes about a minute to solve on a PowerMac */
   printf("Solving %s... ", $sol_name);

   PDQ_Solve($sol_mode);

   printf("Done.\n");

   /* PDQ_PrintXLS();  - unsupported call */

   PDQ_Report();

};// main

main($argc, $argv);

?>