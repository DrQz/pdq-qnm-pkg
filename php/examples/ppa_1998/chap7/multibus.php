<?php
/*
 * multibus.php
 * 
 * Created by NJG: 13:03:53  07-19-96 Updated by NJG: 19:31:12  07-31-96
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------
/* System parameters */

define("BUSES",9);
define("CPUS",64);
define("STIME",1.0);
define("COMPT",10.0);

//-------------------------------------------------------------------------
/* submodel throughput characteristic */

$sm_x = array(); // double [CPUS + 1];

//-------------------------------------------------------------------------

function multiserver($m, $stime) // int m, double stime
{
	global $sm_x;
	
    $i = 0;
	$nodes = 0;
	$streams = 0;
	$x = 0.0;
	$work = "reqs";
	$node = "bus";

	for ($i = 1; $i <= CPUS; $i++) {
		if ($i <= $m) {
	 		PDQ_Init("multibus");
	 		$streams = PDQ_CreateClosed($work, TERM, (double)$i, 0.0);
	 		$nodes = PDQ_CreateNode($node, CEN, ISRV);
	 		PDQ_SetDemand($node, $work, $stime);
	 		PDQ_Solve(EXACT);
	 		$x = PDQ_GetThruput(TERM, $work);
	 		$sm_x[$i] = $x;
		} else {
	 		$sm_x[$i] = $x;
		};
	};
}  /* multiserver */

//-------------------------------------------------------------------------

function main()
{
	global $sm_x;
    $i = 0;
	$j = 0;
    $n = 0;
	$xn = 0.0;
    $qlength = 0.0;
    $R = 0.0;
	$pq = array(array()); //[CPUS + 1][CPUS + 1];

	/* Multibus submodel   */

	multiserver(BUSES, STIME);

	/* Composite model   */

	$pq[0][0] = 1.0;

	for ($n = 1; $n <= CPUS; $n++) {
		$R = 0.0;			/* reset */

		for ($j = 1; $j <= $n; $j++)
	 		$R += ($j / $sm_x[$j]) * $pq[$j - 1][$n - 1];

		$xn = $n / (COMPT + $R);

		$qlength = $xn * $R;

		for ($j = 1; $j <= $n; $j++) {
	 		$pq[$j][$n] = ($xn / $sm_x[$j]) * $pq[$j - 1][$n - 1];
		};

		$pq[0][$n] = 1.0;

		for ($j = 1; $j <= $n; $j++) {
	 		$pq[0][$n] -= $pq[$j][$n];
		};
	};

	/************************
	 *   Processing Power   *
	 ************************/

    printf("Buses:%2d, CPUs:%2d\n", BUSES, CPUS);
    printf("Load %3.4f\n", STIME / COMPT);
    printf("X at FESC: %3.4f\n", $xn);
	printf("P %3.4f\n", $xn * COMPT);
};  /* main */

main();

?>
