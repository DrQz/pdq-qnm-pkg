<?php
/*
 * baseline.php - corrected Client/server model
 *
 * Revised by njgunther@perfdynamics.com Thu Nov 15 11:33:23  2001
 * Updated by njgunther@perfdynamics.com Sun Nov 18 10:10:49  2001
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//----- Model Parameters --------------------------------------------------

// Useful multipliers ...

define("K",1024.00);
define("MIPS",1000000);
define("MBPS",1000000);

// Model parameters ...

define("USERS",125);
define("FS_DISKS",1);
define("MF_DISKS",4);
define("PC_MIPS",(27 * MIPS));
define("FS_MIPS",(41 * MIPS));
define("GW_MIPS",(10 * MIPS));
define("MF_MIPS",(21 * MIPS));
define("TR_MBPS",(4 * MBPS));
define("TR_FACT",2.5); /* fudge factor */

define("MAXPROC",20);
define("MAXDEV",50);

// Computing Device IDs

define("PC",0);
define("FS",1);
define("GW",2);
define("MF",3);
define("TR",4);
define("FDA",10);
define("MDA",20);

// Transaction IDs

define("CD",0);                   /* Category Display */
define("RQ",1);                   /* Remote Query */
define("SU",2);                   /* Status Update */

// Process IDs  from 1993 paper

define("CD_REQ",1);
define("CD_RPY",15);
define("RQ_REQ",2);
define("RQ_RPY",16);
define("SU_REQ",3);
define("SU_RPY",17);
define("REQ_CD",4);
define("REQ_RQ",5);
define("REQ_SU",6);
define("CD_MSG",12);
define("RQ_MSG",13);
define("SU_MSG",14);
define("GT_SND",7);
define("GT_RCV",11);
define("MF_CD",8);
define("MF_RQ",9);
define("MF_SU",10);
define("LAN_TX",18);


//-------------------------------------------------------------------------
class DEVARRAY_TYPE
{
    var $id = 0; // int
    var $label = ""; // char [MAXCHARS]
};
//-------------------------------------------------------------------------

function main()
{
    global $job;
    global $node;

    // Name of this model ...
    $scenario = "C/S Baseline";


	$noNodes = 0;
    $noStreams = 0;
    $txCD = ""; // char [MAXCHARS]
    $txRQ = ""; // char [MAXCHARS]
    $txSU = ""; // char [MAXCHARS]
    $X = 0.0;
	$ulan = 0.0; // double
    $ufs = 0.0; // double
    $uws = 0.0; // double
    $ugw = 0.0; // double
    $umf = 0.0; // double
	$work = 0; // int
    $dev = 0; // int
    $i = 0; // int
    $j = 0; // int

	$demand = array(array()); // double [MAXPROC][MAXDEV]
    $util = array(); // double [MAXDEV]
    $udsk = array(); // double [MAXDEV],
    $udasd = array(); // double [MAXDEV];
    // initialize vectors:
	for ($i = 0; $i < MAXDEV; $i++)
	{
	   $util[$i] = 0.0;
	   $udsk[$i] = 0.0;
	   $udasd[$i] = 0.0;
	   for ($j = 0; $j < MAXPROC; $j++) $demand[$j][$i] = 0.0;
	};

    $FDarray = array();
	$MDarray = array();
	// Allocate FDarray and MDarray
    for ($i = 0; $i < 10; $i++)
	{
	   $FDarray[$i] = new DEVARRAY_TYPE();
	   $MDarray[$i] = new DEVARRAY_TYPE();
	};
	
	for ($i = 0; $i < FS_DISKS; $i++) {
		$FDarray[$i]->id = FDA + $i;
		$FDarray[$i]->label = sprintf("FD%d", $i);
	};

	for ($i = 0; $i < MF_DISKS; $i++) {
		$MDarray[$i]->id = MDA + $i;
		$MDarray[$i]->label = sprintf("MD%d", $i);
	};

	/*
	 * CPU service times are calculated from MIPS Instruction counts in
	 * tables presented in original 1993 CMG paper.
	 */

	$demand[CD_REQ][PC] = 200 * K / PC_MIPS;
	$demand[CD_RPY][PC] = 100 * K / PC_MIPS;
	$demand[RQ_REQ][PC] = 150 * K / PC_MIPS;
	$demand[RQ_RPY][PC] = 200 * K / PC_MIPS;
	$demand[SU_REQ][PC] = 300 * K / PC_MIPS;
	$demand[SU_RPY][PC] = 300 * K / PC_MIPS;

	$demand[REQ_CD][FS] = 50 * K / FS_MIPS;
	$demand[REQ_RQ][FS] = 70 * K / FS_MIPS;
	$demand[REQ_SU][FS] = 10 * K / FS_MIPS;
	$demand[CD_MSG][FS] = 35 * K / FS_MIPS;
	$demand[RQ_MSG][FS] = 35 * K / FS_MIPS;
	$demand[SU_MSG][FS] = 35 * K / FS_MIPS;

	$demand[GT_SND][GW] = 50 * K / GW_MIPS;
	$demand[GT_RCV][GW] = 50 * K / GW_MIPS;

	$demand[MF_CD][MF] = 50 * K / MF_MIPS;
	$demand[MF_RQ][MF] = 150 * K / MF_MIPS;
	$demand[MF_SU][MF] = 20 * K / MF_MIPS;

	// packets generated at each of the following sources ...

	$demand[LAN_TX][PC] = 2 * K * TR_FACT / TR_MBPS;
	$demand[LAN_TX][FS] = 2 * K * TR_FACT / TR_MBPS;
	$demand[LAN_TX][GW] = 2 * K * TR_FACT / TR_MBPS;

	/* File server Disk I/Os = #accesses x caching / (max IOs/Sec) */

	for ($i = 0; $i < FS_DISKS; $i++) {
		$demand[REQ_CD][$FDarray[$i]->id] = (1.0 * 0.5 / 128.9) / FS_DISKS;
		$demand[REQ_RQ][$FDarray[$i]->id] = (1.5 * 0.5 / 128.9) / FS_DISKS;
		$demand[REQ_SU][$FDarray[$i]->id] = (0.2 * 0.5 / 128.9) / FS_DISKS;
		$demand[CD_MSG][$FDarray[$i]->id] = (1.0 * 0.5 / 128.9) / FS_DISKS;
		$demand[RQ_MSG][$FDarray[$i]->id] = (1.5 * 0.5 / 128.9) / FS_DISKS;
		$demand[SU_MSG][$FDarray[$i]->id] = (0.5 * 0.5 / 128.9) / FS_DISKS;
	};

	/* Mainframe DASD I/Os = (#accesses / (max IOs/Sec)) / #disks */

	for ($i = 0; $i < MF_DISKS; $i++) {
		$demand[MF_CD][$MDarray[$i]->id] = (2.0 / 60.24) / MF_DISKS;
		$demand[MF_RQ][$MDarray[$i]->id] = (4.0 / 60.24) / MF_DISKS;
		$demand[MF_SU][$MDarray[$i]->id] = (1.0 / 60.24) / MF_DISKS;
	};


	// Start building the PDQ model  ...

	PDQ_Init($scenario);

	// Define physical resources as queues ...

	$noNodes = PDQ_CreateNode("PC", CEN, FCFS);
	$noNodes = PDQ_CreateNode("FS", CEN, FCFS);

	for ($i = 0; $i < FS_DISKS; $i++) {
		$noNodes = PDQ_CreateNode($FDarray[$i]->label, CEN, FCFS);
	};

	$noNodes = PDQ_CreateNode("GW", CEN, FCFS);
	$noNodes = PDQ_CreateNode("MF", CEN, FCFS);

	for ($i = 0; $i < MF_DISKS; $i++) {
		  $noNodes = PDQ_CreateNode($MDarray[$i]->label, CEN, FCFS);
	}

	$noNodes = PDQ_CreateNode("TR", CEN, FCFS);

	/*
	 * NOTE: Althought the Token Ring LAN is a passive computational device,
	 * it is treated as a separate node so as to agree to the results
	 * presented in the original CMG'93 paper.
	 */

	// Assign transaction names ...

	$txCD = "CatDsply";
	$txRQ = "RemQuote";
	$txSU = "StatusUp";

	// Define an OPEN circuit aggregate workload ...

	$noStreams = PDQ_CreateOpen($txCD, USERS * 4.0 / 60.0);
	$noStreams = PDQ_CreateOpen($txRQ, USERS * 8.0 / 60.0);
	$noStreams = PDQ_CreateOpen($txSU, USERS * 1.0 / 60.0);

	// Define the service demands on each physical resource ...
	// CD request + reply chain  from workflow diagram

	PDQ_SetDemand("PC", $txCD, $demand[CD_REQ][PC] + (5 * $demand[CD_RPY][PC]));
	PDQ_SetDemand("FS", $txCD, $demand[REQ_CD][FS] + (5 * $demand[CD_MSG][FS]));

	for ($i = 0; $i < FS_DISKS; $i++) {
		PDQ_SetDemand($FDarray[$i]->label, $txCD,$demand[REQ_CD][$FDarray[$i]->id] + (5 * $demand[CD_MSG][$FDarray[$i]->id]));
	};

	PDQ_SetDemand("GW", $txCD, $demand[GT_SND][GW] + (5 * $demand[GT_RCV][GW]));
	PDQ_SetDemand("MF", $txCD, $demand[MF_CD][MF]);

	for ($i = 0; $i < MF_DISKS; $i++) {
		PDQ_SetDemand($MDarray[$i]->label, $txCD,$demand[MF_CD][$MDarray[$i]->id]);
	};

	/*
    *  NOTE: Synchronous process execution causes data for the CD
	 * transaction to cross the LAN 12 times as depicted in the following
	 * parameterization of PDQ_SetDemand.
	 */

	PDQ_SetDemand("TR", $txCD,(1 * $demand[LAN_TX][PC]) + (1 * $demand[LAN_TX][FS]) + (5 * $demand[LAN_TX][GW]) +  (5 * $demand[LAN_TX][FS]) );

	// RQ request + reply chain ...

	PDQ_SetDemand("PC", $txRQ, $demand[RQ_REQ][PC] + (3 * $demand[RQ_RPY][PC]));
	PDQ_SetDemand("FS", $txRQ, $demand[REQ_RQ][FS] + (3 * $demand[RQ_MSG][FS]));

	for ($i = 0; $i < FS_DISKS; $i++) {
		PDQ_SetDemand($FDarray[$i]->label, $txRQ, $demand[REQ_RQ][$FDarray[$i]->id] + (3 * $demand[RQ_MSG][$FDarray[$i]->id]) );
	};

	PDQ_SetDemand("GW", $txRQ, $demand[GT_SND][GW] + (3 * $demand[GT_RCV][GW]));
	PDQ_SetDemand("MF", $txRQ, $demand[MF_RQ][MF]);

	for ($i = 0; $i < MF_DISKS; $i++) {
		PDQ_SetDemand($MDarray[$i]->label, $txRQ, $demand[MF_RQ][$MDarray[$i]->id]);
	};

	PDQ_SetDemand("TR", $txRQ, (1 * $demand[LAN_TX][PC]) +  (1 * $demand[LAN_TX][FS]) +  (3 * $demand[LAN_TX][GW]) +  (3 * $demand[LAN_TX][FS]) );

	// SU request + reply chain  ...

	PDQ_SetDemand("PC", $txSU, $demand[SU_REQ][PC] + $demand[SU_RPY][PC]);
	PDQ_SetDemand("TR", $txSU, $demand[LAN_TX][PC]);
	PDQ_SetDemand("FS", $txSU, $demand[REQ_SU][FS] + $demand[SU_MSG][FS]);

	for ($i = 0; $i < FS_DISKS; $i++) {
		PDQ_SetDemand($FDarray[$i]->label, $txSU,$demand[REQ_SU][$FDarray[$i]->id] + $demand[SU_MSG][$FDarray[$i]->id]);
	};

	PDQ_SetDemand("TR", $txSU, $demand[LAN_TX][FS]);
	PDQ_SetDemand("GW", $txSU, $demand[GT_SND][GW] + $demand[GT_RCV][GW]);
	PDQ_SetDemand("MF", $txSU, $demand[MF_SU][MF]);

	for ($i = 0; $i < MF_DISKS; $i++) {
		PDQ_SetDemand($MDarray[$i]->label, $txSU,$demand[MF_SU][$MDarray[$i]->id]);
	};

	PDQ_SetDemand("TR", $txSU,(1 * $demand[LAN_TX][PC]) + (1 * $demand[LAN_TX][FS]) + (1 * $demand[LAN_TX][GW]) + (1 * $demand[LAN_TX][FS]));


	PDQ_Solve(CANON);

	PDQ_Report();

	// Break out Tx response times and device utilizations ...

	printf("*** PDQ Breakout \"%s\" (%d clients) ***\n\n", $scenario, USERS);

	for ($dev = 0; $dev < $noNodes; $dev++) {
		$util[$dev] = 0.0;  // Reset array
		for ($work = 0; $work < $noStreams; $work++) {
			$util[$dev] += 100 * PDQ_GetUtilization($node[$dev]->devname,$job[$work]->trans->name, TRANS);
		};
	};

	// Order of print out follows that in 1993 CMG paper.

	printf("Transaction  \tLatency(Secs)\n");
	printf("-----------  \t-----------\n");

	for ($work = 0; $work < $noStreams; $work++) {
		printf("%s\t%7.4f\n",$job[$work]->trans->name, $job[$work]->trans->sys->response);
	};

	printf("\n\n");

	for ($dev = 0; $dev < $noNodes; $dev++) {
		if ($node[$dev]->devname == "PC")
			$uws += $util[$dev];
		if ($node[$dev]->devname == "GW")
			$ugw += $util[$dev];
		if ($node[$dev]->devname == "FS")
			$ufs += $util[$dev];

		for ($i = 0; $i < FS_DISKS; $i++) {
			if ($node[$dev]->devname == $FDarray[$i]->label)
				$udsk[$i] += $util[$dev];
		};

		if ($node[$dev]->devname == "MF")
			$umf += $util[$dev];

		for ($i = 0; $i < MF_DISKS; $i++) {
			if ($node[$dev]->devname == $MDarray[$i]->label)
				$udasd[$i] += $util[$dev];
		};

		if ($node[$dev]->devname == "TR")
			$ulan += $util[$dev];
	};

	printf("Node      \t%% Utilization\n");
	printf("----      \t--------------\n");
	printf("%s\t%7.4f\n", "Token Ring ", $ulan);
	printf("%s\t%7.4f\n", "Desktop PC ", $uws / USERS);
	printf("%s\t%7.4f\n", "FileServer ", $ufs);

	for ($i = 0; $i < FS_DISKS; $i++) {
		printf("%s%d\t%7.4f\n", "FS Disk", $FDarray[$i]->id, $udsk[$i]);
	};

	printf("%s\t%7.4f\n", "Gateway SNA", $ugw);
	printf("%s\t%7.4f\n", "Mainframe  ", $umf);

	for ($i = 0; $i < MF_DISKS; $i++) {
		printf("%s%d\t%7.4f\n", "MFrame DASD",$MDarray[$i]->id, $udasd[$i]);
	};
}; /* main */

main();

?>