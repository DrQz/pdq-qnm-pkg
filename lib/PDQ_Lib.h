/*******************************************************************************
 *  Copyright (c) 1994--2021, Performance Dynamics Company                    
 *                                                                             
 * This software is licensed as described in the file COPYING, which you should 
 * have received as part of this distribution. The terms are also available at 
 * http://www.perfdynamics.com/Tools/copyright.html. You may opt to use, copy, 
 * modify, merge, publish, distribute and/or sell copies of the Software, and 
 * permit persons to whom the Software is furnished to do so, under the terms of 
 * the COPYING file. This software is distributed on an "AS IS" basis, WITHOUT 
 * WARRANTY OF ANY KIND, either express or implied.                                          
 *
 ===========================  DISCLAIMER OF WARRANTY =========================== 
 * Performance Dynamics Company(SM) and Dr. Neil J. Gunther make no warranty,
 * express or implied, that the source code contained PDQ or in the  book are free 
 * from error, or are consistent with any particular standard of merchantability, 
 * or that they will meet your requirements for a particular application. They 
 * should not be relied upon for solving a problem whose correct solution could 
 * result in injury to a person or loss of property. The author disclaims all 
 * liability for direct or consequential damages resulting from your use of this 
 * source code. Also see separate disclaimers from the respective book publishers.
 ****************************** DO NOT REMOVE **********************************/

// PDQ_Lib.h
//
// Header file for the PDQ (Pretty Damn Quick) performance analyzer.
// The following string constant is read by the GetVersion and Report()

#define PDQ_VERSION    "Version 7.0.0 Build 112320"

// Updated by NJG on Tuesday, May 24, 2016 from string literal to #define constant
// thereby suppressing compiler warnings.
// This string must not contain more than 26 characters in order to satisfy the 
// predefined width in the PDQ Report() banner.


//---- TYPES --------------------------------------------------------------
// Modifying the order of these TYPE fields ramifies into the TYPE_TABLE in PDQ_Utils.c 

#ifndef   TRUE
#define   TRUE  1
#endif /* TRUE */
#ifndef   FALSE
#define   FALSE 0
#endif /* FALSE */


// Size limits 
#define MAXNODES    1024        /* Max queueing nodes */
#define MAXBUF       128        /* Biggest buffer */
#define MAXSTREAMS    64        /* Max job streams */
#define MAXCHARS      64        /* Max chars in param fields */
// Added by NJG on Thu Nov 12, 2020
#define MAX_USERS   1200        // biggish to model thread servers with FESC
#define MAXCLASS       3        // max PDQ stream types


// Queueing Network Types
// These define the queueing 'network' type in JOB_TYPE struct below
#define VOID    0				// Changed per PDQ_Init code (NJG on Apr 4, 2007)
#define OPEN    1
#define CLOSED  2

// Queueing Node Types
// #define FESC has been replaced below by MSO and MSC
#define CEN     3                /* standard queueing center */
#define DLY     4                /* unspecified delay center */
#define MSO     5                /* Multi-Server Open queue M/M/m - Was MSQ in 6.2 */
#define MSC     6                /* Multi-Server Closed M/M/m/N/N uses FESC algorithm */


// Service Schedule Types
#define ISRV    7                /* infinite server */
#define FCFS    8                /* first-come first-serve */
#define PSHR    9                /* processor sharing */
#define LCFS    10               /* last-come first-serve */

// Queueing Job Types
// These define the 'should_be_class' in JOB_TYPE struct below
#define TERM   11
#define TRANS  12
#define BATCH  13

// Solution Methods
#define EXACT  14		// for TERM, BATCH & FESC workloads (NJG on Nov 16, 2020)
#define APPROX 15		// for large TERM and BATCH workloads
#define CANON  16		// for TRANS workloads (OPEN network) 
#define APPROXMSO 17	// prep for multiclass MSO workloads (NJG on May 8, 2016)
                        /// not implemented in PDQ 7

// Service Time and Demand Types
#define VISITS 18
#define DEMAND 19

// Removed the following never-used constants (NJG on Nov 18, 2020)
//#define PDQ_SP 20        // uniprocessor
//#define PDQ_MP 21        // multiprocessor


// Alternative more accurate names for solver methods
// Added here for easier enumeration in PDQ 7.0 (NJG on Nov 18, 2020)
#define EXACTMVA  20 // EXACT alternative
#define APPROXMVA 21 // APPROX alternative
#define STREAMING 22 // CANON alternative (connotes 'continuous' workflow)


#define TOL 0.0010


//---- Metric data structures ------------------------------------------------------------

// Removed the following never-used fields from SYSTAT_TYPE
	//double            physmem;
	//double            highwater;
	//double            malloc;
	//double            mpl;
typedef struct {
	double            response;
	double            thruput;
	double            residency; // number in the system = total Qs
	double            maxN;
	double            maxTP;
	// Following fields were added by NJG on Tue Nov 17, 2020
	double            Nopt; 
	double            minRT;
	double            RTT;
	double            minRTT;
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
   int               should_be_class;  /* TERM, BATCH, TRANS */
   int               network;          /* OPEN, CLOSED */
   TERMINAL_TYPE    *term;
   BATCH_TYPE       *batch;
   TRANSACTION_TYPE *trans;
} JOB_TYPE;



// *** Node attributes ***
// Added by NJG on Mon Nov 16, 2020
// 		+ MSC NODE_TYPE is the token that invokes the FESC solver 
// 		  function MServerFESC() internally from PDQ_MServer.c
// 		+ No explicit FESC type needs to be defined.
// 		+ MSC devtype also uses EXACT solution method.  

typedef struct {
   int               devtype;               // *** CEN, MSO, MSC *** 
   int               sched;                 // FCFS, PSHR, ... 
   int               servers;               // Added by NJG on Dec 29, 2018
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

// ************************************
// Do NOT convert to 'void' or will conflict with SWIG compile
// Updated prep for PDQ 7.0 by NJG on Saturday, May 21, 2016
// Converted all PDQ Create prototypes to void
// ************************************

// Define the workload for a closed-circuit queueing model
//int     PDQ_CreateClosed(char *name, int should_be_class, double pop, double think);
void     PDQ_CreateClosed(char *name, int should_be_class, double pop, double think);
int     PDQ_CreateClosed_p(char *name, int should_be_class, double *pop, double *think);

// Define the workload in an open-circuit queueing * model.
//int     PDQ_CreateOpen(char *name, double lambda);
void     PDQ_CreateOpen(char *name, double lambda);
int     PDQ_CreateOpen_p(char *name, double *lambda);

// Define a single queueing center in either a closed or open circuit
//int     PDQ_CreateNode(char *name, int device, int sched);
void     PDQ_CreateNode(char *name, int device, int sched);

// Define multiserver queueing center in either a closed or open circuit
// Prototype as defined in Chapter 6 of the "Perl::PDQ" book
// New in PDQ v5.0. Added by NJG on Wed Feb 25, 2009
//int     PDQ_CreateMultiNode(int servers, char *name, int device, int sched);
void     PDQ_CreateMultiNode(int servers, char *name, int device, int sched);

// Define closed network multiserver FESC queueing device
// Added by NJG on Thu Nov 12, 2020 for PDQ version 6.3.0
// Removed by NJG on Sun Nov 22, 2020 in favor of CreateMultiNode() keying of MSC device
//void PDQ_CreateMultiserverClosed(int servers, char *name, int device, int sched);





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
char   *PDQ_GetComment(void); // NJG Friday, June 3, 2016: 
                              // Returned for python test and possible unit testing

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

extern void approx(void);    // in MVA_Approx.c
extern void canonical(void); // in MVA_Canon.c
extern void exact(void);     // in PDQ_Exact.c

extern int  getjob_index(char *wname);
extern void getjob_name(char *str, int c);
extern int  getnode_index(char *name);
extern void typetostr(char *str, int type);


// Added by PJP Nov 3, 2012 as support for R in the library 
#ifdef __R_PDQ
#include <R.h>
#define PRINTF Rprintf
#define PDQ_FREE Free
#else
#define PRINTF printf
#define PDQ_FREE free
#endif

