/*******************************************************************************/
/*  Copyright (C) 1994 - 2015, Performance Dynamics Company                    */
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
 * PDQ_Lib.h
 * 
 * Headers for the PDQ (Pretty Damn Quick) performance analyzer.
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
 *
 *  $Id$
 */

// The following string is read by the GetVersion and Report()
// Do not modify order of fields
// Must not contain more than 25 characters for Report header
// Updated by NJG on Tuesday, August 18, 2015

static char *version = "PDQ Analyzer 6.1.2 081815";


//---- TYPES --------------------------------------------------------------

#ifndef   TRUE
#define   TRUE  1
#endif /* TRUE */
#ifndef   FALSE
#define   FALSE 0
#endif /* FALSE */

#define MAXNODES    1024        /* Max queueing nodes */
#define MAXBUF       128        /* Biggest buffer */
#define MAXSTREAMS    64        /* Max job streams */
#define MAXCHARS      64        /* Max chars in param fields */

// Queueing Network Types

#define VOID    0				// Changed per PDQ_Init code (NJG: Wed, Apr 4, 2007)
#define OPEN    1
#define CLOSED  2

// Queueing Node Types

#define MEM     3
#define CEN     4                /* unspecified queueing center */
#define DLY     5                /* unspecified delay center */
#define MSQ     6                /* unspecified multi-server queue */

// Queueing Disciplines

#define ISRV    7                /* infinite server */
#define FCFS    8                /* first-come first-serve */
#define PSHR    9                /* processor sharing */
#define LCFS    10               /* last-come first-serve */


// Queueing Job Types

#define TERM   11
#define TRANS  12
#define BATCH  13

// Solution Methods

#define EXACT  14		// for moderate TERM workloads
#define APPROX 15		// for large TERM workloads
#define CANON  16		// for TRANS workloads

// Service Time and Demand Types

#define VISITS 17
#define DEMAND 18

// MP scalability

#define PDQ_SP 19        // uniprocessor
#define PDQ_MP 20        // multiprocessor

#define TOL 0.0010


//---- STRUCTS ------------------------------------------------------------

typedef struct {
   double            response;
   double            thruput;
   double            residency;
   double            physmem;
   double            highwater;
   double            malloc;
   double            mpl;
   double            maxN;
   double            maxTP;
   double            minRT;
} SYSTAT_TYPE;

typedef struct {
   char              name[MAXCHARS];
   double            pop;
   double            think;
   SYSTAT_TYPE      *sys;
} TERMINAL_TYPE;

typedef struct {
   char              name[MAXCHARS];
   double            pop;
   SYSTAT_TYPE      *sys;
} BATCH_TYPE;

typedef struct {
   char              name[MAXCHARS];
   double            arrival_rate;
   double            saturation_rate;
   SYSTAT_TYPE      *sys;
} TRANSACTION_TYPE;

typedef struct {
   int               should_be_class;  /* stream should_be_class */
   int               network;          /* OPEN, CLOSED */
   TERMINAL_TYPE    *term;
   BATCH_TYPE       *batch;
   TRANSACTION_TYPE *trans;
} JOB_TYPE;

typedef struct {
   int               devtype;               /* CEN, ... */
   int               sched;                 /* FCFS, ... */
   char              devname[MAXCHARS];
   double            visits[MAXSTREAMS];
   double            service[MAXSTREAMS];
   double            demand[MAXSTREAMS];
   double            resit[MAXSTREAMS];
   double            utiliz[MAXSTREAMS];    /* computed node utilization */
   double            qsize[MAXSTREAMS];
   double            avqsize[MAXSTREAMS];
} NODE_TYPE;


//---- FUNCTION PROTOTYPES -------------------------------------------------


int     PDQ_CreateClosed(char *name, int should_be_class, double pop, double think);
int     PDQ_CreateClosed_p(char *name, int should_be_class, double *pop, double *think);
// Define the workload for a closed-circuit queueing model

int     PDQ_CreateOpen(char *name, double lambda);
int     PDQ_CreateOpen_p(char *name, double *lambda);
// Define the workload in an open-circuit queueing * model.

int     PDQ_CreateNode(char *name, int device, int sched); 
// Define a single queueing center in either a closed or open circuit

// New in PDQ v5.0. Added by NJG on Wed Feb 25, 2009
int     PDQ_CreateMultiNode(int servers, char *name, int device, int sched); 
// Define multiserver queueing center in either a closed or open circuit
// Prototype as defined in Chapter 6 of the "Perl::PDQ" book

//------------------------------------------------------
// Next 2 functions will be used when current PDQ Create functions become procedures
// Probably in PDQ v5.0

int 	PDQ_GetStreamsCount();
// New function to determine number of created streams.

int		PDQ_GetNodesCount();
// New function to determine number of created streams.
//------------------------------------------------------


double  PDQ_GetResponse(int should_be_class, char *wname);
// Returns the system response time for the specified workload

double  PDQ_GetResidenceTime(char *device, char *work, int should_be_class);
// Returns the device residence time for the specified workload

double  PDQ_GetThruput(int should_be_class, char *wname);
// Returns the system throughput for the specified workload

double  PDQ_GetLoadOpt(int should_be_class, char *wname);
// Returns the optimal user load for the specified workload

double  PDQ_GetUtilization(char *device, char *work, int should_be_class);
// Returns the utilization of the designated queueing node by the
// specified workload

double  PDQ_GetQueueLength(char *device, char *work, int should_be_class);
// Returns the queue length at the designated queueing node due to the
// specified workload.

double  PDQ_GetThruMax(int should_be_class, char *wname);
// Return the maximum available throughput

//double PDQ_GetTotalDemand(int should_be_class, char *wname);
// Return the sum of the service demands across all PDQ nodes

void    PDQ_Init(char *name);        
// Initialize all internal PDQ variables.
// Must be called prior to any other PDQ function

void    PDQ_Report(void);        
// Generate a formatted report containing system, and node level 
// performance measures

void    PDQ_SetDebug(int flag);        
// Enable diagnostic printout of PDQ internal variables

void    PDQ_SetDemand(char *nodename, char *workname, double time);
void    PDQ_SetDemand_p(char *nodename, char *workname, double *time);
// Define the service demand of a specific workload at a specified node

void    PDQ_SetVisits(char *nodename, char *workname, double visits, double service);
void    PDQ_SetVisits_p(char *nodename, char *workname, double *visits, double *service);
// Define the service demand in terms of the service time and visit count.

void    PDQ_Solve(int method);        
// The solution method must be passed as an argument

void    PDQ_SetWUnit(char *unitName);
void    PDQ_SetTUnit(char *unitName);

void    PDQ_SetComment(char *comment);
char   *PDQ_GetComment(void);

//----- Some utilities ----------------------------------------------------

void       print_nodes(void);
NODE_TYPE *getnode(int idx);
JOB_TYPE  *getjob(int idx);

//-------------------------------------------------------------------------
// Move into PDQ_Global.h header to hide them from outside world
// Add explicit methods to expose them!
// extern int         nodes;
// extern int         streams;
// extern NODE_TYPE  *node;
// extern JOB_TYPE   *job;
// extern char        Comment[];

//-------------------------------------------------------------------------

// Added these to shut the compiler up
extern void resets(char *s);
extern void debug(char *proc, char *info);
extern void errmsg(char *pname, char *msg);
extern void approx(void);
extern void canonical(void);
extern void exact(void);
extern int  getjob_index(char *wname);
extern void getjob_name(char *str, int c);
extern int  getnode_index(char *name);
extern void typetostr(char *str, int type);


// Added by PJP Nov 3, 2012: Added support for R in the library 
#ifdef __R_PDQ
#include <R.h>
#define PRINTF Rprintf
#define PDQ_FREE Free
#else
#define PRINTF printf
#define PDQ_FREE free
#endif

