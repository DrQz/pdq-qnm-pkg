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

// This string gets read by GetVersion script amongst others
// Do not modify order of fields
<<<<<<< PDQ_Lib.h
static char *version = "PDQ Analyzer v4.0 051206";
=======
static char *version = "PDQ Analyzer v4.2 20070101";
>>>>>>> 1.19

//---- TYPES --------------------------------------------------------------

#ifndef   TRUE
#define   TRUE  1
#endif /* TRUE */
#ifndef   FALSE
#define   FALSE 0
#endif /* FALSE */

#define MAXNODES     512	/* Max queueing nodes */
#define MAXBUF       128	/* Biggest buffer */
#define MAXSTREAMS    64	/* Max job streams */
#define MAXCHARS      64	/* Max chars in param fields */

/* Queueing Network Type */

#define VOID 	-1
#define OPEN    0
#define CLOSED  1

/* Nodes */

#define MEM    2
#define CEN 	3		/* unspecified queueing center */
#define DLY 	4		/* unspecified delay center */
#define MSQ 	5		/* unspecified multi-server queue */

/* Queueing Disciplines */

#define ISRV 	6		/* infinite server */
#define FCFS   7		/* first-come first-serve */
#define PSHR 	8		/* processor sharing */
#define LCFS 	9		/* last-come first-serve */


/* Job Types */

#define TERM 	10
#define TRANS 	11
#define BATCH 	12

/* Solution Methods */

#define EXACT 	13
#define APPROX 14
#define CANON 	15

/* Service-demand Types */

#define VISITS	16
#define DEMAND 17

/* MP scalability */

#define PDQ_SP 		18	/* uniprocessor */
#define PDQ_MP 		19	/* multiprocessor */

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


//---- FUNCION PROTOTYPES -------------------------------------------------


int     PDQ_CreateClosed(char *name, int should_be_class, double pop, double think);
int     PDQ_CreateClosed_p(char *name, int should_be_class, double *pop, double *think);
// Define the workload for a closed-circuit queueing model

int     PDQ_CreateOpen(char *name, double lambda);
int     PDQ_CreateOpen_p(char *name, double *lambda);
// Define the workload in an open-circuit queueing * model.

int     PDQ_CreateNode(char *name, int device, int sched); 
// Define a single queueing center in either a closed or open circuit

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

