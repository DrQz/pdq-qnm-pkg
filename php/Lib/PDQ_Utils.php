<?php
/*
 * PDQ_Utils.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Revised by NJG (for Sun): Tue Aug 11 17:31:02 PDT 1998
 * 
 *  $Id$
 */

$PDQ_Utils_version = "PDQ_Utils v1.0 (27 Mar 2006)";

//*********************************************************************
//         Public Utilities
//*********************************************************************

/* double */ 
function PDQ_GetResponse($should_be_class, $wname) /* int $should_be_class, char *wname */
{
    global $streams, $job;
	$p = "PDQ_GetResponse()"; // char *
	$r = 0.0; //double

    $job_index = getjob_index($wname); // int

    if (($job_index >= 0) && ($job_index < $streams)) {
		switch ($should_be_class) {
			case TERM:
				$r = $job[$job_index]->term->sys->response;
				break;
			case BATCH:
				$r = $job[$job_index]->batch->sys->response;
				break;
			case TRANS:
				$r = $job[$job_index]->trans->sys->response;
				break;
			default:
				errmsg($p, "Unknown should_be_class");
				break;
		};
	} else {
		fprintf(STDERR, "[PDQ_GetResponse]  Invalid job index (%d)\n", $job_index);
        exit(99);
	};

	return ($r);
}  /* PDQ_GetResponse */

//-------------------------------------------------------------------------

/* double */
function PDQ_GetThruput($should_be_class, $wname) /* int $should_be_class, char *wname */
{
	global $streams, $job;
    $p = "PDQ_GetThruput()";
	$x = 0.0; // double

    $job_index = getjob_index($wname); // int

    if (($job_index >= 0) && ($job_index < $streams)) {
		switch ($should_be_class) {
			case TERM:
				$x = $job[$job_index]->term->sys->thruput;
				break;
			case BATCH:
				$x = $job[$job_index]->batch->sys->thruput;
				break;
			case TRANS:
				$x = $job[$job_index]->trans->sys->thruput;
				break;
			default:
				errmsg($p, "Unknown should_be_class");
				break;
		};
	} else {
		fprintf(STDERR, "[PDQ_GetThruput]  Invalid job index (%d)\n", $job_index);
        exit(99);
	};

	return ($x);
}  /* PDQ_GetThruput */

//-------------------------------------------------------------------------

/* double */
function PDQ_GetThruMax($should_be_class, $wname) /* int $should_be_class, char *wname */
{
	global $streams, $job;
    $p = "PDQ_GetThruMax()"; // char *
	$r = 0.0; //double

    $job_index = getjob_index($wname); // int

    if (($job_index >= 0) && ($job_index < $streams)) {
		switch ($should_be_class) {
			case TERM:
				$x = $job[$job_index]->term->sys->maxTP;
				break;
			case BATCH:
				$x = $job[$job_index]->batch->sys->maxTP;
				break;
			case TRANS:
				$x = $job[$job_index]->trans->sys->maxTP;
				break;
			default:
				errmsg($p, "Unknown should_be_class");
				break;
		};
	} else {
		fprintf(STDERR, "[PDQ_GetThruMax]  Invalid job index (%d)\n", $job_index);
        exit(99);
	};

	return ($x);
}  /* PDQ_GetThruMax */

//-------------------------------------------------------------------------

/* double */
function PDQ_GetLoadOpt($should_be_class, $wname) /* int $should_be_class, char *wname */
{
	global $streams, $job;
    $p = "PDQ_GetLoadOpt()"; // char *
	$Dmax = 0.0; // double
    $Dsum = 0.0; // double
	$Nopt = 0.0; // double
    $Z = 0.0; // double

    $job_index = getjob_index($wname); // int

    if (($job_index >= 0) && ($job_index < $streams)) {
		switch ($should_be_class) {
				case TERM:
					$Dsum = $job[$job_index]->term->sys->minRT;
					$Dmax = 1.0 / $job[$job_index]->term->sys->maxTP;
					$Z = $job[$job_index]->term->think;
					break;
				case BATCH:
					$Dsum = $job[$job_index]->batch->sys->minRT;
					$Dmax = 1.0 / $job[$job_index]->batch->sys->maxTP;
					$Z = 0.0;
					break;
				case TRANS:
					errmsg($p, "Cannot calculate max Load for TRANS class");
					break;
				default:
					errmsg($p, "Unknown should_be_class");
					break;
			};
	} else {
		fprintf(STDERR, "[PDQ_GetThruMax]  Invalid job index (%d)\n", $job_index);
        exit(99);
	};

	$Nopt = ($Dsum + $Z) / $Dmax;

	return (floor($Nopt)); /* return lower bound as integral value */
}  /* PDQ_GetLoadOpt */

//-------------------------------------------------------------------------

/* double */
function PDQ_GetResidenceTime($device, $work, $should_be_class) // char *device, char *work, int should_be_class
{
	$p = "PDQ_GetResidenceTime()"; // char *
	global $s1; // extern char[]
	global $nodes, $node;
	$r = 0.0; // double
	$c = 0; // int
    $k = 0; // int

	$c = getjob_index($work);

	for ($k = 0; $k < $nodes; $k++) {
		//if (strcmp(device, node[k].devname) == 0) {
		if ($device == $node[$k]->devname) {
			$r = $node[$k]->resit[$c];
			return ($r);
		};
	};

	$s1 = sprintf( "Unknown device %s", $device);
	errmsg($p, $s1);

	/*g_debug("PDQ_GetResidenceTime:  Returning bad double\n");*/
	fprintf(STDERR, "%s:%d PDQ_GetResidenceTime:  Returning bad double\n", __FILE__, __LINE__);

	return -1.0;
}  /* PDQ_GetResidenceTime */

//-------------------------------------------------------------------------

// double
function PDQ_GetUtilization($device, $work, $should_be_class) // char *device, char *work, int should_be_class
{
	$p = "PDQ_GetUtilization()"; // char *
	global $s1, $job, $nodes, $node; // extern char[]
	$x = 0.0; // double
    $u = 0.0; // double
	$c = 0; // int
    $k = 0; // int

	if ($job) {
		$c = getjob_index($work);
		$x = PDQ_GetThruput($should_be_class, $work);

		for ($k = 0; $k < $nodes; $k++) {
			if ($device == $node[$k]->devname) {
				$u = $node[$k]->demand[$c] * $x;
				return ($u);
			};
		};

		$s1 = sprintf( "Unknown device %s", $device);
		errmsg($p, $s1);
	};

    fprintf(STDERR, "%s:%d PDQ_GetUtiliation:  Failed to find utilization\n", __FILE__, __LINE__);

	return 0.0;
}  /* PDQ_GetUtilization */

//-------------------------------------------------------------------------

// double
function PDQ_GetQueueLength($device, $work, $should_be_class) // char *device, char *work, int should_be_class
{
	$p = "PDQ_GetQueueLength()"; // char *

	global $s1; //extern char[]
	global $nodes, $node;
	
	$q = 0.0; // double
    $x = 0.0; // double
	$c = 0; // int
    $k = 0; // int

	$c = getjob_index($work);
	$x = PDQ_GetThruput($should_be_class, $work);

	for ($k = 0; $k < $nodes; $k++) {
		if ($device == $node[$k]->devname) {
			$q = $node[$k]->resit[$c] * x;
			return ($q);
		};
	};

	$s1 = sprintf( "Unknown device %s", $device);
	errmsg($p, $s1);

	/*g_debug("PDQ_GetQueueLength - Bad double return");*/
    fprintf(STDERR, "%s:%d PDQ_GetQueueLength - Bad double return\n", __FILE__, __LINE__);
	return -1.0;
}  /* PDQ_GetQueueLength */

//-------------------------------------------------------------------------

// void
function PDQ_SetDebug($flag) // int flag
{
	global $DEBUG;
    $DEBUG = $flag;

	if ($DEBUG) {
		printf("debug on\n");
	} else {
		printf("debug off\n");
	};
}  /* PDQ_SetDebug */

//-------------------------------------------------------------------------

//void
function typetostr(&$str, $type) // char *str, int type
/* convert a #define to a string */
{
    $buf = "";
    global $typetable;
    
    if (in_array($type, $typetable)) {
        $str = $typetable[$type];
    } else {
        $str = "NONE";
	    $buf = sprintf("Unknown type id for \"%s\"", $str);
	    errmsg("typetostr()", $buf);
    };

    return $str;
}  /* typetostr */

//-------------------------------------------------------------------------

// int
function strtotype($str) // char *str
/* convert a string to its #define value */
{
    $buf = "";
    $ret = -2;
    global $typetable;
    
    if (in_array($str, $typetable)) {
        $ret = $typetable[$str];
    };
	
	$buf = sprintf("Unknown type name \"%s\"", $str);
	errmsg("strtotype()", $buf);

    return $ret;
}  /* strtotype */

//-------------------------------------------------------------------------

//void
function allocate_nodes($n) // int n
{
	//$p = "allocate_nodes"; //char *
	global $node, $DEBUG;
	$i = 0; // int

    $node = array();
    for ($i = 0; $i<$n; $i++) {
        //if ($DEBUG) debug(__FUNCTION__, "Allocating_nodes ".$i);
        $node[$i] = new NODE_TYPE();
    };
    
}  /* allocate_nodes */

//-------------------------------------------------------------------------

//void
function allocate_jobs($jobs) // int jobs
{
	// $p    = "allocate_jobs()"; // char *

	global $job; // extern JOB_TYPE *
	global $tm; // extern TERMINAL_TYPE *
	global $bt; // extern BATCH_TYPE *
	global $tx; // extern TRANSACTION_TYPE *
	global $sys; // extern SYSTAT_TYPE *
	global $DEBUG;

	$c = 0; // int

	//if ((job = (JOB_TYPE*) calloc(sizeof(JOB_TYPE), jobs)) == NULL)
	//	errmsg(p, "Job allocation failed!\n");
	$job = array();
    for ($c = 0; $c < $jobs; $c++) {
        //if ($DEBUG) debug(__FUNCTION__, "Allocating_job ".$c);
        $job[$c] = new JOB_TYPE();
    };
	

	for ($c = 0; $c < $jobs; $c++) {
	  
		$job[$c]->term = new TERMINAL_TYPE();
		$job[$c]->term->sys = new SYSTAT_TYPE();; 
		
		$job[$c]->batch = new BATCH_TYPE();
		$job[$c]->batch->sys =& $job[$c]->term->sys;
		
		$job[$c]->trans = new TRANSACTION_TYPE();
		$job[$c]->trans->sys =& $job[$c]->term->sys;

		$job[$c]->should_be_class = VOID;
		$job[$c]->network = VOID;
	}
}  /* allocate_jobs */

//-------------------------------------------------------------------------

//int
function getjob_index($wname) // char *wname
{
	$p = "getjob_index()"; // char *

	global $s1; // extern char[]
	global $streams, $job, $DEBUG;
	
    $job_term_name = ""; // char *
	$n = 0; // int

	if ($DEBUG)
		debug($p, "Entering for \"".$wname."\"");
	
	if ($wname) {
		for ($n = 0; $n < $streams; $n++) {
			if ($job[$n]->term)
			{
				$job_term_name = $job[$n]->term->name;
			} else {
				$job_term_name = "UNDEFINED";
			};
		 
			if (($job_term_name == $wname) || ($job[$n]->batch->name == $wname) || ($job[$n]->trans->name == $wname)) {
				if ($DEBUG) {
				   $s1="";
				   $s1 = sprintf( "stream:\"%s\"  index: %d", $wname, $n);
				   debug($p, $s1);
				   $s1="";
				   debug($p, "Exiting for \"".$wname."\" = ".$n);
				};
				return ($n);
			};
		};
	};

	// g_debug("*** CRITICAL *** function needs to return something!\n");

   return -1;
}  /* getjob_index */

//-------------------------------------------------------------------------

//int
function getnode_index($name) // char *name
{
	$p = "getnode_index()"; // char *

	global $s1, $DEBUG, $nodes, $node; // extern char[]

	$k = 0; // int

	if ($DEBUG)
		debug($p, "Entering for \"".$name."\"");

	for ($k = 0; $k < $nodes; $k++) {
		if ($node[$k]->devname == $name) {
			if ($DEBUG) {
				$s1="";
				$s1 = sprintf( "node:\"%s\"  index: %d", $name, $k);
				debug($p, $s1);
				$s1="";
				debug($p, "Exiting for \"".$name."\" = ".$k);
			};
			return ($k);
		};
	};

	/* if you are here, you're in deep yoghurt! */

	$s1="";
	$s1 = sprintf( "Node name \"%s\" not found at index: %d", $name, $k);
	errmsg($p, $s1);

	/*g_debug("[getnode_index]  Bad return value");*/
    fprintf(STDERR, "%s:%d [getnode_index]  Bad return value\n", __FILE__, __LINE__);
	return -1;
}  /* getnode_index */

//-------------------------------------------------------------------------

//NODE_TYPE *
function &getnode($idx) // int idx
{
    global $nodes, $node;
    
	if (($idx >= 0) && ($idx < $nodes)) {
		return $node[$idx];
	} else {
		return  NULL; //(NODE_TYPE*)0;
	};
}  /* getnode */

//-------------------------------------------------------------------------

//void
function getjob_name(&$str, $c) // char *str, int c
{
	$p = "getjob_name()"; // char *
	global $DEBUG, $job;

	if ($DEBUG)
		debug($p, "Entering");

	switch ($job[$c]->should_be_class) {
		case TERM:
			$str = $job[$c]->term->name;
			break;
		case BATCH:
			$str = $job[$c]->batch->name;
			break;
		case TRANS:
			$str = $job[$c]->trans->name;
			break;
		default:
			break;
	};

	if ($DEBUG) debug($p, "Exiting");
	return $str;
}  /* getjob_name */

//-------------------------------------------------------------------------

//double 
function getjob_pop($c) // int c
{
	global $s1, $s2; // extern char[]
	global $DEBUG, $job;

	$p = "getjob_pop()"; // char *

	if ($DEBUG)
		debug($p, "Entering");

	switch ($job[$c]->should_be_class) {
		case TERM:
			if ($DEBUG)	debug($p, "TERM Exiting");
			return ($job[$c]->term->pop);
			break;
		case BATCH:
			if ($DEBUG) debug($p, "BATCH Exiting");
			return ($job[$c]->batch->pop);
			break;
		default:         /* error */
			typetostr($s1, $job[$c]->should_be_class);
			$s2 = sprintf( "Stream %d. Unknown job type %s", $c, $s1);
			errmsg($p, $s2);
			break;
	};

	return -1.0;
}  /* getjob_pop */

//-------------------------------------------------------------------------

//JOB_TYPE* 
function &getjob($c) // int c
{
  global $job;
  
	if ($c >= 0) {
		return $job[$c];
	} else {
		return  NULL; //(JOB_TYPE*)0;
	};
}  /* getjob */

//-------------------------------------------------------------------------

/*
 * For the purpose of indexing the the average number of terminals or
 * jobs. Take the ceiling of a double and return an int.
 */

//int 
function roundup($f) // double f
{
	$i = (int) ceil((double) $f); // int

	return ($i);
}  /* roundup */

//-------------------------------------------------------------------------
// Reset a string buffer

//void 
function resets(&$s) // char *s
{
	$s = "";
	return $s;
}  /* resets */

//-------------------------------------------------------------------------

// void
function debug($proc, $info) // char *proc, char *info
{
    global $prevproc;
    
	if ($prevproc == $proc) {
		printf("\t%s\n", $info);
	} else {
		printf("DEBUG: %s\n\t%s\n", $proc, $info);
		$prevproc = $proc;
	};

	//resets(info);
}  /* debug */

//-------------------------------------------------------------------------

//void 
function errmsg($pname, $msg) // char *pname, char *msg
{
	global $model; // extern char[]

	/* output to tty always */
	fprintf(STDERR,"ERROR in model:\"%s\" at %s: %s\n",$model, $pname, $msg);

	/*if (strchr(msg, '\012') && strlen(msg) != 1)
		printf("\n");
    */
	exit(2);
}  /* errmsg */

//-------------------------------------------------------------------------

function gets(&$s)
{
  $ta = array();
  $s = "";
  
  $ta = fscanf(STDIN, "%s\n");
  $s = $ta[0];
  return $ta[0];
};

function atol($s)
{
    $i = (integer) $s;
    return $i;
};

function atof($s)
{
    $f = (float) $s;
    return $f;
};

function atoi($s)
{
  $i = (integer) $s;
  return $i;
};

function repair($m, $S, $N, $Z)
{
/*
    Exact solution for M/M/m/N/N repairmen model.
    
    $m = Number of servicemen 
    $S = Mean service time
    $N = Number of machines
    $Z = Mean time to failure (MTTF) 
*/

    $L = 0.0;		/* mean number of broken machines in line */
    $Q = 0.0;		/* mean number of broken machines in system */
    $R = 0.0;		/* mean response time */
    $U = 0.0;		/* total mean utilization */
    $rho = 0.0;		/* per server utilization */
    $W = 0.0;		/* mean time waiting for repair */
    $X = 0.0;		/* mean throughput */
    $p = 0.0;		/* temp variable for prob calc. */
    $p0 = 0.0;		/* prob if zero breakdowns */
    $k = 0;		    /* loop index */

   $p = 1;
   $p0 = 1;
   $L = 0;

   for ($k = 1; $k <= $N; $k++) {
      $p *= ($N - $k + 1) * $S / $Z;

      if ($k <= $m) {
	       $p /= $k;
      } else {
	       $p /= $m;
      };
      $p0 += $p;

      if ($k > $m) {
	       $L += $p * ($k - $m);
      };
   }; /* k loop */

   $p0 = 1.0 / $p0;
   $L *= $p0;
   $W = $L * ($S + $Z) / ($N - $L);
   $R = $W + $S;
   $X = $N / ($R + $Z);
   $U = $X * $S;
   $rho = $U / $m;
   $Q = $X * $R;

   printf("\n");
   printf("  M/M/%ld/%ld/%ld Repair Model\n", $m, $N, $N);
   printf("  ----------------------------\n");
   printf("  Machine pop:      %4ld\n", $N);
   printf("  MT to failure:    %9.4lf\n", $Z);
   printf("  Service time:     %9.4lf\n", $S);
   printf("  Breakage rate:    %9.4lf\n", 1 / $Z);
   printf("  Service rate:     %9.4lf\n", 1 / $S);
   printf("  Utilization:      %9.4lf\n", $U);
   printf("  Per Server:       %9.4lf\n", $rho);
   printf("  \n");
   printf("  No. in system:    %9.4lf\n", $Q);
   printf("  No. in service:   %9.4lf\n", $U);
   printf("  No. enqueued:     %9.4lf\n", $Q - $U);
   printf("  Waiting time:     %9.4lf\n", $R - $S);
   printf("  Throughput:       %9.4lf\n", $X);
   printf("  Response time:    %9.4lf\n", $R);
   printf("  Normalized RT:    %9.4lf\n", $R / $S);
   printf("  \n");
}

function erlang($servers, $traffic)
{
   $erlangB = 0.0;
   $erlangC = 0.0;
   $eb = 0.0;
   $rho = 0.0;
   $nrt = 0.0;
   $ql = 0.0;
   $m = 0;

   /* initialize variables */
   $rho = $traffic / $servers;
   $erlangB = $traffic / (1 + $traffic);

   /* Jagerman's algorithm */
   for ($m = 2; $m <= $servers; $m++) {
      $eb = $erlangB;
      $erlangB = $eb * $traffic / ($m + $eb * $traffic);
   };

   $erlangC = $erlangB / (1 - $rho + $rho * $erlangB);
   $nrt = 1 + $erlangC / ($servers * (1 - $rho));
   $ql = $traffic * $nrt;

   /* outputs */
   printf("\nIterative computation of Erlang B and C functions:\n");
   printf("  %ld Server System\n", $servers);
   printf("  -----------------\n");
   printf("  Traffic intensity:  %5.5lf\n", $traffic);
   printf("  Server utilization: %5.5lf\n", $rho);
   printf("  \n");
   printf("  Erlang B  (loss  prob): %5.5lf\n", $erlangB);
   printf("  Erlang C  (queue prob): %5.5lf\n", $erlangC);
   printf("  M/M/m    Normalized RT: %5.5lf\n", $nrt);
   printf("  M/M/m    No. in System: %5.5lf\n", $ql);
   printf("\n  NOTE: Per server load = traffic/servers\n");

}

?>
