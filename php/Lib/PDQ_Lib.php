<?php
error_reporting(E_ALL);
/*
 * PDQ/PHP5 Analyzer v1.0 (27 Mar 2006)
 * This is a C to PHP5 translation of the PDQ (Pretty Damn Quick) performance analyzer.
 * PHP5 translation By Samuel Zallocco - University of L'Aquila - Italy.
 * e-mail: samuel.zallocco@univaq.it
 *
 * All (C)opyright and Rights reserved to the original author of the C version.
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

$PDQ_Lib_version = "PDQ_Lib v1.0 (27 Mar 2006)";

 
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

define("MEM",2); 								/* Memory ?!?!?!? */
define("CEN",3); 								/* unspecified queueing center */
define("CENTER",3); 						/* unspecified queueing center */
define("SERVICECENTER",3); 			/* unspecified queueing center */
define("SINGLESERVERQUEUE",3); 	/* unspecified queueing center */
define("DLY",4); 								/* unspecified delay center */
define("DELAY",4);	 						/* unspecified delay center */
define("DELAYCENTER",4); 				/* unspecified delay center */
define("MSQ",5); 								/* unspecified multi-server queue */
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

define("TERM",10);				/* Terminal workload */
define("TERMMINAL",10);		/* Terminal workload */
define("INTERACTIVE",10); /* Terminal workload */

define("TRANS",11);				/* Transactional workload */
define("TRANSACTION",11); /* Transactional workload */

define("BATCH",12);       /* Batch workload */

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
 
*/
// This string gets read by GetVersion script amongst others
$version = "PDQ Analyzer v3.0 111904";

$model = ""; // char[MAXCHARS]  /* Model name */
$wUnit = ""; // char[10]        /* Work unit string */
$tUnit = ""; // char[10]        /* Time unit string */

$DEBUG = FALSE; // int
$prevproc = ""; // char[MAXBUF];
$prev_init = FALSE; //int
$demand_ext = 0; //int
$nodes = 0; // int
$streams = 0; //int
$iterations = 0; // int
$method = 0; // int
$memdata = 0; // int
$sumD = 0.0; // double
$tolerance = 0.0; // double

/* temp string buffers  */

$s1 = ""; // char[MAXBUF]
$s2 = ""; // char[MAXBUF]
$s3 = ""; // char[MAXBUF]
$s4 = ""; // char[MAXBUF]
$k = 0; // static int
$c = 0; // static int

$syshdr = 0; // int;
$jobhdr = 0; // int
$nodhdr = 0; // int
$devhdr = 0; // int
$trmhdr = FALSE; // int
$bathdr = FALSE; // int
$trxhdr = FALSE; // int

$node = NULL; // NODE_TYPE
$job = NULL; // JOB_TYPE
$tm = NULL; // TERMINAL_TYPE
$bt = NULL; // BATCH_TYPE
$tx = NULL; // TRANSACTION_TYPE 
$sys = NULL; // SYSTAT_TYPE

$fname = ""; // char[MAXBUF]

$typetable = array(
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

$qlen = array(array(array())); // static double[MAXPOP1][MAXPOP2][MAXDEVS]

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

require_once "PDQ_Utils.php";
require_once "PDQ_Build.php";
require_once "MVA_Approx.php";
require_once "MVA_Canon.php";
require_once "PDQ_Exact.php";
require_once "MVA_Solve.php";
require_once "PDQ_Report.php";

function PDQ_ShowLibsVersion()
{
  global $version, $PDQ_Lib_version, $MVA_Approx_version;
  global $MVA_Canon_version, $MVA_Solve_version, $PDQ_Build_version;
  global $PDQ_Exact_version, $PDQ_Utils_version, $PDQ_Report_version;
     
  $s ="\nThis is the PDQ (Pretty Damn Quick) Performance Analyzer\n";
  $s .= "The  C-language  version is  intended  for use with  the\n"; 
  $s .= "following books by Dr. Neil J. Gunther:\n";
  $s .= "    (1) \"The Practical Performance Analyst\" \n";
  $s .= "        McGraw-Hill Companies 1998. ISBN: 0-079-12946-3\n"; 
  $s .= "        iUniverse Press Inc., 2000. ISBN: 0-595-12674-X\n";
  $s .= "    (2) \"Analyzing Computer System Performance Using Perl::PDQ\"\n"; 
  $s .= "        Springer-Verlag, 2004. ISBN: 3-540-20865-8\n";
  $s .= "Visit the www.perfdynamics.com for additional information\n";
  $s .= "on the book and other resources.\n\n";
  $s .= "The PHP5 version is based upon the \"".$version."\" C-language version\n";
  $s .= "\nLibrary and Module version:\n";
  $s .= "  ".$PDQ_Lib_version."\n";
  $s .= "  ".$MVA_Approx_version."\n";
  $s .= "  ".$MVA_Canon_version."\n";
  $s .= "  ".$MVA_Solve_version."\n"; 
  $s .= "  ".$PDQ_Build_version."\n"; 
  $s .= "  ".$PDQ_Exact_version."\n"; 
  $s .= "  ".$PDQ_Utils_version."\n"; 
  $s .= "  ".$PDQ_Report_version."\n";
  $s .= "\nAll (C)opyright and Rights reserved to the original author of the C-language version:\n";
  $s .= "Copyright for the C-language version (c) 1995-2004 Performance Dynamics Company\n";
  $s .= "PHP5 Translation by Samuel Zallocco - University of L'Aquila- Italy\n\n";  
  return $s;
};


// --------------------------------------------------
// Examples 
// --------------------------------------------------
 
// Uncomment the following example and run PDQ_Lib.php to test the library:

//PDQ_SetDebug(FALSE);
/*
PDQ_Init("Samuel Test");
PDQ_SetWUnit("job");
PDQ_SetTUnit("sec");
$nodes = PDQ_CreateNode("CPU", CEN, FCFS);
$nodes = PDQ_CreateNode("DISK", CEN, FCFS);
$streams = PDQ_CreateOpen("SomeJob", 0.5);
PDQ_SetVisits("CPU", "SomeJob", 1.0, 0.054);
PDQ_SetVisits("DISK", "SomeJob", 1.0, 0.05);
PDQ_Solve(CANON);
PDQ_Report();
*/

//echo PDQ_ShowLibsVersion();
?>
