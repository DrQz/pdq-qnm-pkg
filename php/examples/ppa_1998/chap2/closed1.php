<?php
/*
 * closed1.php
 * 
 * Illustrates PDQ solver for closed uni-server queue. Compare with repair.c
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

function main($argc, $argv)
{
   //----- Model specific variables ---------------------------------------

   global $streams, $nodes;
   
   $pop = 100.0;
   $think = 300.0;
   $servt = 0.63;

   //----- Initialize the model -------------------------------------------
	/* Give model a name */

   PDQ_Init("Time Share Computer");

   /* Define the workload and circuit type */

   $streams = PDQ_CreateClosed("compile", TERM, $pop, $think);

   /* Define the queueing center */

   $nodes = PDQ_CreateNode("CPU", CEN, FCFS);

   /* Define service demand */

   PDQ_SetDemand("CPU", "compile", $servt);

   //----- Solve the model ------------------------------------------------
   PDQ_Solve(EXACT);
   //----- Solve the model ------------------------------------------------
   PDQ_Report();

}; // main

main($argc, $argv);

?>
