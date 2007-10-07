/*
 * PDQ_Build.c
 * 
 * Copyright © 1994-2006 Performance Dynamics. All Rights Reserved.
 * 
 * Created by NJG on 18:19:02  04-28-95 
 * Revised by NJG on 09:33:05  31-03-99
 * 
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "PDQ_Lib.h"
#include "PDQ_Global.h"

//-------------------------------------------------------------------------

#define MAXSUFF 10

//-------------------------------------------------------------------------

static int      k = 0;
static int      c = 0;

//----- Prototypes of internal functions ----------------------------------

void create_term_stream(int circuit, char *label, double pop, double think);
void create_batch_stream(int net, char* label, double number);
void create_transaction(int net, char* label, double lambda);

//-------------------------------------------------------------------------

void PDQ_Init(char *name)
{
	extern char             model[];
	extern char             tUnit[];
	extern char             wUnit[];
	extern char             s1[];
	extern int              demand_ext;
	extern int              method;
	extern double           tolerance;
	extern int              nodes;
	extern int              streams;
	extern int              prev_init;
	extern NODE_TYPE        *node;
	extern JOB_TYPE         *job;
	extern TERMINAL_TYPE    *tm;
	extern BATCH_TYPE       *bt;
	extern TRANSACTION_TYPE *tx;
	extern SYSTAT_TYPE      *sys;
	extern int               DEBUG;
	extern void              allocate_nodes();
	extern void              allocate_jobs();
	char                    *p = "PDQ_Init()";

	int             cc, kk;

	if (DEBUG)
		debug(p, "Entering");

	if (strlen(name) > MAXCHARS) {
		resets(s1);
		sprintf(s1, "Model name > %d characters", MAXCHARS);
		errmsg(p, s1);
	}
    
    // There may be multiple Inits in the same model
	if (prev_init) {
		for (c = 0; c < MAXSTREAMS; c++) {
			if (job[c].term) {
				if (job[c].term->sys) {
					free(job[c].term->sys);
					job[c].term->sys = NULL;
					job[c].batch->sys = NULL;
					job[c].trans->sys = NULL;
				}
				free(job[c].term);
				job[c].term = NULL;
			}
			if (job[c].batch) {
				if (job[c].batch->sys) {
					free(job[c].batch->sys);
					job[c].term->sys = NULL;
					job[c].batch->sys = NULL;
					job[c].trans->sys = NULL;
				}
				free(job[c].batch);
				job[c].batch = NULL;
			}
			if (job[c].trans) {
				if (job[c].trans->sys) {
					free(job[c].trans->sys);
					job[c].term->sys = NULL;
					job[c].batch->sys = NULL;
					job[c].trans->sys = NULL;
				}
				free(job[c].trans);
				job[c].trans = NULL;
			}
		}                         /* over c */

		if (job) {
			free(job);
			job = NULL;
		}
		if (node) {
			free(node);
			node = NULL;
		}

		resets(model);
		resets(wUnit);
		resets(tUnit);
	}

	// Copy user-supplied name string into PDQ global model[]
	strcpy(model, name);
        Comment[0] = '\0';  // NULL string

	// Set default units 
	strcpy(wUnit, "Job");
	strcpy(tUnit, "Sec");

	demand_ext = VOID;
	tolerance = TOL;
	method = VOID;

	allocate_nodes(MAXNODES+1);
	allocate_jobs(MAXSTREAMS+1);

	for (cc = 0; cc < MAXSTREAMS; cc++) {
		for (kk = 0; kk < MAXNODES; kk++) {
			node[kk].devtype = VOID;
			node[kk].sched = VOID;
			node[kk].demand[cc] = 0.0;
			node[kk].resit[cc] = 0.0;
			node[kk].qsize[cc] = 0.0;
		}
		job[cc].should_be_class = VOID;
		job[cc].network = VOID;
	}

	/* reset circuit counters */

	nodes = streams = 0;
	c = k = 0;

	prev_init = TRUE;

	if (DEBUG)
		debug(p, "Exiting");
}  /* PDQ_Init */

//-------------------------------------------------------------------------

void  PDQ_SetComment(char *comment)
{
   strncpy(Comment, comment, MAXBUF);
}  /* PDQ_SetComment */

//-------------------------------------------------------------------------

char*  PDQ_GetComment(void)
{
   return Comment;
}  /* PDQ_GetComment */

//-------------------------------------------------------------------------

int PDQ_CreateNode(char *name, int device, int sched)
{
	extern NODE_TYPE *node;
	extern char     s1[], s2[];
	extern int      nodes;
	extern int      DEBUG;
	char           *p = "PDQ_CreateNode";
	FILE*	out_fd;

	if (DEBUG)
	{
		debug(p, "Entering");
		out_fd = fopen("PDQ.out", "a");
		fprintf(out_fd, "name : %s  device : %d  sched : %d\n", name, device, sched);
		close(out_fd);
	}

	if (k > MAXNODES) {
		sprintf(s1, "Allocating \"%s\" exceeds %d max nodes",
			name, MAXNODES);
		errmsg(p, s1);
	}

	if (strlen(name) >= MAXCHARS) {
		sprintf(s1, "Nodename \"%s\" is longer than %d characters",
			name, MAXCHARS);
		errmsg("create_node()", s1);
	}

	strcpy(node[k].devname, name);

	node[k].devtype = device;
	node[k].sched = sched;

	if (DEBUG) {
		typetostr(s1, node[k].devtype);
		typetostr(s2, node[k].sched);
		printf("\tNode[%d]: %s %s \"%s\"\n",
		  k, s1, s2, node[k].devname);
		resets(s1);
		resets(s2);
	};

	if (DEBUG)
		debug(p, "Exiting");

	k =  ++nodes;

	return nodes;
}  /* PDQ_CreateNode */

//-------------------------------------------------------------------------

int PDQ_CreateClosed(char *name, int should_be_class, double pop, double think)
{
	return PDQ_CreateClosed_p(name, should_be_class, &pop, &think);
}

//-------------------------------------------------------------------------

int PDQ_CreateClosed_p(char *name, int should_be_class, double *pop, double *think)
{
	extern char     s1[];
	extern int      streams;
	extern int      DEBUG;
	char           *p = "PDQ_CreateClosed()";
	FILE           *out_fd;

	if (DEBUG)
	{
		debug(p, "Entering");
		out_fd = fopen("PDQ.out", "a");
		fprintf(out_fd, "name : %s  should_be_class : %d  pop : %f  think : %f\n", name, should_be_class, *pop, *think);
		close(out_fd);
	}

	if (strlen(name) >= MAXCHARS) {
		sprintf(s1, "Nodename \"%s\" is longer than %d characters",
			name, MAXCHARS);
		errmsg(p, s1);
	}

	if (c > MAXSTREAMS) {
		printf("c = %d\n", c);
		sprintf(s1, "Allocating \"%s\" exceeds %d max streams",
			name, MAXSTREAMS);
		errmsg(p, s1);
	}

	switch (should_be_class) {
		case TERM:
			if (*pop == 0.0) {
				resets(s1);
				sprintf(s1, "Stream: \"%s\", has zero population", name);
				errmsg(p, s1);
			}
			create_term_stream(CLOSED, name, *pop, *think);
			break;
		case BATCH:
			if (*pop == 0.0) {
				resets(s1);
				sprintf(s1, "Stream: \"%s\", has zero population", name);
				errmsg(p, s1);
			}
			create_batch_stream(CLOSED, name, *pop);
			break;
		default:
			sprintf(s1, "Unknown stream: %d", should_be_class);
			errmsg(p, s1);
			break;
	}

	if (DEBUG)
		debug(p, "Exiting");

	c =  ++streams;

	return streams;
}  /* PDQ_CreateClosed */

//-------------------------------------------------------------------------

int PDQ_CreateOpen(char *name, double lambda)
{
	return PDQ_CreateOpen_p(name, &lambda);
}

//-------------------------------------------------------------------------

int PDQ_CreateOpen_p(char *name, double *lambda)
{
	extern char     s1[];
	extern int      streams;
	extern int	    DEBUG;
	FILE           *out_fd;

	if (DEBUG)
	{
		  out_fd = fopen("PDQ.out", "a");
	fprintf(out_fd, "name : %s  lambda : %f\n", name, *lambda);
		close(out_fd);
	}
	
	if (strlen(name) > MAXCHARS) {
		sprintf(s1, "Nodename \"%s\" is longer than %d characters",
			name, MAXCHARS);
		errmsg("PDQ_CreateOpen()", s1);
	}

	create_transaction(OPEN, name, *lambda);

	c =  ++streams;

	return streams;
}  /* PDQ_CreateOpen */

//-------------------------------------------------------------------------

void PDQ_SetDemand(char *nodename, char *workname, double time)
{
	PDQ_SetDemand_p(nodename, workname, &time);
}

//-------------------------------------------------------------------------

void PDQ_SetDemand_p(char *nodename, char *workname, double *time)
{
	char             *p = "PDQ_SetDemand()";

	extern NODE_TYPE *node;
	extern int        nodes;
	extern int        streams;
	extern int        demand_ext;
	extern int        DEBUG;

	int               node_index;
	int               job_index;

	FILE             *out_fd;

	if (DEBUG)
	{
		debug(p, "Entering");
		out_fd = fopen("PDQ.out", "a");
		fprintf(out_fd, "nodename : %s  workname : %s  time : %f\n", nodename, workname, *time);
		close(out_fd);
	}

	/* that demand type is being used consistently per model */

	if (demand_ext == VOID || demand_ext == DEMAND) {
		node_index = getnode_index(nodename);
		job_index  = getjob_index(workname);

		if (!((node_index >=0) && (node_index <= nodes))) {
			fprintf(stderr, "Illegal node index value %d\n", node_index);
			exit(1);
		}

		if (!((job_index >=0) && (job_index <= streams))) {
			fprintf(stderr, "Illegal job index value %d\n", job_index);
			exit(1);
		}

		node[node_index].demand[job_index] = *time;
		demand_ext = DEMAND;
	} else
		errmsg(p, "Extension conflict");

	if (DEBUG)
		debug(p, "Exiting");
}  /* PDQ_SetDemand */

//-------------------------------------------------------------------------

void PDQ_SetVisits(char *nodename, char *workname, double visits, double service)
{
	PDQ_SetVisits_p(nodename, workname, &visits, &service);
}

//-------------------------------------------------------------------------

void PDQ_SetVisits_p(char *nodename, char *workname, double *visits, double *service)
{
	extern NODE_TYPE *node;
	extern int demand_ext;
	extern int DEBUG;

	if (DEBUG)
	{
		printf("nodename : %s  workname : %s  visits : %f  service : %f\n", nodename, workname, *visits, *service);
	}

	if (demand_ext == VOID || demand_ext == VISITS) {
		node[getnode_index(nodename)].visits[getjob_index(workname)] = *visits;
		node[getnode_index(nodename)].service[getjob_index(workname)] = *service;
		node[getnode_index(nodename)].demand[getjob_index(workname)] = (*visits) * (*service);
		demand_ext = VISITS;
	} else
		errmsg("PDQ_SetVisits()", "Extension conflict");
}  /* PDQ_SetVisits */

//-------------------------------------------------------------------------

void PDQ_SetWUnit(char* unitName)
{
	extern char     wUnit[];

	if (strlen(unitName) > 10)
		errmsg("PDQ_SetWUnit()", "Name > 10 characters");

	resets(wUnit);
	strcpy(wUnit, unitName);
}  /* PDQ_SetWUnit */

//-------------------------------------------------------------------------

void PDQ_SetTUnit(char* unitName)
{
	extern char     tUnit[];

	if (strlen(unitName) > 10)
		errmsg("PDQ_SetTUnit()", "Name > 10 characters");

	resets(tUnit);
	strcpy(tUnit, unitName);
}  /* PDQ_SetTUnit */

//----- Internal Functions ------------------------------------------------

void create_term_stream(int circuit, char *label, double pop, double think)
{
	extern JOB_TYPE *job;
	extern char     s1[];
	extern int      DEBUG;
	char           *p = "create_term_stream()";

	if (DEBUG)
		debug(p, "Entering");

	strcpy(job[c].term->name, label);
	job[c].should_be_class = TERM;
	job[c].network = circuit;
	job[c].term->think = think;
	job[c].term->pop = pop;

	if (DEBUG) {
		typetostr(s1, job[c].should_be_class);
		printf("\tStream[%d]: %s \"%s\"; N: %3.1f, Z: %3.2f\n",
		  c, s1,
		  job[c].term->name,
		  job[c].term->pop,
		  job[c].term->think
			);
		resets(s1);
	}

	if (DEBUG)
		debug(p, "Exiting");
}  /* create_term_stream */

//-------------------------------------------------------------------------

void create_batch_stream(int net, char* label, double number)
{
	extern JOB_TYPE *job;
	extern char     s1[];
	extern int      DEBUG;
	char           *p = "create_batch_stream()";

	if (DEBUG)
		debug(p, "Entering");

	/***** using global value of n *****/

	strcpy(job[c].batch->name, label);

	job[c].should_be_class = BATCH;
	job[c].network = net;
	job[c].batch->pop = number;

	if (DEBUG) {
		typetostr(s1, job[c].should_be_class);
		printf("\tStream[%d]: %s \"%s\"; N: %3.1f\n",
		  c, s1, job[c].batch->name, job[c].batch->pop);
		resets(s1);
	}

	if (DEBUG)
		debug(p, "Exiting");
}  /* create_batch_stream */

//-------------------------------------------------------------------------

void create_transaction(int net, char* label, double lambda)
{
	extern JOB_TYPE *job;
	extern char     s1[];
	extern int DEBUG;

	strcpy(job[c].trans->name, label);

	job[c].should_be_class = TRANS;
	job[c].network = net;
	job[c].trans->arrival_rate = lambda;

	if (DEBUG) {
		typetostr(s1, job[c].should_be_class);
		printf("\tStream[%d]:  %s\t\"%s\";\tLambda: %3.1f\n",
		  c, s1, job[c].trans->name, job[c].trans->arrival_rate);
		resets(s1);
	}
}  /* create_transaction */

//-------------------------------------------------------------------------

void writetmp(FILE* fp, char* s)
{
	fprintf(fp, "%s", s);
	printf("%s", s);
}  /* writetmp */

//-------------------------------------------------------------------------

