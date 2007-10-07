<?php
/*
 * PDQ_Build.c
 * 
 * Copyright © 1994-2004 Neil J. Gunther. All Rights Reserved.
 * 
 * Created by NJG: 18:19:02  04-28-95 
 * Revised by NJG: 09:33:05  31-03-99
 * 
 *  $Id$
*/
//-------------------------------------------------------------------------
$PDQ_Build_version = "PDQ_Build v1.0 (27 Mar 2006)";

// void 
function PDQ_Init($name = "The Model Name") // char *name
{
	global $model; // extern char[]
	global $tUnit; // extern char[]
	global $wUnit; // extern char[]
	global $s1; // extern char[]
	global $demand_ext; // extern int
	global $method; // extern int 
	global $tolerance; // extern double
	global $nodes;  // extern int
	global $streams;  // extern int
	global $prev_init;  // extern int
	global $node; // extern NODE_TYPE *
	global $job; // extern JOB_TYPE *
	global $tm; // extern TERMINAL_TYPE *
	global $bt; // extern BATCH_TYPE *
	global $tx; // extern TRANSACTION_TYPE *
	global $sys; // extern SYSTAT_TYPE *
	global $DEBUG;  // extern int
	global $c;
	global $k;
	
	// extern void              allocate_nodes();
	// extern void              allocate_jobs();
	$p = "PDQ_Init()"; // char *

	$cc = 0; // int
    $kk = 0; // int

	if ($DEBUG) debug($p, "Entering");

	if (strlen($name) > MAXCHARS) {
		$s1 = "";
		$s1 = sprintf( "Model name > %d characters", MAXCHARS);
		errmsg($p, $s1);
	};

	if ($prev_init) {
	    if ($DEBUG) debug($p, "Prev_init detected");
		for ($c = 0; $c < MAXSTREAMS; $c++) {
				$job[$c]->term->sys = NULL;
				$job[$c]->batch->sys = NULL;
				$job[$c]->trans->sys = NULL;
				$job[$c]->term = NULL;
				$job[$c]->batch = NULL;
				$job[$c]->trans = NULL;
		}; /* over c */

		if ($job) {
			//free(job);
			$job = NULL;
		};
		
		if ($node) {
			//free(node);
			$node = NULL;
		};

		$model = "";
		$wUnit = "";
		$tUnit = "";
	};
    if ($DEBUG) debug($p, "Setting model name");
	$model = $name;

	/* default units */

	$wUnit="Job";
	$tUnit="Sec";

	$demand_ext = VOID;
	$tolerance = TOL;
	$method = VOID;
    if ($DEBUG) debug($p, "Allocate_nodes");
	allocate_nodes(MAXNODES+1);
	if ($DEBUG) debug($p, "Allocate_jobs");
	allocate_jobs(MAXSTREAMS+1);
    if ($DEBUG) debug($p, "Nodes and Jobs Allocated");
	for ($cc = 0; $cc < MAXSTREAMS; $cc++) {
		for ($kk = 0; $kk < MAXNODES; $kk++) {
			$node[$kk]->devtype = VOID;
			$node[$kk]->sched = VOID;
			$node[$kk]->demand[$cc] = 0.0;
			$node[$kk]->resit[$cc] = 0.0;
			$node[$kk]->qsize[$cc] = 0.0;
		};
		$job[$cc]->should_be_class = VOID;
		$job[$cc]->network = VOID;
	};

	/* reset circuit counters */

	$nodes = 0;
    $streams = 0;
	$c = 0;
    $k = 0;

	$prev_init = TRUE;

	if ($DEBUG)
		debug($p, "Exiting");
}  /* PDQ_Init */

//-------------------------------------------------------------------------

//int 
function PDQ_CreateNode($name, $device, $sched) // char *name, int device, int sched
{
	global $node; // extern NODE_TYPE *
	global $s1, $s2; // extern char[]
	global $nodes; // extern int
	global $DEBUG; // extern int
	global $k;
	$p = "PDQ_CreateNode"; // char *
	
    $out_fd = NULL; // FILE*

	if ($DEBUG)
	{
		debug($p, "Entering");
		$out_fd = fopen("PDQ.out", "a");
		fprintf($out_fd, "name : %s  device : %d  sched : %d\n", $name, $device, $sched);
		fclose($out_fd);
	};

	if ($k > MAXNODES) {
		$s1 = sprintf( "Allocating \"%s\" exceeds %d max nodes",$name,MAXNODES);
		errmsg($p, $s1);
	};

	if (strlen($name) >= MAXCHARS) {
		$s1 = sprintf( "Nodename \"%s\" is longer than %d characters",$name, MAXCHARS);
		errmsg($p, $s1);
	}

	$node[$k]->devname = $name;
	$node[$k]->devtype = $device;
	$node[$k]->sched = $sched;

	if ($DEBUG) {
		typetostr($s1, $node[$k]->devtype);
		typetostr($s2, $node[$k]->sched);
		printf("\tNode[%d]: %s %s \"%s\"\n",$k, $s1, $s2, $node[$k]->devname);
		$s1 = "";
		$s2 = "";
	};

	if ($DEBUG)
		debug($p, "Exiting");

	$k =  ++$nodes;

	return $nodes;
}  /* PDQ_CreateNode */

//-------------------------------------------------------------------------
/*
int PDQ_CreateClosed(char *name, int should_be_class, double pop, double think)
{
	return PDQ_CreateClosed_p(name, should_be_class, &pop, &think);
}
*/
//-------------------------------------------------------------------------

// int 
function PDQ_CreateClosed($name, $should_be_class, $pop, $think) // PDQ_CreateClosed_p(char *name, int should_be_class, double *pop, double *think)
{
	global $s1; // extern char[]
	global $streams; // extern int
	global $DEBUG; // extern int
	global $c;
	
	$p = "PDQ_CreateClosed()"; // char *
	
    $out_fd = NULL; // FILE *

	if ($DEBUG)
	{
		debug($p, "Entering");
		$out_fd = fopen("PDQ.out", "a");
		fprintf($out_fd, "name : %s  should_be_class : %d  pop : %f  think : %f\n", $name, $should_be_class, $pop, $think);
		fclose($out_fd);
	};

	if (strlen($name) >= MAXCHARS) {
		$s1 = sprintf( "Nodename \"%s\" is longer than %d characters",$name, MAXCHARS);
		errmsg($p, $s1);
	};

	if ($c > MAXSTREAMS) {
		printf("c = %d\n", $c);
		$s1 = sprintf( "Allocating \"%s\" exceeds %d max streams",$name, MAXSTREAMS);
		errmsg($p, $s1);
	};

	switch ($should_be_class) {
		case TERM:
			if ($pop == 0.0) {
				$s1="";
				$s1 = sprintf( "Stream: \"%s\", has zero population", $name);
				errmsg($p, $s1);
			};
			create_term_stream(CLOSED, $name, $pop, $think);
			break;
		case BATCH:
			if ($pop == 0.0) {
				$s1 = "";
				$s1 = sprintf( "Stream: \"%s\", has zero population", $name);
				errmsg($p, $s1);
			}
			create_batch_stream(CLOSED, $name, $pop);
			break;
		default:
			$s1 = sprintf( "Unknown stream: %d", $should_be_class);
			errmsg($p, $s1);
			break;
	};

	if ($DEBUG)	debug($p, "Exiting");

	$c =  ++$streams;

	return $streams;
}  /* PDQ_CreateClosed */

//-------------------------------------------------------------------------
/*
int PDQ_CreateOpen(char *name, double lambda)
{
	return PDQ_CreateOpen_p(name, &lambda);
}
*/
//-------------------------------------------------------------------------

// int 
function PDQ_CreateOpen($name, $lambda) // int PDQ_CreateOpen_p(char *name, double *lambda)
{
	global $s1; // extern char[]
	global $streams; // extern int
	global $DEBUG; // extern int
	global $c;
	
    $out_fd = NULL; // FILE *

	if ($DEBUG)
	{
		$out_fd = fopen("PDQ.out", "a");
	    fprintf($out_fd, "name : %s  lambda : %f\n", $name, $lambda);
		fclose($out_fd);
	};
	
	if (strlen($name) > MAXCHARS) {
		$s1 = sprintf( "Nodename \"%s\" is longer than %d characters",$name, MAXCHARS);
		errmsg("PDQ_CreateOpen()", $s1);
	}

	create_transaction(OPEN, $name, $lambda);

	$c =  ++$streams;

	return $streams;
}  /* PDQ_CreateOpen */

//-------------------------------------------------------------------------
/*
void PDQ_SetDemand(char *nodename, char *workname, double time)
{
	PDQ_SetDemand_p(nodename, workname, &time);
}
*/
//-------------------------------------------------------------------------

// void 
function PDQ_SetDemand($nodename, $workname, $time) // void PDQ_SetDemand_p(char *nodename, char *workname, double *time)
{
	$p = "PDQ_SetDemand()"; // char *

	global $node; // extern NODE_TYPE *
	global $nodes; // extern int
	global $streams; // extern int
	global $demand_ext; // extern int
	global $DEBUG; // extern int

	$node_index = 0; // int
	$job_index = 0; // int

	$out_fd = NULL; // FILE *

	if ($DEBUG)
	{
		debug($p, "Entering");
		$out_fd = fopen("PDQ.out", "a");
		fprintf($out_fd, "nodename : %s  workname : %s  time : %f\n", $nodename, $workname, $time);
		fclose($out_fd);
	};

	/* that demand type is being used consistently per model */

	if ($demand_ext == VOID || $demand_ext == DEMAND) {
		$node_index = getnode_index($nodename);
		$job_index  = getjob_index($workname);

		if (!(($node_index >=0) && ($node_index <= $nodes))) {
			fprintf(STDERR, "Illegal node index value %d\n", $node_index);
			exit(1);
		};

		if (!(($job_index >=0) && ($job_index <= $streams))) {
			fprintf(STDERR, "Illegal job index value %d\n", $job_index);
			exit(1);
		};

		$node[$node_index]->demand[$job_index] = $time;
		$demand_ext = DEMAND;
	} else
		errmsg($p, "Extension conflict");

	if ($DEBUG)
		debug($p, "Exiting");
}  /* PDQ_SetDemand */

//-------------------------------------------------------------------------
/*
void PDQ_SetVisits(char *nodename, char *workname, double visits, double service)
{
	PDQ_SetVisits_p(nodename, workname, &visits, &service);
}
*/
//-------------------------------------------------------------------------

// void 
function PDQ_SetVisits($nodename, $workname, $visits, $service) // void PDQ_SetVisits_p(char *nodename, char *workname, double *visits, double *service)
{
	global $node; // extern NODE_TYPE *
	global $demand_ext; // extern int 
	global $DEBUG; // extern int 

	if ($DEBUG)
	{
		printf("nodename : %s  workname : %s  visits : %f  service : %f\n", $nodename, $workname, $visits, $service);
	}

	if ($demand_ext == VOID || $demand_ext == VISITS) {
		$node[getnode_index($nodename)]->visits[getjob_index($workname)] = $visits;
		$node[getnode_index($nodename)]->service[getjob_index($workname)] = $service;
		$node[getnode_index($nodename)]->demand[getjob_index($workname)] = $visits * $service;
		$demand_ext = VISITS;
	} else
		errmsg("PDQ_SetVisits()", "Extension conflict");
}  /* PDQ_SetVisits */

//-------------------------------------------------------------------------

//void 
function PDQ_SetWorkloadUnit($unitName)
{
    PDQ_SetWUnit($unitName);
}

function PDQ_SetWUnit($unitName) // char* unitName
{
	global $wUnit; // extern char[]

	if (strlen($unitName) > MAXSUFF)
		errmsg("PDQ_SetWUnit()", "Name > ".MAXSUFF." characters");

	$wUnit = $unitName;
}  /* PDQ_SetWUnit */

//-------------------------------------------------------------------------

// void 
function PDQ_SetTimeUnit($unitName)
{
    PDQ_SetTUnit($unitName);
}

function PDQ_SetTUnit($unitName) // char* unitName
{
	global $tUnit; // extern char[]

	if (strlen($unitName) > MAXSUFF)
		errmsg("PDQ_SetTUnit()", "Name > ".MAXSUFF." characters");

	$tUnit=$unitName;
}  /* PDQ_SetTUnit */

//----- Internal Functions ------------------------------------------------

// void 
function create_term_stream($circuit, $label, $pop, $think) // void create_term_stream(int circuit, char *label, double pop, double think)
{
	global $job; // extern JOB_TYPE *
	global $s1; // extern char[]
	global $DEBUG; // extern int
	global $c;
	$p = "create_term_stream()"; // char *

	if ($DEBUG)
		debug($p, "Entering");

	$job[$c]->term->name = $label;
	$job[$c]->should_be_class = TERM;
	$job[$c]->network = $circuit;
	$job[$c]->term->think = $think;
	$job[$c]->term->pop = $pop;

	if ($DEBUG) {
		typetostr($s1, $job[$c]->should_be_class);
        printf("\tStream[%d]: %s \"%s\"; N: %3.1f, Z: %3.2f\n",$c, $s1,$job[$c]->term->name,$job[$c]->term->pop,$job[$c]->term->think);
		$s1="";
	};

	if ($DEBUG)
		debug($p, "Exiting");
}  /* create_term_stream */

//-------------------------------------------------------------------------

// void 
function create_batch_stream($net, $label, $number) // void create_batch_stream(int net, char* label, double number)
{
	global $job; // extern JOB_TYPE *
	global $s1; // extern char[]
	global $DEBUG; // extern int
	global $c;
	$p = "create_batch_stream()"; // char *

	if ($DEBUG)
		debug($p, "Entering");

	/***** using global value of c *****/

	$job[$c]->batch->name = $label;

	$job[$c]->should_be_class = BATCH;
	$job[$c]->network = $net;
	$job[$c]->batch->pop = $number;

	if ($DEBUG) {
		typetostr($s1, $job[$c]->should_be_class);
		printf("\tStream[%d]: %s \"%s\"; N: %3.1f\n",$c, $s1, $job[$c]->batch->name, $job[$c]->batch->pop);
		$s1="";
	};

	if ($DEBUG)
		debug($p, "Exiting");
}  /* create_batch_stream */

//-------------------------------------------------------------------------

//void 
function create_transaction($net, $label, $lambda) // void create_transaction(int net, char* label, double lambda)
{
	global $job; // extern JOB_TYPE *
	global $s1; // extern char[]
	global $DEBUG; // extern int
	global $c;

	$job[$c]->trans->name = $label;

	$job[$c]->should_be_class = TRANS;
	$job[$c]->network = $net;
	$job[$c]->trans->arrival_rate = $lambda;

	if ($DEBUG) {
		typetostr($s1, $job[$c]->should_be_class);
		printf("\tStream[%d]:  %s\t\"%s\";\tLambda: %3.1f\n",$c, $s1, $job[$c]->trans->name, $job[$c]->trans->arrival_rate);
		$s1="";
	};
}  /* create_transaction */

//-------------------------------------------------------------------------

//void 
function writetmp(&$fp, $s) // void writetmp(FILE* fp, char* s)
{
	fprintf($fp, "%s", $s);
	printf("%s", $s);
}  /* writetmp */

//-------------------------------------------------------------------------


?>
