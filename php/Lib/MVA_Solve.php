<?php
/*
 * MVA_Solve.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Revised by NJG: 20:05:52  7/28/95
 * 
 *  $Id$
 */
$MVA_Solve_version = "MVA_Solve v1.0 (27 Mar 2006)";


//void 
function PDQ_Solve($meth) // int meth
{
	global $DEBUG, $method, $streams, $nodes; // extern int
	//global $centers_declared, $streams_declared; // extern int
	global $job; // extern JOB_TYPE *
	global $node; // extern NODE_TYPE *
	global $s1, $s2, $s3, $s4; // extern char[]
	global $sumD; // extern double

	$k = 0;  // int
    $c = 0; // int
	$should_be_class = 0; // int
	$demand = 0.0; // double
	$maxD = 0.0; // double
	$p = "PDQ_Solve()"; // char *

	if ($DEBUG) debug($p, "Entering");

	/* There'd better be a job[0] or you're in trouble !!!  */

	$method = $meth;

	switch ($method) {
		case EXACT:
			if ($job[0]->network != CLOSED) {	/* bail ! */
				typetostr($s2, $job[0]->network);
				typetostr($s3, $method);
				$s1 = sprintf("Network should_be_class \"%s\" is incompatible with \"%s\" method",$s2,$s3);
				errmsg($p, $s1);
			};
			switch ($job[0]->should_be_class) {
				case TERM:
				case BATCH:
					exact();
					break;
				default:
					break;
			};
			break;

		case APPROX:
			if ($job[0]->network != CLOSED) {	/* bail ! */
				typetostr($s2, $job[0]->network);
				typetostr($s3, $method);
				$s1 = sprintf("Network should_be_class \"%s\" is incompatible with \"%s\" method",$s2,$s3);
				errmsg($p, $s1);
			};
			switch ($job[0]->should_be_class) {
				case TERM:
				case BATCH:
					approx();
					break;
				default:
					break;
			};
			break;

		case CANON:
			if ($job[0]->network != OPEN) {	/* bail out ! */
				typetostr($s2, $job[0]->network);
				typetostr($s3, $method);
				$s1 = sprintf("Network should_be_class \"%s\" is incompatible with \"%s\" method",$s2,$s3);
				errmsg($p, $s1);
			};
			canonical();
			break;

		default:
			typetostr($s3, $method);
			$s1 = sprintf( "Unknown  method \"%s\"", $s3);
			errmsg($p, $s1);
			break;
	};

	/* Now compute bounds */

	for ($c = 0; $c < $streams; $c++) {
		$sumD = 0.0;
        $maxD = 0.0;
		$should_be_class = $job[$c]->should_be_class;

		for ($k = 0; $k < $nodes; $k++) {
			$demand = $node[$k]->demand[$c];

			if (($node[$k]->sched == ISRV) && ($job[$c]->network == CLOSED))
				$demand /= ($should_be_class == TERM) ? $job[$c]->term->pop : $job[$c]->batch->pop;

			if ($maxD < $demand) $maxD = $demand;

			$sumD += $node[$k]->demand[$c];
		};  /* Over k */

		switch ($should_be_class) {
			case TERM:
				$job[$c]->term->sys->maxN = ($sumD + $job[$c]->term->think) / $maxD;
				$job[$c]->term->sys->maxTP = 1.0 / $maxD;
				$job[$c]->term->sys->minRT = $sumD;
				if ($sumD == 0) {
					getjob_name($s1, $c);
					$s2 = sprintf( "Sum of demands is zero for workload \"%s\"", $s1);
					errmsg($p, $s2);
				};
				break;
			case BATCH:
				$job[$c]->batch->sys->maxN = $sumD / $maxD;
				$job[$c]->batch->sys->maxTP = 1.0 / $maxD;
				$job[$c]->batch->sys->minRT = $sumD;
				if ($sumD == 0) {
					getjob_name($s1, $c);
					$s2 = sprintf( "Sum of demands is zero for workload \"%s\"", $s1);
					errmsg($p, $s2);
				};
				break;
			case TRANS:
				$job[$c]->trans->sys->maxTP = 1.0 / $maxD;
				$job[$c]->trans->sys->minRT = $sumD;
				if ($sumD == 0) {
					getjob_name($s1, $c);
					$s2 = sprintf( "Sum of demands is zero for workload \"%s\"", $s1);
					errmsg($p, $s2);
				};
				break;
			default:
				break;
		};
	};  /* Over c */

	if ($DEBUG) debug($p, "Exiting");
}  /* PDQ_Solve */



?>
