/*******************************************************************************/
/*  Copyright (C) 1994 - 2019, Performance Dynamics Company                    */
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
 * Updated by PJP on Sat, Nov 3, 2012 Added R support to the library
 * Updated by NJG on Tuesday, August 18, 2015 
 * 		Removed floor() in GetLoadOpt() return
 *		Added tests for PDQ circuit existence
 * Updated by NJG on Wed, August 19, 2015         Use PRINTF from PDQ_Lib.h for R
 * Updated by NJG on Sunday, December 16, 2018    TYPE_TABLE for M/M/n/N/N FESC node
 * Updated by NJG on Saturday, December 29, 2018  New MSO, MSC multi-server devtypes
 * Updated by NJG on Monday, December 31, 2018    Changed following function names:
 *													+ GetResponseTime
 *													+ PDQ_GetThruputMax
 *													+ PDQ_GetOptimalLoad
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "PDQ_Lib.h"
#include "PDQ_Global.h"
#include "debug.h"


//-------------------------------------------------------------------------

#define MAXVAL 21

//-------------------------------------------------------------------------

extern NODE_TYPE *node;
extern JOB_TYPE  *job;
extern int        nodes;
extern int        streams;
extern int        nzdemand; // non-zero when SetDemand() called
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
		{"CEN",     CEN},
		{"DLY",     DLY},
		{"MSO",     MSO},  //Edited by NJG on Saturday, December 29, 2018 (was MSQ)
     /* {"FESC",    FESC}, Removed by NJG for M/M/n/N/N FESC on Dec 16, 2018 */
		{"MSC",     MSC},  //Added by NJG on Saturday, December 29, 2018
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
        {"APXMSO",  APXMSO},
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
	extern void errmsg();

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

//Changed by NIG on Monday, December 31, 2018
double PDQ_GetResponseTime(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetResponse()";
	double          r = 0.0;
    int     job_index = getjob_index(wname);
   
   	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetResponse warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("PDQ_GetResponse warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("PDQ_GetResponse warning: No PDQ service demands defined.\n");

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
#ifndef __R_PDQ
		fprintf(stderr, "[PDQ_GetResponse]  Invalid job index (%d)\n", job_index);
      exit(99);
#else
      //	REprintf("[PDQ_GetResponse]  Invalid job index (%d)\n", job_index);
	error("[PDQ_GetResponse]  Invalid job index (%d)\n", job_index);

#endif
	}
	
	return (r);
	
}  // PDQ_GetResponseTime 

//-------------------------------------------------------------------------

double
PDQ_GetThruput(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetThruput()";
	double          x = 0.0;
    int     job_index = getjob_index(wname);
   
   	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetThruput warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("PDQ_GetThruput warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("PDQ_GetThruput warning: No PDQ service demands defined.\n");

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
#ifndef __R_PDQ
	fprintf(stderr, "[PDQ_GetThruput]  Invalid job index (%d)\n", job_index);
      exit(99);
#else
      //	REprintf("[PDQ_GetThruput]  Invalid job index (%d)\n", job_index);
	error("[PDQ_GetThruput]  Invalid job index (%d)\n", job_index);
#endif
	}
	
	return (x);
}  /* PDQ_GetThruput */

//-------------------------------------------------------------------------

//Changed by NIG on Monday, December 31, 2018
double PDQ_GetThruputMax(int should_be_class, char *wname)
{
	char    *p = "PDQ_GetThruMax()";
	double   x = 0.0;
    int     job_index = getjob_index(wname);

	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetThruMax warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("PDQ_GetThruMax warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("PDQ_GetThruMax warning: No PDQ service demands defined.\n");

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
#ifndef __R_PDQ
	fprintf(stderr, "[PDQ_GetThruMax]  Invalid job index (%d)\n", job_index);
      exit(99);
#else
      //	REprintf("[PDQ_GetThruMax]  Invalid job index (%d)\n", job_index);
	error("[PDQ_GetThruMax]  Invalid job index (%d)\n", job_index);
#endif
	}

	return (x);
	
}  /* PDQ_GetThruputMax */

//-------------------------------------------------------------------------

//Changed by NIG on Monday, December 31, 2018
double PDQ_GetOptimalLoad(int should_be_class, char *wname)
{
	char           *p = "PDQ_GetLoadOpt()";
	// Edited by NJG on Tuesday, August 18, 2015
	// Initialize vars to suppress compiler warnings
	double          Dmax = 0.0;
	double          Dsum = 0.0;
	double          Nopt = 0.0;
	double             Z = 0.0;
	int             job_index = getjob_index(wname);
   
   	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetLoadOpt warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("PDQ_GetLoadOpt warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("PDQ_GetLoadOpt warning: No PDQ service demands defined.\n");

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
#ifndef __R_PDQ
		fprintf(stderr, "[PDQ_GetLoadOpt]  Invalid job index (%d)\n", job_index);
      exit(99);
#else
      //    REprintf("[PDQ_GetLoadOpt]  Invalid job index (%d)\n", job_index);
    error("[PDQ_GetLoadOpt]  Invalid job index (%d)\n", job_index);
#endif
	}

	Nopt = (Dsum + Z) / Dmax;

	// Removed Tuesday, August 18, 2015
	//return (floor(Nopt)); /* return lower bound as integral value */
	// Want theoretical value, not rounded down 'practical' value. 
	// If Nopt < 1 then floor produces zero !!!
		
	return (Nopt);
	
}  /* PDQ_GetOptimalLoad */

//-------------------------------------------------------------------------

/*double PDQ_GetResidenceTime_p(char device[8], char work[8], int should_be_class)
{
		  return PDQ_GetResidenceTime(device, work, should_be_class);
}*/

double
PDQ_GetResidenceTime(char *device, char *work, int should_be_class)
{
	char             *p = "PDQ_GetResidenceTime()";
	extern char       s1[];
	// Initialize vars to suppress compiler warnings
	double            r = 0.0;
	int               c = 0;
	int               k = 0;
	
	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetResidenceTime warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("[PDQ_GetResidenceTime warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("[PDQ_GetResidenceTime warning: No PDQ service demands defined.\n");

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
	// Initialize vars to suppress compiler warnings
	double            x = 0.0;
	double            u = 0.0;
	int               c = 0;
	int               k = 0;
	int               m = 0;

	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetUtilization warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("PDQ_GetUtilization warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("PDQ_GetUtilization warning: No PDQ service demands defined.\n");

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
				
		        // Updated by NJG on Dec 29, 2018 with new NODE_TYPEs in PDQ_Lib.h
				// Edited by NJG on September 10, 2009
				// Divide by m to calculate per-server utilization
				if (node[k].devtype == MSO) {
					m = node[k].servers;
					u = u / m;
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
	// Initialize vars to suppress compiler warnings
	double            q = 0.0;
	double            x = 0.0;
	int               c = 0;
	int               k = 0;

	// Added by NJG on Wednesday, August 19, 2015
	if (!streams) PRINTF("PDQ_GetQueueLength warning: No PDQ workload defined.\n");
	if (!nodes) PRINTF("PDQ_GetQueueLength warning: No PDQ nodes defined.\n");
	if (!demands) PRINTF("PDQ_GetQueueLength warning: No PDQ service demands defined.\n");

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
		PRINTF("debug on\n");
	}
	else {
		PRINTF("debug off\n");
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
	int             i = 0;

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
	int             i = 0;
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
	
#ifndef __R_PDQ
	if ((node = (NODE_TYPE *) calloc(sizeof(NODE_TYPE), n)) == NULL)
#else
	  if ((node =  (NODE_TYPE *) Calloc( (size_t) n ,  NODE_TYPE )) == NULL)
#endif
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

	int                       c = 0;
#ifndef __R_PDQ
	if ((job = (JOB_TYPE*) calloc(sizeof(JOB_TYPE), jobs)) == NULL)
#else
	  if ((job = Calloc(jobs,JOB_TYPE)) == NULL)
#endif
		errmsg(p, "Job allocation failed!\n");

	for (c = 0; c < jobs; c++) {
		tm = NULL;
#ifndef __R_PDQ
		if ((tm = (TERMINAL_TYPE*) calloc(sizeof(TERMINAL_TYPE), 1)) == NULL)
#else
		  if ((tm = Calloc(1,TERMINAL_TYPE)) == NULL)
#endif
			errmsg(p, "term allocation failed!\n");

		bt = NULL;
#ifndef __R_PDQ
		if ((bt = (BATCH_TYPE*) calloc(sizeof(BATCH_TYPE), 1)) == NULL)
#else
		  if ((bt = Calloc(1,BATCH_TYPE)) == NULL)
#endif
			errmsg(p, "batch allocation failed!\n");

		tx = NULL;
#ifndef __R_PDQ
		if ((tx = (TRANSACTION_TYPE*) calloc(sizeof(TRANSACTION_TYPE), 1)) == NULL)
#else
		  if ((tx = Calloc(1,TRANSACTION_TYPE)) == NULL)
#endif
			errmsg(p, "trans allocation failed!\n");

		sys = NULL;
#ifndef __R_PDQ
		if ((sys = (SYSTAT_TYPE*) calloc(sizeof(SYSTAT_TYPE), 1)) == NULL)
#else
		  if ((sys = Calloc(1,SYSTAT_TYPE)) == NULL)
#endif
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

	int             n = 0;

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

	int               k = 0;

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
		PRINTF("        %s\n", info);
	else {
		PRINTF("DEBUG: %s\n        %s\n", proc, info);
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
#ifndef __R_PDQ
    fprintf(stderr, "ERROR in procedure \'%s\': %s\n", pname, msg);
 
	if (strchr(msg, '\012') && strlen(msg) != 1) {
		PRINTF("\n");
    }
    

	exit(1);
#else
	//    REprintf("ERROR in procedure \'%s\': %s\n", pname, msg);
 
	if (strchr(msg, '\012') && strlen(msg) != 1) {
		Rprintf("\n");
	}
    
    error("ERROR in procedure \'%s\': %s\n", pname, msg);

#endif
}  /* errmsg */

//-------------------------------------------------------------------------


#ifdef __R_PDQ
  

void
PDQ_SetNodes(int ns)
{
	nodes = ns;

	if (PDQ_DEBUG) {
		PRINTF("nodes global = %d\n",nodes);
	}
}  /* PDQ_SetNodes */

void
PDQ_SetStreams(int ss)
{
      
	streams = ss;

	if (PDQ_DEBUG) {
		PRINTF("Streams global = %d\n",streams);
	}
}  /* PDQ_SetStreams */

#endif
