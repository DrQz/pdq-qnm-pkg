<?php

/*
 * MVA_Approx.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Last revised by NJG: 14:14:59  7/16/95
 * 
 *  $Id$
 */
$MVA_Approx_version = "MVA_Approx v1.0 (27 Mar 2006)";

//void 
function approx() // void
{
	global $DEBUG, $iterations, $streams, $nodes; // extern int
	global $s1, $s2, $s3, $s4; // extern char[]
	global $tolerance; // extern double
	global $job; // extern JOB_TYPE  *
	global $node; // extern NODE_TYPE *

	$k = 0; // int
    $c = 0; // int
	$should_be_class = 0; // int
	$sumR = array(); // double[MAXSTREAMS];
	$delta = 2 * TOL; // double
	$iterate = 0; // int
	$jobname = ""; // char[MAXBUF];
	$last = NULL; // NODE_TYPE *
	$p = "approx()"; // char
	$N = 0.0; // double;

	if ($DEBUG) debug($p, "Entering");

	if (($nodes == 0) || ($streams == 0)) errmsg($p, "Network nodes and streams not defined.");

	//if ((last = (NODE_TYPE *) calloc(sizeof(NODE_TYPE), nodes)) == NULL)
	//	errmsg(p, "Node (last) allocation failed!\n");
	$last = array();
	for ($c = 0; $c < $nodes; $c++)
	{
	   $last[$c] = new NODE_TYPE();
	};

	$iterations = 0;

	if ($DEBUG) {
		$s1 = sprintf("\nIteration: %d", $iterations);
		debug($p, $s1);
		$s1="";
	};

	/* initialize all queues */

	for ($c = 0; $c < $streams; $c++) {
		$should_be_class = $job[$c]->should_be_class;

		for ($k = 0; $k < $nodes; $k++) {
			switch ($should_be_class) {
				case TERM:
					$node[$k]->qsize[$c] = $job[$c]->term->pop / $nodes;
					$last[$k]->qsize[$c] = $node[$k]->qsize[$c];
					break;
				case BATCH:
					$node[$k]->qsize[$c] = $job[$c]->batch->pop / $nodes;
					$last[$k]->qsize[$c] = $node[$k]->qsize[$c];
					break;
				default:
					break;
			};

			if ($DEBUG) {
				getjob_name($jobname, $c);
				$s2 = sprintf("Que[%s][%s]: %3.4f (D=%f)",$node[$k]->devname,$jobname,$node[$k]->qsize[$c],$delta);
				debug($p, $s2);
				$s2 = "";
				$jobname ="";
			};
		};  /* over k */
	};  /* over c */


	do {
		$iterations++;

		if ($DEBUG) {
			$s1 = sprintf("\nIteration: %d", $iterations);
			debug($p, $s1);
			$s1="";
		};

		for ($c = 0; $c < $streams; $c++) {
			getjob_name($jobname, $c);

			$sumR[$c] = 0.0;

			if ($DEBUG) {
				$s1 = sprintf("\nStream: %s", $jobname);
				debug($p, $s1);
				$s1="";
			};

			$should_be_class = $job[$c]->should_be_class;

			for ($k = 0; $k < $nodes; $k++) {
				if ($DEBUG) {
					$s2= sprintf("Que[%s][%s]: %3.4f (D=%1.5f)",$node[$k]->devname,$jobname,$node[$k]->qsize[$c],$delta);
					debug($p, $s2);
				    $s1="";
				};

				/* approximate avg queue length */

				switch ($should_be_class) {
					
					case TERM:
						$N = $job[$c]->term->pop;
						$node[$k]->avqsize[$c] = sumQ($k, $c) +	($node[$k]->qsize[$c] * ($N - 1.0) / $N);
						break;
					case BATCH:
						$N = $job[$c]->batch->pop;
						$node[$k]->avqsize[$c] = sumQ($k, $c) + ($node[$k]->qsize[$c] * ($N - 1.0) / $N);
						break;
					default:
						typetostr($s1, $should_be_class);
						$s2 = sprintf("Unknown should_be_class: %s", $s1);
						errmsg($p, $s2);
						$s2="";
						break;
					};

					if ($DEBUG) {
						$s2 = sprintf("<Q>[%s][%s]: %3.4f (D=%1.5f)",$node[$k]->devname,$jobname,$node[$k]->avqsize[$c],$delta);
					    debug($p, $s2);
					    $s2="";
			        };

			/* residence times */

			switch ($node[$k]->sched) {
				case FCFS:
				case PSHR:
				case LCFS:
					$node[$k]->resit[$c] = $node[$k]->demand[$c] * ($node[$k]->avqsize[$c] + 1.0);
					break;
				case ISRV:
					$node[$k]->resit[$c] = $node[$k]->demand[$c];
					break;
				default:
					typetostr($s1, $node[$k]->sched);
					$s2 = sprintf("Unknown queue type: %s", $s1);
					errmsg($p, $s2);
					break;
			};

			$sumR[$c] += $node[$k]->resit[$c];


			if ($DEBUG) {
				printf("\tTot ResTime[%s] = %3.4f\n", $jobname, $sumR[$c]);
				printf("\tnode[%s].qsize[%s] = %3.4f\n",$node[$k]->devname,$jobname,$node[$k]->qsize[$c]);
				printf("\tnode[%s].demand[%s] = %3.4f\n",$node[$k]->devname,$jobname,$node[$k]->demand[$c]);
				printf("\tnode[%s].resit[%s] = %3.4f\n",$node[$k]->devname,$jobname,$node[$k]->resit[$c]);
			};
		};			/* over k */


		/* system throughput, residency & response-time */

		switch ($should_be_class) {
			case TERM:
				$job[$c]->term->sys->thruput = ($job[$c]->term->pop / ($sumR[$c] + $job[$c]->term->think));
				$job[$c]->term->sys->response = ($job[$c]->term->pop / $job[$c]->term->sys->thruput) - $job[$c]->term->think;
				$job[$c]->term->sys->residency = $job[$c]->term->pop - ($job[$c]->term->sys->thruput * $job[$c]->term->think);

				if ($DEBUG) {
					$s2 = sprintf("\tTERM<X>[%s]: %5.4f",$jobname, $job[$c]->term->sys->thruput);
					debug($p, $s2);
					$s2="";
					$s2 = sprintf( "\tTERM<R>[%s]: %5.4f",$jobname, $job[$c]->term->sys->response);
					debug($p, $s2);
					$s2="";
				}
				break;

			case BATCH:
				$job[$c]->batch->sys->thruput = $job[$c]->batch->pop / $sumR[$c];
				$job[$c]->batch->sys->response = ($job[$c]->batch->pop / $job[$c]->batch->sys->thruput);
				$job[$c]->batch->sys->residency = $job[$c]->batch->pop;

				if ($DEBUG) {
					$s2 = sprintf( "\t<X>[%s]: %3.4f",$jobname, $job[$c]->batch->sys->thruput);
					debug($p, $s2);
					$s2="";
					$s2 = sprintf( "\t<R>[%s]: %3.4f",$jobname, $job[$c]->batch->sys->response);
					debug($p, $s2);
					$s2="";
				};

				break;
			default:
					$s1 = sprintf( "Unknown should_be_class: %s", $should_be_class);
					errmsg($p, $s1);
					break;
			};

			$jobname="";
		};  /* over c */

		/* update queue sizes */

		for ($c = 0; $c < $streams; $c++) {
			getjob_name($jobname, $c);
			$should_be_class = $job[$c]->should_be_class;
			$iterate = FALSE;

			if ($DEBUG) {
				$s1 = sprintf( "Updating queues of \"%s\"", $jobname);
				printf("\n");
				debug($p, $s1);
				$s1="";
			};

			for ($k = 0; $k < $nodes; $k++) {
				switch ($should_be_class) {
					case TERM:
						$node[$k]->qsize[$c] = $job[$c]->term->sys->thruput * $node[$k]->resit[$c];
						break;
					case BATCH:
						$node[$k]->qsize[$c] = $job[$c]->batch->sys->thruput * $node[$k]->resit[$c];
						break;
					default:
						$s1 = sprintf( "Unknown should_be_class: %s", $should_be_class);
						errmsg($p, $s1);
						break;
				};

				/* check convergence */

				$delta = abs((double) ($last[$k]->qsize[$c] - $node[$k]->qsize[$c]));

				if ($delta > $tolerance)	/* for any node */
					$iterate = TRUE;	/* but complete all queue updates */

				$last[$k]->qsize[$c] = $node[$k]->qsize[$c];

				if ($DEBUG) {
					$s2 = sprintf( "Que[%s][%s]: %3.4f (D=%1.5f)",$node[$k]->devname,$jobname,$node[$k]->qsize[$c],$delta);
					debug($p, $s2);
					$s2="";
				};
			};			/* over k */

			$jobname="";
		};				/* over c */

		if ($DEBUG) debug($p, "Update complete");
	} while ($iterate);

	/* cleanup */

	if ($last) {
		$last=NULL;
	};

	if ($DEBUG)
		debug($p, "Exiting");
}  /* approx */

//-------------------------------------------------------------------------

// double 
function sumQ($k, $skip) // int k, int skip
{
	global $streams; // extern int
	global $node; // extern NODE_TYPE *

	$c = 0; // int
	$sum = 0.0; // double

	for ($c = 0; $c < $streams; $c++) {
		if ($c == $skip) continue;
		$sum += $node[$k]->qsize[$c];
	};

	return ($sum);
}  /* sumQ */

//-------------------------------------------------------------------------

?>
