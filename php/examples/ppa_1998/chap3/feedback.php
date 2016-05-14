<?php
/*
 * feedback.php
 * 
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//--------------------------------------------------------------------

function main($argc, $argv)
{

   global  $nodes, $streams;

   //---- Model specific variables -----
   $rx_prob = 0.30;
   $inter_arriv_rate = 0.5;
   $service_time = 0.75;
   $mean_visits = 1.0 / (1.0 - $rx_prob);

	//----- Initialize the model -----
   // Give model a name */

   PDQ_Init("Open Feedback");

   // Define the queueing center

   $nodes = PDQ_CreateNode("channel", CEN, FCFS);

   // Define the workload and circuit type

   $streams = PDQ_CreateOpen("message", $inter_arriv_rate);

   // Define service demand due to workload on the queueing center

   PDQ_SetVisits("channel", "message", $mean_visits, $service_time);

   //----- Solve the model -----
   // Must use the CANONical method for an open circuit

   PDQ_Solve(CANON);

   // Generate a report

   PDQ_Report();
};// main

main($argc, $argv); // Call the main function

?>