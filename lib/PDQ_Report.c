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
void banner_chars(char *s);

//-------------------------------------------------------------------------

void PDQ_Report_null(void)
{
	printf("foo!\n");
}	/* PDQ_Report_null */

//-------------------------------------------------------------------------

void PDQ_Report(void)
{
	extern char     model[];
	extern char     s1[], s2[], s3[], s4[];
	extern int      streams, nodes, DEBUG;
	extern JOB_TYPE *job;

	int             c;
	int             prevclass;
	time_t          clock;
	char           *pc;
	char           *tstamp;
	int             fillbase = 24;
	int             fill;
	char           *pad = "                       ";
	FILE           *fp;
	double           allusers = 0.0;
	char           *p = "PDQ_Report()";

	if (DEBUG == 1)
	{
		/*debug(p, "Entering");*/
		printf("Entering PDQ_Report()\n");
	}

	resets(s1);
	resets(s2);
	resets(s3);
	resets(s4);

	syshdr = FALSE;
	jobhdr = FALSE;
	nodhdr = FALSE;
	devhdr = FALSE;

	if ((clock = time(0)) == -1)
		errmsg(p, "Failed to get date");

	tstamp = (char *) ctime(&clock);	/* 24 chars + \n\0  */
	strncpy(s1, tstamp, fillbase);

	fill = fillbase - strlen(model);
	strcpy(s2, model);
	strncat(s2, pad, fill);

	fill = fillbase - strlen(version);
	strcpy(s3, version);
	strncat(s3, pad, fill);

	printf("\n\n");
	banner_stars();
	banner_chars(" Pretty Damn Quick REPORT");
	banner_stars();
	printf("                ***  of : %s  ***\n", s1);
	printf("                ***  for: %s  ***\n", s2);
	printf("                ***  Ver: %s  ***\n", s3);
	banner_stars();
	banner_stars();
	printf("\n");

	resets(s1);
	resets(s2);
	resets(s3);

	// Append comments

	printf("\n\n");

        if (strlen(Comment)) {
		banner_chars("        Comments");
		printf("\n");
		printf("        %s\n\n\n", Comment);  // Is defined as a global!
	}

	/* Show INPUT Parameters */

	banner_stars();
	banner_chars("    PDQ Model INPUTS");
	banner_stars();
	printf("\n\n");
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

	printf("\nQueueing Circuit Totals:\n\n");

	for (c = 0; c < streams; c++) {
		switch (job[c].should_be_class) {
			case TERM:
				printf("        Clients:    %3.2f\n", job[c].term->pop);
				break;
			case BATCH:
				printf("        Jobs:       %3.2f\n", job[c].batch->pop);
				break;
			default:
				break;
		}
	}

	printf("        Streams:    %3d\n", streams);
	printf("        Nodes:      %3d\n", nodes);
	printf("\n");

	printf("\n\nWORKLOAD Parameters\n\n");

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

	printf("\n");

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

	printf("\n");

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

	printf("\n");

	if (DEBUG)
		debug(p, "Exiting");
}  /* PDQ_Report */

//----- Internal print layout routines ------------------------------------

void print_node_head(void)
{
	extern int      demand_ext, DEBUG;
	extern char     model[];
	extern char     s1[];
	extern JOB_TYPE *job;

	char           *dmdfmt = "%-4s %-5s %-10s %-10s %-5s %10s\n";
	char           *visfmt = "%-4s %-5s %-10s %-10s %-5s %10s %10s %10s\n";

	if (DEBUG) {
		typetostr(s1, job[0].network);
		printf("%s Network: \"%s\"\n", s1, model);
		resets(s1);
	}
	switch (demand_ext) {
	case DEMAND:
		printf(dmdfmt,
		  "Node", "Sched", "Resource", "Workload", "Class", "Demand");
		printf(dmdfmt,
		  "----", "-----", "--------", "--------", "-----", "------");
		break;
	case VISITS:
		printf(visfmt,
		  "Node", "Sched", "Resource", "Workload", "Class", "Visits", "Service", "Demand");
		printf(visfmt,
		  "----", "-----", "--------", "--------", "-----", "------", "-------", "------");
		break;
	default:
		errmsg("print_node_head()", "Unknown file type");
		break;
	}

	nodhdr = TRUE;
}  /* print_node_head */

//-------------------------------------------------------------------------

void print_nodes(void)
{
	extern char       s1[], s2[], s3[], s4[];
	extern int        demand_ext, DEBUG;
	extern int        streams, nodes;
	extern NODE_TYPE *node;
	extern JOB_TYPE  *job;

	int               c, k;
	char             *p = "print_nodes()";

	if (DEBUG)
		debug(p, "Entering");

	if (!nodhdr)
		print_node_head();

	for (c = 0; c < streams; c++) {
		for (k = 0; k < nodes; k++) {
			resets(s1);
			resets(s2);
			resets(s3);
			resets(s4);

			typetostr(s1, node[k].devtype);
			typetostr(s3, node[k].sched);

			getjob_name(s2, c);

			switch (job[c].should_be_class) {
				case TERM:
					strcpy(s4, "TERML");
					break;
				case BATCH:
					strcpy(s4, "BATCH");
					break;
				case TRANS:
					strcpy(s4, "TRANS");
					break;
				default:
					break;
			}

			switch (demand_ext) {
				case DEMAND:
					printf("%-4s %-5s %-10s %-10s %-5s %10.4f\n",
					  s1,
					  s3,
					  node[k].devname,
					  s2,
					  s4,
					  node[k].demand[c]
					);
					break;
				case VISITS:
					printf("%-4s %-4s %-10s %-10s %-5s %10.4f %10.4f %10.4f\n",
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

		printf("\n");
	}  /* over c */

	printf("\n");

	if (DEBUG)
		debug(p, "Exiting");

	nodhdr = FALSE;
}  /* print_nodes */

//-------------------------------------------------------------------------

void print_job(int c, int should_be_class)
{
	extern int      DEBUG;
	extern JOB_TYPE *job;
	char           *p = "print_job()";

	if (DEBUG)
		debug(p, "Entering");

	switch (should_be_class) {
		case TERM:
			print_job_head(TERM);
			printf("%-10s   %6.2f    %10.4f   %6.2f\n",
		  	job[c].term->name,
		  	job[c].term->pop,
		  	job[c].term->sys->minRT,
		  	job[c].term->think
				);
			break;
		case BATCH:
			print_job_head(BATCH);
			printf("%-10s   %6.2f    %10.4f\n",
		  	job[c].batch->name,
		  	job[c].batch->pop,
		  	job[c].batch->sys->minRT
				);
			break;
		case TRANS:
			print_job_head(TRANS);
			printf("%-10s   %8.4f    %10.4f\n",
		  	job[c].trans->name,
		  	job[c].trans->arrival_rate,
		  	job[c].trans->sys->minRT
				);
			break;
		default:
			break;
	}

	if (DEBUG)
		debug(p, "Exiting");
}  /* print_job */

//-------------------------------------------------------------------------

void print_sys_head(void)
{
	extern double   tolerance;
	extern char     s1[];
	extern int      DEBUG, method, iterations;
	char           *p = "print_sys_head()";

	if (DEBUG)
		debug(p, "Entering");

	printf("\n\n\n\n");
	banner_stars();
	banner_chars("   PDQ Model OUTPUTS");
	banner_stars();
	printf("\n\n");
	typetostr(s1, method);
	printf("Solution Method: %s", s1);

	if (method == APPROX)
		printf("        (Iterations: %d; Accuracy: %3.4lf%%)",
		  iterations,
		  tolerance * 100.0
		);

	printf("\n\n");
	banner_chars("   SYSTEM Performance");
	printf("\n\n");

	printf("Metric                     Value    Unit\n");
	printf("------                     -----    ----\n");

	syshdr = TRUE;

	if (DEBUG)
		debug(p, "Exiting");
}  /* print_sys_head */

//-------------------------------------------------------------------------

int             trmhdr = FALSE;
int             bathdr = FALSE;
int             trxhdr = FALSE;

//-------------------------------------------------------------------------

void print_job_head(int should_be_class)
{
	switch (should_be_class) {
		case TERM:
			if (!trmhdr) {
				printf("\n");
				printf("Client       Number        Demand   Thinktime\n");
				printf("------       ------        ------   ---------\n");
				trmhdr = TRUE;
				bathdr = trxhdr = FALSE;
			}
			break;
		case BATCH:
			if (!bathdr) {
				printf("\n");
				printf("Job             MPL        Demand\n");
				printf("---             ---        ------\n");
				bathdr = TRUE;
				trmhdr = trxhdr = FALSE;
			}
			break;
		case TRANS:
			if (!trxhdr) {
				printf("Source        per Sec        Demand\n");
				printf("------        -------        ------\n");
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
	printf("\n\n");
	printf("Metric          Resource     Work              Value   Unit\n");
	printf("------          --------     ----              -----   ----\n");

	devhdr = TRUE;
}  /* print_dev_head */

//-------------------------------------------------------------------------

void print_system_stats(int c, int should_be_class)
{
	extern char      tUnit[];
	extern char      wUnit[];
	extern int       DEBUG;
	extern char      s1[];
	extern JOB_TYPE *job;
	char            *p = "print_system_stats()";

	if (DEBUG)
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
			printf("Workload: \"%s\"\n", job[c].term->name);
			printf("Mean Throughput       %10.4f    %s/%s\n",
		  		job[c].term->sys->thruput, wUnit, tUnit);
			printf("Response Time         %10.4f    %s\n",
		  		job[c].term->sys->response, tUnit);
			printf("Mean Concurrency      %10.4f    %s\n",
		  		job[c].term->sys->residency, wUnit);
			printf("Stretch Factor        %10.4f\n",
		  		job[c].term->sys->response / job[c].term->sys->minRT);
			break;
		case BATCH:
			if (job[c].batch->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f at N = %d",
		 	job[c].batch->sys->thruput, c);
				errmsg(p, s1);
			}
			printf("Workload: \"%s\"\n", job[c].batch->name);
			printf("Mean Throughput       %10.4f    %s/%s\n",
		  		job[c].batch->sys->thruput, wUnit, tUnit);
			printf("Response Time         %10.4f    %s\n",
		  		job[c].batch->sys->response, tUnit);
			printf("Mean Concurrency      %10.4f    %s\n",
		  		job[c].batch->sys->residency, wUnit);
			printf("Stretch Factor        %10.4f\n",
		  		job[c].batch->sys->response / job[c].batch->sys->minRT);
			break;
		case TRANS:
			if (job[c].trans->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f for N = %d", job[c].trans->sys->thruput, c);
				errmsg(p, s1);
			}
			printf("Workload: \"%s\"\n", job[c].trans->name);
			printf("Mean Throughput       %10.4f    %s/%s\n",
		  		job[c].trans->sys->thruput, wUnit, tUnit);
			printf("Response Time         %10.4f    %s\n",
		  		job[c].trans->sys->response, tUnit);
			break;
		default:
			break;
	}

	printf("\nBounds Analysis:\n");

	switch (should_be_class) {
		case TERM:
			if (job[c].term->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f at N = %d", job[c].term->sys->thruput, c);
				errmsg(p, s1);
			}
			printf("Max Throughput        %10.4f    %s/%s\n",
		  		job[c].term->sys->maxTP, wUnit, tUnit);
			printf("Min Response          %10.4f    %s\n",
		  		job[c].term->sys->minRT, tUnit);
			printf("Max Demand            %10.4f    %s\n",
		  		1 / job[c].term->sys->maxTP,  tUnit);
			printf("Tot Demand            %10.4f    %s\n",
		  		job[c].term->sys->minRT, tUnit);
			printf("Think time            %10.4f    %s\n",
		  		job[c].term->think, tUnit);
			printf("Optimal Clients       %10.4f    %s\n",
		  		(job[c].term->think + job[c].term->sys->minRT) * 
		  		job[c].term->sys->maxTP, "Clients");
			break;
		case BATCH:
			if (job[c].batch->sys->thruput == 0) {
				sprintf(s1, "X = %10.4f at N = %d",
		 			job[c].batch->sys->thruput, c);
				errmsg(p, s1);
			}
			printf("Max Throughput        %10.4f    %s/%s\n",
		  		job[c].batch->sys->maxTP, wUnit, tUnit);
			printf("Min Response          %10.4f    %s\n",
		  		job[c].batch->sys->minRT, tUnit);
	
			printf("Max Demand            %10.4f    %s\n",
		  		1 / job[c].batch->sys->maxTP,  tUnit);
			printf("Tot Demand            %10.4f    %s\n",
		  		job[c].batch->sys->minRT, tUnit);
			printf("Optimal Jobs          %10.4f    %s\n",
				job[c].batch->sys->minRT * 
				job[c].batch->sys->maxTP, "Jobs");
			break;
		case TRANS:
			printf("Max Demand            %10.4f    %s/%s\n",
		  		job[c].trans->sys->maxTP, wUnit, tUnit);
			printf("Max Throughput        %10.4f    %s/%s\n",
		  		job[c].trans->sys->maxTP, wUnit, tUnit);
			break;
		default:
			break;
	}

	printf("\n");

	if (DEBUG)
		debug(p, "Exiting");
}  /* print_system_stats */

//-------------------------------------------------------------------------

void print_node_stats(int c, int should_be_class)
{
	int               k;
	double            X, devR, devD;
	extern char       s1[];
	extern char       tUnit[];
	extern char       wUnit[];
	extern int        DEBUG, demand_ext, nodes;
	extern JOB_TYPE  *job;
	extern NODE_TYPE *node;
	extern char       s4[];
	char             *p = "print_node_stats()";

	if (DEBUG)
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

		printf("%-14s  %-10s   %-10s   %10.4f   %s\n",
		  "Throughput",
		  node[k].devname,
		  s1,
		  (demand_ext == VISITS) ? node[k].visits[c] * X : X,
		  s4
		);


		/* calculate other stats */

		printf("%-14s  %-10s   %-10s   %10.4f   %s\n",
		  "Utilization",
		  node[k].devname,
		  s1,
		  (node[k].sched == ISRV) ? 100 : node[k].demand[c] * X * 100,
		  "Percent"
		);

		printf("%-14s  %-10s   %-10s   %10.4f   %s\n",
		  "Queue Length",
		  node[k].devname,
		  s1,
		  (node[k].sched == ISRV) ? 0 : node[k].resit[c] * X,
		  wUnit
		);

		printf("%-14s  %-10s   %-10s   %10.4f   %s\n",
			"Residence Time",
			node[k].devname,
			s1,
			(node[k].sched == ISRV) ? node[k].demand[c] : node[k].resit[c],
			tUnit
		);

		if (demand_ext == VISITS) {
			/* don't do this if service-time is unspecified */
			devD = node[k].demand[c];
			devR = node[k].resit[c];

			printf("%-14s  %-10s   %-10s   %10.4f   %s\n",
				"Waiting Time",
				node[k].devname,
				s1,
		      		(node[k].sched == ISRV) ? devD : devR - devD,
				tUnit
			);
		}
		printf("\n");
	}

	if (DEBUG)
		debug(p, "Exiting");
}  /* print_node_stats */

//-------------------------------------------------------------------------

void banner_stars(void)
{
	printf("                ***************************************\n");

}  /* banner_stars */

//-------------------------------------------------------------------------

void banner_chars(char *s)
{

	printf("                ******%-26s*******\n", s);

}  /* banner_chars */

//-------------------------------------------------------------------------

