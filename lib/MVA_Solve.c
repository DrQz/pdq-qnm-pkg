/*
 * MVA_Solve.c
 * 
 * Copyright (c) 1995-2007 Performance Dynamics Company
 * 
 * Revised by NJG: 20:05:52  7/28/95
 * Updated by NJG: 6:28:39 PM Mon, Apr 2, 2007
 * 
 *  $Id$
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

#define    MAXTP      (1e9)    

void PDQ_Solve(int meth)
{
    extern int        DEBUG, method, streams, nodes;
    extern int        centers_declared, streams_declared;
    extern JOB_TYPE  *job;
    extern NODE_TYPE *node;
    extern char       s1[], s2[], s3[], s4[];

    int               should_be_class;
    int               k, c;
    int               m; 	// MSQ servers (added by NJG)
    double            maxXX;
    double            maxTP = MAXTP;
    double            maxD  = 0.0;
    double            demand;
    char             *p = "solve()";
    extern double     sumD;

    if (DEBUG)
        debug(p, "Entering");

    /* There'd better be a job[0] or you're in trouble !!!  */

    method = meth;

    switch (method) {
        case EXACT:
            if (job[0].network != CLOSED) { // bail !!
                typetostr(s2, job[0].network);
                typetostr(s3, method);
                sprintf(s1,
                   "Network should_be_class \"%s\" is incompatible with \"%s\" method",
                    s2, s3);
                errmsg(p, s1);
            }

            switch (job[0].should_be_class) {
                case TERM:
                case BATCH:
                    exact();
                    break;
                default:
                    break;
            }
            break;

        case APPROX:
            if (job[0].network != CLOSED) { // bail !! 
                typetostr(s2, job[0].network);
                typetostr(s3, method);
                sprintf(s1,
                "Network should_be_class \"%s\" is incompatible with \"%s\" method",
                    s2, s3);
                errmsg("solve()", s1);
            }
            switch (job[0].should_be_class) {
                case TERM:
                case BATCH:
                    approx();
                    break;
                default:
                    break;
            }
            break;

        case CANON:
            if (job[0].network != OPEN) {   // bail !! 
                typetostr(s2, job[0].network);
                typetostr(s3, method);
                sprintf(s1,
                    "Network should_be_class \"%s\" is incompatible with \"%s\" method",
                    s2, s3);
                errmsg(p, s1);
            }
            canonical();
            break;

        default:
            typetostr(s3, method);
            sprintf(s1, "Unknown  method \"%s\"", s3);
            errmsg(p, s1);
            break;
    };

    /* Now compute bounds */

    for (c = 0; c < streams; c++) {
        sumD = maxD = 0.0;
        should_be_class = job[c].should_be_class;

        for (k = 0; k < nodes; k++) {
            // fprintf(stderr, "c %d  k %d\n", c, k);

            demand = node[k].demand[c];

            if (node[k].sched == ISRV && job[c].network == CLOSED)
                demand /= (should_be_class == TERM) ? job[c].term->pop : job[c].batch->pop;

			// Find largest demand across all nodes
            if (demand > maxD) {
                maxD = demand;
			}
			
            sumD += node[k].demand[c];
            
			// Added by NJG on Mon, Apr 2, 2007
			// Find largest thruput across all nodes and multinodes
			if (node[k].sched == MSQ) {
				m = node[k].devtype; // contains number of servers
				maxXX = m / demand;
            } else {
                maxXX = 1 / demand;
            }
            
            // The LEAST of these max X's will throttle the system X
			if (maxXX < maxTP) {
                maxTP = maxXX;
			}
            
        }  // loop over k 

        switch (should_be_class) {
            case TERM:
                job[c].term->sys->maxN = (sumD + job[c].term->think) / maxD;
                job[c].term->sys->maxTP = 1.0 / maxD;
                job[c].term->sys->minRT = sumD;
                if (sumD == 0) {
                    getjob_name(s1, c);
                    sprintf(s2, "Sum of demands is zero for workload \"%s\"", s1);
                    errmsg(p, s2);
                }
                break;
            case BATCH:
                job[c].batch->sys->maxN = sumD / maxD;
                job[c].batch->sys->maxTP = 1.0 / maxD;
                job[c].batch->sys->minRT = sumD;
                if (sumD == 0) {
                    getjob_name(s1, c);
                    sprintf(s2, "Sum of demands is zero for workload \"%s\"", s1);
                    errmsg(p, s2);
                }
                break;
            case TRANS:
				job[c].trans->sys->maxTP = maxTP;                          
                job[c].trans->sys->minRT = sumD;
                if (sumD == 0) {
                    getjob_name(s1, c);
                    sprintf(s2, "Sum of demands is zero for workload \"%s\"", s1);
                    errmsg(p, s2);
                }
                break;
            default:
                break;
        }
        
    }  // loop over c 

    if (DEBUG)
        debug(p, "Exiting");
        
}  // PDQ_Solve

//-------------------------------------------------------------------------

