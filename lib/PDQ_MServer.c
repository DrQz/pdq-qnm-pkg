/*******************************************************************************
 *  Copyright (C) 2007 - 2021, Performance Dynamics Company                    
 *
 * Collection of subroutines to solve multiserver queues:
 * 		+ ErlangR returns the residence for an M/M/m queue.
 *      + MServerFESC solves single M/M/m/N/N queue
 *
 * NJG on Monday, December 18, 2017
 * 		+ Prototype version of M/M/m/N/N FESC
 * 		+ Ultimately will be integrated into PDQ_MServer.c
 * 
 * Created by NJG on Mon, Apr  2, 2007 - Implemented ErlangR
 * Updated by NJG on Mon, Dec 18, 2017 - Failed implementation of MServerFESC
 * Updated by NJG on Sat, Dec 19, 2018 - Working implementation of MServerFESC
 * Updated by NJG on Mon, Nov 16, 2020 - Tweaked MServerFESC for PDQ 7.0 release
 *
 *******************************************************************************/

 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h> 
#include "PDQ_Lib.h"
 

double ErlangR(double arrivrate, double servtime, int servers) {
// called from MVA_Canon.c 

	extern int   PDQ_DEBUG;
	extern char  s1[];
	extern       JOB_TYPE  *job;

	double		erlangs;
	double		erlangB;
	double		erlangC;
	double		rho;
	double		eb;
	double		wtE;
	double		rtE;
	int		    mm;
	char        *p = "ErlangR()";

	
	erlangs  = arrivrate * servtime;
	
	if (erlangs >= servers) {
		sprintf(s1, "%4.2lf Erlangs saturates %d servers", erlangs, servers);
	    errmsg(p, s1);
	}
	
	rho     = erlangs / servers;
	erlangB = erlangs / (1.0 + erlangs);
	for (mm = 2; mm <= servers; mm++) {
		eb  = erlangB;
		erlangB = eb * erlangs / (mm + (eb * erlangs));
	}
	
	erlangC  = erlangB / (1.0 - rho + (rho * erlangB));
	
	wtE = servtime * erlangC / (servers * (1.0 - rho));
	rtE = servtime + wtE;
	
	if (PDQ_DEBUG) {
		sprintf(s1, "Erlang R: %6.4lf", rtE);
		errmsg(p, s1);
	}
	
	return(rtE);

} // end of ErlangR





// Added by NJG on Thursday, December 27, 2018
// MAX_USERS = 1200 defined in PDQ_Lib.h
extern double sm_x[MAX_USERS + 1]; //declared in PDQ_Globals.c


void MServerFESC(void) {
// Updated by NJG on Mon, Nov 16, 2020
// Now called from PDQ_Solve() in MVA_Solve.c

	extern int        streams, nodes;
	extern            NODE_TYPE *node;
	extern            JOB_TYPE  *job;
	extern char       s1[], s2[], s3[], s4[];
	extern double     getjob_pop(int c);

	int i, j;
	int c; 
	int k;
    int n;
    int m = 0;
    int N = 0;
    
    double D = 0;  // service demand
    double Z = 0;  // think time 
    double R = 0;  // residence time 
	double Q = 0;  // no. customers 
	double X = 0;  // mean thruput
	double U = 0;  // total utilization
	
	void 			MServers(int pop, int servers, float demand); // submodel
	
    float           pq[MAX_USERS + 1][MAX_USERS + 1]; 
    double          sumR[MAXCLASS] = {0.0, 0.0, 0.0};
	char            *p = "MServerFESC()";
    
	
	// Added by NJG on Saturday, December 29, 2018
	// HARDCORE: we only allow a single stream and node in PDQ 7.0
	c = streams - 1;
	if (c > 0) {
		sprintf(s1, "Workload class = %d but only single workload allowed with FESC network", c);
		errmsg(p, s1);
	}
	
	k = nodes - 1;
	if (k > 0) {
		sprintf(s1, "Node=%d but only single node allowed with FESC network", k);
		errmsg(p, s1);
	}

    m = node[k].servers;  //Added by NJG on Saturday, December 29, 2018
    D = node[k].demand[c];
    
    // Updated by NJG on Sun, Nov 22, 2020 to catch BATCH workloads
    if (job[c].should_be_class == TERM) {
   		N = job[c].term->pop;
    	Z = job[c].term->think;
    } else {
       	N = job[c].batch->pop;
    	Z = 0;
    }
        
	if (N > MAX_USERS) {
        sprintf(s1, "N=%d cannot exceed %d\n", N, MAX_USERS);
        errmsg(p, s1);		
	}	
		
	for (i = 0; i <= N; i++) {
		for (j = 0; j <= N; j++) {
			pq[i][j] = 0;
		}
	}
	
	pq[0][0] = 1.0;
	
	// Call the submodel defined below to calculate sm_x[] array
    MServers(N, m, D);


	// Solve the composite model
    for (n = 1; n <= N; n++) {
    
        R = 0.0;  // reset

        // response time at the FESC
        for (j = 1; j <= n; j++) {
            R += (j / sm_x[j]) * pq[j - 1][n - 1];
        }

        // mean thruput and mean qlength at the FESC */
        X = n / (Z + R);
        Q = X * R;
        
        // compute qlength dsn at the FESC */
        for (j = 1; j <= n; j++) {
            pq[j][n] = (X / sm_x[j]) * pq[j - 1][n - 1];
        }

        // include j = 0 row
        pq[0][n] = 1.0;
        for (j = 1; j <= n; j++) {
            pq[0][n] -= pq[j][n];
        }
        
    } // loop over n

	// This is the total utilization across all servers
    U = X * D;
    
    // collect workload results
	switch (job[c].should_be_class) {
		case TERM:
			job[c].term->sys->thruput = X;
			job[c].term->sys->response = R;
			job[c].term->sys->residency = N;
			job[c].term->sys->maxTP = m / D; 
			job[c].term->sys->minRT = D;
			job[c].term->sys->Nopt = (D + Z) * X;
			break;
		case BATCH:
			job[c].batch->sys->thruput = X;
			job[c].batch->sys->response = R;
			job[c].batch->sys->residency = N;
			job[c].batch->sys->maxTP = m / D;
			job[c].batch->sys->minRT = D;
			break;
		default:
			break;
	}
	
	node[k].servers  = m;
	node[k].qsize[c] = Q;
	node[k].resit[c] = R;
	node[k].utiliz[c] = U / m;  // PDQ_Report expects per-server utilization
	sumR[c] += node[k].resit[c];
		
} // end of MServerFESC 



void MServers(int pop, int servers, float demand) {
// Multiple servers are a delay center with no waiting line
// Called by MServerFESC() in this module
// Submodel throughput sm_x[] array declared in PDQ_Globals.c

    int             i;
    
    for (i = 0; i <= pop; i++) {
        if (i <= servers) {
            sm_x[i] = (double) i / demand;
        } else {
            sm_x[i] = (double) servers / demand;
        }
    }
    
} // end of MServers 


