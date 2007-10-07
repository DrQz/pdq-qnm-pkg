<?php
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

$PDQ_Report_version = "PDQ_Report v1.0 (27 Mar 2006)";

//-------------------------------------------------------------------------

//void 
function PDQ_Report_null() // void
{
	printf("This is an empty report of PDQ\n");
}	/* PDQ_Report_null */

//-------------------------------------------------------------------------

//void 
function PDQ_Report() // void
{
	global $model, $version; // extern char[];
	global $fname, $s1, $s2, $s3, $s4; // extern char[];
	global $streams, $nodes, $DEBUG; // extern int
	global $job; // extern JOB_TYPE *
    global $syshdr, $jobhdr, $nodhdr, $devhdr;
    
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
	$p = "PDQ_Report()"; // char *

	if ($DEBUG == 1)
	{
		/*debug(p, "Entering");*/
		printf("Entering PDQ_Report()\n");
	};

	$s1="";
	$s2="";
	$s3="";
	$s4="";

	$syshdr = FALSE;
	$jobhdr = FALSE;
	$nodhdr = FALSE;
	$devhdr = FALSE;

    $clock = time();
	if ($clock == -1) errmsg($p, "Failed to get date");

	$tstamp = strftime("%a %b %d %H:%M:%S %Y",$clock); //(char *) ctime(&clock);	/* 24 chars + \n\0  */
	$s1 = $tstamp;

	$fill = $fillbase - strlen($model);
	$s2 = $model;
    for ($c=0; $c<$fill; $c++) $s2 .= " ";

	$fill = $fillbase - strlen($version);
	$s3 = $version;
    for ($c=0; $c<$fill; $c++) $s3 .= " ";

	printf("\n\n");
	banner_stars();
	banner_chars(" Pretty Damn Quick REPORT");
	banner_stars();
	printf("\t\t***  of : %s  ***\n", $s1);
	printf("\t\t***  for: %s  ***\n", $s2);
	printf("\t\t***  Ver: %s  ***\n", $s3);
	banner_stars();
	banner_stars();
	printf("\n");

	$s1="";
	$s2="";
	$s3="";

	/****   append comments file ****/
    
	$fname="comments.pdq";
	if (file_exists($fname)) {
        $fp = fopen($fname, "r");
    	if ($fp != NULL) {
            printf("\n\n");
    		banner_stars();
    		banner_chars("        Comments");
    		banner_stars();
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
	        banner_stars();
      		banner_chars("        Comments");
   			banner_stars();
    		printf("\nNo comments.pdq file found in the default directory!\n");
    };*/
    
	/* Show INPUT Parameters */

	printf("\n\n");
	banner_stars();
	banner_chars("    PDQ Model INPUTS");
	banner_stars();
	printf("\n\n");
	print_nodes();

	/* OUTPUT Statistics */

	for ($c = 0; $c < $streams; $c++) {
		switch ($job[$c]->should_be_class) {
			case TERM:
				$allusers += $job[$c]->term->pop;
				break;
			case BATCH:
				$allusers += $job[$c]->batch->pop;
				break;
			case TRANS:
				$allusers = 0.0;
				break;
			default:
				$s2="";
				$s2 = sprintf( "Unknown job should_be_class: %d", $job[$c]->should_be_class);
				errmsg($p, $s2);
				break;
		};
	};  /* loop over c */

	printf("\nQueueing Circuit Totals:\n\n");

	for ($c = 0; $c < $streams; $c++) {
		switch ($job[$c]->should_be_class) {
			case TERM:
				printf("\tClients:    %3.2f\n", $job[$c]->term->pop);
				break;
			case BATCH:
				printf("\tJobs:       %3.2f\n", $job[$c]->batch->pop);
				break;
			default:
				break;
		};
	};

	printf("\tStreams:    %3d\n", $streams);
	printf("\tNodes:      %3d\n", $nodes);
	printf("\n");

	printf("\n\nWORKLOAD Parameters\n\n");

	for ($c = 0; $c < $streams; $c++) {
		switch ($job[$c]->should_be_class) {
			case TERM:
				print_job($c, TERM);
				break;
			case BATCH:
				print_job($c, BATCH);
				break;
			case TRANS:
				print_job($c, TRANS);
				break;
			default:
				typetostr($s1, $job[$c]->should_be_class);
				$s2 = sprintf( "Unknown job should_be_class: %s", $s1);
				errmsg($p, $s2);
				break;
		};
	};  /* loop over $c */

	printf("\n");

	for ($c = 0; $c < $streams; $c++) {
		switch ($job[$c]->should_be_class) {
			case TERM:
				print_system_stats($c, TERM);
				break;
			case BATCH:
				print_system_stats($c, BATCH);
				break;
			case TRANS:
				print_system_stats($c, TRANS);
				break;
			default:
				typetostr($s1, $job[$c]->should_be_class);
				$s2 = sprintf( "Unknown job should_be_class: %s", $s1);
				errmsg($p, $s2);
				break;
		};
	};  /* loop over $c */

	printf("\n");

	for ($c = 0; $c < $streams; $c++) {
		switch ($job[$c]->should_be_class) {
			case TERM:
				print_node_stats($c, TERM);
				break;
			case BATCH:
				print_node_stats($c, BATCH);
				break;
			case TRANS:
				print_node_stats($c, TRANS);
				break;
			default:
				typetostr($s1, $job[$c]->should_be_class);
				$s2 = sprintf( "Unknown job should_be_class: %s", $s1);
				errmsg($p, $s2);
				break;
		};
	};  /* over $c */

	printf("\n");

	if ($DEBUG) debug($p, "Exiting");
}  /* PDQ_Report */

//----- Internal print layout routines ------------------------------------

//void 
function print_node_head() // void
{
	global $demand_ext, $DEBUG; // extern int
	global $model; // extern char
	global $s1; // extern char
	global $job; // extern JOB_TYPE *
	global $nodhdr;

	$dmdfmt = "%-4s %-5s %-10s %-10s %-5s %10s\n"; // char *
	$visfmt = "%-4s %-5s %-10s %-10s %-5s %10s %10s %10s\n"; // char *

	if ($DEBUG) {
		typetostr($s1, $job[0]->network);
		printf("%s Network: \"%s\"\n", $s1, $model);
		$s1="";
	};
	switch ($demand_ext) {
	case DEMAND:
		printf($dmdfmt,"Node", "Sched", "Resource", "Workload", "Class", "Demand");
		printf($dmdfmt,"----", "-----", "--------", "--------", "-----", "------");
		break;
	case VISITS:
		printf($visfmt,"Node", "Sched", "Resource", "Workload", "Class", "Visits", "Service", "Demand");
		printf($visfmt,"----", "-----", "--------", "--------", "-----", "------", "-------", "------");
		break;
	default:
		errmsg(__FUNCTION__, "Unknown file type");
		break;
	};

	$nodhdr = TRUE;
}  /* print_node_head */

//-------------------------------------------------------------------------

//void 
function print_nodes() // void
{
	global $s1, $s2, $s3, $s4; // extern char[]
	global $demand_ext, $DEBUG, $streams, $nodes; // extern int
	global $node; // extern NODE_TYPE *
	global $job; // extern JOB_TYPE  *
	global $nodhdr;

	$c = 0; // int               
    $k = 0; // int               
	$p = "print_nodes()"; // char *

	if ($DEBUG)	debug($p, "Entering");

	if (!$nodhdr) print_node_head();

	for ($c = 0; $c < $streams; $c++) {
		for ($k = 0; $k < $nodes; $k++) {
			$s1 = "";
			$s2 = "";
			$s3 = "";
			$s4 = "";

			typetostr($s1, $node[$k]->devtype);
			typetostr($s3, $node[$k]->sched);
			getjob_name($s2, $c);

			switch ($job[$c]->should_be_class) {
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

			switch ($demand_ext) {
				case DEMAND:
					printf("%-4s %-5s %-10s %-10s %-5s %10.4f\n",$s1,$s3,$node[$k]->devname,$s2,$s4,$node[$k]->demand[$c]);
					break;
				case VISITS:
					printf("%-4s %-4s %-10s %-10s %-5s %10.4f %10.4f %10.4f\n",$s1,$s3,$node[$k]->devname,$s2,$s4,$node[$k]->visits[$c],$node[$k]->service[$c],$node[$k]->demand[$c]);
					break;
				default:
					errmsg($p, "Unknown demand_ext type");
					break;
			};  /* switch */
		};  /* over k */

		printf("\n");
	};  /* over $c */

	printf("\n");

	if ($DEBUG) debug($p, "Exiting");

	$nodhdr = FALSE;
}  /* print_nodes */

//-------------------------------------------------------------------------

//void 
function print_job($c, $should_be_class) // int c, int should_be_class
{
	global $DEBUG; // extern int
	global $job; // extern JOB_TYPE *
	$p = "print_job()"; // char *

	if ($DEBUG) debug($p, "Entering");

	switch ($should_be_class) {
		case TERM:
			print_job_head(TERM);
			printf("%-10s   %6.2f    %10.4f   %6.2f\n",$job[$c]->term->name,$job[$c]->term->pop,$job[$c]->term->sys->minRT,$job[$c]->term->think);
			break;
		case BATCH:
			print_job_head(BATCH);
			printf("%-10s   %6.2f    %10.4f\n",$job[$c]->batch->name,$job[$c]->batch->pop,$job[$c]->batch->sys->minRT);
			break;
		case TRANS:
			print_job_head(TRANS);
			printf("%-10s   %4.4f    %10.4f\n",$job[$c]->trans->name,$job[$c]->trans->arrival_rate,$job[$c]->trans->sys->minRT);
			break;
		default:
			break;
	};

	if ($DEBUG) debug($p, "Exiting");
}  /* print_job */

//-------------------------------------------------------------------------

//void 
function print_sys_head() // void
{
	global $tolerance; // extern double
	global $s1; // extern char
	global $DEBUG, $method, $iterations; // extern int
	global $syshdr;
	
	$p = "print_sys_head()"; // char *

	if ($DEBUG)	debug($p, "Entering");

	printf("\n\n\n\n");
	banner_stars();
	banner_chars("   PDQ Model OUTPUTS");
	banner_stars();
	printf("\n\n");
	typetostr($s1, $method);
	printf("Solution Method: %s", $s1);

	if ($method == APPROX)
		printf("\t(Iterations: %d; Accuracy: %3.4lf%%)",$iterations,($tolerance * 100.0));

	printf("\n\n");
	banner_chars("   SYSTEM Performance");
	printf("\n\n");

	printf("%-20s\t%10s\t%-10s\n", "Metric", "Value", "Unit");
	printf("%-20s\t%10s\t%-10s\n", "-----------------", "-----", "----");

	$syshdr = TRUE;

	if ($DEBUG) debug($p, "Exiting");
}  /* print_sys_head */

//-------------------------------------------------------------------------

//void 
function print_job_head($should_be_class) // int should_be_class
{
    global $trmhdr, $bathdr, $trxhdr;
    
	switch ($should_be_class) {
		case TERM:
			if (!$trmhdr) {
				printf("\n");
				printf("%-10s   %-6s   %10s   %-10s\n","Client", "Number", "Demand", "Thinktime");
				printf("%-10s   %-6s   %10s   %-10s\n","----", "------", "------", "---------");
				$trmhdr = TRUE;
				$trxhdr = FALSE;
				$bathdr = FALSE;
			};
			break;
		case BATCH:
			if (!$bathdr) {
				printf("\n");
				printf("%-10s   %6s   %10s\n","Job", "MPL", "Demand");
				printf("%-10s   %6s   %10s\n","---", "---", " ------");
				$bathdr = TRUE;
				$trxhdr = FALSE;
				$trmhdr = FALSE;
			};
			break;
		case TRANS:
			if (!$trxhdr) {
				printf("%-10s   %-6s   %10s\n","Source", "per Sec", "Demand");
				printf("%-10s   %-6s   %10s\n","--------", "-------", " ------");
				$trxhdr = TRUE;
				$bathdr = FALSE;
				$trmhdr = FALSE;
			};
			break;
		default:
			break;
	};
}  /* print_job_head */

//-------------------------------------------------------------------------

//void 
function print_dev_head() // void
{
	global $devhdr;
     
    banner_chars("   RESOURCE Performance");
	printf("\n\n");
	printf("%-14s  %-10s   %-10s      %7s   %-7s\n","Metric", "Resource", "Work", "Value", "Unit");
	printf("%-14s  %-10s   %-10s      %7s   %-7s\n","---------", "------", "----", "-----", "----");

	$devhdr = TRUE;
}  /* print_dev_head */

//-------------------------------------------------------------------------

//void 
function print_system_stats($c,$should_be_class) // int c, int should_be_class
{
	global $tUnit; // extern char
	global $wUnit; // extern char
	global $DEBUG; // extern int
	global $s1; // extern char[]
	global $job; // extern JOB_TYPE *
	global $syshdr;
	
	$p = "print_system_stats()"; // char *

	if ($DEBUG) debug($p, "Entering");

	if (!$syshdr) print_sys_head();

	switch ($should_be_class) {
		case TERM:
			if ($job[$c]->term->sys->thruput == 0) {
				$s1 = sprintf( "X = %10.4f for stream = %d",$job[$c]->term->sys->thruput, $c);
				errmsg($p, $s1);
			};
			printf("Workload: \"%s\"\n", $job[$c]->term->name);
			printf("Mean Throughput  \t%10.4f   \t%s/%s\n",$job[$c]->term->sys->thruput, $wUnit, $tUnit);
			printf("Response Time    \t%10.4f   \t%s\n",$job[$c]->term->sys->response, $tUnit);
			printf("Mean Concurrency \t%10.4f   \t%s\n",$job[$c]->term->sys->residency, $wUnit);
			printf("Stretch Factor  \t%10.4f\n",$job[$c]->term->sys->response / $job[$c]->term->sys->minRT);
			break;
		case BATCH:
			if ($job[$c]->batch->sys->thruput == 0) {
				$s1 = sprintf( "X = %10.4f at N = %d",$job[$c]->batch->sys->thruput, $c);
				errmsg($p, $s1);
			};
			printf("Workload: \"%s\"\n", $job[$c]->batch->name);
			printf("Mean Throughput  \t%10.4f\t%s/%s\n",$job[$c]->batch->sys->thruput, $wUnit, $tUnit);
			printf("Response Time    \t%10.4f   \t%s\n",$job[$c]->batch->sys->response, $tUnit);
			printf("Mean Concurrency \t%10.4f   \t%s\n",$job[$c]->batch->sys->residency, $wUnit);
			printf("Stretch Factor  \t%10.4f\n",$job[$c]->batch->sys->response / $job[$c]->batch->sys->minRT);
			break;
		case TRANS:
			if ($job[$c]->trans->sys->thruput == 0) {
				$s1 = sprintf( "X = %10.4f for N = %d", $job[$c]->trans->sys->thruput, $c);
				errmsg($p, $s1);
			};
			printf("Workload: \"%s\"\n", $job[$c]->trans->name);
			printf("Mean Throughput  \t%10.4f\t%s/%s\n",$job[$c]->trans->sys->thruput, $wUnit, $tUnit);
			printf("Response Time    \t%10.4f\t%s\n",$job[$c]->trans->sys->response, $tUnit);
			break;
		default:
			break;
	};

	printf("\nBounds Analysis:\n");

	switch ($should_be_class) {
		case TERM:
			if ($job[$c]->term->sys->thruput == 0) {
				$s1 = sprintf( "X = %10.4f at N = %d", $job[$c]->term->sys->thruput, $c);
				errmsg($p, $s1);
			};
			printf("Max Throughput  \t%10.4f   \t%s/%s\n",$job[$c]->term->sys->maxTP, $wUnit, $tUnit);
			printf("Min Response    \t%10.4f   \t%s\n",$job[$c]->term->sys->minRT, $tUnit);
			printf("Max Demand      \t%10.4f   \t%s\n",1 / $job[$c]->term->sys->maxTP,  $tUnit);
			printf("Tot Demand      \t%10.4f   \t%s\n",$job[$c]->term->sys->minRT, $tUnit);
			printf("Think time      \t%10.4f   \t%s\n",$job[$c]->term->think, $tUnit);
			printf("Optimal Clients \t%10.4f   \t%s\n",($job[$c]->term->think + $job[$c]->term->sys->minRT) * $job[$c]->term->sys->maxTP, "Clients");
			break;
		case BATCH:
			if ($job[$c]->batch->sys->thruput == 0) {
				$s1 = sprintf( "X = %10.4f at N = %d",$job[$c]->batch->sys->thruput, $c);
				errmsg($p, $s1);
			};
			printf("Max Throughput  \t%10.4f   \t%s/%s\n",$job[$c]->batch->sys->maxTP, $wUnit, $tUnit);
			printf("Min Response    \t%10.4f   \t%s\n",$job[$c]->batch->sys->minRT, $tUnit);	
			printf("Max Demand      \t%10.4f   \t%s\n",1 / $job[$c]->batch->sys->maxTP,  $tUnit);
			printf("Tot Demand      \t%10.4f   \t%s\n",$job[$c]->batch->sys->minRT, $tUnit);
			printf("Optimal Jobs \t%10.4f   \t%s\n",$job[$c]->batch->sys->minRT * $job[$c]->batch->sys->maxTP, "Jobs");
			break;
		case TRANS:
			printf("Max Demand      \t%10.4f   \t%s/%s\n",$job[$c]->trans->sys->maxTP, $wUnit, $tUnit);
			printf("Max Throughput  \t%10.4f   \t%s/%s\n",$job[$c]->trans->sys->maxTP, $wUnit, $tUnit);
			break;
		default:
			break;
	};

	printf("\n");

	if ($DEBUG) debug($p, "Exiting");
}  /* print_system_stats */

//-------------------------------------------------------------------------

// void 
function print_node_stats($c, $should_be_class) // int c, int should_be_class
{
	global $s1, $s4, $tUnit, $wUnit; // extern char[]
	global $DEBUG, $demand_ext, $nodes; // extern int
	global $job; // extern JOB_TYPE  *
	global $node; // extern NODE_TYPE *
    global $devhdr;

	$k = 0; // int
	$X = 0.0; // double
    $devR = 0.0; // double
    $devD = 0.0; // double
	$p = "print_node_stats()"; // char *

	if ($DEBUG) debug($p, "Entering");

	if (!$devhdr) print_dev_head();

	getjob_name($s1, $c);

	switch ($should_be_class) {
		case TERM:
			$X = $job[$c]->term->sys->thruput;
			break;
		case BATCH:
			$X = $job[$c]->batch->sys->thruput;
			break;
		case TRANS:
			$X = $job[$c]->trans->arrival_rate;
			break;
		default:
			break;
	};

	for ($k = 0; $k < $nodes; $k++) {
		if ($node[$k]->demand[$c] == 0)
			continue;

		if ($demand_ext == VISITS) {
			$s4 = "Visits/".$tUnit;
		} else {
			$s4 = $wUnit."/".$tUnit;
		};

		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Throughput",$node[$k]->devname,$s1,($demand_ext == VISITS) ? ($node[$k]->visits[$c] * $X) : $X,$s4);
		/* calculate other stats */
		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Utilization",$node[$k]->devname,$s1,($node[$k]->sched == ISRV) ? 100 : ($node[$k]->demand[$c] * $X * 100),"Percent");
		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Queue Length",$node[$k]->devname,$s1,($node[$k]->sched == ISRV) ? 0 : ($node[$k]->resit[$c] * $X),$wUnit);
		printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Residence Time",$node[$k]->devname,$s1,($node[$k]->sched == ISRV) ? $node[$k]->demand[$c] : $node[$k]->resit[$c],$tUnit);
		if ($demand_ext == VISITS) {
			/* don't do this if service-time is unspecified */
            $devD = $node[$k]->demand[$c];
            $devR = $node[$k]->resit[$c];
			printf("%-14s  %-10s   %-10s   %10.4f   %-7s\n","Waiting Time",$node[$k]->devname,$s1,(($node[$k]->sched == ISRV) ? $devD : ($devR - $devD)),$tUnit);
		};
		printf("\n");
	};

	if ($DEBUG) debug($p, "Exiting");
}  /* print_node_stats */

//-------------------------------------------------------------------------

// void 
function banner_stars() // void
{
	printf("\t\t***************************************\n");

}  /* banner_stars */

//-------------------------------------------------------------------------

// void 
function banner_chars($s) // char *s
{

	printf("\t\t******%-26s*******\n", $s);

}  /* banner_chars */

//-------------------------------------------------------------------------

?>