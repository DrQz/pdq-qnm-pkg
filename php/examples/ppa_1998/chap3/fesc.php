<?php
/*
 * fesc.php -- Flow Equivalent Service Center model
 *
 * Composite system is a closed circuit comprising N USERS
 * and a FESC submodel with a single-class workload.
 *
 * This model is discussed on p.112 ff. of the book that accompanies
 * PDQ entitled: "The Practical Performance Analyst," by N.J.Gunther
 * and matches the results presented in the book: "Quantitative System
 * Performance," by Lazowska, Zahorjan, Graham, and Sevcik, Prentice-Hall
 * 1984.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

define("USERS",15);

// Global Variables
$sm_x = array(); // float [USERS + 1];/* submodel throughput characteristic */

function mem_model($n, $m)
{
	$x = 0.0;
	$i = 0;
	$noNodes = 0;
	$noStreams = 0;
	global $sm_x;

	for ($i = 1; $i <= $n; $i++) {
		if ($i <= $m) {

			PDQ_Init("");

			$noNodes = PDQ_CreateNode("CPU", CEN, FCFS);
			$noNodes = PDQ_CreateNode("DK1", CEN, FCFS);
			$noNodes = PDQ_CreateNode("DK2", CEN, FCFS);

			$noStreams = PDQ_CreateClosed("work", TERM, (float) $i, 0.0);

			PDQ_SetDemand("CPU", "work", 3.0);
			PDQ_SetDemand("DK1", "work", 4.0);
			PDQ_SetDemand("DK2", "work", 2.0);

			PDQ_Solve(EXACT);

			$x = PDQ_GetThruput(TERM, "work");
			$sm_x[$i] = $x;

		} else {
			$sm_x[$i] = $x;        /* last computed value */
		};

	};
}  /* mem_model */

//-------------------------------------------------------------------------


function main()
{

	/****************************
	 * Model specific variables *
	 ****************************/

    $noNodes = 0;
    $noStreams = 0;
    $j = 0;
    $n = 0;
    $max_pgm = 3;
    $think = 60.0;
    $xn = 0.0;
    $qlength = 0.0;
    $R = 0.0;
    global  $sm_x;
	$pq = array(array()); // float[USERS + 1][USERS + 1];


	/****************************
	 * Memory-limited Submodel  *
	 ****************************/
	mem_model(USERS, $max_pgm);


	/***********************
	 *   Composite Model   *
	 ***********************/
	$pq[0][0] = 1.0;

	for ($n = 1; $n <= USERS; $n++) {
		$R = 0.0;                /* reset */

		/* response time at the FESC */
		for ($j = 1; $j <= $n; $j++)
			$R += ($j / $sm_x[$j]) * $pq[$j - 1][$n - 1];

		/* thruput and queue-length at the FESC */
		$xn = $n / ($think + $R);
		$qlength = $xn * $R;

		/* compute queue-length distribution at the FESC */
		for ($j = 1; $j <= $n; $j++)
			$pq[$j][$n] = ($xn / $sm_x[$j]) * $pq[$j - 1][$n - 1];

		$pq[0][$n] = 1.0;

		for ($j = 1; $j <= $n; $j++)
			$pq[0][$n] -= $pq[$j][$n];

	};

	/************************
	 * Report FESC Measures *
	 ************************/

	printf("\n");
	printf("Max Users: %2d\n", USERS);
	printf("X at FESC: %3.4f\n", $xn);
	printf("R at FESC: %3.2f\n", $R);
	printf("Q at FESC: %3.2f\n\n", $qlength);

	/* Joint Probability Distribution */

	printf("QLength\t\tP(j | n)\n");
	printf("-------\t\t--------\n");
	for ($n = 0; $n <= USERS; $n++)
		printf(" %2d\t\tp(%2d|%2d): %3.4f\n", $n, $n, USERS, $pq[$n][USERS]);

};/* main */

main();

?>