<?php
error_reporting(E_ALL);
/*
 * PDQ/PHP5 Analyzer v1.0 (27 Mar 2006)
 * This is a C to PHP5 translation of the PDQ (Pretty Damn Quick) performance analyzer.
 * PHP5 translation By Samuel Zallocco - University of L'Aquila - Italy.
 * e-mail: samuel.zallocco@univaq.it
 *
 * All (C)opyright and Rights reserved by the original author of the C version.
 *
 * Based upon: "PDQ Analyzer v3.0 111904" Original Copyright disclaimer follow:
 *
 * Headers for the PDQ (Pretty Damn Quick) performance analyzer.
 * 
 * This version is intended for use with the following books 
 * by Dr. Neil J. Gunther:
 *    (1) "The Practical Performance Analyst" 
 *           McGraw-Hill Companies 1998. ISBN: 0-079-12946-3 
 *           iUniverse Press Inc., 2000. ISBN: 0-595-12674-X
 *    (2) "Analyzing Computer System Performance Using Perl::PDQ" 
             Springer-Verlag, 2004. ISBN: 3-540-20865-8
 * 
 *  Visit the www.perfdynamics.com for additional information
 *  on the book and other resources.
 * 
 *  $Id$
 * 
*******************  DISCLAIMER OF WARRANTY ************************
 * Performance Dynamics Company(SM) and Neil J. Gunther make no warranty,
 * express or implied, that the source code contained PDQ or in the  book
 * are free from error, or are consistent with any particular standard of
 * merchantability, or that they will meet your requirements for a
 * particular application. They should not be relied upon for solving a
 * problem whose correct solution could result in injury to a person or
 * loss of property. The author disclaims all liability for direct or
 * consequential damages resulting from your use of this source code.
 * Please refer to the separate disclaimer from McGraw-Hill attached to
 * the diskette. 
************************* DO NOT REMOVE ****************************
*/
 
//---- CONSTANT --------------------------------------------------------------

define("MAXNODES",1000);	/* Max queueing nodes */
define("MAXBUF",256);		/* Biggest buffer */
define("MAXSTREAMS",30);	/* Max job streams */
define("MAXCHARS",24);		/* Max chars in param fields */
define("MAXVAL",21);

define("MAXSUFF",10);

define("MAXPOP1",1000);
define("MAXPOP2",1000);
define("MAXDEVS",10);

define("MAXCLASS",3);

/* Queueing Network Type */
define("VOID",-1);

define("OPEN",0);
define("CLOSED",1);

/* Nodes */

define("MEM",2); 				/* Memory ?!?!?!? */
define("CEN",3); 				/* unspecified queueing center */
define("CENTER",3); 			/* unspecified queueing center */
define("SERVICECENTER",3); 		/* unspecified queueing center */
define("SINGLESERVERQUEUE",3); 	/* unspecified queueing center */
define("DLY",4); 				/* unspecified delay center */
define("DELAY",4);	 			/* unspecified delay center */
define("DELAYCENTER",4); 		/* unspecified delay center */
define("MSQ",5); 				/* unspecified multi-server queue */
define("MULTISERVERQUEUE",5); 	/* unspecified multi-server queue */

/* Queueing Disciplines */

define("ISRV",6);		/* infinite server */
define("IS",6);			/* infinite server */
define("FCFS",7);		/* first-come first-serve */
define("FIFO",7);		/* first-in first-out */
define("PSHR",8);		/* processor sharing */
define("PS",8);			/* processor sharing */
define("LCFS",9);		/* last-come first-serve */
define("LIFO",9);		/* last-in first-out */


/* Job Types */

define("TERM",10);			/* Terminal workload */
define("TERMMINAL",10);		/* Terminal workload */
define("INTERACTIVE",10);   /* Terminal workload */

define("TRANS",11);			/* Transactional workload */
define("TRANSACTION",11);   /* Transactional workload */

define("BATCH",12);         /* Batch workload */

/* Solution Methods */

define("EXACT",13);
define("APPROX",14);
define("CANON",15);

/* Service-demand Types */

define("VISITS",16);
define("DEMAND",17);

/* MP scalability */

define("PDQ_SP",18);	/* uniprocessor */
define("PDQ_MP",19);	/* multiprocessor */

define("TOL",0.0010); /* Tollerance */

define("PDQ_COMMENTS_FILE","comments.pdq");

define("PDQ_OUT_FILE","PDQ.out");

//---- VARIABLES -----------------------------------------------------------------
/*
               <<<<< !! WARNING NOTE FROM SAMUEL ZALLOCCO !! >>>>>
 
 The wide use of global variables, as in the original "c" version can cause
 strange behaviour and anomalies when in the example you use variables with
 the same name of the global ones!!
 To avoid this kind of anomalies you can use a function, "main" for example,
 to make all variables local to the example:
  
 < ? php
 function main($argc, $argv)
 {
      global  $nodes, $streams;
      $k = "bla bla"; // <-- local to main. it does not interfer with $k in PDQ_Lib
      $c = 456.123;   // As above;
      .....
      
 };
 main($argc,$argv); // call the main function and pass it the predefined $argc and $argv special variables
 ? >
 
 In this "All In One" version of PDQ_Lib we have removed some global variables and have
 added the "PDQ_" prefix to all function and variables name.
 This isn't the definitive solution but it can help avoiding users variable and function conflict.
    by S.Z. 
*/

// This string gets read by GetVersion script amongst others
$PDQ_version = "PDQ Analyzer v3.0 111904";

$PDQ_model = ""; // char[MAXCHARS]  /* Model name */
$PDQ_wUnit = ""; // char[10]        /* Work unit string */
$PDQ_tUnit = ""; // char[10]        /* Time unit string */

$PDQ_DEBUG = FALSE; // int
$PDQ_prevproc = ""; // char[MAXBUF];
$PDQ_prev_init = FALSE; //int
$PDQ_demand_ext = 0; //int
$PDQ_nodes = 0; // int
$PDQ_streams = 0; //int
$PDQ_iterations = 0; // int
$PDQ_method = 0; // int
//$PDQ_memdata = 0; // int ------------------> it Come from the original C-language Version but never used !!!!!
$PDQ_sumD = 0.0; // double
$PDQ_tolerance = 0.0; // double

/* temp buffers  */
$PDQ_k = 0; // static int
$PDQ_c = 0; // static int

$PDQ_syshdr = 0; // int;
$PDQ_jobhdr = 0; // int
$PDQ_nodhdr = 0; // int
$PDQ_devhdr = 0; // int
$PDQ_trmhdr = FALSE; // int
$PDQ_bathdr = FALSE; // int
$PDQ_trxhdr = FALSE; // int

$PDQ_node = NULL; // NODE_TYPE
$PDQ_job = NULL; // JOB_TYPE

$PDQ_typetable = array(
        "VOID"=>VOID, VOID=>"VOID",
		"OPEN"=>OPEN, OPEN=>"OPEN",
		"CLOSED"=>CLOSED, CLOSED=>"CLOSED",
		"MEM"=>MEM, MEM=>"MEM",
		"CEN"=>CEN, CEN=>"CEN",
		"DLY"=>DLY, DLY=>"DLY",
		"MSQ"=>MSQ, MSQ=>"MSQ",
		"ISRV"=>ISRV, ISRV=>"ISRV",
		"FCFS"=>FCFS, FCFS=>"FCFS",
		"PSHR"=>PSHR, PSHR=>"PSHR",
		"LCFS"=>LCFS, LCFS=>"LCFS",
		"TERM"=>TERM, TERM=>"TERM",
		"TRANS"=>TRANS, TRANS=>"TRANS",
		"BATCH"=>BATCH, BATCH=>"BATCH",
		"EXACT"=>EXACT, EXACT=>"EXACT",
		"APPROX"=>APPROX, APPROX=>"APPROX",
		"CANON"=>CANON, CANON=>"CANON",
		"VISITS"=>VISITS, VISITS=>"VISITS",
		"DEMAND"=>DEMAND, DEMAND=>"DEMAND",
		"SP"=>PDQ_SP, PDQ_SP=>"SP",
		"MP"=>PDQ_MP, PDQ_MP=>"MP"
	);  /* typetable */

//---- TYPES as CLASS ------------------------------------------------------------

// PHP can't define type structures so we have to use class!!

class  SYSTAT_TYPE {
   var $response = 0.0; // double
   var $thruput = 0.0; // double
   var $residency = 0.0; // double
   var $physmem = 0.0; // double
   var $highwater = 0.0; // double
   var $malloc = 0.0; // double
   var $mpl = 0.0; // double
   var $maxN = 0.0; // double
   var $maxTP = 0.0; // double
   var $minRT = 0.0; // double
};

class TERMINAL_TYPE  {
   var $name= ""; // char [MAXCHARS]
   var $pop = 0.0; // double
   var $think = 0.0; // double
   var $sys = NULL; // SYSTAT_TYPE
};

class BATCH_TYPE {
   var $name = ""; // char [MAXCHARS];
   var $pop = 0.0; // double
   var $sys = NULL; // SYSTAT_TYPE
};

class TRANSACTION_TYPE {
   var $name =""; // char [MAXCHARS];
   var $arrival_rate = 0.0; // double
   var $saturation_rate = 0.0; //double
   var $sys = NULL; // SYSTAT_TYPE
};

class  JOB_TYPE {
   var $should_be_class = 0;  // int stream should_be_class
   var $network = 0;          // int OPEN, CLOSED
   var $term = NULL; // TERMINAL_TYPE
   var $batch = NULL; // BATCH_TYPE
   var $trans = NULL; // TRANSACTION_TYPE 
};

class NODE_TYPE {
   var $devtype = 0; // int CEN, ...
   var $sched = 0; // int FCFS, ... 
   var $devname = ""; // char [MAXCHARS];
   var $visits = array(); // double [MAXSTREAMS];
   var $service = array(); // double [MAXSTREAMS];
   var $demand = array(); // double [MAXSTREAMS];
   var $resit = array(); // double [MAXSTREAMS];
   var $utiliz = array(); // double [MAXSTREAMS];    /* computed node utilization */
   var $qsize = array(); // double [MAXSTREAMS];
   var $vqsize = array(); // double [MAXSTREAMS];

   function __construct()
   {
        $NODE_TYPE->visits = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];
        $NODE_TYPE->service = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];
        $NODE_TYPE->demand = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];
        $NODE_TYPE->resit = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];
        $NODE_TYPE->utiliz = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];    /* computed node utilization */
        $NODE_TYPE->qsize = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];
        $NODE_TYPE->vqsize = array_fill(0,MAXSTREAMS-1,0.0); // double [MAXSTREAMS];
   }

};

// -- Ask user to input a string and confirm it with [ENTER]
function gets(&$s)
{
  $ta = array();
  $s = "";
  
  $ta = fscanf(STDIN, "%s\n");
  $s = $ta[0];
  return $ta[0];
};

// -- C equivalent atol() function
function atol($s)
{
    $i = (integer) $s;
    return $i;
};

// -- C equivalent atof() function
function atof($s)
{
    $f = (float) $s;
    return $f;
};

// -- C equivalent atoi() function
function atoi($s)
{
  $i = (integer) $s;
  return $i;
};


/* 
   ----------------------------------------------------
    Exact solution for M/M/m/N/N repairmen model.
    
    $m = Number of servicemen 
    $S = Mean service time
    $N = Number of machines
    $Z = Mean time to failure (MTTF) 
   ----------------------------------------------------
*/
function PDQ_Repair($m, $S, $N, $Z)
{

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

/*
    -------------------------------------------------
    Iterative computation of Erlang B and C functions
    -------------------------------------------------
*/
function PDQ_Erlang($servers, $traffic)
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

function PDQ_GetVersion($printit = FALSE)
{
  global $PDQ_version;
  if ($printit )
  {
      print $PDQ_version;
  } else {
      return $PDQ_version;
  };
}

/*
 * PDQ_Utils.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Revised by NJG (for Sun): Tue Aug 11 17:31:02 PDT 1998
 * 
 *  $Id$
 */

//*********************************************************************
//         Public Utilities
//*********************************************************************

/* double */ 
function PDQ_GetResponse($should_be_class, $wname) /* int $should_be_class, char *wname */
{
    global $PDQ_streams, $PDQ_job;
	$r = 0.0; //double

    $job_index = PDQ_GetJobIndex($wname); // int

    if (($job_index >= 0) && ($job_index < $PDQ_streams)) {
		switch ($should_be_class) {
			case TERM:
				$r = $PDQ_job[$job_index]->term->sys->response;
				break;
			case BATCH:
				$r = $PDQ_job[$job_index]->batch->sys->response;
				break;
			case TRANS:
				$r = $PDQ_job[$job_index]->trans->sys->response;
				break;
			default:
				PDQ_ErrMsg(__FUNCTION__, "Unknown should_be_class");
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
	global $PDQ_streams, $PDQ_job;
	$x = 0.0; // double

    $job_index = PDQ_GetJobIndex($wname); // int

    if (($job_index >= 0) && ($job_index < $PDQ_streams)) {
		switch ($should_be_class) {
			case TERM:
				$x = $PDQ_job[$job_index]->term->sys->thruput;
				break;
			case BATCH:
				$x = $PDQ_job[$job_index]->batch->sys->thruput;
				break;
			case TRANS:
				$x = $PDQ_job[$job_index]->trans->sys->thruput;
				break;
			default:
				PDQ_ErrMsg(__FUNCTION__, "Unknown should_be_class");
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
	global $PDQ_streams, $PDQ_job;
	$r = 0.0; //double

    $job_index = PDQ_GetJobIndex($wname); // int

    if (($job_index >= 0) && ($job_index < $PDQ_streams)) {
		switch ($should_be_class) {
			case TERM:
				$x = $PDQ_job[$job_index]->term->sys->maxTP;
				break;
			case BATCH:
				$x = $PDQ_job[$job_index]->batch->sys->maxTP;
				break;
			case TRANS:
				$x = $PDQ_job[$job_index]->trans->sys->maxTP;
				break;
			default:
				PDQ_ErrMsg(__FUNCTION__, "Unknown should_be_class");
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
	global $PDQ_streams, $PDQ_job;
	$Dmax = 0.0; // double
    $Dsum = 0.0; // double
	$Nopt = 0.0; // double
    $Z = 0.0; // double

    $job_index = PDQ_GetJobIndex($wname); // int

    if (($job_index >= 0) && ($job_index < $PDQ_streams)) {
		switch ($should_be_class) {
				case TERM:
					$Dsum = $PDQ_job[$job_index]->term->sys->minRT;
					$Dmax = 1.0 / $PDQ_job[$job_index]->term->sys->maxTP;
					$Z = $PDQ_job[$job_index]->term->think;
					break;
				case BATCH:
					$Dsum = $PDQ_job[$job_index]->batch->sys->minRT;
					$Dmax = 1.0 / $PDQ_job[$job_index]->batch->sys->maxTP;
					$Z = 0.0;
					break;
				case TRANS:
					PDQ_ErrMsg(__FUNCTION__, "Cannot calculate max Load for TRANS class");
					break;
				default:
					PDQ_ErrMsg(__FUNCTION__, "Unknown should_be_class");
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
	global $PDQ_nodes, $PDQ_node;
	$r = 0.0; // double
	$c = 0; // int
    $k = 0; // int

	$c = PDQ_GetJobIndex($work);

	for ($k = 0; $k < $PDQ_nodes; $k++) {
		//if (strcmp(device, node[k].devname) == 0) {
		if ($device == $PDQ_node[$k]->devname) {
			$r = $PDQ_node[$k]->resit[$c];
			return ($r);
		};
	};

	PDQ_ErrMsg(__FUNCTION__, "Unknown device ".$device);

	fprintf(STDERR, "%s:%d PDQ_GetResidenceTime:  Returning bad double\n", __FILE__, __LINE__);

	return -1.0;
}  /* PDQ_GetResidenceTime */

//-------------------------------------------------------------------------

// double
function PDQ_GetUtilization($device, $work, $should_be_class) // char *device, char *work, int should_be_class
{
	global $PDQ_job, $PDQ_nodes, $PDQ_node; // extern char[]
	$x = 0.0; // double
    $u = 0.0; // double
	$c = 0; // int
    $k = 0; // int

	if ($PDQ_job) {
		$c = PDQ_GetJobIndex($work);
		$x = PDQ_GetThruput($should_be_class, $work);

		for ($k = 0; $k < $PDQ_nodes; $k++) {
			if ($device == $PDQ_node[$k]->devname) {
				$u = $PDQ_node[$k]->demand[$c] * $x;
				return ($u);
			};
		};

		PDQ_ErrMsg(__FUNCTION__, "Unknown device ".$device);
	};

    fprintf(STDERR, "%s:%d PDQ_GetUtiliation:  Failed to find utilization\n", __FILE__, __LINE__);

	return 0.0;
}  /* PDQ_GetUtilization */

//-------------------------------------------------------------------------

// double
function PDQ_GetQueueLength($device, $work, $should_be_class) // char *device, char *work, int should_be_class
{
	global $PDQ_nodes, $PDQ_node;
	
	$q = 0.0; // double
    $x = 0.0; // double
	$c = 0; // int
    $k = 0; // int

	$c = PDQ_GetJobIndex($work);
	$x = PDQ_GetThruput($should_be_class, $work);

	for ($k = 0; $k < $PDQ_nodes; $k++) {
		if ($device == $PDQ_node[$k]->devname) {
			$q = $PDQ_node[$k]->resit[$c] * x;
			return ($q);
		};
	};
	PDQ_ErrMsg(__FUNCTION__, "Unknown device ".$device);
    fprintf(STDERR, "%s:%d PDQ_GetQueueLength - Bad double return\n", __FILE__, __LINE__);
	return -1.0;
}  /* PDQ_GetQueueLength */

//-------------------------------------------------------------------------

// void
function PDQ_SetDebug($flag) // int flag
{
	global $PDQ_DEBUG;
    $PDQ_DEBUG = $flag;

	if ($PDQ_DEBUG) {
		printf("debug on\n");
	} else {
		printf("debug off\n");
	};
}  /* PDQ_SetDebug */

//-------------------------------------------------------------------------

//void
function PDQ_TypeToStr(&$str, $type) // char *str, int type
/* convert a #define to a string */
{
    global $PDQ_typetable;
    
    if (in_array($type, $PDQ_typetable)) {
        $str = $PDQ_typetable[$type];
    } else {
        $str = "NONE";
	    PDQ_ErrMsg(__FUNCTION__, "Unknown type id for \"".$str."\"");
    };

    return $str;
}  /* PDQ_TypeToStr */

//-------------------------------------------------------------------------

// int
function PDQ_StrToType($str) // char *str
/* convert a string to its #define value */
{
    $ret = -2;
    global $PDQ_typetable;
    
    if (in_array($str, $PDQ_typetable)) {
        $ret = $PDQ_typetable[$str];
    };
	
	PDQ_ErrMsg(__FUNCTION__, "Unknown type name \"".$str."\"");

    return $ret;
}  /* PDQ_StrToType */

//-------------------------------------------------------------------------

//void
function PDQ_AllocateNodes($n) // int n
{
	global $PDQ_node, $PDQ_DEBUG;
	$i = 0; // int

    $PDQ_node = array();
    for ($i = 0; $i<$n; $i++) {
        $PDQ_node[$i] = new NODE_TYPE();
    };
    
}  /* PDQ_AllocateNodes */

//-------------------------------------------------------------------------

//void
function PDQ_AllocateJobs($jobs) // int jobs
{
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_DEBUG;

	$c = 0; // int

	//if ((job = (JOB_TYPE*) calloc(sizeof(JOB_TYPE), jobs)) == NULL)
	//	PDQ_ErrMsg(p, "Job allocation failed!\n");
	$PDQ_job = array();
    for ($c = 0; $c < $jobs; $c++) {
        //if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Allocating_job ".$c);
        $PDQ_job[$c] = new JOB_TYPE();
    };
	

	for ($c = 0; $c < $jobs; $c++) {
	  
		$PDQ_job[$c]->term = new TERMINAL_TYPE();
		$PDQ_job[$c]->term->sys = new SYSTAT_TYPE();; 
		
		$PDQ_job[$c]->batch = new BATCH_TYPE();
		$PDQ_job[$c]->batch->sys =& $PDQ_job[$c]->term->sys;
		
		$PDQ_job[$c]->trans = new TRANSACTION_TYPE();
		$PDQ_job[$c]->trans->sys =& $PDQ_job[$c]->term->sys;

		$PDQ_job[$c]->should_be_class = VOID;
		$PDQ_job[$c]->network = VOID;
	};
}  /* PDQ_AllocateJobs */

//-------------------------------------------------------------------------

//int
function PDQ_GetJobIndex($wname) // char *wname
{
	global $PDQ_streams, $PDQ_job, $PDQ_DEBUG;
	
    $job_term_name = ""; // char *
	$n = 0; // int

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering for \"".$wname."\"");
	
	if ($wname) {
		for ($n = 0; $n < $PDQ_streams; $n++) {
			if ($PDQ_job[$n]->term)
			{
				$job_term_name = $PDQ_job[$n]->term->name;
			} else {
				$job_term_name = "UNDEFINED";
			};
		 
			if (($job_term_name == $wname) || ($PDQ_job[$n]->batch->name == $wname) || ($PDQ_job[$n]->trans->name == $wname)) {
				if ($PDQ_DEBUG) {
				   PDQ_Debug(__FUNCTION__, "stream:\"".$wname."\"  index: ".$n);
				   PDQ_Debug(__FUNCTION__, "Exiting for \"".$wname."\" = ".$n);
				};
				return ($n);
			};
		};
	};
   return -1;
}  /* PDQ_GetJobIndex */

//-------------------------------------------------------------------------

//int
function PDQ_GetNodeIndex($name) // char *name
{
	global $PDQ_DEBUG, $PDQ_nodes, $PDQ_node; // extern char[]

	$k = 0; // int

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering for \"".$name."\"");

	for ($k = 0; $k < $PDQ_nodes; $k++) {
		if ($PDQ_node[$k]->devname == $name) {
			if ($PDQ_DEBUG) {
				PDQ_Debug(__FUNCTION__, "node:\"".$name."\"  index: ".$k);
				PDQ_Debug(__FUNCTION__, "Exiting for \"".$name."\" = ".$k);
			};
			return ($k);
		};
	};

	/* if you are here, you're in deep yoghurt! */
	PDQ_ErrMsg(__FUNCTION__, "Node name \"".$name."\" not found at index: ".$k);
    fprintf(STDERR, "%s:%d [PDQ_GetNodeIndex]  Bad return value\n", __FILE__, __LINE__);
	return -1;
}  /* PDQ_GetNodeIndex */

//-------------------------------------------------------------------------

//NODE_TYPE *
function &PDQ_GetNode($idx) // int idx
{
    global $PDQ_nodes, $PDQ_node;
    
	if (($idx >= 0) && ($idx < $PDQ_nodes)) {
		return $PDQ_node[$idx];
	} else {
		return  NULL; //(NODE_TYPE*)0;
	};
}  /* PDQ_GetNode */

//-------------------------------------------------------------------------

//void
function PDQ_GetJobName(&$str, $c) // char *str, int c
{
	global $PDQ_DEBUG, $PDQ_job;

	if ($PDQ_DEBUG)
		PDQ_Debug(__FUNCTION__, "Entering");

	switch ($PDQ_job[$c]->should_be_class) {
		case TERM:
			$str = $PDQ_job[$c]->term->name;
			break;
		case BATCH:
			$str = $PDQ_job[$c]->batch->name;
			break;
		case TRANS:
			$str = $PDQ_job[$c]->trans->name;
			break;
		default:
			break;
	};

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
	return $str;
}  /* PDQ_GetJobName */

//-------------------------------------------------------------------------

//double 
function PDQ_GetJobPop($c) // int c
{
	global $PDQ_DEBUG, $PDQ_job;
	$s1 = "";

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	switch ($PDQ_job[$c]->should_be_class) {
		case TERM:
			if ($PDQ_DEBUG)	PDQ_Debug(__FUNCTION__, "TERM Exiting");
			return ($PDQ_job[$c]->term->pop);
			break;
		case BATCH:
			if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "BATCH Exiting");
			return ($PDQ_job[$c]->batch->pop);
			break;
		default:         /* error */
			PDQ_TypeToStr($s1, $PDQ_job[$c]->should_be_class);
			PDQ_ErrMsg(__FUNCTION__, "Stream ".$c.". Unknown job type ".$s1);
			break;
	};

	return -1.0;
}  /* PDQ_GetJobPop */

//-------------------------------------------------------------------------

//JOB_TYPE* 
function &PDQ_GetJob($c) // int c
{
  global $PDQ_job;
  
	if ($c >= 0) {
		return $PDQ_job[$c];
	} else {
		return  NULL; //(JOB_TYPE*)0;
	};
}  /* PDQ_GetJob */

//-------------------------------------------------------------------------

/*
 * For the purpose of indexing the the average number of terminals or
 * jobs. Take the ceiling of a double and return an int.
 */

//int 
function PDQ_RoundUp($f) // double f
{
	$i = (int) ceil((double) $f); // int

	return ($i);
}  /* PDQ_RoundUp */

//-------------------------------------------------------------------------
// Reset a string buffer
//void 
function PDQ_Resets(&$s) // char *s
{
	$s = "";
	return $s;
}  /* PDQ_Resets */

//-------------------------------------------------------------------------

// void
function PDQ_Debug($proc, $info) // char *proc, char *info
{
    global $PDQ_prevproc;
    
	if ($PDQ_prevproc == $proc) {
		printf("\t%s\n", $info);
	} else {
		printf("DEBUG: %s\n\t%s\n", $proc, $info);
		$PDQ_prevproc = $proc;
	};
}  /* PDQ_Debug */

//-------------------------------------------------------------------------

//void 
function PDQ_ErrMsg($pname, $msg) // char *pname, char *msg
{
	global $PDQ_model; // extern char[]
	fprintf(STDERR,"ERROR in model:\"%s\" at %s: %s\n",$PDQ_model, $pname, $msg);
	exit(2);
}  /* PDQ_ErrMsg */

//-------------------------------------------------------------------------

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

// void 
function PDQ_Init($name = "The Model Name") // char *name
{
	global $PDQ_model; // extern char[]
	global $PDQ_tUnit; // extern char[]
	global $PDQ_wUnit; // extern char[]
	global $PDQ_demand_ext; // extern int
	global $PDQ_method; // extern int 
	global $PDQ_tolerance; // extern double
	global $PDQ_nodes;  // extern int
	global $PDQ_streams;  // extern int
	global $PDQ_prev_init;  // extern int
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_DEBUG;  // extern int
	global $PDQ_c;
	global $PDQ_k;
	

	$cc = 0; // int
    $kk = 0; // int

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	if (strlen($name) > MAXCHARS) PDQ_ErrMsg(__FUNCTION__, "Model name > ".MAXCHARS." characters");

	if ($PDQ_prev_init) {
	    if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Prev_init detected");
		for ($cc = 0; $cc < MAXSTREAMS; $cc++) {
				$PDQ_job[$cc]->term->sys = NULL;
				$PDQ_job[$cc]->batch->sys = NULL;
				$PDQ_job[$cc]->trans->sys = NULL;
				$PDQ_job[$cc]->term = NULL;
				$PDQ_job[$cc]->batch = NULL;
				$PDQ_job[$cc]->trans = NULL;
		}; /* over c */

		if ($PDQ_job) {
			//free(job);
			$PDQ_job = NULL;
		};
		
		if ($PDQ_node) {
			//free(node);
			$PDQ_node = NULL;
		};

		$PDQ_model = "";
		$PDQ_wUnit = "";
		$PDQ_tUnit = "";
	};
    if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Setting model name");
	$PDQ_model = $name;

	/* default units */

	$PDQ_wUnit="Job";
	$PDQ_tUnit="Sec";

	$PDQ_demand_ext = VOID;
	$PDQ_tolerance = TOL;
	$PDQ_method = VOID;
	
    if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Allocate_nodes");
    
	PDQ_AllocateNodes(MAXNODES+1);
	
    if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Allocate_jobs");
	
    PDQ_AllocateJobs(MAXSTREAMS+1);
    
    if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Nodes and Jobs Allocated");
	
    for ($cc = 0; $cc < MAXSTREAMS; $cc++) {
		for ($kk = 0; $kk < MAXNODES; $kk++) {
			$PDQ_node[$kk]->devtype = VOID;
			$PDQ_node[$kk]->sched = VOID;
			$PDQ_node[$kk]->demand[$cc] = 0.0;
			$PDQ_node[$kk]->resit[$cc] = 0.0;
			$PDQ_node[$kk]->qsize[$cc] = 0.0;
		};
		$PDQ_job[$cc]->should_be_class = VOID;
		$PDQ_job[$cc]->network = VOID;
	};

	/* reset circuit counters */
	$PDQ_nodes = 0;
    $PDQ_streams = 0;
	$PDQ_c = 0;
    $PDQ_k = 0;

	$PDQ_prev_init = TRUE;

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_Init */

//-------------------------------------------------------------------------

//int 
function PDQ_CreateNode($name, $device, $sched) // char *name, int device, int sched
{
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_nodes; // extern int
	global $PDQ_DEBUG; // extern int
	global $PDQ_k;
	
	$s1 = "";
    $s2 = "";
    $out_fd = NULL; // FILE*

	if ($PDQ_DEBUG)
	{
		PDQ_Debug(__FUNCTION__, "Entering");
		$out_fd = fopen(PDQ_OUT_FILE, "a");
		fprintf($out_fd, "name : %s  device : %d  sched : %d\n", $name, $device, $sched);
		fclose($out_fd);
	};

	if ($PDQ_k > MAXNODES) PDQ_ErrMsg(__FUNCTION__, "Allocating \"".$name."\" exceeds ".MAXNODES." max nodes");

	if (strlen($name) >= MAXCHARS) PDQ_ErrMsg(__FUNCTION__, "Nodename \"".$name."\" is longer than ".MAXCHARS." characters");

	$PDQ_node[$PDQ_k]->devname = $name;
	$PDQ_node[$PDQ_k]->devtype = $device;
	$PDQ_node[$PDQ_k]->sched = $sched;

	if ($PDQ_DEBUG) {
		PDQ_TypeToStr($s1, $PDQ_node[$PDQ_k]->devtype);
		PDQ_TypeToStr($s2, $PDQ_node[$PDQ_k]->sched);
		PDQ_Debug(__FUNCTION__, "\tNode[".$PDQ_k."]: ".$s1." ".$s2." \"".$PDQ_node[$PDQ_k]->devname."\"");
		PDQ_Debug(__FUNCTION__, "Exiting");
	};

	$PDQ_k =  ++$PDQ_nodes;

	return $PDQ_nodes;
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
	global $PDQ_streams; // extern int
	global $PDQ_DEBUG; // extern int
	global $PDQ_c;
	
    $out_fd = NULL; // FILE *

	if ($PDQ_DEBUG)
	{
		PDQ_Debug(__FUNCTION__, "Entering");
		$out_fd = fopen(PDQ_OUT_FILE, "a");
		fprintf($out_fd, "name : %s  should_be_class : %d  pop : %f  think : %f\n", $name, $should_be_class, $pop, $think);
		fclose($out_fd);
	};

	if (strlen($name) >= MAXCHARS) PDQ_ErrMsg(__FUNCTION__, "Nodename \"".$name."\" is longer than ".MAXCHARS." characters");

	if ($PDQ_c > MAXSTREAMS) PDQ_ErrMsg(__FUNCTION__, "Allocating \"".$name."\" exceeds ".MAXSTREAMS." max streams");

	switch ($should_be_class) {
		case TERM:
			if ($pop == 0.0) PDQ_ErrMsg(__FUNCTION__, "Stream: \"".$name."\", has zero population");
			PDQ_CreateTermStream(CLOSED, $name, $pop, $think);
			break;
		case BATCH:
			if ($pop == 0.0) PDQ_ErrMsg(__FUNCTION__, "Stream: \"".$name."\", has zero population");
			PDQ_CreateBatchStream(CLOSED, $name, $pop);
			break;
		default:
			PDQ_ErrMsg(__FUNCTION__, "Unknown stream: ".$should_be_class);
			break;
	};

	if ($PDQ_DEBUG)	PDQ_Debug(__FUNCTION__, "Exiting");

	$PDQ_c =  ++$PDQ_streams;

	return $PDQ_streams;
}  /* PDQ_CreateClosed */

//-------------------------------------------------------------------------

// int 
function PDQ_CreateOpen($name, $lambda) // int PDQ_CreateOpen_p(char *name, double *lambda)
{
	global $PDQ_streams; // extern int
	global $PDQ_DEBUG; // extern int
	global $PDQ_c;
	
    $out_fd = NULL; // FILE *

	if ($PDQ_DEBUG)
	{
		$out_fd = fopen(PDQ_OUT_FILE, "a");
	    fprintf($out_fd, "name : %s  lambda : %f\n", $name, $lambda);
		fclose($out_fd);
	};
	
	if (strlen($name) > MAXCHARS) PDQ_ErrMsg("PDQ_CreateOpen()", "Nodename \"".$name."\" is longer than ".MAXCHARS." characters");

	PDQ_CreateTransaction(OPEN, $name, $lambda);

	$PDQ_c =  ++$PDQ_streams;

	return $PDQ_streams;
}  /* PDQ_CreateOpen */

//-------------------------------------------------------------------------

// void 
function PDQ_SetDemand($nodename, $workname, $time) // void PDQ_SetDemand_p(char *nodename, char *workname, double *time)
{
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_nodes; // extern int
	global $PDQ_streams; // extern int
	global $PDQ_demand_ext; // extern int
	global $PDQ_DEBUG; // extern int

	$node_index = 0; // int
	$job_index = 0; // int

	$out_fd = NULL; // FILE *

	if ($PDQ_DEBUG)
	{
		PDQ_Debug(__FUNCTION__, "Entering");
		$out_fd = fopen(PDQ_OUT_FILE, "a");
		fprintf($out_fd, "nodename : %s  workname : %s  time : %f\n", $nodename, $workname, $time);
		fclose($out_fd);
	};

	/* that demand type is being used consistently per model */

	if ($PDQ_demand_ext == VOID || $PDQ_demand_ext == DEMAND) {
		$node_index = PDQ_GetNodeIndex($nodename);
		$job_index  = PDQ_GetJobIndex($workname);

		if (!(($node_index >=0) && ($node_index <= $PDQ_nodes))) {
			fprintf(STDERR, "Illegal node index value %d\n", $node_index);
			exit(1);
		};

		if (!(($job_index >=0) && ($job_index <= $PDQ_streams))) {
			fprintf(STDERR, "Illegal job index value %d\n", $job_index);
			exit(1);
		};

		$PDQ_node[$node_index]->demand[$job_index] = $time;
		$PDQ_demand_ext = DEMAND;
	} else
		PDQ_ErrMsg(__FUNCTION__, "Extension conflict");

	if ($PDQ_DEBUG)
		PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_SetDemand */

//-------------------------------------------------------------------------

// void 
function PDQ_SetVisits($nodename, $workname, $visits, $service) // void PDQ_SetVisits_p(char *nodename, char *workname, double *visits, double *service)
{
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_demand_ext; // extern int 
	global $PDQ_DEBUG; // extern int 

	if ($PDQ_DEBUG)
	{
		printf("nodename : %s  workname : %s  visits : %f  service : %f\n", $nodename, $workname, $visits, $service);
	};

	if ($PDQ_demand_ext == VOID || $PDQ_demand_ext == VISITS) {
		$PDQ_node[PDQ_GetNodeIndex($nodename)]->visits[PDQ_GetJobIndex($workname)] = $visits;
		$PDQ_node[PDQ_GetNodeIndex($nodename)]->service[PDQ_GetJobIndex($workname)] = $service;
		$PDQ_node[PDQ_GetNodeIndex($nodename)]->demand[PDQ_GetJobIndex($workname)] = $visits * $service;
		$PDQ_demand_ext = VISITS;
	} else
		PDQ_ErrMsg(__FUNCTION__, "Extension conflict");
}  /* PDQ_SetVisits */

//-------------------------------------------------------------------------

//void 
function PDQ_SetWorkloadUnit($unitName)
{
    PDQ_SetWUnit($unitName);
}

function PDQ_SetWUnit($unitName) // char* unitName
{
	global $PDQ_wUnit; // extern char[]

	if (strlen($unitName) > MAXSUFF)
		PDQ_ErrMsg(__FUNCTION__, "Name > ".MAXSUFF." characters");

	$PDQ_wUnit = $unitName;
}  /* PDQ_SetWUnit */

//-------------------------------------------------------------------------

// void 
function PDQ_SetTimeUnit($unitName)
{
    PDQ_SetTUnit($unitName);
}

function PDQ_SetTUnit($unitName) // char* unitName
{
	global $PDQ_tUnit; // extern char[]

	if (strlen($unitName) > MAXSUFF)
		PDQ_ErrMsg(__FUNCTION__, "Name > ".MAXSUFF." characters");

	$PDQ_tUnit=$unitName;
}  /* PDQ_SetTUnit */

//----- Internal Functions ------------------------------------------------

// void 
function PDQ_CreateTermStream($circuit, $label, $pop, $think) // void create_term_stream(int circuit, char *label, double pop, double think)
{
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_DEBUG; // extern int
	global $PDQ_c;

    $s1 = "";
    
	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	$PDQ_job[$PDQ_c]->term->name = $label;
	$PDQ_job[$PDQ_c]->should_be_class = TERM;
	$PDQ_job[$PDQ_c]->network = $circuit;
	$PDQ_job[$PDQ_c]->term->think = $think;
	$PDQ_job[$PDQ_c]->term->pop = $pop;

	if ($PDQ_DEBUG) {
		PDQ_TypeToStr($s1, $PDQ_job[$PDQ_c]->should_be_class);
        PDQ_Debug(__FUNCTION__,"\tStream[".$PDQ_c."]: ".$s1." \"".$PDQ_job[$PDQ_c]->term->name."\"; N: ".$PDQ_job[$PDQ_c]->term->pop.", Z: ".$PDQ_job[$PDQ_c]->term->think);
        PDQ_Debug(__FUNCTION__, "Exiting");
	};
}  /* PDQ_CreateTermStream */

//-------------------------------------------------------------------------

// void 
function PDQ_CreateBatchStream($net, $label, $number) // void create_batch_stream(int net, char* label, double number)
{
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_DEBUG; // extern int
	global $PDQ_c;

	$s1 = "";

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	/***** using global value of c *****/

	$PDQ_job[$PDQ_c]->batch->name = $label;

	$PDQ_job[$PDQ_c]->should_be_class = BATCH;
	$PDQ_job[$PDQ_c]->network = $net;
	$PDQ_job[$PDQ_c]->batch->pop = $number;

	if ($PDQ_DEBUG) {
		PDQ_TypeToStr($s1, $PDQ_job[$PDQ_c]->should_be_class);
		PDQ_Debug(__FUNCTION__, "\tStream[".$PDQ_c."]: ".$s1." \"".$PDQ_job[$PDQ_c]->batch->name."\"; N: ".$PDQ_job[$PDQ_c]->batch->pop);
	    PDQ_Debug(__FUNCTION__, "Exiting");
    };
}  /* PDQ_CreateBatchStream */

//-------------------------------------------------------------------------

//void 
function PDQ_CreateTransaction($net, $label, $lambda) // void create_transaction(int net, char* label, double lambda)
{
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_DEBUG; // extern int
	global $PDQ_c;

	$s1 = "";
    if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");
    
	$PDQ_job[$PDQ_c]->trans->name = $label;

	$PDQ_job[$PDQ_c]->should_be_class = TRANS;
	$PDQ_job[$PDQ_c]->network = $net;
	$PDQ_job[$PDQ_c]->trans->arrival_rate = $lambda;

	if ($PDQ_DEBUG) {
		PDQ_TypeToStr($s1, $PDQ_job[$PDQ_c]->should_be_class);
		PDQ_Debug(__FUNCTION__, "\tStream[".$PDQ_c."]:  ".$s1."\t\"".$PDQ_job[$PDQ_c]->trans->name."\";\tLambda: ".$PDQ_job[$PDQ_c]->trans->arrival_rate);
		PDQ_Debug(__FUNCTION__, "Exiting");
	};
}  /* PDQ_CreateTransaction */

//-------------------------------------------------------------------------

/*
 * MVA_Approx.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Last revised by NJG: 14:14:59  7/16/95
 * 
 *  $Id$
 */

//void 
function PDQ_Approx() // void
{
	global $PDQ_DEBUG, $PDQ_iterations, $PDQ_streams, $PDQ_nodes; // extern int
	global $PDQ_tolerance; // extern double
	global $PDQ_job; // extern JOB_TYPE  *
	global $PDQ_node; // extern NODE_TYPE *

	$s1 = "";
    $s2 = "";
	$k = 0; // int
    $c = 0; // int
	$should_be_class = 0; // int
	$sumR = array(); // double[MAXSTREAMS];
	$delta = 2 * TOL; // double
	$iterate = 0; // int
	$jobname = ""; // char[MAXBUF];
	$last = NULL; // NODE_TYPE *
	$N = 0.0; // double;

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	if (($PDQ_nodes == 0) || ($PDQ_streams == 0)) PDQ_ErrMsg(__FUNCTION__, "Network nodes and streams not defined.");

	//if ((last = (NODE_TYPE *) calloc(sizeof(NODE_TYPE), nodes)) == NULL)
	//	PDQ_ErrMsg(p, "Node (last) allocation failed!\n");
	$last = array();
	for ($c = 0; $c < $PDQ_nodes; $c++)
	{
	   $last[$c] = new NODE_TYPE();
	};

	$PDQ_iterations = 0;

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "\nIteration: ".$PDQ_iterations);

	/* initialize all queues */
	for ($c = 0; $c < $PDQ_streams; $c++) {
		$should_be_class = $PDQ_job[$c]->should_be_class;

		for ($k = 0; $k < $PDQ_nodes; $k++) {
			switch ($should_be_class) {
				case TERM:
					$PDQ_node[$k]->qsize[$c] = $PDQ_job[$c]->term->pop / $PDQ_nodes;
					$last[$k]->qsize[$c] = $PDQ_node[$k]->qsize[$c];
					break;
				case BATCH:
					$PDQ_node[$k]->qsize[$c] = $PDQ_job[$c]->batch->pop / $PDQ_nodes;
					$last[$k]->qsize[$c] = $PDQ_node[$k]->qsize[$c];
					break;
				default:
					break;
			};

			if ($PDQ_DEBUG) {
				PDQ_GetJobName($jobname, $c);
				$s2 = sprintf("Que[%s][%s]: %3.4f (D=%f)",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->qsize[$c],$delta);
				PDQ_Debug(__FUNCTION__, $s2);
			};
		};  /* over k */
	};  /* over c */


	do {
		$PDQ_iterations++;

		if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "\nIteration: ".$PDQ_iterations);

		for ($c = 0; $c < $PDQ_streams; $c++) {
			PDQ_GetJobName($jobname, $c);

			$sumR[$c] = 0.0;

			if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "\nStream: ".$jobname);

			$should_be_class = $PDQ_job[$c]->should_be_class;

			for ($k = 0; $k < $PDQ_nodes; $k++) {
				if ($PDQ_DEBUG) {
					$s2 = sprintf("Que[%s][%s]: %3.4f (D=%1.5f)",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->qsize[$c],$delta);
					PDQ_Debug(__FUNCTION__, $s2);
				};

				/* approximate avg queue length */

				switch ($should_be_class) {
					
					case TERM:
						$N = $PDQ_job[$c]->term->pop;
						$PDQ_node[$k]->avqsize[$c] = PDQ_SumQ($k, $c) +	($PDQ_node[$k]->qsize[$c] * ($N - 1.0) / $N);
						break;
					case BATCH:
						$N = $PDQ_job[$c]->batch->pop;
						$PDQ_node[$k]->avqsize[$c] = PDQ_SumQ($k, $c) + ($PDQ_node[$k]->qsize[$c] * ($N - 1.0) / $N);
						break;
					default:
						PDQ_TypeToStr($s1, $should_be_class);
						PDQ_ErrMsg(__FUNCTION__, "Unknown should_be_class: ".$s1);
						break;
					};

					if ($PDQ_DEBUG) {
						$s2 = sprintf("<Q>[%s][%s]: %3.4f (D=%1.5f)",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->avqsize[$c],$delta);
					    PDQ_Debug(__FUNCTION__, $s2);
			        };

			/* residence times */

			switch ($PDQ_node[$k]->sched) {
				case FCFS:
				case PSHR:
				case LCFS:
					$PDQ_node[$k]->resit[$c] = $PDQ_node[$k]->demand[$c] * ($PDQ_node[$k]->avqsize[$c] + 1.0);
					break;
				case ISRV:
					$PDQ_node[$k]->resit[$c] = $PDQ_node[$k]->demand[$c];
					break;
				default:
					PDQ_TypeToStr($s1, $PDQ_node[$k]->sched);
					PDQ_ErrMsg(__FUNCTION__, "Unknown queue type: ",$s1);
					break;
			};

			$sumR[$c] += $PDQ_node[$k]->resit[$c];


			if ($PDQ_DEBUG) {
				printf("\tTot ResTime[%s] = %3.4f\n", $jobname, $sumR[$c]);
				printf("\tnode[%s].qsize[%s] = %3.4f\n",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->qsize[$c]);
				printf("\tnode[%s].demand[%s] = %3.4f\n",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->demand[$c]);
				printf("\tnode[%s].resit[%s] = %3.4f\n",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->resit[$c]);
			};
		};			/* over k */


		/* system throughput, residency & response-time */

		switch ($should_be_class) {
			case TERM:
				$PDQ_job[$c]->term->sys->thruput = ($PDQ_job[$c]->term->pop / ($sumR[$c] + $PDQ_job[$c]->term->think));
				$PDQ_job[$c]->term->sys->response = ($PDQ_job[$c]->term->pop / $PDQ_job[$c]->term->sys->thruput) - $PDQ_job[$c]->term->think;
				$PDQ_job[$c]->term->sys->residency = $PDQ_job[$c]->term->pop - ($PDQ_job[$c]->term->sys->thruput * $PDQ_job[$c]->term->think);

				if ($PDQ_DEBUG) {
					$s2 = sprintf("\tTERM<X>[%s]: %5.4f",$jobname, $PDQ_job[$c]->term->sys->thruput);
					PDQ_Debug(__FUNCTION__, $s2);
					$s2 = sprintf("\tTERM<R>[%s]: %5.4f",$jobname, $PDQ_job[$c]->term->sys->response);
					PDQ_Debug(__FUNCTION__, $s2);
				};
				break;

			case BATCH:
				$PDQ_job[$c]->batch->sys->thruput = $PDQ_job[$c]->batch->pop / $sumR[$c];
				$PDQ_job[$c]->batch->sys->response = ($PDQ_job[$c]->batch->pop / $PDQ_job[$c]->batch->sys->thruput);
				$PDQ_job[$c]->batch->sys->residency = $PDQ_job[$c]->batch->pop;

				if ($PDQ_DEBUG) {
					$s2 = sprintf("\t<X>[%s]: %3.4f",$jobname, $PDQ_job[$c]->batch->sys->thruput);
					PDQ_Debug(__FUNCTION__, $s2);
					$s2 = sprintf("\t<R>[%s]: %3.4f",$jobname, $PDQ_job[$c]->batch->sys->response);
					PDQ_Debug(__FUNCTION__, $s2);
				};

				break;
			default:
					PDQ_ErrMsg(__FUNCTION__,"Unknown should_be_class: ".$should_be_class);
					break;
			};

			$jobname="";
		};  /* over c */

		/* update queue sizes */

		for ($c = 0; $c < $PDQ_streams; $c++) {
			PDQ_GetJobName($jobname, $c);
			$should_be_class = $PDQ_job[$c]->should_be_class;
			$iterate = FALSE;

			if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "\nUpdating queues of \"".$jobname."\"");

			for ($k = 0; $k < $PDQ_nodes; $k++) {
				switch ($should_be_class) {
					case TERM:
						$PDQ_node[$k]->qsize[$c] = $PDQ_job[$c]->term->sys->thruput * $PDQ_node[$k]->resit[$c];
						break;
					case BATCH:
						$PDQ_node[$k]->qsize[$c] = $PDQ_job[$c]->batch->sys->thruput * $PDQ_node[$k]->resit[$c];
						break;
					default:
						PDQ_ErrMsg(__FUNCTION__, "Unknown should_be_class: ".$should_be_class);
						break;
				};

				/* check convergence */

				$delta = abs((double) ($last[$k]->qsize[$c] - $PDQ_node[$k]->qsize[$c]));

				if ($delta > $PDQ_tolerance)	/* for any node */
					$iterate = TRUE;	/* but complete all queue updates */

				$last[$k]->qsize[$c] = $PDQ_node[$k]->qsize[$c];

				if ($PDQ_DEBUG) {
					$s2 = sprintf("Que[%s][%s]: %3.4f (D=%1.5f)",$PDQ_node[$k]->devname,$jobname,$PDQ_node[$k]->qsize[$c],$delta);
					PDQ_Debug(__FUNCTION__, $s2);
				};
			};			/* over k */

			$jobname="";
		};				/* over c */

		if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Update complete");
	} while ($iterate);

	/* cleanup */

	if ($last) $last=NULL;

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_Approx */

//-------------------------------------------------------------------------

// double 
function PDQ_SumQ($k, $skip) // int k, int skip
{
	global $PDQ_streams; // extern int
	global $PDQ_node; // extern NODE_TYPE *

	$c = 0; // int
	$sum = 0.0; // double

	for ($c = 0; $c < $PDQ_streams; $c++) {
		if ($c == $skip) continue;
		$sum += $PDQ_node[$k]->qsize[$c];
	};

	return ($sum);
}  /* PDQ_SumQ */

//-------------------------------------------------------------------------



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

// void 
function PDQ_Canonical() // void
{
	global $PDQ_DEBUG, $PDQ_streams, $PDQ_nodes; // extern int
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_node; // extern NODE_TYPE *


	$s1 = "";
	$k = 0;; // int
	$c = 0; // int
	$X = 0.0; // double
	$Xsat = 0.0; // double;
	$Dsat = 0.0;
	$sumR = array(); // double [MAXSTREAMS];

	$devU = 0.0; // double
	$jobname = ""; // char [MAXBUF];

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	for ($c = 0; $c < $PDQ_streams; $c++) {
		$sumR[$c] = 0.0;

		$X = $PDQ_job[$c]->trans->arrival_rate;

		/* find saturation device */

		for ($k = 0; $k < $PDQ_nodes; $k++) {
	 		if ($PDQ_node[$k]->demand[$c] > $Dsat) $Dsat = $PDQ_node[$k]->demand[$c];
		};

		if ($Dsat == 0) {
	 		$s1 = sprintf("Dsat = %3.3f", $Dsat);
	 		PDQ_ErrMsg(__FUNCTION__, $s1);
		};

		$Xsat = 1.0 / $Dsat;
		$PDQ_job[$c]->trans->saturation_rate = $Xsat;

		if ($X > $PDQ_job[$c]->trans->saturation_rate) {
	 		$s1 = sprintf("\nArrival rate %3.3f exceeds system saturation %3.3f = 1/%3.3f",$X, $Xsat, $Dsat);
	 		PDQ_ErrMsg(__FUNCTION__, $s1);
		};

		for ($k = 0; $k < $PDQ_nodes; $k++) {
	 		$PDQ_node[$k]->utiliz[$c] = $X * $PDQ_node[$k]->demand[$c];

	 		$devU = PDQ_SumU($k);

	 		if ($devU > 1.0) {
		 		$s1 = sprintf("\nTotal utilization of node %s is %2.2f%% (>100%%)",$PDQ_node[$k]->devname,$devU * 100.0);
		 		PDQ_ErrMsg(__FUNCTION__, $s1);
	 		};

	 		if ($PDQ_DEBUG) printf("Tot Util: %3.4f for %s\n", $devU, $PDQ_node[$k]->devname);

	 		switch ($PDQ_node[$k]->sched) {
	 			case FCFS:
	 			case PSHR:
	 			case LCFS:
		 			$PDQ_node[$k]->resit[$c] = $PDQ_node[$k]->demand[$c] / (1.0 - $devU);
		 			$PDQ_node[$k]->qsize[$c] = $X * $PDQ_node[$k]->resit[$c];
		 			break;
	 			case ISRV:
		 			$PDQ_node[$k]->resit[$c] = $PDQ_node[$k]->demand[$c];
		 			$PDQ_node[$k]->qsize[$c] = $PDQ_node[$k]->utiliz[$c];
		 			break;
	 			default:
		 			PDQ_TypeToStr($s1, $PDQ_node[$k]->sched);
		 			PDQ_ErrMsg(__FUNCTION__, "Unknown queue type: ".$s1);
		 			break;
	 		};
	 		$sumR[$c] += $PDQ_node[$k]->resit[$c];
		};  /* loop over k */

		$PDQ_job[$c]->trans->sys->thruput = $X;
		$PDQ_job[$c]->trans->sys->response = $sumR[$c];
		$PDQ_job[$c]->trans->sys->residency = $X * $sumR[$c];

		if ($PDQ_DEBUG) {
	 		PDQ_GetJobName($jobname, $c);
	 		printf("\tX[%s]: %3.4f\n", $jobname, $PDQ_job[$c]->trans->sys->thruput);
	 		printf("\tR[%s]: %3.4f\n", $jobname, $PDQ_job[$c]->trans->sys->response);
	 		printf("\tN[%s]: %3.4f\n", $jobname, $PDQ_job[$c]->trans->sys->residency);
		};
	};  /* loop over c */

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");

}  /* PDQ_Canonical */

//-------------------------------------------------------------------------

//double 
function PDQ_SumU($k) //int k
{
	global $PDQ_streams; // extern int
	global $PDQ_job; // extern JOB_TYPE  *
	global $PDQ_node; // extern NODE_TYPE *


	$c = 0; // int
	$sum = 0.0; // double

	for ($c = 0; $c < $PDQ_streams; $c++) {
		$sum += ($PDQ_job[$c]->trans->arrival_rate * $PDQ_node[$k]->demand[$c]);
	};

	return ($sum);
} /* PDQ_SumU */


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

//void 
function PDQ_Exact() //void
{
	global $PDQ_streams, $PDQ_nodes; // extern int
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_job; // extern JOB_TYPE  *
	
    $qlen = array(array(array())); // static double[MAXPOP1][MAXPOP2][MAXDEVS]

    $s1 = "";
    $s2 = "";

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

	if ($PDQ_streams > MAXCLASS) {
		printf("Streams = %d", $PDQ_streams);
		$s1 = sprintf("%d workload streams exceeds maximum of 3.\n", $PDQ_streams);
		PDQ_ErrMsg(__FUNCTION__, $s1);
	};

	for ($c = 0; $c < $PDQ_streams; $c++) {
		$pop[$c] = (int) ceil((double) PDQ_GetJobPop($c));

		if (($pop[$c] > MAXPOP1) || ($pop[$c] > MAXPOP2)) {
			$s1 = sprintf("Pop %d > allowed:\n", $pop[$c]);
			$s2 = sprintf("max1: %d\nmax2: %d\n", MAXPOP1, MAXPOP2);
			PDQ_ErrMsg(__FUNCTION__, $s1.$s2);
		};
	};


	/* initialize lowest queue configs on each device */

	for ($k = 0; $k < $PDQ_nodes; $k++) {
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
					for ($k = 0; $k < $PDQ_nodes; $k++) {
						$PDQ_node[$k]->qsize[$c] = $qlen[$N[1]][$N[2]][$k];
						$PDQ_node[$k]->resit[$c] = $PDQ_node[$k]->demand[$c] * (1.0 + $PDQ_node[$k]->qsize[$c]);
						$sumR[$c] += $PDQ_node[$k]->resit[$c];
					};

					$N[$c] += 1;

					switch ($PDQ_job[$c]->should_be_class) {
						case TERM:
							if ($sumR[$c] == 0)	PDQ_ErrMsg(__FUNCTION__, "sumR is zero");
							$PDQ_job[$c]->term->sys->thruput = $N[$c] / ($sumR[$c] + $PDQ_job[$c]->term->think);
							$PDQ_job[$c]->term->sys->response =	($N[$c] / $PDQ_job[$c]->term->sys->thruput) - $PDQ_job[$c]->term->think;
							$PDQ_job[$c]->term->sys->residency = $N[$c] - ($PDQ_job[$c]->term->sys->thruput * $PDQ_job[$c]->term->think);
							break;
						case BATCH:
							if ($sumR[$c] == 0)	PDQ_ErrMsg(__FUNCTION__, "sumR is zero");
							$PDQ_job[$c]->batch->sys->thruput = $N[$c] / $sumR[$c];
							$PDQ_job[$c]->batch->sys->response = $N[$c] / $PDQ_job[$c]->batch->sys->thruput;
							$PDQ_job[$c]->batch->sys->residency = $N[$c];
							break;
						default:
							break;
					};
				};

				for ($k = 0; $k < $PDQ_nodes; $k++) {
					$qlen[$n1][$n2][$k] = 0.0;
					for ($c = 0; $c < MAXCLASS; $c++) {
						if ($N[$c] == 0) continue;

						switch ($PDQ_job[$c]->should_be_class) {
							case TERM:
								$qlen[$n1][$n2][$k] += ($PDQ_job[$c]->term->sys->thruput * $PDQ_node[$k]->resit[$c]);
								$PDQ_node[$k]->qsize[$c] = $qlen[$n1][$n2][$k];
								break;
							case BATCH:
								$qlen[$n1][$n2][$k] += ($PDQ_job[$c]->batch->sys->thruput * $PDQ_node[$k]->resit[$c]);
								$PDQ_node[$k]->qsize[$c] = $qlen[$n1][$n2][$k];
								break;
							default:
								break;
						};
					};
				};
			};  /* over n2 */
		};  /* over n1 */
	};  /* over n0 */
}  /* PDQ_Exact */

//-------------------------------------------------------------------------



/*
 * MVA_Solve.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Revised by NJG: 20:05:52  7/28/95
 * 
 *  $Id$
 */

//void 
function PDQ_Solve($meth) // int meth
{
	global $PDQ_DEBUG, $PDQ_method, $PDQ_streams, $PDQ_nodes; // extern int
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_sumD; // extern double

	$s1 = "";
    $s2 = "";
    $s3 = "";
    
	$k = 0;  // int
    $c = 0; // int
	$should_be_class = 0; // int
	$demand = 0.0; // double
	$maxD = 0.0; // double

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	/* There'd better be a job[0] or you're in trouble !!!  */

	$PDQ_method = $meth;

	switch ($PDQ_method) {
		case EXACT:
			if ($PDQ_job[0]->network != CLOSED) {	/* bail ! */
				PDQ_TypeToStr($s2, $PDQ_job[0]->network);
				PDQ_TypeToStr($s3, $PDQ_method);
				$s1 = sprintf("Network should_be_class \"%s\" is incompatible with \"%s\" method",$s2,$s3);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			switch ($PDQ_job[0]->should_be_class) {
				case TERM:
				case BATCH:
					PDQ_Exact();
					break;
				default:
					break;
			};
			break;

		case APPROX:
			if ($PDQ_job[0]->network != CLOSED) {	/* bail ! */
				PDQ_TypeToStr($s2, $PDQ_job[0]->network);
				PDQ_TypeToStr($s3, $PDQ_method);
				$s1 = sprintf("Network should_be_class \"%s\" is incompatible with \"%s\" method",$s2,$s3);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			switch ($PDQ_job[0]->should_be_class) {
				case TERM:
				case BATCH:
					PDQ_Approx();
					break;
				default:
					break;
			};
			break;

		case CANON:
			if ($PDQ_job[0]->network != OPEN) {	/* bail out ! */
				PDQ_TypeToStr($s2, $PDQ_job[0]->network);
				PDQ_TypeToStr($s3, $PDQ_method);
				$s1 = sprintf("Network should_be_class \"%s\" is incompatible with \"%s\" method",$s2,$s3);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			PDQ_Canonical();
			break;

		default:
			PDQ_TypeToStr($s3, $PDQ_method);
			$s1 = sprintf("Unknown  method \"%s\"", $s3);
			PDQ_ErrMsg(__FUNCTION__, $s1);
			break;
	};

	/* Now compute bounds */

	for ($c = 0; $c < $PDQ_streams; $c++) {
		$PDQ_sumD = 0.0;
        $maxD = 0.0;
		$should_be_class = $PDQ_job[$c]->should_be_class;

		for ($k = 0; $k < $PDQ_nodes; $k++) {
			$demand = $PDQ_node[$k]->demand[$c];

			if (($PDQ_node[$k]->sched == ISRV) && ($PDQ_job[$c]->network == CLOSED))
				$demand /= ($should_be_class == TERM) ? $PDQ_job[$c]->term->pop : $PDQ_job[$c]->batch->pop;

			if ($maxD < $demand) $maxD = $demand;

			$PDQ_sumD += $PDQ_node[$k]->demand[$c];
		};  /* Over k */

		switch ($should_be_class) {
			case TERM:
				$PDQ_job[$c]->term->sys->maxN = ($PDQ_sumD + $PDQ_job[$c]->term->think) / $maxD;
				$PDQ_job[$c]->term->sys->maxTP = 1.0 / $maxD;
				$PDQ_job[$c]->term->sys->minRT = $PDQ_sumD;
				if ($PDQ_sumD == 0) {
					PDQ_GetJobName($s1, $c);
					$s2 = sprintf("Sum of demands is zero for workload \"%s\"", $s1);
					PDQ_ErrMsg(__FUNCTION__, $s2);
				};
				break;
			case BATCH:
				$PDQ_job[$c]->batch->sys->maxN = $PDQ_sumD / $maxD;
				$PDQ_job[$c]->batch->sys->maxTP = 1.0 / $maxD;
				$PDQ_job[$c]->batch->sys->minRT = $PDQ_sumD;
				if ($PDQ_sumD == 0) {
					PDQ_GetJobName($s1, $c);
					$s2 = sprintf("Sum of demands is zero for workload \"%s\"", $s1);
					PDQ_ErrMsg(__FUNCTION__, $s2);
				};
				break;
			case TRANS:
				$PDQ_job[$c]->trans->sys->maxTP = 1.0 / $maxD;
				$PDQ_job[$c]->trans->sys->minRT = $PDQ_sumD;
				if ($PDQ_sumD == 0) {
					PDQ_GetJobName($s1, $c);
					$s2 = sprintf("Sum of demands is zero for workload \"%s\"", $s1);
					PDQ_ErrMsg(__FUNCTION__, $s2);
				};
				break;
			default:
				break;
		};
	};  /* Over c */

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_Solve */



/*
 * PDQ_Report.c
 * 
 * Copyright (c) 1995-2005 Performance Dynamics Company
 * 
 * Last revised by NJG on Fri Aug  2 10:29:48  2002
 * Last revised by NJG on Thu Oct  7 20:02:27 PDT 2004
 * 
 *  $Id$
 */


//-------------------------------------------------------------------------

//void 
function PDQ_ReportNull() // void
{
	printf("This is an empty report of PDQ\n");
}	/* PDQ_ReportNull */

//-------------------------------------------------------------------------

//void 
function PDQ_Report() // void
{
	global $PDQ_model, $PDQ_version; // extern char[];
	global $PDQ_streams, $PDQ_nodes, $PDQ_DEBUG; // extern int
	global $PDQ_job; // extern JOB_TYPE *
    global $PDQ_syshdr, $PDQ_jobhdr, $PDQ_nodhdr, $PDQ_devhdr;
    
    $PDQ_fname = PDQ_COMMENTS_FILE; // char[MAXBUF]
    
	$c = 0; // int
	$prevclass = 0; // int
	$clock = ""; // time_t
	$comment = ""; // char[BUFSIZ];
	$pc = ""; // char *
	$tstamp = ""; // char *
	$fillbase = 24; // int
	$fill = 0; // int
	$pad = "                       "; // char *
	$fp = NULL; // FILE *
	$allusers = 0.0; // double 

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	$s1="";
	$s2="";
	$s3="";
	
	$PDQ_syshdr = FALSE;
	$PDQ_jobhdr = FALSE;
	$PDQ_nodhdr = FALSE;
	$PDQ_devhdr = FALSE;

    $clock = time();
	if ($clock == -1) PDQ_ErrMsg(__FUNCTION__, "Failed to get date");

	$tstamp = strftime("%a %b %d %H:%M:%S %Y",$clock); //(char *) ctime(&clock);	/* 24 chars + \n\0  */
	$s1 = $tstamp;

	$fill = $fillbase - strlen($PDQ_model);
	$s2 = $PDQ_model;
    for ($c=0; $c<$fill; $c++) $s2 .= " ";

	$fill = $fillbase - strlen($PDQ_version);
	$s3 = $PDQ_version;
    for ($c=0; $c<$fill; $c++) $s3 .= " ";

	printf("\n\n");
	PDQ_BannerStars();
	PDQ_BannerChars(" Pretty Damn Quick REPORT");
	PDQ_BannerStars();
	printf("\t\t***  of : %s  ***\n", $s1);
	printf("\t\t***  for: %s  ***\n", $s2);
	printf("\t\t***  Ver: %s  ***\n", $s3);
	PDQ_BannerStars();
	PDQ_BannerStars();
	printf("\n");

	$s1="";
	$s2="";
	$s3="";

	/****   append comments file ****/
    
	if (file_exists($PDQ_fname)) {
        $fp = fopen($PDQ_fname, "r");
    	if ($fp != NULL) {
            printf("\n\n");
    		PDQ_BannerStars();
    		PDQ_BannerChars("        Comments");
    		PDQ_BannerStars();
    		printf("\n\n");
    		$comment = fgets($fp, MAXBUF);
    		while ($comment != FALSE) {
    			printf("%s", $comment);
    			$comment = fgets($fp, MAXBUF);
    		};
    		fclose($fp);
    	};
    };/* else {
    		printf("\n\n");
	        PDQ_BannerStars();
      		PDQ_BannerChars("        Comments");
   			PDQ_BannerStars();
    		printf("\nNo comments.pdq file found in the default directory!\n");
    };*/
    
	/* Show INPUT Parameters */

	printf("\n\n");
	PDQ_BannerStars();
	PDQ_BannerChars("    PDQ Model INPUTS");
	PDQ_BannerStars();
	printf("\n\n");
	PDQ_PrintNodes();

	/* OUTPUT Statistics */

	for ($c = 0; $c < $PDQ_streams; $c++) {
		switch ($PDQ_job[$c]->should_be_class) {
			case TERM:
				$allusers += $PDQ_job[$c]->term->pop;
				break;
			case BATCH:
				$allusers += $PDQ_job[$c]->batch->pop;
				break;
			case TRANS:
				$allusers = 0.0;
				break;
			default:
				$s2 = sprintf("Unknown job should_be_class: %d", $PDQ_job[$c]->should_be_class);
				PDQ_ErrMsg(__FUNCTION__, $s2);
				break;
		};
	};  /* loop over c */

	printf("\nQueueing Circuit Totals:\n\n");
    $poptotal = 0.0;
	for ($c = 0; $c < $PDQ_streams; $c++) {
		switch ($PDQ_job[$c]->should_be_class) {
			case TERM:
				printf("\tClients:    %3.2f\tfor %dth TERM job class\n", $PDQ_job[$c]->term->pop,$c+1);
				$poptotal += $PDQ_job[$c]->term->pop;
				break;
			case BATCH:
				printf("\tJobs:       %3.2f\tfor %dth BATCH job class\n", $PDQ_job[$c]->batch->pop,$c+1);
				$poptotal += $PDQ_job[$c]->batch->pop;
				break;
			default:
				break;
		};
	};

	printf("\t-----------------\n");
	printf("\tGenerators: %3.2f\tTotal System Clients\n\n", $poptotal);
	printf("\tStreams:    %3d\n", $PDQ_streams);
	printf("\tNodes:      %3d\n", $PDQ_nodes);
	printf("\n");

	printf("\n\nWORKLOAD Parameters\n\n");

	for ($c = 0; $c < $PDQ_streams; $c++) {
		switch ($PDQ_job[$c]->should_be_class) {
			case TERM:
				PDQ_PrintJob($c, TERM);
				break;
			case BATCH:
				PDQ_PrintJob($c, BATCH);
				break;
			case TRANS:
				PDQ_PrintJob($c, TRANS);
				break;
			default:
				PDQ_TypeToStr($s1, $PDQ_job[$c]->should_be_class);
				$s2 = sprintf("Unknown job should_be_class: %s", $s1);
				PDQ_ErrMsg(__FUNCTION__, $s2);
				break;
		};
	};  /* loop over $c */

	printf("\n");

	for ($c = 0; $c < $PDQ_streams; $c++) {
		switch ($PDQ_job[$c]->should_be_class) {
			case TERM:
				PDQ_PrintSystemStats($c, TERM);
				break;
			case BATCH:
				PDQ_PrintSystemStats($c, BATCH);
				break;
			case TRANS:
				PDQ_PrintSystemStats($c, TRANS);
				break;
			default:
				PDQ_TypeToStr($s1, $PDQ_job[$c]->should_be_class);
				$s2 = sprintf("Unknown job should_be_class: %s", $s1);
				PDQ_ErrMsg(__FUNCTION__, $s2);
				break;
		};
	};  /* loop over $c */

	printf("\n");

	for ($c = 0; $c < $PDQ_streams; $c++) {
		switch ($PDQ_job[$c]->should_be_class) {
			case TERM:
				PDQ_PrintNodeStats($c, TERM);
				break;
			case BATCH:
				PDQ_PrintNodeStats($c, BATCH);
				break;
			case TRANS:
				PDQ_PrintNodeStats($c, TRANS);
				break;
			default:
				PDQ_TypeToStr($s1, $PDQ_job[$c]->should_be_class);
				$s2 = sprintf("Unknown job should_be_class: %s", $s1);
				PDQ_ErrMsg(__FUNCTION__, $s2);
				break;
		};
	};  /* over $c */

	printf("\n");

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_Report */

//----- Internal print layout routines ------------------------------------

//void 
function PDQ_PrintNodeHead() // void
{
	global $PDQ_demand_ext, $PDQ_DEBUG; // extern int
	global $PDQ_model; // extern char
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_nodhdr;

	$s1 = "";
	
	$dmdfmt = "%-4s %-5s %-10s %-10s %-5s %10s\n"; // char *
	$visfmt = "%-4s %-5s %-10s %-10s %-5s %10s %10s %10s\n"; // char *

	if ($PDQ_DEBUG) {
		PDQ_TypeToStr($s1, $PDQ_job[0]->network);
		printf("%s Network: \"%s\"\n", $s1, $PDQ_model);
	};
	switch ($PDQ_demand_ext) {
	case DEMAND:
		printf($dmdfmt,"Node", "Sched", "Resource", "Workload", "Class", "Demand");
		printf($dmdfmt,"----", "-----", "--------", "--------", "-----", "------");
		break;
	case VISITS:
		printf($visfmt,"Node", "Sched", "Resource", "Workload", "Class", "Visits", "Service", "Demand");
		printf($visfmt,"----", "-----", "--------", "--------", "-----", "------", "-------", "------");
		break;
	default:
		PDQ_ErrMsg(__FUNCTION__, "Unknown file type");
		break;
	};

	$PDQ_nodhdr = TRUE;
}  /* PDQ_PrintNodeHead */

//-------------------------------------------------------------------------

//void 
function PDQ_PrintNodes() // void
{
	global $PDQ_demand_ext, $PDQ_DEBUG, $PDQ_streams, $PDQ_nodes; // extern int
	global $PDQ_node; // extern NODE_TYPE *
	global $PDQ_job; // extern JOB_TYPE  *
	global $PDQ_nodhdr;

	$s1="";
	$s2="";
	$s3="";
	$s4="";
	$c = 0; // int               
    $k = 0; // int               

	if ($PDQ_DEBUG)	PDQ_Debug(__FUNCTION__, "Entering");

	if (!$PDQ_nodhdr) PDQ_PrintNodeHead();

	for ($c = 0; $c < $PDQ_streams; $c++) {
		for ($k = 0; $k < $PDQ_nodes; $k++) {
			$s1 = "";
			$s2 = "";
			$s3 = "";
			$s4 = "";

			PDQ_TypeToStr($s1, $PDQ_node[$k]->devtype);
			PDQ_TypeToStr($s3, $PDQ_node[$k]->sched);
			PDQ_GetJobName($s2, $c);

			switch ($PDQ_job[$c]->should_be_class) {
				case TERM:
					$s4 = "TERML";
					break;
				case BATCH:
					$s4 = "BATCH";
					break;
				case TRANS:
					$s4 = "TRANS";
					break;
				default:
					break;
			};

			switch ($PDQ_demand_ext) {
				case DEMAND:
					printf("%-4s %-5s %-10s %-10s %-5s %10.4f\n",$s1,$s3,$PDQ_node[$k]->devname,$s2,$s4,$PDQ_node[$k]->demand[$c]);
					break;
				case VISITS:
					printf("%-4s %-4s %-10s %-10s %-5s %10.4f %10.4f %10.4f\n",$s1,$s3,$PDQ_node[$k]->devname,$s2,$s4,$PDQ_node[$k]->visits[$c],$PDQ_node[$k]->service[$c],$PDQ_node[$k]->demand[$c]);
					break;
				default:
					PDQ_ErrMsg(__FUNCTION__, "Unknown demand_ext type");
					break;
			};  /* switch */
		};  /* over k */

		printf("\n");
	};  /* over $c */

	printf("\n");

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");

	$PDQ_nodhdr = FALSE;
}  /* PDQ_PrintNodes */

//-------------------------------------------------------------------------

//void 
function PDQ_PrintJob($c, $should_be_class) // int c, int should_be_class
{
	global $PDQ_DEBUG; // extern int
	global $PDQ_job; // extern JOB_TYPE *

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	switch ($should_be_class) {
		case TERM:
			PDQ_PrintJobHead(TERM);
			printf("%-10s   %6.2f    %10.4f   %6.2f\n",$PDQ_job[$c]->term->name,$PDQ_job[$c]->term->pop,$PDQ_job[$c]->term->sys->minRT,$PDQ_job[$c]->term->think);
			break;
		case BATCH:
			PDQ_PrintJobHead(BATCH);
			printf("%-10s   %6.2f    %10.4f\n",$PDQ_job[$c]->batch->name,$PDQ_job[$c]->batch->pop,$PDQ_job[$c]->batch->sys->minRT);
			break;
		case TRANS:
			PDQ_PrintJobHead(TRANS);
			printf("%-10s   %4.4f    %10.4f\n",$PDQ_job[$c]->trans->name,$PDQ_job[$c]->trans->arrival_rate,$PDQ_job[$c]->trans->sys->minRT);
			break;
		default:
			break;
	};

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_PrintJob */

//-------------------------------------------------------------------------

//void 
function PDQ_PrintSysHead() // void
{
	global $PDQ_tolerance; // extern double
	global $PDQ_DEBUG, $PDQ_method, $PDQ_iterations; // extern int
	global $PDQ_syshdr;

	$s1="";
	

	if ($PDQ_DEBUG)	PDQ_Debug(__FUNCTION__, "Entering");

	printf("\n\n\n\n");
	PDQ_BannerStars();
	PDQ_BannerChars("   PDQ Model OUTPUTS");
	PDQ_BannerStars();
	printf("\n\n");
	PDQ_TypeToStr($s1, $PDQ_method);
	printf("Solution Method: %s", $s1);

	if ($PDQ_method == APPROX)
		printf("\t(Iterations: %d; Accuracy: %3.4lf%%)",$PDQ_iterations,($PDQ_tolerance * 100.0));

	printf("\n\n");
	PDQ_BannerChars("   SYSTEM Performance");
	printf("\n\n");

	printf("%-20s\t%10s\t%-10s\n", "Metric", "Value", "Unit");
	printf("%-20s\t%10s\t%-10s\n", "-----------------", "-----", "----");

	$PDQ_syshdr = TRUE;

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_PrintSysHead */

//-------------------------------------------------------------------------

//void 
function PDQ_PrintJobHead($should_be_class) // int should_be_class
{
    global $PDQ_trmhdr, $PDQ_bathdr, $PDQ_trxhdr;
    
	switch ($should_be_class) {
		case TERM:
			if (!$PDQ_trmhdr) {
				printf("\n");
				printf("%-10s   %-6s   %10s   %-10s\n","Client", "Number", "Demand", "Thinktime");
				printf("%-10s   %-6s   %10s   %-10s\n","----", "------", "------", "---------");
				$PDQ_trmhdr = TRUE;
				$PDQ_trxhdr = FALSE;
				$PDQ_bathdr = FALSE;
			};
			break;
		case BATCH:
			if (!$PDQ_bathdr) {
				printf("\n");
				printf("%-10s   %6s   %10s\n","Job", "MPL", "Demand");
				printf("%-10s   %6s   %10s\n","---", "---", " ------");
				$PDQ_bathdr = TRUE;
				$PDQ_trxhdr = FALSE;
				$PDQ_trmhdr = FALSE;
			};
			break;
		case TRANS:
			if (!$PDQ_trxhdr) {
				printf("%-10s   %-6s   %10s\n","Source", "per Sec", "Demand");
				printf("%-10s   %-6s   %10s\n","--------", "-------", " ------");
				$PDQ_trxhdr = TRUE;
				$PDQ_bathdr = FALSE;
				$PDQ_trmhdr = FALSE;
			};
			break;
		default:
			break;
	};
}  /* PDQ_PrintJobHead */

//-------------------------------------------------------------------------

//void 
function PDQ_PrintDevHead() // void
{
	global $PDQ_devhdr;
     
    PDQ_BannerChars("   RESOURCE Performance");
	printf("\n\n");
	printf("%-14s  %-10s   %-10s      %7s   %-7s\n","Metric", "Resource", "Work", "Value", "Unit");
	printf("%-14s  %-10s   %-10s      %7s   %-7s\n","---------", "------", "----", "-----", "----");

	$PDQ_devhdr = TRUE;
}  /* PDQ_PrintDevHead */

//-------------------------------------------------------------------------

//void 
function PDQ_PrintSystemStats($c,$should_be_class) // int c, int should_be_class
{
	global $PDQ_tUnit; // extern char
	global $PDQ_wUnit; // extern char
	global $PDQ_DEBUG; // extern int
	global $PDQ_job; // extern JOB_TYPE *
	global $PDQ_syshdr;

    $s1 = "";
	
	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	if (!$PDQ_syshdr) PDQ_PrintSysHead();

	switch ($should_be_class) {
		case TERM:
			if ($PDQ_job[$c]->term->sys->thruput == 0) {
				$s1 = sprintf("X = %10.4f for stream = %d",$PDQ_job[$c]->term->sys->thruput, $c);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			printf("Workload: \"%s\"\n", $PDQ_job[$c]->term->name);
			printf("Mean Throughput  \t%10.4f   \t%s/%s\n",$PDQ_job[$c]->term->sys->thruput, $PDQ_wUnit, $PDQ_tUnit);
			printf("Response Time    \t%10.4f   \t%s\n",$PDQ_job[$c]->term->sys->response, $PDQ_tUnit);
			printf("Mean Concurrency \t%10.4f   \t%s\n",$PDQ_job[$c]->term->sys->residency, $PDQ_wUnit);
			printf("Stretch Factor  \t%10.4f\n",$PDQ_job[$c]->term->sys->response / $PDQ_job[$c]->term->sys->minRT);
			break;
		case BATCH:
			if ($PDQ_job[$c]->batch->sys->thruput == 0) {
				$s1 = sprintf($s1, "X = %10.4f at N = %d",$PDQ_job[$c]->batch->sys->thruput, $c);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			printf("Workload: \"%s\"\n", $PDQ_job[$c]->batch->name);
			printf("Mean Throughput  \t%10.4f\t%s/%s\n",$PDQ_job[$c]->batch->sys->thruput, $PDQ_wUnit, $PDQ_tUnit);
			printf("Response Time    \t%10.4f   \t%s\n",$PDQ_job[$c]->batch->sys->response, $PDQ_tUnit);
			printf("Mean Concurrency \t%10.4f   \t%s\n",$PDQ_job[$c]->batch->sys->residency, $PDQ_wUnit);
			printf("Stretch Factor  \t%10.4f\n",$PDQ_job[$c]->batch->sys->response / $PDQ_job[$c]->batch->sys->minRT);
			break;
		case TRANS:
			if ($PDQ_job[$c]->trans->sys->thruput == 0) {
				$s1 = sprintf("X = %10.4f for N = %d", $PDQ_job[$c]->trans->sys->thruput, $c);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			printf("Workload: \"%s\"\n", $PDQ_job[$c]->trans->name);
			printf("Mean Throughput  \t%10.4f\t%s/%s\n",$PDQ_job[$c]->trans->sys->thruput, $PDQ_wUnit, $PDQ_tUnit);
			printf("Response Time    \t%10.4f\t%s\n",$PDQ_job[$c]->trans->sys->response, $PDQ_tUnit);
			break;
		default:
			break;
	};

	printf("\nBounds Analysis:\n");

	switch ($should_be_class) {
		case TERM:
			if ($PDQ_job[$c]->term->sys->thruput == 0) {
				$s1 = sprintf("X = %10.4f at N = %d", $PDQ_job[$c]->term->sys->thruput, $c);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			printf("Max Throughput  \t%10.4f   \t%s/%s\n",$PDQ_job[$c]->term->sys->maxTP, $PDQ_wUnit, $PDQ_tUnit);
			printf("Min Response    \t%10.4f   \t%s\n",$PDQ_job[$c]->term->sys->minRT, $PDQ_tUnit);
			printf("Max Demand      \t%10.4f   \t%s\n",1 / $PDQ_job[$c]->term->sys->maxTP,  $PDQ_tUnit);
			printf("Tot Demand      \t%10.4f   \t%s\n",$PDQ_job[$c]->term->sys->minRT, $PDQ_tUnit);
			printf("Think time      \t%10.4f   \t%s\n",$PDQ_job[$c]->term->think, $PDQ_tUnit);
			printf("Optimal Clients \t%10.4f   \t%s\n",($PDQ_job[$c]->term->think + $PDQ_job[$c]->term->sys->minRT) * $PDQ_job[$c]->term->sys->maxTP, "Clients");
			break;
		case BATCH:
			if ($PDQ_job[$c]->batch->sys->thruput == 0) {
				$s1 = sprintf("X = %10.4f at N = %d",$PDQ_job[$c]->batch->sys->thruput, $c);
				PDQ_ErrMsg(__FUNCTION__, $s1);
			};
			printf("Max Throughput  \t%10.4f   \t%s/%s\n",$PDQ_job[$c]->batch->sys->maxTP, $PDQ_wUnit, $PDQ_tUnit);
			printf("Min Response    \t%10.4f   \t%s\n",$PDQ_job[$c]->batch->sys->minRT, $PDQ_tUnit);	
			printf("Max Demand      \t%10.4f   \t%s\n",1 / $PDQ_job[$c]->batch->sys->maxTP,  $PDQ_tUnit);
			printf("Tot Demand      \t%10.4f   \t%s\n",$PDQ_job[$c]->batch->sys->minRT, $PDQ_tUnit);
			printf("Optimal Jobs \t%10.4f   \t%s\n",$PDQ_job[$c]->batch->sys->minRT * $PDQ_job[$c]->batch->sys->maxTP, "Jobs");
			break;
		case TRANS:
			printf("Max Demand      \t%10.4f   \t%s/%s\n",$PDQ_job[$c]->trans->sys->maxTP, $PDQ_wUnit, $PDQ_tUnit);
			printf("Max Throughput  \t%10.4f   \t%s/%s\n",$PDQ_job[$c]->trans->sys->maxTP, $PDQ_wUnit, $PDQ_tUnit);
			break;
		default:
			break;
	};

	printf("\n");

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_PrintSystemStats */

//-------------------------------------------------------------------------

// void 
function PDQ_PrintNodeStats($c, $should_be_class) // int c, int should_be_class
{
	global $PDQ_tUnit, $PDQ_wUnit; // extern char[]
	global $PDQ_DEBUG, $PDQ_demand_ext, $PDQ_nodes; // extern int
	global $PDQ_job; // extern JOB_TYPE  *
	global $PDQ_node; // extern NODE_TYPE *
    global $PDQ_devhdr;

	$k = 0; // int
	$X = 0.0; // double
    $devR = 0.0; // double
    $devD = 0.0; // double
    $s1 = "";
    $s4 = "";
    
	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Entering");

	if (!$PDQ_devhdr) PDQ_PrintDevHead();

	PDQ_GetJobName($s1, $c);

	switch ($should_be_class) {
		case TERM:
			$X = $PDQ_job[$c]->term->sys->thruput;
			break;
		case BATCH:
			$X = $PDQ_job[$c]->batch->sys->thruput;
			break;
		case TRANS:
			$X = $PDQ_job[$c]->trans->arrival_rate;
			break;
		default:
			break;
	};

	for ($k = 0; $k < $PDQ_nodes; $k++) {
		if ($PDQ_node[$k]->demand[$c] == 0)
			continue;

		if ($PDQ_demand_ext == VISITS) {
			$s4 = "Visits/".$PDQ_tUnit;
		} else {
			$s4 = $PDQ_wUnit."/".$PDQ_tUnit;
		};

		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Throughput",$PDQ_node[$k]->devname,$s1,($PDQ_demand_ext == VISITS) ? ($PDQ_node[$k]->visits[$c] * $X) : $X,$s4);
		/* calculate other stats */
		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Utilization",$PDQ_node[$k]->devname,$s1,($PDQ_node[$k]->sched == ISRV) ? 100 : ($PDQ_node[$k]->demand[$c] * $X * 100),"Percent");
		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Queue Length",$PDQ_node[$k]->devname,$s1,($PDQ_node[$k]->sched == ISRV) ? 0 : ($PDQ_node[$k]->resit[$c] * $X),$PDQ_wUnit);
		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Residence Time",$PDQ_node[$k]->devname,$s1,($PDQ_node[$k]->sched == ISRV) ? $PDQ_node[$k]->demand[$c] : $PDQ_node[$k]->resit[$c],$PDQ_tUnit);
		if ($PDQ_demand_ext == VISITS) {
			/* don't do this if service-time is unspecified */
            $devD = $PDQ_node[$k]->demand[$c];
            $devR = $PDQ_node[$k]->resit[$c];
			printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Waiting Time",$PDQ_node[$k]->devname,$s1,(($PDQ_node[$k]->sched == ISRV) ? $devD : ($devR - $devD)),$PDQ_tUnit);
		};
		printf("\n");
	};

	if ($PDQ_DEBUG) PDQ_Debug(__FUNCTION__, "Exiting");
}  /* PDQ_PrintNodeStats */

//-------------------------------------------------------------------------

// void 
function PDQ_BannerStars() // void
{
	printf("\t\t***************************************\n");

}  /* PDQ_BannerStars */

//-------------------------------------------------------------------------

// void 
function PDQ_BannerChars($s) // char *s
{

	printf("\t\t******%-26s*******\n", $s);

}  /* PDQ_BannerChars */

//-------------------------------------------------------------------------

?>
