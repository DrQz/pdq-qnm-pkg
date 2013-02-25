/*******************************************************************************/
/*  Copyright (C) 1994 - 2013, Performance Dynamics Company                    */
/*                                                                             */
/*  This software is licensed as described in the file COPYING, which          */
/*  you should have received as part of this distribution. The terms           */
/*  are also available at http://www.perfdynamics.com/Tools/copyright.html.    */
/*                                                                             */
/*  You may opt to use, copy, modify, merge, publish, distribute and/or sell   */
/*  copies of the Software, and permit persons to whom the Software is         */
/*  furnished to do so, under the terms of the COPYING file.                   */
/*                                                                             */
/*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  */
/*  KIND, either express or implied.                                           */
/*******************************************************************************/

/*
 * PDQ_Report.c
 * 
 * Revised by NJG on Fri Aug  2 10:29:48  2002
 * Revised by NJG on Thu Oct  7 20:02:27 PDT 2004
 * Updated by NJG on Mon, Apr 2, 2007
 * Updated by NJG on Wed, Apr 4, 2007: Added Waiting line and time
 * Updated by NJG on Friday, July 10, 2009: fixed dev utilization reporting
 * Updated by PJP on Sat, Nov 3, 2012: Added R support
 * Updated by NJG on Friday, January 11, 2013: 
 *    o Widened top header for new Z.x.y version format
 *    o Centered Report title w/o stars and less glitter
 *    o Modified Model INPUTS to show number of servers numerically for 
 *      both *single* and multi node comparison
 * Updated by NJG on Saturday, January 12, 2013: 
 *    o Fixed wUnit to be tUnit in WORKLOAD Parameters section
 *    o Queue was sometimes wrong for MSQ (too many divides by m)
 * 
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "PDQ_Lib.h"
#include "PDQ_Global.h"


//-------------------------------------------------------------------------

int             syshdr;
int             jobhdr;
int             nodhdr;
int             devhdr;

extern char     *version;

//----- Prototypes of internal print layout routins -----------------------

void print_node_head(void);
void print_nodes(void);
void print_job(int c, int should_be_class);
void print_sys_head(void);
void print_job_head(int should_be_class);
void print_dev_head(void);
void print_system_stats(int c, int should_be_class);
void print_node_stats(int c, int should_be_class);
void banner_stars(void);
void banner_dash(void);		// Added by NJG on Mon, Apr 2, 2007
void banner_chars(char *s);

//-------------------------------------------------------------------------

void PDQ_Report_null(void)
{
	PRINTF("foo!\n");
}	/* PDQ_Report_null */

//-------------------------------------------------------------------------

void PDQ_Report(void)
{
	extern char     model[];
	extern char     s1[], s2[], s3[], s4[];
	extern int      streams, nodes, PDQ_DEBUG;
	extern JOB_TYPE *job;

	int             c;
	int             prevclass;
	time_t          clock;
	char           *pc;
	char           *tstamp;
	int             fillbase = 25; // was 24
	int             fill;
	char           *pad = "                        "; // 24 was 23
	FILE           *fp;
	double          allusers = 0.0;
	char           *p = "PDQ_Report()";

	if (PDQ_DEBUG == 1)
	{
		/*debug(p, "Entering");*/
		PRINTF("Entering PDQ_Report()\n");
	}

	resets(s1);
	resets(s2);
	resets(s3);
	resets(s4);

	syshdr = FALSE;
	jobhdr = FALSE;
	nodhdr = FALSE;
	devhdr = FALSE;

	if ((clock = time(0)) == -1) {
		errmsg(p, "Failed to get date");
	}

    tstamp = (char *) ctime(&clock);
    // e.g., "Thu Jan 10 21:19:40 2013" is 24 chars + \n\0 
    // see http://www.thinkage.ca/english/gcos/expl/c/lib/ctime.html
	strncpy(s4, tstamp, 24); // toss embedded \n char
	fill = fillbase - strlen(s4);
	strcpy(s1, s4);
	strncat(s1, pad, fill);
	
	fill = fillbase - strlen(model);
	strcpy(s2, model);
	strncat(s2, pad, fill);

	fill = fillbase - strlen(version);
	strcpy(s3, version);
	strncat(s3, pad, fill);

	PRINTF("\n");
	// NJG on Friday, January 11, 2013
	// Center the Report title w/o stars
	PRINTF("%15s%9s%24s%9s\n", " ", " ","PRETTY DAMN QUICK REPORT"," ");
	banner_dash();
	PRINTF("               ***    of: %s   ***\n", s1);
	PRINTF("               ***   for: %s   ***\n", s2);
	PRINTF("               ***   Ver: %s   ***\n", s3);
	banner_dash();

	resets(s1);
	resets(s2);
	resets(s3);
	resets(s4);

	PRINTF("\n");
	
	// Append comments
    if (strlen(Comment)) {
		PRINTF("COMMENT: ");
		PRINTF("%s\n\n", Comment);  // Is defined as a global!
	}

	/* Show INPUT Parameters */

	banner_dash();
	banner_chars("    PDQ Model INPUTS");
	banner_dash();
	PRINTF("\n");
	print_nodes();

	/* OUTPUT Statistics */

	for (c = 0; c < streams; c++) {
		switch (job[c].should_be_class) {
			case TERM:
				allusers += job[c].term->pop;
				break;
			case BATCH:
				allusers += job[c].batch->pop;
				break;
			case TRANS:
				allusers = 0.0;
				break;
			default:
				resets(s2);
				sprintf(s2, "Unknown job should_be_class: %d", job[c].should_be_class);
				errmsg(p, s2);
				break;
		}
	}  /* loop over c */

	PRINTF("\n");
	PRINTF("Queueing Circuit Totals\n");
	PRINTF("Streams: %3d\n", streams);
	PRINTF("Nodes:   %3d\n\n", nodes);

	//PRINTF("WORKLOAD Parameters:\n");

	for (c = 0; c < streams; c++) {
		switch (job[c].should_be_class) {
			case TERM:
				print_job(c, TERM);
				break;
			case BATCH:
				print_job(c, BATCH);
				break;
			case TRANS:
				print_job(c, TRANS);
				break;
			default:
				typetostr(s1, job[c].should_be_class);
				sprintf(s2, "Unknown job should_be_class: %s", s1);
				errmsg(p, s2);
				break;
		}
	}  /* loop over c */


	for (c = 0; c < streams; c++) {
		switch (job[c].should_be_class) {
			case TERM:
				print_system_stats(c, TERM);
				break;
			case BATCH:
				print_system_stats(c, BATCH);
				break;
			case TRANS:
				print_system_stats(c, TRANS);
				break;
			default:
				typetostr(s1, job[c].should_be_class);
				sprintf(s2, "Unknown job should_be_class: %s", s1);
				errmsg(p, s2);
				break;
		}
	}  /* loop over c */

	PRINTF("\n");

	for (c = 0; c < streams; c++) {
		switch (job[c].should_be_class) {
			case TERM:
				print_node_stats(c, TERM);
				break;
			case BATCH:
				print_node_stats(c, BATCH);
				break;
			case TRANS:
				print_node_stats(c, TRANS);
				break;
			default:
				typetostr(s1, job[c].should_be_class);
				sprintf(s2, "Unknown job should_be_class: %s", s1);
				errmsg(p, s2);
				break;
		}
	}  /* over c */

	PRINTF("\n");

	if (PDQ_DEBUG)
		debug(p, "Exiting");
}  /* PDQ_Report */

//----- Internal print layout routines ------------------------------------

void print_node_head(void)
{
	extern int      demand_ext, PDQ_DEBUG;
	extern char     model[];
	extern char     s1[];
	extern JOB_TYPE *job;

	char           *dmdfmt = "%-4s %-5s %-10s %-10s %-5s %10s\n";
	char           *visfmt = "%-4s %-5s %-10s %-10s %-5s %10s %10s %10s\n";

	if (PDQ_DEBUG) {
		typetostr(s1, job[0].network);
		PRINTF("%s Network: \"%s\"\n", s1, model);
		resets(s1);
	}
	
	PRINTF("WORKLOAD Parameters:\n\n");

	switch (demand_ext) {
	case DEMAND:
		PRINTF(dmdfmt,
		  "Node", "Sched", "Resource", "Workload", "Class", "Demand");
		PRINTF(dmdfmt,
		  "----", "-----", "--------", "--------", "-----", "------");
		break;
	case VISITS:
		PRINTF(visfmt,
		  "Node", "Sched", "Resource", "Workload", "Class", "Visits", "Service", "Demand");
		PRINTF(visfmt,
		  "----", "-----", "--------", "--------", "-----", "------", "-------", "------");
		break;
	default:
		errmsg("print_node_head()", "Unknown file type");
		break;
	}

	nodhdr = TRUE;
}  // print_node_head 

//-------------------------------------------------------------------------

void print_nodes(void)
{
	extern char       s1[], s2[], s3[], s4[];
	extern int        demand_ext, PDQ_DEBUG;
	extern int        streams, nodes;
	extern NODE_TYPE *node;
	extern JOB_TYPE  *job;

	int               c, k;
	char             *p = "print_nodes()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	if (!nodhdr)
		print_node_head();

	for (c = 0; c < streams; c++) {
		for (k = 0; k < nodes; k++) {
			resets(s1);
			resets(s2);
			resets(s3);
			resets(s4);

			typetostr(s3, node[k].sched);
			if (node[k].sched == MSQ) {
			// From CreateMultiNode()
			// number of MSQ servers contained in node.devtype
				sprintf(s1, "%3d", node[k].devtype); 
			} else {
			// NJG: Friday, January 11, 2013
			// From CreateNode() node.devtype == CEN
			// More consistent with MSQ Inputs reporting 
			// to show number of servers as numeric 1
			// node.sched still displays as FCFS
				//typetostr(s1, node[k].devtype);
				sprintf(s1, "%3d", 1);
			}

			getjob_name(s2, c);

			switch (job[c].should_be_class) {
				case TERM:
					strcpy(s4, "Closed");
					break;
				case BATCH:
					strcpy(s4, "Batch");
					break;
				case TRANS:
					strcpy(s4, "Open");
					break;
				default:
					break;
			}

			switch (demand_ext) {
				case DEMAND:
					PRINTF("%-4s %-5s %-10s %-10s %-5s %10.4lf",
					  s1,
					  s3,
					  node[k].devname,
					  s2,
					  s4,
					  node[k].demand[c]
					);
					break;
				case VISITS:
					PRINTF("%-4s %-4s %-10s %-10s %-5s %10.4f %10.4lf %10.4lf",
					  s1,
					  s3,
					  node[k].devname,
					  s2,
					  s4,
					  node[k].visits[c],
					  node[k].service[c],
					  node[k].demand[c]
					);
					break;
				default:
					errmsg("print_nodes()", "Unknown file type");
					break;
			}  /* switch */
		}  /* over k */

		PRINTF("\n");
	}  /* over c */


	if (PDQ_DEBUG)
		debug(p, "Exiting");

	nodhdr = FALSE;
}  /* print_nodes */

//-------------------------------------------------------------------------

void print_job(int c, int should_be_class)
{
	extern int      PDQ_DEBUG;
	extern JOB_TYPE *job;
	char           *p = "print_job()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	switch (should_be_class) {
		case TERM:
			print_job_head(TERM);
			PRINTF("%-10s   %6.2f    %10.4lf   %6.2f\n",
		  	job[c].term->name,
		  	job[c].term->pop,
		  	job[c].term->sys->minRT,
		  	job[c].term->think
				);
			break;
		case BATCH:
			print_job_head(BATCH);
			PRINTF("%-10s   %6.2f    %10.4lf\n",
		  	job[c].batch->name,
		  	job[c].batch->pop,
		  	job[c].batch->sys->minRT
				);
			break;
		case TRANS:
			print_job_head(TRANS);
			PRINTF("%-10s   %8.4f    %10.4lf\n",
		  	job[c].trans->name,
		  	job[c].trans->arrival_rate,
		  	job[c].trans->sys->minRT
				);
			break;
		default:
			break;
	}

	if (PDQ_DEBUG)
		debug(p, "Exiting");
}  /* print_job */

//-------------------------------------------------------------------------
//
// The following stats appear in the section labeled
//
//               ******   PDQ Model OUTPUTS   *******

void print_sys_head(void)
{
	extern double   tolerance;
	extern char     s1[];
	extern int      PDQ_DEBUG, method, iterations;
	char           *p = "print_sys_head()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	PRINTF("\n\n");
	banner_dash();
	banner_chars("   PDQ Model OUTPUTS");
	banner_dash();
	PRINTF("\n");
	typetostr(s1, method);
	PRINTF("Solution Method: %s", s1);

	if (method == APPROX)
		PRINTF("        (Iterations: %d; Accuracy: %3.4lf%%)",
		  iterations,
		  tolerance * 100.0
		);

	PRINTF("\n\n");
	banner_chars("   SYSTEM Performance");
	PRINTF("\n");

	PRINTF("Metric                     Value    Unit\n");
	PRINTF("------                     -----    ----\n");

	syshdr = TRUE;

	if (PDQ_DEBUG)
		debug(p, "Exiting");
}  /* print_sys_head */

//-------------------------------------------------------------------------

int             trmhdr = FALSE;
int             bathdr = FALSE;
int             trxhdr = FALSE;

//-------------------------------------------------------------------------

void print_job_head(int should_be_class)
{
	extern char      tUnit[];

	switch (should_be_class) {
		case TERM:
			if (!trmhdr) {
				PRINTF("\n");
				PRINTF("Client       Number        Demand   Thinktime\n");
				PRINTF("------       ------        ------   ---------\n");
				trmhdr = TRUE;
				bathdr = trxhdr = FALSE;
			}
			break;
		case BATCH:
			if (!bathdr) {
				PRINTF("\n");
				PRINTF("Job             MPL        Demand\n");
				PRINTF("---             ---        ------\n");
				bathdr = TRUE;
				trmhdr = trxhdr = FALSE;
			}
			break;
		case TRANS:
			if (!trxhdr) {
				PRINTF("Arrivals       per %-5s     Demand \n", tUnit);
				PRINTF("--------       --------     -------\n");
				trxhdr = TRUE;
				trmhdr = bathdr = FALSE;
			}
			break;
		default:
			break;
	}
}  /* print_job_head */

//-------------------------------------------------------------------------

void print_dev_head(void)
{
	banner_chars("   RESOURCE Performance");
	PRINTF("\n");
	PRINTF("Metric          Resource     Work              Value   Unit\n");
	PRINTF("------          --------     ----              -----   ----\n");

	devhdr = TRUE;
}  /* print_dev_head */

//-------------------------------------------------------------------------
//
// The following stats appear in the section labeled
//
//               ******   SYSTEM Performance   *******

void print_system_stats(int c, int should_be_class)
{
	extern char      tUnit[];
	extern char      wUnit[];
	extern int       PDQ_DEBUG;
	extern char      s1[];
	extern JOB_TYPE *job;
	char            *p = "print_system_stats()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	if (!syshdr)
		print_sys_head();

	switch (should_be_class) {
		case TERM:
			if (job[c].term->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f for stream = %d",
		 	job[c].term->sys->thruput, c);
				errmsg(p, s1);
			}
			PRINTF("Workload: \"%s\"\n", job[c].term->name);
			PRINTF("Mean concurrency      %10.4lf    %s\n",
		  		job[c].term->sys->residency, wUnit);
			PRINTF("Mean throughput       %10.4lf    %s/%s\n",
		  		job[c].term->sys->thruput, wUnit, tUnit);
			PRINTF("Response time         %10.4lf    %s\n",
		  		job[c].term->sys->response, tUnit);
			PRINTF("Round trip time       %10.4lf    %s\n",
		  		job[c].term->sys->response + job[c].term->think, tUnit);
		  	PRINTF("Stretch factor        %10.4lf\n",
		  		job[c].term->sys->response / job[c].term->sys->minRT);
			break;
		case BATCH:
			if (job[c].batch->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f at N = %d",
		 	job[c].batch->sys->thruput, c);
				errmsg(p, s1);
			}
			PRINTF("Workload: \"%s\"\n", job[c].batch->name);
			PRINTF("Mean concurrency      %10.4lf    %s\n",
		  		job[c].batch->sys->residency, wUnit);
			PRINTF("Mean throughput       %10.4lf    %s/%s\n",
		  		job[c].batch->sys->thruput, wUnit, tUnit);
			PRINTF("Response time         %10.4lf    %s\n",
		  		job[c].batch->sys->response, tUnit);
			PRINTF("Stretch factor        %10.4lf\n",
		  		job[c].batch->sys->response / job[c].batch->sys->minRT);
			break;
		case TRANS:
			if (job[c].trans->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f for N = %d", job[c].trans->sys->thruput, c);
				errmsg(p, s1);
			}
			PRINTF("Workload: \"%s\"\n", job[c].trans->name);
			PRINTF("Number in system      %10.4lf    %s\n",
		  		job[c].term->sys->residency, wUnit);
			PRINTF("Mean throughput       %10.4lf    %s/%s\n",
		  		job[c].trans->sys->thruput, wUnit, tUnit);
			PRINTF("Response time         %10.4lf    %s\n",
		  		job[c].trans->sys->response, tUnit);
			PRINTF("Stretch factor        %10.4lf\n",
		  		job[c].term->sys->response / job[c].term->sys->minRT);
		  		break;
		default:
			break;
	}

	PRINTF("\nBounds Analysis:\n");

	switch (should_be_class) {
		case TERM:
			if (job[c].term->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f at N = %d", job[c].term->sys->thruput, c);
				errmsg(p, s1);
			}
			PRINTF("Max throughput        %10.4lf    %s/%s\n",
		  		job[c].term->sys->maxTP, wUnit, tUnit);
			PRINTF("Min response          %10.4lf    %s\n",
		  		job[c].term->sys->minRT, tUnit);
			PRINTF("Max Demand            %10.4lf    %s\n",
		  		1 / job[c].term->sys->maxTP,  tUnit);
			PRINTF("Tot demand            %10.4lf    %s\n",
		  		job[c].term->sys->minRT, tUnit);
			PRINTF("Think time            %10.4lf    %s\n",
		  		job[c].term->think, tUnit);
			PRINTF("Optimal clients       %10.4lf    %s\n",
		  		(job[c].term->think + job[c].term->sys->minRT) * 
		  		job[c].term->sys->maxTP, "Clients");
			break;
		case BATCH:
			if (job[c].batch->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f at N = %d",
		 			job[c].batch->sys->thruput, c);
				errmsg(p, s1);
			}
			PRINTF("Max throughput        %10.4lf    %s/%s\n",
		  		job[c].batch->sys->maxTP, wUnit, tUnit);
			PRINTF("Min response          %10.4lf    %s\n",
		  		job[c].batch->sys->minRT, tUnit);
	
			PRINTF("Max demand            %10.4lf    %s\n",
		  		1 / job[c].batch->sys->maxTP,  tUnit);
			PRINTF("Tot demand            %10.4lf    %s\n",
		  		job[c].batch->sys->minRT, tUnit);
			PRINTF("Optimal jobs          %10.4f    %s\n",
				job[c].batch->sys->minRT * 
				job[c].batch->sys->maxTP, "Jobs");
			break;
		case TRANS:
			PRINTF("Max throughput        %10.4lf    %s/%s\n",
		  		job[c].trans->sys->maxTP, wUnit, tUnit);
			PRINTF("Min response          %10.4lf    %s\n",
		  		job[c].trans->sys->minRT, tUnit);
		  	break;
		default:
			break;
	}

	PRINTF("\n");

	if (PDQ_DEBUG)
		debug(p, "Exiting");
}  /* print_system_stats */

//-------------------------------------------------------------------------
//
// The following stats appear in the section labeled
//
//               ******   RESOURCE Performance   *******


void print_node_stats(int c, int should_be_class)
{

	extern char       s1[];
	extern char       tUnit[];
	extern char       wUnit[];
	extern int        PDQ_DEBUG, demand_ext, nodes;
	extern JOB_TYPE  *job;
	extern NODE_TYPE *node;
	extern char       s3[];
	extern char       s4[];

	double            	X;
	double            	devR;
	double            	devD;
	double          	devU;
	double          	devQ;
	double          	devW;
	double          	devL;
	int               	k;
	int               	mservers;
	char             	*p = "print_node_stats()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	if (!devhdr)
		print_dev_head();

	getjob_name(s1, c);

	switch (should_be_class) {
		case TERM:
			X = job[c].term->sys->thruput;
			break;
		case BATCH:
			X = job[c].batch->sys->thruput;
			break;
		case TRANS:
			X = job[c].trans->arrival_rate;
			break;
		default:
			break;
	}

	for (k = 0; k < nodes; k++) {
		if (node[k].demand[c] == 0)
			continue;

		if (demand_ext == VISITS) {
			resets(s4);
			strcpy(s4, "Visits");
			strcat(s4, "/");
			strcat(s4, tUnit);
		} else {
			resets(s4);
			strcpy(s4, wUnit);
			strcat(s4, "/");
			strcat(s4, tUnit);
		}

// NJG: Friday, January 11, 2013 
// New metric: MSQ server capacity; the 'm' in M/M/m
			resets(s3);
			typetostr(s3, node[k].sched);
			if (node[k].sched == MSQ) {
			// This is a hack until the multiserver data types are consistent
			// number of MSQ servers
				mservers = node[k].devtype; 
			} else {
				mservers = 1;
			}
		// Now, display mservers metric	
		PRINTF("%-14s  %-10s   %-10s   %10d   %s\n",
		  "Capacity",
		  node[k].devname,
		  s1,
		  mservers,
		  "Servers"
		);


		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
		  "Throughput",
		  node[k].devname,
		  s1,
		  (demand_ext == VISITS) ? node[k].visits[c] * X : X,
		  s4
		);


		// calculate other stats
		switch (node[k].sched) {
			case ISRV:
				devU = 100.0;
				devQ = 0.0;
				devW = node[k].demand[c];
				devL = 0.0;
				break;
			case MSQ:
			 	// devU is per-server from U<1 test in MVA_Canon.c
			 	devU = node[k].utiliz[c];
				mservers = node[k].devtype;
				// X is total arrival rate into PDQ network
				devQ = X * node[k].resit[c]; // Little's law
				devW = node[k].resit[c] - node[k].demand[c];
				devL = X * devW;
				break;
			default:
				// NJG on Friday, July 10, 2009
				// devU = node[k].utiliz[c];
				// node[k].utiliz[c] is not updated in either EXACT 
				// or APPROX methods.
				// Rather than implementing it in every relevant module, 
				// we just use Little's law here.	
				devU = X * node[k].demand[c];
				devQ = X * node[k].resit[c];
				devW = node[k].resit[c] - node[k].demand[c];
				devL = X * devW;
                break;
		}

// NJG: Friday, January 11, 2013 
		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
		  "In service",
		  node[k].devname,
		  s1,
		  devU * mservers,
		  wUnit
		);
			
		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
		  "Utilization",
		  node[k].devname,
		  s1,
		  devU * 100,
		  "Percent"
		);
	
		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
		  "Queue length",
		  node[k].devname,
		  s1,
		  devQ,
		  wUnit
		);
		
		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
			"Waiting line",
			node[k].devname,
			s1,
			devL,
			wUnit
		);
		
		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
			"Waiting time",
			node[k].devname,
			s1,
			devW,
			tUnit
		);
		
		PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
			"Residence time",
			node[k].devname,
			s1,
			(node[k].sched == ISRV) ? node[k].demand[c] : node[k].resit[c],
			tUnit
		);

		// Only if visits are used ...
		if (demand_ext == VISITS) {
			/* don't do this if service-time is unspecified */
			devD = node[k].demand[c];
			devR = node[k].resit[c];

			PRINTF("%-14s  %-10s   %-10s   %10.4lf   %s\n",
				"Waiting time",
				node[k].devname,
				s1,
		        (node[k].sched == ISRV) ? devD : devR - devD,
				tUnit
			);
		}
		PRINTF("\n");
	}

	if (PDQ_DEBUG)
		debug(p, "Exiting");
		
}  // print_node_stats

//-------------------------------------------------------------------------

void banner_stars(void)
{
	PRINTF("               ******************************************\n");

}  /* banner_stars */

//-------------------------------------------------------------------------

void banner_dash(void)
{
	PRINTF("               ==========================================\n");

}  // banner_dash




//-------------------------------------------------------------------------
void banner_chars(char *s)
{

	PRINTF("               ********%-26s********\n", s);

}  /* banner_chars */

//-------------------------------------------------------------------------

