<?php

/*
 * PDQ_Exact.c
 *
 * Copyright (c) 1995-2004 Performance Dynamics Company
 *
 * Updated by NJG: 02:44:17 AM  2/23/97
 *
 * Edited by NJG: Fri Feb  5 16:58:09 PST 1999 to fix N=1 stability problem
 *
 *  $Id$
 */

//-------------------------------------------------------------------------
$PDQ_Exact_version = "PDQ_Exact v1.0 (27 Mar 2006)";

//void 
function exact() //void
{
	global $streams, $nodes; // extern int
	global $node; // extern NODE_TYPE *
	global $job; // extern JOB_TYPE  *
	global $s1, $s2, $s3, $s4; // extern char []
	global $qlen;

	$p = "exact()"; // char *
	$n0 = 0; // int
    $n1 = 0; // int
    $n2 = 0; // int

	$pop = array(); //int[MAXCLASS] = {0, 0, 0};	/* pop vector */
	$N = array(); // int[MAXCLASS] = {0, 0, 0};	/* temp counters */
	$sumR = array(); // double[MAXCLASS] = {0.0, 0.0, 0.0};

    for ($c=0;$c<MAXCLASS;$c++)
    {
        $pop[$c] = 0;
        $N[$c] = 0;
        $sumR[$c] = 0.0;
    };

 	$c = 0; //int
    $k = 0; // int

	if ($streams > MAXCLASS) {
		printf("Streams = %d", $streams);
		$s1 = sprintf( "%d workload streams exceeds maximum of 3.\n", $streams);
		errmsg($p, $s1);
	};

	for ($c = 0; $c < $streams; $c++) {
		$pop[$c] = (int) ceil((double) getjob_pop($c));

		if (($pop[$c] > MAXPOP1) || ($pop[$c] > MAXPOP2)) {
			$s1 = sprintf( "Pop %d > allowed:\n", $pop[$c]);
			$s2 = sprintf( "max1: %d\nmax2: %d\n", MAXPOP1, MAXPOP2);
			
			errmsg($p, $s1.$s2);
		};
	};


	/* initialize lowest queue configs on each device */

	for ($k = 0; $k < $nodes; $k++) {
		$qlen[0][0][$k] = 0.0;
	};

	/* MVA loop starts here .... */

	for ($n0 = 0; $n0 <= $pop[0]; $n0++) {
		for ($n1 = 0; $n1 <= $pop[1]; $n1++) {
			for ($n2 = 0; $n2 <= $pop[2]; $n2++) {
				if (($n0 + $n1 + $n2) == 0)	continue;
				$N[0] = $n0;
				$N[1] = $n1;
				$N[2] = $n2;

				for ($c = 0; $c < MAXCLASS; $c++) {
					$sumR[$c] = 0.0;
					if ($N[$c] == 0) continue;

					$N[$c] -= 1;
					for ($k = 0; $k < $nodes; $k++) {
						$node[$k]->qsize[$c] = $qlen[$N[1]][$N[2]][$k];
						$node[$k]->resit[$c] = $node[$k]->demand[$c] * (1.0 + $node[$k]->qsize[$c]);
						$sumR[$c] += $node[$k]->resit[$c];
					};

					$N[$c] += 1;

					switch ($job[$c]->should_be_class) {
						case TERM:
							if ($sumR[$c] == 0)	errmsg($p, "sumR is zero");
							$job[$c]->term->sys->thruput = $N[$c] / ($sumR[$c] + $job[$c]->term->think);
							$job[$c]->term->sys->response =	($N[$c] / $job[$c]->term->sys->thruput) - $job[$c]->term->think;
							$job[$c]->term->sys->residency = $N[$c] - ($job[$c]->term->sys->thruput * $job[$c]->term->think);
							break;
						case BATCH:
							if ($sumR[$c] == 0)	errmsg($p, "sumR is zero");
							$job[$c]->batch->sys->thruput = $N[$c] / $sumR[$c];
							$job[$c]->batch->sys->response = $N[$c] / $job[$c]->batch->sys->thruput;
							$job[$c]->batch->sys->residency = $N[$c];
							break;
						default:
							break;
					};
				};

				for ($k = 0; $k < $nodes; $k++) {
					$qlen[$n1][$n2][$k] = 0.0;
					for ($c = 0; $c < MAXCLASS; $c++) {
						if ($N[$c] == 0) continue;

						switch ($job[$c]->should_be_class) {
							case TERM:
								$qlen[$n1][$n2][$k] += ($job[$c]->term->sys->thruput * $node[$k]->resit[$c]);
								$node[$k]->qsize[$c] = $qlen[$n1][$n2][$k];
								break;
							case BATCH:
								$qlen[$n1][$n2][$k] += ($job[$c]->batch->sys->thruput * $node[$k]->resit[$c]);
								$node[$k]->qsize[$c] = $qlen[$n1][$n2][$k];
								break;
							default:
								break;
						};
					};
				};
			};  /* over n2 */
		};  /* over n1 */
	};  /* over n0 */
}  /* exact */

//-------------------------------------------------------------------------



?>
