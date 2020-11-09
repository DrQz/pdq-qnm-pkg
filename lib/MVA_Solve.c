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
 * MVA_Solve.c
 * 
 * Revised by NJG: 20:05:52  7/28/95
 * Updated by NJG: 6:28:39 PM Mon, Apr 2, 2007
 * Updated by NJG: Wednesday, February 6, 2013 - flag MSQ node if CLOSED network
 * NJG on Sunday, May 15, 2016   - Moved incomplete circuit detection from PDQ_Report()
 * NJG on Saturday, May 21, 2016 - Verified incomplete PDQ circuit detection works
 * NJG on May 8, 2016 - Added APPROXMSQ for M/M/m queue 
 * Updated by NJG on Saturday, December 29, 2018 New MSO, MSC multi-server devtypes
 *
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

#define    MAXTP      (1e9)    

void PDQ_Solve(int meth)
{
    extern int        PDQ_DEBUG, method, streams, nodes, demands; //in PDQ_Global.h
    extern int        centers_declared, streams_declared;
    extern JOB_TYPE  *job;
    extern NODE_TYPE *node;
    extern char       s1[], s2[], s3[], s4[];

    int               should_be_class;
    int               k, c;
    int               mservers = 0; // MSQ servers (added by NJG)
    double            maxXX;
    double            maxTP = MAXTP;
    double            maxD  = 0.0;
    double            demand;
    char             *p = "solve()";
    extern double     sumD;

    if (PDQ_DEBUG)
        debug(p, "Entering");

    /* There'd better be a job[0] or you're in trouble !!!  */
    
    // NJG on Sunday, May 15, 2016 moved warning from Report() to halt execution here.
    // This action was promised in the 6.2.0 release of PDQ.
    if (!streams) {
        //PRINTF("PDQ_Solve warning: No PDQ workload defined.\n");
        sprintf(s1, "PDQ_Solve: No PDQ workload defined.\n");
        errmsg(p, s1);
    }
    
    if (!nodes) {
        //PRINTF("PDQ_Solve warning: No PDQ nodes defined.\n");
        sprintf(s1, "PDQ_Solve: No PDQ nodes defined.\n");
        errmsg(p, s1);
    }
    
    if (!demands) {
        //PRINTF("PDQ_Solve warning: No PDQ service demands defined.\n");
        sprintf(s1, "PDQ_Solve: No PDQ service demands defined.\n");
        errmsg(p, s1);
    }
    
    method = meth;

    switch (method) {
        case EXACT:
            if (job[0].network != CLOSED) { // bail
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
                    exact(); // in PDQ_Exact.c
                    break;
                default:
                    break;
            }
            break;

        case APPROX:
            if (job[0].network != CLOSED) { // bail 
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
                    approx(); // in MVA_Approx.c
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
            canonical(); // in MVA_Canon.c
            break;

        case APXMSO: // Added by NJG on May 8, 2016
            if (job[0].network != OPEN) { 
                typetostr(s2, job[0].network);
                typetostr(s3, method);
                sprintf(s1,
                        "Network should_be_class \"%s\" is incompatible with \"%s\" method",
                        s2, s3);   // bail
                errmsg(p, s1);
            }
            canonical(); // in MVA_Canon.c
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
			if (node[k].devtype == MSO) {
				mservers = node[k].servers; // contains number of servers
				maxXX = mservers / demand;
            } else {
                maxXX = 1 / demand;
            }
            
            // The LEAST of these max X's will throttle the system-X
			if (maxXX < maxTP) {
                maxTP = maxXX;
			}
            
        }   // loop over k
        
        
        if(job[c].network == CLOSED && mservers != 0) { //bail !!
        // Solving MSQ node in CLOSED network is not logically compatible
        	typetostr(s2, job[c].network);
            sprintf(s1, "Network class \"%s\" is incompatible with \"CreateMultiNode\" function", s2);
            errmsg(p, s1);
        } 

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
        
    }   // loop over c

    if (PDQ_DEBUG)
        debug(p, "Exiting");
        
}  // end of PDQ_Solve

