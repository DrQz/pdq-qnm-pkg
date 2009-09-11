/*******************************************************************************/
/*  Copyright (C) 1994 - 2008, Performance Dynamics Company                    */
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
 * PDQ_Utils.c
 * 
 * Revised by NJG on Tue Aug 11 17:31:02 PDT 1998
 * Updated by NJG on Fri May 12 13:09:28 PDT 2006
 * Updated by NJG on Sat, Apr 7, 2007 Added GetNodesCount and GetStreamsCount
 * Updated by NJG on Mon, Sep 29, 2008 Removed resets() in debug()
 * Updated by NJG on Thu, Sep 10, 2009 Changed GetUtilization() for m server case
 *
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "PDQ_Lib.h"
#include "debug.h"

//-------------------------------------------------------------------------

#define MAXVAL 21

//-------------------------------------------------------------------------

extern NODE_TYPE *node;
extern JOB_TYPE  *job;
extern int        nodes;
extern int        streams;
extern int        PDQ_DEBUG;

//-------------------------------------------------------------------------

void resets(char *s);
void debug(char *proc, char *info);
void errmsg(char *pname, char *msg);

//-------------------------------------------------------------------------
// Must agree with PDQ_Lib.h

typedef struct {
	char           *name;
	int             value;
} TYPE_TABLE;

TYPE_TABLE
	typetable[] = {
		{"VOID",    VOID},
		{"OPEN",    OPEN},
		{"CLOSED",  CLOSED},
		{"MEM",     MEM},
		{"CEN",     CEN},
		{"DLY",     DLY},
		{"MSQ",     MSQ},
		{"ISRV",    ISRV},
		{"FCFS",    FCFS},
		{"PSHR",    PSHR},
		{"LCFS",    LCFS},
		{"TERM",    TERM},
		{"TRANS",   TRANS},
		{"BATCH",   BATCH},
		{"EXACT",   EXACT},
		{"APPROX",  APPROX},
		{"CANON",   CANON},
		{"VISITS",  VISITS},
		{"DEMAND",  DEMAND},
		{"SP",      PDQ_SP},
		{"MP",      PDQ_MP}
	};  /* typetable */

char            prevproc[MAXBUF];


//*********************************************************************
//         Public Utilities
//*********************************************************************

int 
PDQ_GetStreamsCount()
{
	char           *p = "PDQ_GetStreamsCount()";

	if (streams == 0) {
		errmsg(p, "No streams created.");
	}
	
	return (streams);
	
}  // PDQ_GetStreamsCount

//-------------------------------------------------------------------------

int
PDQ_GetNodesCount()
{
	char           *p = "PDQ_GetNodesCount()";

	if (nodes == 0) {
		errmsg(p, "No nodes created.");
	}
	
	return (nodes);
	
}  // PDQ_GetNodesCount

//-------------------------------------------------------------------------


double
PDQ_GetResponse(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetResponse()";
	double           r;

   int job_index = getjob_index(wname);

   if ((job_index >= 0) && (job_index < streams)) {
		switch (should_be_class) {
			case TERM:
				r = job[job_index].term->sys->response;
				break;
			case BATCH:
				r = job[job_index].batch->sys->response;
				break;
			case TRANS:
				r = job[job_index].trans->sys->response;
				break;
			default:
				errmsg(p, "Unknown should_be_class");
				break;
		}
	} else {
		fprintf(stderr, "[PDQ_GetResponse]  Invalid job index (%d)\n", job_index);
      exit(99);
	}

	return (r);
}  /* PDQ_GetResponse */

//-------------------------------------------------------------------------

double
PDQ_GetThruput(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetThruput()";
	double           x;

	// g_debugf("wname[%s]\n", wname);

   int job_index = getjob_index(wname);

   if ((job_index >= 0) && (job_index < streams)) {
		switch (should_be_class) {
			case TERM:
				x = job[job_index].term->sys->thruput;
				break;
			case BATCH:
				x = job[job_index].batch->sys->thruput;
				break;
			case TRANS:
				x = job[job_index].trans->sys->thruput;
				break;
			default:
				errmsg(p, "Unknown should_be_class");
				break;
		}
	} else {
		fprintf(stderr, "[PDQ_GetThruput]  Invalid job index (%d)\n", job_index);
      exit(99);
	}

	return (x);
}  /* PDQ_GetThruput */

//-------------------------------------------------------------------------

double
PDQ_GetThruMax(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetThruMax()";
	double           x;

   int job_index = getjob_index(wname);

   if ((job_index >= 0) && (job_index < streams)) {
		switch (should_be_class) {
			case TERM:
				x = job[job_index].term->sys->maxTP;
				break;
			case BATCH:
				x = job[job_index].batch->sys->maxTP;
				break;
			case TRANS:
				x = job[job_index].trans->sys->maxTP;
				break;
			default:
				errmsg(p, "Unknown should_be_class");
				break;
		}
	} else {
		fprintf(stderr, "[PDQ_GetThruMax]  Invalid job index (%d)\n", job_index);
      exit(99);
	}

	return (x);
}  /* PDQ_GetThruMax */

//-------------------------------------------------------------------------

double
PDQ_GetLoadOpt(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetLoadOpt()";
	double          Dmax, Dsum;
	double          Nopt, Z;

   int job_index = getjob_index(wname);

   if ((job_index >= 0) && (job_index < streams)) {
		switch (should_be_class) {
				case TERM:
					Dsum = job[job_index].term->sys->minRT;
					Dmax = 1.0 / job[job_index].term->sys->maxTP;
					Z = job[job_index].term->think;
					break;
				case BATCH:
					Dsum = job[job_index].batch->sys->minRT;
					Dmax = 1.0 / job[job_index].batch->sys->maxTP;
					Z = 0.0;
					break;
				case TRANS:
					errmsg(p, "Cannot calculate max Load for TRANS class");
					break;
				default:
					errmsg(p, "Unknown should_be_class");
					break;
			}
	} else {
		fprintf(stderr, "[PDQ_GetThruMax]  Invalid job index (%d)\n", job_index);
      exit(99);
	}

	Nopt = (Dsum + Z) / Dmax;

	return (floor(Nopt)); /* return lower bound as integral value */
}  /* PDQ_GetLoadOpt */

//-------------------------------------------------------------------------

/*double PDQ_GetResidenceTime_p(char device[8], char work[8], int should_be_class)
{
		  return PDQ_GetResidenceTime(device, work, should_be_class);
}*/

double
PDQ_GetResidenceTime(char *device, char *work, int should_be_class)
{
	char           *p = "PDQ_GetResidenceTime()";
	extern char       s1[];
	double            r;
	int               c, k;

	c = getjob_index(work);

	for (k = 0; k < nodes; k++) {
		if (strcmp(device, node[k].devname) == 0) {
			r = node[k].resit[c];
			return (r);
		}
	}

	sprintf(s1, "Unknown device %s", device);
	errmsg(p, s1);

	g_debug("PDQ_GetResidenceTime:  Returning bad double\n");

	return -1.0;
}  /* PDQ_GetResidenceTime */

//-------------------------------------------------------------------------

/*double PDQ_GetUtilization_p(char device[8], char work[8], int should_be_class)
{
	return PDQ_GetUtilization(device, work, should_be_class);
}*/

//-------------------------------------------------------------------------

double
PDQ_GetUtilization(char *device, char *work, int should_be_class)
{
	char             *p = "PDQ_GetUtilization()";

	extern char       s1[];

	double            x, u;

	int               c, k, m;

	// g_debug("PDQ_GetUtilization\n");
	// g_debugf("job[%d]\n", job);
	// g_debugf("work[%s]\n", work);
	// g_debugf("class[%d]\n", should_be_class);

	if (job) {
		// g_debugf("work[%s]\n", work);

		c = getjob_index(work);
		x = PDQ_GetThruput(should_be_class, work);

		for (k = 0; k < nodes; k++) {
			if (strcmp(device, node[k].devname) == 0) {
				// X is total arrival rate for MSQ
				u = node[k].demand[c] * x;
				
				// Edited by NJG on Thursday, September 10, 2009
				// Calculate per-server utilization; divide by m
				if (node[k].sched == MSQ) {
					m = node[k].devtype;
					u = u/m;
				}
				return (u);
			}
		}

		sprintf(s1, "Unknown device %s", device);
		errmsg(p, s1);
	}

	g_debug("PDQ_GetUtiliation:  Failed to find utilization\n");

	/* # b. why is there no return value? */

	return 0.0;
}  /* PDQ_GetUtilization */

//-------------------------------------------------------------------------

/*double PDQ_GetQueueLength(char device[8], char work[8], int should_be_class)
{
		  return PDQ_GetQueueLength(device, work, should_be_class);
}*/

//-------------------------------------------------------------------------

double
PDQ_GetQueueLength(char *device, char *work, int should_be_class)
{
	char             *p = "PDQ_GetQueueLength()";

	extern char       s1[];
	double            q, x;
	int               c, k;

	c = getjob_index(work);
	x = PDQ_GetThruput(should_be_class, work);

	for (k = 0; k < nodes; k++) {
		if (strcmp(device, node[k].devname) == 0) {
			q = node[k].resit[c] * x;
			return (q);
		}
	}

	sprintf(s1, "Unknown device %s", device);
	errmsg(p, s1);

	g_debug("PDQ_GetQueueLength - Bad double return");

	return -1.0;
}  /* PDQ_GetQueueLength */

//-------------------------------------------------------------------------

void
PDQ_SetDebug(int flag)
{
	PDQ_DEBUG = flag;

	if (PDQ_DEBUG) {
		printf("debug on\n");
	}
	else {
		printf("debug off\n");
	}
}  /* PDQ_SetDebug */

//-------------------------------------------------------------------------
// Local subroutines
//-------------------------------------------------------------------------

void
typetostr(char *str, int type)
/* convert a #define to a string */
{
	char            buf[MAXBUF];
	int             i;

	for (i = 0; i < MAXVAL; i++) {
		if (type == typetable[i].value) {
			strcpy(str, typetable[i].name);
			return;
		}
	}

	sprintf(buf, "Unknown type id for \"%s\"", str);
	errmsg("typetostr()", buf);

	strcpy(str, "NONE");
}  /* typetostr */

//-------------------------------------------------------------------------

int
strtotype(char *str)
/* convert a string to its #define value */
{
	int             i;
	char            buf[MAXBUF];

	for (i = 0; i <= MAXVAL; i++) {
		if ((strcmp(str, typetable[i].name) == 0)) {
			return (typetable[i].value);
		}
	}

	sprintf(buf, "Unknown type name \"%s\"", str);
	errmsg("strtotype()", buf);

	return -2;
}  /* strtotype */

//-------------------------------------------------------------------------

void
allocate_nodes(int n)
{
	char           *p = "allocate_nodes";

	if ((node = (NODE_TYPE *) calloc(sizeof(NODE_TYPE), n)) == NULL)
		errmsg(p, "Node allocation failed!\n");
}  /* allocate_nodes */

//-------------------------------------------------------------------------

void
allocate_jobs(int jobs)
{
	char                     *p    = "allocate_jobs()";

	extern TERMINAL_TYPE     *tm;
	extern BATCH_TYPE        *bt;
	extern TRANSACTION_TYPE  *tx;
	extern SYSTAT_TYPE       *sys;

	int                       c;

	if ((job = (JOB_TYPE*) calloc(sizeof(JOB_TYPE), jobs)) == NULL)
		errmsg(p, "Job allocation failed!\n");

	for (c = 0; c < jobs; c++) {
		tm = NULL;

		if ((tm = (TERMINAL_TYPE*) calloc(sizeof(TERMINAL_TYPE), 1)) == NULL)
			errmsg(p, "term allocation failed!\n");

		bt = NULL;

		if ((bt = (BATCH_TYPE*) calloc(sizeof(BATCH_TYPE), 1)) == NULL)
			errmsg(p, "batch allocation failed!\n");

		tx = NULL;

		if ((tx = (TRANSACTION_TYPE*) calloc(sizeof(TRANSACTION_TYPE), 1)) == NULL)
			errmsg(p, "trans allocation failed!\n");

		sys = NULL;

		if ((sys = (SYSTAT_TYPE*) calloc(sizeof(SYSTAT_TYPE), 1)) == NULL)
			errmsg(p, "systat allocation failed!\n");

		job[c].term            = tm;
		job[c].term->sys       = sys;
		job[c].batch           = bt;
		job[c].batch->sys      = sys;
		job[c].trans           = tx;
		job[c].trans->sys      = sys;

		job[c].should_be_class = VOID;
		job[c].network         = VOID;
	}
}  /* allocate_jobs */

//-------------------------------------------------------------------------

int
getjob_index(char *wname)
{
	char           *p = "getjob_index()";

	extern char     s1[];

	int             n;

	if (PDQ_DEBUG)
		debug(p, "Entering");

	// g_debugf("=====>  wname -> \"%s\"\n", wname);
	
	if (wname) {
		for (n = 0; n < streams; n++) {
			char
				*job_term_name;

			if (0) {
				g_debugf("n[%d]  &job[%p]\n", n, &(job[n]));
				g_debugf("job[]:[%p]\n", &(job[n]));
				g_debugf("job[].term:[%p]\n", &(job[n].term));
				g_debugf("job[].term->name:[%s]\n", job[n].term->name);
			}

			if (job[n].term)
				job_term_name = job[n].term->name;
         else
				job_term_name = "UNDEFINED";
		 
			// g_debugf("job_term_name:[%s]\n", job_term_name);

			if ((strcmp(job_term_name, wname) == 0) ||
				   (strcmp(job[n].batch->name, wname) == 0) ||
				   (strcmp(job[n].trans->name, wname) == 0)) {
				if (PDQ_DEBUG) {
				   resets(s1);
				   sprintf(s1, "stream:\"%s\"  index: %d", wname, n);
				   debug(p, s1);
				   resets(s1);
				   debug(p, "Exiting");
				}
				return (n);
			}
		}
	}

	// g_debug("*** CRITICAL *** function needs to return something!\n");

   return -1;
}  /* getjob_index */

//-------------------------------------------------------------------------

int
getnode_index(char *name)
{
	char             *p = "getnode_index()";

	extern char       s1[];

	int               k;

	if (PDQ_DEBUG)
		debug(p, "Entering");

	for (k = 0; k < nodes; k++) {
		if (strcmp(node[k].devname, name) == 0) {
			if (PDQ_DEBUG) {
				resets(s1);
				sprintf(s1, "node:\"%s\"  index: %d", name, k);
				debug(p, s1);
				resets(s1);
				debug(p, "Exiting");
			}
			return (k);
		}
	}

	/* if you are here, you're in deep yoghurt! */

	resets(s1);
	sprintf(s1, "Node name \"%s\" not found at index: %d", name, k);
	errmsg(p, s1);

	g_debug("[getnode_index]  Bad return value");

	return -1;
}  /* getnode_index */

//-------------------------------------------------------------------------

NODE_TYPE *getnode(int idx)
{
	if ((idx >= 0) && (idx < nodes)) {
		return &node[idx];
	} else
		return  (NODE_TYPE*)0;
}  /* getnode */

//-------------------------------------------------------------------------

void
getjob_name(char *str, int c)
{
	char *p = "getjob_name()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	switch (job[c].should_be_class) {
		case TERM:
			strcpy(str, job[c].term->name);
			break;
		case BATCH:
			strcpy(str, job[c].batch->name);
			break;
		case TRANS:
			strcpy(str, job[c].trans->name);
			break;
		default:
			break;
	}

	if (PDQ_DEBUG)
		debug(p, "Exiting");
}  /* getjob_name */

//-------------------------------------------------------------------------

double
getjob_pop(int c)
{
	extern char     s1[], s2[];

	char           *p = "getjob_pop()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	switch (job[c].should_be_class) {
		case TERM:
			if (PDQ_DEBUG)
				debug(p, "Exiting");
			return (job[c].term->pop);
			break;
		case BATCH:
			if (PDQ_DEBUG)
				debug(p, "Exiting");
			return (job[c].batch->pop);
			break;
		default:         /* error */
			typetostr(s1, job[c].should_be_class);
			sprintf(s2, "Stream %d. Unknown job type %s", c, s1);
			errmsg(p, s2);
			break;
	}

	return -1.0;
}  /* getjob_pop */

//-------------------------------------------------------------------------

JOB_TYPE* getjob(int c)
{
	if (c >= 0) {
		return &job[c];
	} else
		return  (JOB_TYPE*)0;
}  /* getjob */

//-------------------------------------------------------------------------

/*
 * For the purpose of indexing the the average number of terminals or
 * jobs. Take the ceiling of a double and return an int.
 */

int
roundup(double f)
{
	int             i = (int) ceil((double) f);

	return (i);
}  /* roundup */

//-------------------------------------------------------------------------
// Reset a string buffer

void
resets(char *s)
{
	*s = '\0';
}  /* resets */

//-------------------------------------------------------------------------

void
debug(char *proc, char *info)
{

	if (strcmp(prevproc, proc) == 0)
		printf("        %s\n", info);
	else {
		printf("DEBUG: %s\n        %s\n", proc, info);
		strcpy(prevproc, proc);
	}
	
	//resets(info); NJG: Unnecessary and can cause seg fault.
}  /* debug */

//-------------------------------------------------------------------------

void
errmsg(char *pname, char *msg)
{
	extern char     model[];  // in PDQ_Globals.c
    
    // For some reason 'model' string is trashed (NJG Sat May 13 10:15:52 PDT 2006)
    //printf("ERROR in model: \'%s\' at procedure \'%s\': %s\n", model, pname, msg);
    // output to tty always 
    fprintf(stderr, "ERROR in procedure \'%s\': %s\n", pname, msg);
 
	if (strchr(msg, '\012') && strlen(msg) != 1) {
		printf("\n");
    }
    
	exit(1);
}  /* errmsg */

//-------------------------------------------------------------------------

