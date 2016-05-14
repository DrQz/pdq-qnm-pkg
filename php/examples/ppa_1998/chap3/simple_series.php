<?php
/*
 * simple_series.php
 * 
 * An open queueing circuit with 3 centers.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

function main()
{
   $noNodes = 0;
   $noStreams = 0;

   $arrivals_per_second = 0.10;

   /* Initialize and solve the model */

   PDQ_Init("Simple Series Circuit");

   $noStreams = PDQ_CreateOpen("Work", $arrivals_per_second);

   $noNodes = PDQ_CreateNode("Center1", CEN, FCFS);
   $noNodes = PDQ_CreateNode("Center2", CEN, FCFS);
   $noNodes = PDQ_CreateNode("Center3", CEN, FCFS);

   PDQ_SetDemand("Center1", "Work", 1.0);
   PDQ_SetDemand("Center2", "Work", 2.0);
   PDQ_SetDemand("Center3", "Work", 3.0);

   PDQ_Solve(CANON);

   PDQ_Report();

};// main

main();

?>