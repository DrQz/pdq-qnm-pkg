<?php
/*
 * open1.php
 * 
 * Illustrate use of PDQ solver for open uni-server queue.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//----------------------------------------------------------------------------

function main($argc, $argv)
{
   //----- Model specific variables -----
   global $nodes, $streams;
   
   $arrivRate = 0.75;
   $service_time = 1.0;

   //----- Initialize the model & Give it a name ------

   PDQ_Init("OpenCenter");
   
   //----- Change unit labels -----

   PDQ_SetWUnit("Customers");
   PDQ_SetTUnit("Seconds");

   //----- Define the queueing center -----

   $nodes = PDQ_CreateNode("server", CEN, FCFS);

   //----- Define the workload and circuit type -----

   $streams = PDQ_CreateOpen("work", $arrivRate);

   //----- Define service demand due to workload on the queueing center ------

   PDQ_SetDemand("server", "work", $service_time);

   //----- Solve the model -----
   //  Must use the CANONical method for an open circuit

   PDQ_Solve(CANON);

   //----- Generate a report -----

   PDQ_Report();
}; // main

main($argc, $argv);

?>