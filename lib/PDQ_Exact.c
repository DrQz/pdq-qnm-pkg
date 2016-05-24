/*******************************************************************************/
/*  Copyright (C) 1994 - 2013, Performance Dynamics Company                    */
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
 * PDQ_Exact.c (not full MVA_Exact.c)
 * 
 * Updated by NJG on 02:44:17 AM  2/23/97
 * The book release only permits up to 3 classes of workload 
 * and thus, only a 3-deep loop.
 * Hence, PDQ_Exact and not MVA_Exact, which uses recurseration.
 * 
 * Edited by NJG: Fri Feb  5 16:58:09 PST 1999
 * 	Fix N=1 stability problem
 * 
 * Updated by PJP: Sat Nov 3 2012: Added supported for R
 *
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

#define	MAXPOP1	 1000
#define	MAXPOP2	 1000
#define	MAXDEVS	 10
#define MAXCLASS  3

//-------------------------------------------------------------------------

static double    qlen[MAXPOP1][MAXPOP2][MAXDEVS];

//-------------------------------------------------------------------------

void exact(void)
{
	extern int        streams, nodes;
	extern            NODE_TYPE *node;
	extern            JOB_TYPE  *job;
	extern char       s1[], s2[], s3[], s4[];
	extern double     getjob_pop();

	char             *p = "exact()";
	int               c, k;
	int               n0, n1, n2;
	int               pop[MAXCLASS] = {0, 0, 0};	/* pop vector */
	int               N[MAXCLASS] = {0, 0, 0};	/* temp counters */
	double            sumR[MAXCLASS] = {0.0, 0.0, 0.0};

#undef DMVA

	if (streams > MAXCLASS) {
		PRINTF("Streams = %d", streams);
		sprintf(s1, "%d workload streams exceeds maximum of 3.\n", streams);
		//sprintf(s2, "(At workload: \"%s\" with population: %3.2f)\n", s3, getjob_pop(c));
		//strcat(s1, s2);
		errmsg(p, s1);
	}

	for (c = 0; c < streams; c++) {
		pop[c] = (int) ceil((double) getjob_pop(c));

#ifdef DMVA
		fprintf(stderr, "pop[%d]: %2d\n", c, pop[c]);
#endif

		if (pop[c] > MAXPOP1 || pop[c] > MAXPOP2) {
			sprintf(s1, "Pop %d > allowed:\n", pop[c]);
			sprintf(s2, "max1: %d\nmax2: %d\n", MAXPOP1, MAXPOP2);
			strcat(s1, s2);
			errmsg(p, s1);
		}
	}


	/* initialize lowest queue configs on each device */

	for (k = 0; k < nodes; k++) {
		qlen[0][0][k] = 0.0;
	}

	/* MVA loop starts here .... */

	for (n0 = 0; n0 <= pop[0]; n0++) {
		for (n1 = 0; n1 <= pop[1]; n1++) {
			for (n2 = 0; n2 <= pop[2]; n2++) {
				if (n0 + n1 + n2 == 0)
					continue;
				N[0] = n0;
				N[1] = n1;
				N[2] = n2;

#ifdef DMVA
				fprintf(stderr, "N[%d,%d,%d]\t", n0, n1, n2);
#endif

				for (c = 0; c < MAXCLASS; c++) {
					sumR[c] = 0.0;
					if (N[c] == 0)
						continue;

					N[c] -= 1;
					for (k = 0; k < nodes; k++) {
#ifdef DMVA
						fprintf(stderr, "Q[%d,%d,%d](c:%d)-->", n0, n1, n2, c);
						fprintf(stderr, "Q[%d,%d,%d]: %6.4f\t", N[1], N[2], k, qlen[N[1]][N[2]][k]);
#endif
						node[k].qsize[c] = qlen[N[1]][N[2]][k];
						node[k].resit[c] = node[k].demand[c] * (1.0 + node[k].qsize[c]);
						sumR[c] += node[k].resit[c];
#ifdef DMVA
						fprintf(stderr, "R(%d)=%4.2f\n", c, sumR[c]);
#endif
					}

					N[c] += 1;

					switch (job[c].should_be_class) {
						case TERM:
							if (sumR[c] == 0)
								errmsg(p, "sumR is zero");
							job[c].term->sys->thruput = N[c] / (sumR[c] + job[c].term->think);
#ifdef DMVA
							fprintf(stderr, "X(%d)=%6.4f\n", c, job[c].term->sys->thruput);
#endif
							job[c].term->sys->response =
								(N[c] / job[c].term->sys->thruput) - job[c].term->think;
							job[c].term->sys->residency =
								N[c] - (job[c].term->sys->thruput * job[c].term->think);
							break;
						case BATCH:
							if (sumR[c] == 0)
								errmsg(p, "sumR is zero");
							job[c].batch->sys->thruput = N[c] / sumR[c];
							job[c].batch->sys->response = N[c] / job[c].batch->sys->thruput;
							job[c].batch->sys->residency = N[c];
							break;
						default:
							break;
					}
				}

				for (k = 0; k < nodes; k++) {
					qlen[n1][n2][k] = 0.0;
					for (c = 0; c < MAXCLASS; c++) {
						if (N[c] == 0)
							continue;

						switch (job[c].should_be_class) {
							case TERM:
								qlen[n1][n2][k] += (job[c].term->sys->thruput * node[k].resit[c]);
								node[k].qsize[c] = qlen[n1][n2][k];
#ifdef DMVA
								fprintf(stderr, "Q(%d)=%6.4f\n", c, node[k].qsize[c]);
#endif
								break;
							case BATCH:
								qlen[n1][n2][k] += (job[c].batch->sys->thruput * node[k].resit[c]);
								node[k].qsize[c] = qlen[n1][n2][k];
								break;
							default:
								break;
						}
					}
				}
			}  /* over n2 */
		}  /* over n1 */
	}  /* over n0 */
}  /* exact */

//-------------------------------------------------------------------------

