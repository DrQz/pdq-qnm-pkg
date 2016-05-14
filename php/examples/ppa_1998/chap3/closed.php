<?php
/*
 * closed.php
 * 
 * Illustrate use of PDQ solver for a closed circuit queue.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_lib.php";

//-------------------------------------------------------------------------

function main($argc, $argv)
{

   /****************************
    * Model specific variables *
    ****************************/
    $noNodes = 0;
    $noStreams = 0;
    $solve_as = APPROX; // or EXACT;
    $pop = 3.0;
    $think = 0.1;

   /************************
    * Initialize the model *
    ************************/

    /* Give model a name and initialize internal PDQ variables */

    PDQ_Init("Closed Queue");

    printf("**** %s ****:\n", $solve_as == EXACT ? "EXACT" : "APPROX");

	/* Define the workload and circuit type */

	$noStreams = PDQ_CreateClosed("w1", TERM, 1.0 * $pop, $think);

	/* Define the queueing center */

	$noNodes = PDQ_CreateNode("node", CEN, FCFS);

	/* Define service demand */

	PDQ_SetDemand("node", "w1", 0.10);

	/*******************
	* Solve the model *
	*******************/

	PDQ_Solve($solve_as);

	PDQ_Report();

}; // main

main($argc, $argv);

?>