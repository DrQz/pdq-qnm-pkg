/*******************************************************************************/
/*  Copyright (c) 1994--2021, Performance Dynamics Company                    */
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
 * MVA_Canon.c
 * 
 * Updated by NJG on Saturday, May 13, 2006.     Reviewed for Perl::PDQ book release (1st edn.)
 * Revised by NJG on Monday, Apr 2, 2007.        Added MSQ Erlang multiserver
 * Revised by NJG on Friday, June 26, 2009.      See function: sumU(int k)
 * Revised by NJG on Tuesday, March 1, 2011.     Set Dsat=0.0 in each c-loop iteration (Newsom)
 * Updated by PJP on Saturday, Nov 3, 2012.      Added R support
 * Updated by NJG on Saturday, January 12, 2013. Changed devU to perServerU
 * Updated by NJG on Saturday, May 7, 2016.      Added approximate multiclass multiserver
 * Updated by NJG on Sunday, May 8, 2016.        Must choose APPROX solution method with
 *                                               multiclass multiserver MSO nodes
 * Updated by NJG on Tuesday, May 24, 2016.      Cleaned up compiler wornings about unused variables
 * Updated by NJG on Saturday, Dec 29, 2018      New MSO, MSC multi-server devtypes
 * Updated by NJG on Wed Nov 18, 2020            Added STREAMING method name
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

void canonical(void)
{
    extern int        method; 
    extern int        streams, nodes;
    extern char       s1[], s2[], s3[], s4[];
    extern JOB_TYPE  *job;
    extern NODE_TYPE *node;
    extern double     sumD;
    extern int        PDQ_DEBUG;


	// ErlangR function is in PDQ_MServer.c
    extern double     ErlangR(double arrivrate, double servtime, int servers); 
    

    int               k;
    int               m = 1; // default servers in MSO device
    int               c = 0;
    double            X;
    double            Xsat;
    double            Dsat;
    double            Ddev;
    double            sumR[MAXSTREAMS];
    double            perServerU = 0.0;
    double            sumU();
    char              jobname[MAXBUF];
    char              satname[MAXBUF];
    char             *p = "canonical()";

    if (PDQ_DEBUG)
        debug(p, "Entering");

    for (c = 0; c < streams; c++) {
        sumR[c] = 0.0;
        
        sumD = 0;
        
        Dsat = 0.0; // default on each pass thru loop
        // Fix submitted by James Newsom, 23 Feb 2011
        //Otherwise, stream index can be compared to wrong (old) device index

        X = job[c].trans->arrival_rate;
               
        // find bottleneck node (== largest service demand)
        for (k = 0; k < nodes; k++) {
        	// Hope to remove single class restriction eventually
            // And today is the day: Sun May  8 18:34:27 PDT 2016
        	if (node[k].devtype == MSO && streams > 1) {
                if (method == CANON || method == STREAMING) {
                    sprintf(s1, "Only single PDQ stream allowed with MSO nodes.");
                    // APPROXMSQ method not implemented in PDQ 7 --NJG
                    //sprintf(s1, "Must use APPROXMSQ method with multi-stream MSO nodes.");
                    errmsg(p, s1);
                }
            }
            Ddev = node[k].demand[c]; // from SetDemand in either CEN or MSO
            if (node[k].devtype == MSO) { // multiserver case
                m = node[k].servers;	  // overrides m=1 initialized default
            }
            if (Ddev > Dsat) { // Dsat = 0 initially
                Dsat = Ddev;   // updated value
                // About to fall out this k-loop so keep devname in case of error msg
                sprintf(satname, "%s", node[k].devname);
            }
            
            sumD += node[k].demand[c];
            
        } // end of k-loop
        
        
        if (Dsat == 0) {
            sprintf(s1, "Dsat = %3.3f", Dsat);
            errmsg(p, s1);
        }

        Xsat = m / Dsat; // includes multi-server case
        job[c].trans->saturation_rate = Xsat;

        if (X > Xsat) {
        	getjob_name(jobname, c);
            sprintf(s1, 
            	"\nArrival rate %3.3f for stream \'%s\' exceeds saturation thruput %3.3f of node \'%s\' with demand %3.3f", 
            	X, jobname, Xsat, satname, Dsat
            );  
        	errmsg(p, s1);
        }
        
        for (k = 0; k < nodes; k++) {
            node[k].utiliz[c] = X * node[k].demand[c];
            if (node[k].devtype == MSO) { // multiserver OPEN queue case
                m = node[k].servers;    // recompute m in each k-iteration
                node[k].utiliz[c] /= m; // per server
            }

        	// Sum over all workload classes on dev k
        	// Uses node[k].utiliz[c] per server for MSQ case
        	// Also used below for R = D/(1-U) in single node case
        	perServerU = sumU(k); 

            if (PDQ_DEBUG) // Call here or won't appear if perServerU > 1 error
                PRINTF("Tot Util: %3.4f for %s\n", perServerU, node[k].devname);

            if (perServerU > 1.0) {
                sprintf(s1, "\nTotal utilization of node \"%s\" is %2.2f%% (> 100%%)",
                    node[k].devname,
                    perServerU * 100
                    );
                errmsg(p, s1);
            }

            switch (node[k].devtype) {
                //case FCFS:
                //case PSHR:
                case CEN: // Queue service schedules
                    node[k].resit[c] = node[k].demand[c] / (1.0 - perServerU);
                    node[k].qsize[c] = X * node[k].resit[c];
                    break;
                case MSO:  // This denotes M/M/m type node
                    if (streams == 1) {
                        // Added by NJG on Monday, Apr 2, 2007
                        // Use exact solution
                        node[k].resit[c] = ErlangR(X, node[k].demand[c], m);
                    } else { // multiple workload streams
                        // Added by NJG on Saturday, May 7, 2016
                        // Use approximate solution
                        node[k].resit[c] = node[k].demand[c] / (1 - pow(perServerU,m));
                    }
                    node[k].qsize[c] = X * node[k].resit[c];
                    break;
                case DLY:
                    node[k].resit[c] = node[k].demand[c];
                    node[k].qsize[c] = node[k].utiliz[c];
                    break;
                default:
                    typetostr(s1, node[k].sched);
                    sprintf(s2, "Unknown queue type: %s", s1);
                    errmsg(p, s2);
                    break;
            }
            
            sumR[c] += node[k].resit[c];
            
        }  // end of k-loop

        job[c].trans->sys->thruput = X;             // system throughput
        job[c].trans->sys->response = sumR[c];      // system response time 
        job[c].trans->sys->residency = X * sumR[c]; // total number in system
        job[c].trans->sys->minRT = sumD;            // Added by NJG on Wed Nov 18, 2020

        if (PDQ_DEBUG) {
            getjob_name(jobname, c);
            PRINTF("\tX[%s]: %3.4f\n", jobname, job[c].trans->sys->thruput);
            PRINTF("\tR[%s]: %3.4f\n", jobname, job[c].trans->sys->response);
            PRINTF("\tN[%s]: %3.4f\n", jobname, job[c].trans->sys->residency);
        }
        
    }  // end of c-loop

    if (PDQ_DEBUG)
        debug(p, "Exiting");

}  // canonical



double sumU(int k)
{
	// Compute the total utilization for device k
	
    extern int        PDQ_DEBUG, streams, nodes;
    extern            JOB_TYPE  *job;
    extern            NODE_TYPE *node;


    int               c;
    double            sum = 0.0;
    //char             *p = "sumU()";

    for (c = 0; c < streams; c++) {
    	// NJG on Sunday, June 28, 2009 7:29:45 PM
        // The following if-else is a hack b/c multi-class workloads
        // and multi-servers are currently incompatible.
         if (node[k].devtype == MSO) {
         	sum += node[k].utiliz[c];
         } else {  // CEN device
         	sum += (job[c].trans->arrival_rate * node[k].demand[c]);
         }
    }

    return (sum);
    
}   // sumU 

