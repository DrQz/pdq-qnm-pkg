/*******************************************************************************
 *  Copyright (C) 2007 - 2021, Performance Dynamics Company                    
 *
 * Collection of subroutines to solve multiserver queues:
 * 		+ ErlangR returns the residence for an M/M/m queue.
 *      + MServerFESC solves single M/M/m/N/N queue
 *
 * NJG on Monday, December 18, 2017
 * This is prototype version of M/M/m/N/N FESC
 * Ultimately will be integrated into PDQ_MServer.c
 * 
 * Created by NJG on Monday, April 2, 2007       - Implemented ErlangR
 * Updated by NJG on Monday, December 18, 2017   - Failed implementation of MServerFESC
 * Updated by NJG on Saturday, December 19, 2018 - Working implementation of MServerFESC
 *
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
extern double sm_x[MAX_USERS + 1]; //declared in PDQ_Globals.c


void MServerFESC(void) {
// Called from exact() in PDQ_Exact.c

	extern int        streams, nodes;
	extern            NODE_TYPE *node;
	extern            JOB_TYPE  *job;
	extern char       s1[], s2[], s3[], s4[];
	extern double     getjob_pop();

	int i, j;
	int c, k, c_fesc, k_fesc;
    int n;
    int m;
    int N;
    double D;
    double Z;
    
    double R;      // residence time 
	double Q;      // no. customers 
	double X;      // mean thruput
	double U;      // total utilization
	
    float           pq[MAX_USERS + 1][MAX_USERS + 1]; 
    double          sumR[MAXCLASS] = {0.0, 0.0, 0.0};
	char            *p = "MServerFESC()";
    
	void            MServers(int pop, int servers, float demand);
	
	//Added by NJG on Saturday, December 29, 2018
	for (c = 0; c < streams; c++) {
		c_fesc = c;
		if (c_fesc > 0) {
			sprintf(s1, "Streams=%d but only single workload allowed with MSC node", c_fesc);
			errmsg(p, s1);
		}
	
		for (k = 0; k < nodes; k++) {
			k_fesc = k;
			if (k_fesc > 0) {
			sprintf(s1, "Node=%d but only single node allowed with MSC type", k_fesc);
			errmsg(p, s1);
			}
		}
	}

    m = node[k_fesc].servers;  //Added by NJG on Saturday, December 29, 2018
    N = job[c_fesc].term->pop;
    D = node[k_fesc].demand[c_fesc];
    Z = job[c_fesc].term->think;

	if (N > MAX_USERS) {
        sprintf(s1, "N=%d must not exceed %d\n", N, MAX_USERS);
        errmsg(p, s1);		
	}	
	
	for (i = 0; i <= N; i++) {
		for (j = 0; j <= N; j++) {
			pq[i][j] = 0;
		}
	}
	
	pq[0][0] = 1.0;
	
	// Solve the multiple servers submodel
    MServers(N, m, D);

	// Solve the composite model
    for (n = 1; n <= N; n++) {
    
        R = 0.0;                // reset

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

    U = X * D;
    
    // collect queueing results
	switch (job[c_fesc].should_be_class) {
		case TERM:
			job[c_fesc].term->sys->thruput = X;
			job[c_fesc].term->sys->response = R;
			break;
		case BATCH:
			job[c_fesc].batch->sys->thruput = X;
			job[c_fesc].batch->sys->response = R;
			break;
		default:
			break;
	}
	
	node[k_fesc].qsize[c_fesc] = Q;
	node[k_fesc].resit[c_fesc] = R;
	sumR[c_fesc] += node[k_fesc].resit[c_fesc];
	node[k_fesc].utiliz[c_fesc] = U;
		
} // end of MServerFESC 


void MServers(int pop, int servers, float demand) {
//Multiple servers are a delay center with no waiting line
//Called by MServerFESC() in this module
//Submodel thruput declared in PDQ_Globals.c

    int             i;
    
    for (i = 0; i <= pop; i++) {
        if (i <= servers) {
            sm_x[i] = (double) i / demand;
        } else {
            sm_x[i] = (double) servers / demand;
        }
    }
    
} // end of MServers 


