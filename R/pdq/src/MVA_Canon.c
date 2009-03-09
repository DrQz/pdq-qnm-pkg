/*
 * MVA_Canon.c
 * 
 * Copyright (c) 1995-2006 Performance Dynamics Company. All Rights Reserved.
 * 
 * Updated by NJG on Sat May 13 10:01:19 PDT 2006
 * Revised by NJG on Mon, Apr 2, 2007 (for MSQ erlang solution)
 *
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

void canonical(void)
{
    extern int        PDQ_DEBUG, streams, nodes;
    extern char       s1[], s2[], s3[], s4[];
    extern JOB_TYPE  *job;
    extern NODE_TYPE *node;
    extern double     ErlangR(double arrivrate, double servtime, int servers); // ANSI

    int               k;
    int               m; // servers in MSQ case
    int               c = 0;
    double            X;
    double            Xsat;
    double            Dsat = 0.0;
    double            Ddev;
    double            sumR[MAXSTREAMS];
    double            devU;
    double            sumU();
    char              jobname[MAXBUF];
    char             *p = "canonical()";

    if (PDQ_DEBUG)
        debug(p, "Entering");

    for (c = 0; c < streams; c++) {
        sumR[c] = 0.0;
        X = job[c].trans->arrival_rate;

                
        // find the bottleneck node (i.e., largest service demand) 
        for (k = 0; k < nodes; k++) {
        	// Hope to remove single class restriction
        	if (node[k].sched == MSQ && streams > 1) {
				sprintf(s1, "Only single PDQ stream allowed with MSQ nodes.");
				errmsg(p, s1);
            }
            Ddev = node[k].demand[c];
            if (node[k].sched == MSQ) {     // multiserver case
                m = node[k].devtype;        // contains number of servers > 0
                Ddev /= m;
            }
            if (Ddev > Dsat) {
                Dsat = Ddev;
            }
        }

        if (Dsat == 0) {
            sprintf(s1, "Dsat = %3.3f", Dsat);
            errmsg(p, s1);
        }

        job[c].trans->saturation_rate = Xsat = 1.0 / Dsat;

        if (X > job[c].trans->saturation_rate) {
            sprintf(s1,
                "\nArrival rate %3.3f exceeds saturation throughput %3.3f = 1/%3.3f",
                X, Xsat, Dsat);
            errmsg(p, s1);
        }

        for (k = 0; k < nodes; k++) {
            node[k].utiliz[c] = X * node[k].demand[c];
            if (node[k].sched == MSQ) {     // multiserver case
                m = node[k].devtype;            // recompute m in every k-loop
                node[k].utiliz[c] /= m;     // per server
            }

            devU = sumU(k); // sum all workload classes

            if (devU > 1.0) {
                sprintf(s1, "\nTotal utilization of node \"%s\" is %2.2f%% (> 100%%)",
                    node[k].devname,
                    devU * 100
                    );
                errmsg(p, s1);
            }

            if (PDQ_DEBUG)
                printf("Tot Util: %3.4f for %s\n", devU, node[k].devname);

            switch (node[k].sched) {
                case FCFS:
                case PSHR:
                case LCFS:
                    node[k].resit[c] = node[k].demand[c] / (1.0 - devU);
                    node[k].qsize[c] = X * node[k].resit[c];
                    break;
                case MSQ: // Added by NJG on Mon, Apr 2, 2007
                    node[k].resit[c] = ErlangR(X, node[k].demand[c], m);
                    node[k].qsize[c] = X * node[k].resit[c];
                    break;
                case ISRV:
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
            
        }  // loop over k

        job[c].trans->sys->thruput = X;             // system throughput
        job[c].trans->sys->response = sumR[c];      // system response time 
        job[c].trans->sys->residency = X * sumR[c]; // total number in system

        if (PDQ_DEBUG) {
            getjob_name(jobname, c);
            printf("\tX[%s]: %3.4f\n", jobname, job[c].trans->sys->thruput);
            printf("\tR[%s]: %3.4f\n", jobname, job[c].trans->sys->response);
            printf("\tN[%s]: %3.4f\n", jobname, job[c].trans->sys->residency);
        }
        
    }  // loop over c

    if (PDQ_DEBUG)
        debug(p, "Exiting");

}  // canonical

//-------------------------------------------------------------------------

double sumU(int k)
{
    extern int        PDQ_DEBUG, streams, nodes;
    extern JOB_TYPE  *job;
    extern NODE_TYPE *node;


    int               c;
    double            sum = 0.0;
    char             *p = "sumU()";

    for (c = 0; c < streams; c++) {
        //sum += (job[c].trans->arrival_rate * node[k].demand[c]);
        sum += node[k].utiliz[c];
    }

    return (sum);
}   // sumU 

//-------------------------------------------------------------------------
