<?php

/*
 * MVA_Canon.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Revised by NJG: 20:05:52  7/29/95
 * 
 *  $Id$
 */

//-------------------------------------------------------------------------
$MVA_Canon_version = "MVA_Canon v1.0 (27 Mar 2006)";

// void 
function canonical() // void
{
	global $DEBUG, $streams, $nodes; // extern int
	global $s1, $s2, $s3, $s4; // extern char
	global $job; // extern JOB_TYPE *
	global $node; // extern NODE_TYPE *


	$k = 0;; // int
	$c = 0; // int
	$X = 0.0; // double
	$Xsat = 0.0; // double;
	$Dsat = 0.0;
	$sumR = array(); // double [MAXSTREAMS];

	$devU = 0.0; // double
	$jobname = ""; // char [MAXBUF];
	$p = "canonical()"; //  = 0.0; // double

	if ($DEBUG) debug($p, "Entering");

	for ($c = 0; $c < $streams; $c++) {
		$sumR[$c] = 0.0;

		$X = $job[$c]->trans->arrival_rate;

		/* find saturation device */

		for ($k = 0; $k < $nodes; $k++) {
	 		if ($node[$k]->demand[$c] > $Dsat) $Dsat = $node[$k]->demand[$c];
		};

		if ($Dsat == 0) {
	 		$s1 = sprintf( "Dsat = %3.3f", $Dsat);
	 		errmsg($p, $s1);
		};

		$Xsat = 1.0 / $Dsat;
		$job[$c]->trans->saturation_rate = $Xsat;

		if ($X > $job[$c]->trans->saturation_rate) {
	 		$s1 = sprintf("\nArrival rate %3.3f exceeds system saturation %3.3f = 1/%3.3f",$X, $Xsat, $Dsat);
	 		errmsg($p, $s1);
		};

		for ($k = 0; $k < $nodes; $k++) {
	 		$node[$k]->utiliz[$c] = $X * $node[$k]->demand[$c];

	 		$devU = sumU($k);

	 		if ($devU > 1.0) {
		 		$s1 = sprintf( "\nTotal utilization of node %s is %2.2f%% (>100%%)",$node[$k]->devname,$devU * 100.0);
		 		errmsg($p, $s1);
	 		};

	 		if ($DEBUG) printf("Tot Util: %3.4f for %s\n", $devU, $node[$k]->devname);

	 		switch ($node[$k]->sched) {
	 			case FCFS:
	 			case PSHR:
	 			case LCFS:
		 			$node[$k]->resit[$c] = $node[$k]->demand[$c] / (1.0 - $devU);
		 			$node[$k]->qsize[$c] = $X * $node[$k]->resit[$c];
		 			break;
	 			case ISRV:
		 			$node[$k]->resit[$c] = $node[$k]->demand[$c];
		 			$node[$k]->qsize[$c] = $node[$k]->utiliz[$c];
		 			break;
	 			default:
		 			typetostr($s1, $node[$k]->sched);
		 			$s2 = sprintf( "Unknown queue type: %s", $s1);
		 			errmsg($p, $s2);
		 			break;
	 		};
	 		$sumR[$c] += $node[$k]->resit[$c];
		};  /* loop over k */

		$job[$c]->trans->sys->thruput = $X;
		$job[$c]->trans->sys->response = $sumR[$c];
		$job[$c]->trans->sys->residency = $X * $sumR[$c];

		if ($DEBUG) {
	 		getjob_name($jobname, $c);
	 		printf("\tX[%s]: %3.4f\n", $jobname, $job[$c]->trans->sys->thruput);
	 		printf("\tR[%s]: %3.4f\n", $jobname, $job[$c]->trans->sys->response);
	 		printf("\tN[%s]: %3.4f\n", $jobname, $job[$c]->trans->sys->residency);
		};
	};  /* loop over c */

	if ($DEBUG) debug($p, "Exiting");

}  /* canonical */

//-------------------------------------------------------------------------

//double 
function sumU($k) //int k
{
	global $streams; // extern int
	global $job; // extern JOB_TYPE  *
	global $node; // extern NODE_TYPE *


	$c = 0; // int
	$sum = 0.0; // double

	for ($c = 0; $c < $streams; $c++) {
		$sum += ($job[$c]->trans->arrival_rate * $node[$k]->demand[$c]);
	};

	return ($sum);
} /* sumU */

?>
