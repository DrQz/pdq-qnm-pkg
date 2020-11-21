/*******************************************************************************/
/*  Copyright (C) 1994 - 2016, Performance Dynamics Company                    */
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
 * MVA_Approx.c
 * 
 * Last revised by NJG: 14:14:59  7/16/95
 * Last Updated by PJP: Nov 3, 2012
 * 
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "PDQ_Lib.h"


//-------------------------------------------------------------------------

void approx(void)
{
	extern int        PDQ_DEBUG, iterations, method, streams, nodes;
	extern char       s1[], s2[], s3[], s4[];
	extern double     tolerance;
	extern JOB_TYPE  *job;
	extern NODE_TYPE *node;
	extern void       typetostr();
	extern void       getjob_name();

	int               k, c;
	int               should_be_class;
	double            sumQ();
	double            sumR[MAXSTREAMS];
	double            delta = 2 * TOL;
	int               iterate;
	char              jobname[MAXBUF];
	NODE_TYPE        *last;
	char             *p = "approx()";

	if (PDQ_DEBUG)
		debug(p, "Entering");

	if (nodes == 0 || streams == 0)
		errmsg(p, "Network nodes and streams not defined.");
#ifndef __R_PDQ
	if ((last = (NODE_TYPE *) calloc(sizeof(NODE_TYPE), nodes)) == NULL)
#else
	  if ((last = (NODE_TYPE *) Calloc((size_t) nodes,  NODE_TYPE )) == NULL)
#endif
		errmsg(p, "Node (last) allocation failed!\n");

	iterations = 0;

	if (PDQ_DEBUG) {
		sprintf(s1, "\nIteration: %d", iterations);
		debug(p, s1);
		resets(s1);
	}

	/* initialize all queues */

	for (c = 0; c < streams; c++) {
		should_be_class = job[c].should_be_class;

		for (k = 0; k < nodes; k++) {
			switch (should_be_class) {
				case TERM:
					last[k].qsize[c] = node[k].qsize[c] = job[c].term->pop / nodes;
					break;
				case BATCH:
					last[k].qsize[c] = node[k].qsize[c] = job[c].batch->pop / nodes;
					break;
				default:
					break;
			}

			if (PDQ_DEBUG) {
				getjob_name(jobname, c);
				sprintf(s2, "Que[%s][%s]: %3.4f (D=%f)",
					node[k].devname,
					jobname,
					node[k].qsize[c],
					delta);
				debug(p, s2);
				resets(s2);
				resets(jobname);
			}
		}  /* over k */
	}  /* over c */

	do {
		iterations++;

		if (PDQ_DEBUG) {
			sprintf(s1, "\nIteration: %d", iterations);
			debug(p, s1);
			resets(s1);
		}

		for (c = 0; c < streams; c++) {
			getjob_name(jobname, c);

			sumR[c] = 0.0;

			if (PDQ_DEBUG) {
				sprintf(s1, "\nStream: %s", jobname);
				debug(p, s1);
				resets(s1);
			}

			should_be_class = job[c].should_be_class;

			for (k = 0; k < nodes; k++) {
				if (PDQ_DEBUG) {
					sprintf(s2, "Que[%s][%s]: %3.4f (D=%1.5f)",
						node[k].devname,
						jobname,
						node[k].qsize[c],
						delta);
					debug(p, s2);
					resets(s1);
				}

				/* approximate avg queue length */

				switch (should_be_class) {
					double  N;
					case TERM:
						N = job[c].term->pop;
						node[k].avqsize[c] = sumQ(k, c) +
							(node[k].qsize[c] * (N - 1.0) / N);
						break;
					case BATCH:
						N = job[c].batch->pop;
						node[k].avqsize[c] =
							sumQ(k, c) + (node[k].qsize[c] * (N - 1.0) / N);
						break;
					default:
						typetostr(s1, should_be_class);
						sprintf(s2, "Unknown should_be_class: %s", s1);
						errmsg(p, s2);
						resets(s2);
						break;
					}

					if (PDQ_DEBUG) {
						sprintf(s2, "<Q>[%s][%s]: %3.4f (D=%1.5f)",
							node[k].devname,
							jobname,
							node[k].avqsize[c],
							delta
					);
					debug(p, s2);
					resets(s2);
			}

			/* residence times */

			switch (node[k].sched) {
				case FCFS:
				case PSHR:
				case LCFS:
					node[k].resit[c] =
				node[k].demand[c] * (node[k].avqsize[c] + 1.0);
					break;
				case ISRV:
					node[k].resit[c] = node[k].demand[c];
					break;
				default:
					typetostr(s1, node[k].sched);
					sprintf(s2, "Unknown queue type: %s", s1);
					errmsg(p, s2);
					break;
			}

			sumR[c] += node[k].resit[c];


			if (PDQ_DEBUG) {
				PRINTF("\tTot ResTime[%s] = %3.4f\n", jobname, sumR[c]);

				PRINTF("\tnode[%s].qsize[%s] = %3.4f\n",
					node[k].devname,
					jobname,
					node[k].qsize[c]
				);

				PRINTF("\tnode[%s].demand[%s] = %3.4f\n",
					node[k].devname,
					jobname,
					node[k].demand[c]
				);

				PRINTF("\tnode[%s].resit[%s] = %3.4f\n",
					node[k].devname,
					jobname,
					node[k].resit[c]
				);
			}
		}			/* over k */


		/* system throughput, residency & response-time */

		switch (should_be_class) {
			case TERM:
				job[c].term->sys->thruput =
					(job[c].term->pop / (sumR[c] + job[c].term->think));
				job[c].term->sys->response =
					(job[c].term->pop / job[c].term->sys->thruput) - job[c].term->think;
				job[c].term->sys->residency =
					job[c].term->pop - (job[c].term->sys->thruput * job[c].term->think);

				if (PDQ_DEBUG) {
					sprintf(s2, "\tTERM<X>[%s]: %5.4f",
						jobname, job[c].term->sys->thruput);
					debug(p, s2);
					resets(s2);
					sprintf(s2, "\tTERM<R>[%s]: %5.4f",
						jobname, job[c].term->sys->response);
					debug(p, s2);
					resets(s2);
				}
				break;

			case BATCH:
				job[c].batch->sys->thruput = job[c].batch->pop / sumR[c];
				job[c].batch->sys->response =
					(job[c].batch->pop / job[c].batch->sys->thruput);
				job[c].batch->sys->residency = job[c].batch->pop;

				if (PDQ_DEBUG) {
					sprintf(s2, "\t<X>[%s]: %3.4f",
						jobname, job[c].batch->sys->thruput);
					debug(p, s2);
					resets(s2);
					sprintf(s2, "\t<R>[%s]: %3.4f",
						jobname, job[c].batch->sys->response);
					debug(p, s2);
					resets(s2);
				}

				break;
                default:
                switch (should_be_class) {
                    case TRANS:
                        sprintf(s1, "Unknown should_be_class: %s", "TRANS");
                        errmsg(p, s1);
                        break;
                    case TERM:
                        sprintf(s1, "Unknown should_be_class: %s", "TERM");
                        errmsg(p, s1);
                        break;
                    case BATCH:
                        sprintf(s1, "Unknown should_be_class: %s", "BATCH");
                        errmsg(p, s1);
                        break;
                    default:
                        break;
                }
                break;
			}

			resets(jobname);
		}  /* over c */

		/* update queue sizes */

		for (c = 0; c < streams; c++) {
			getjob_name(jobname, c);
			should_be_class = job[c].should_be_class;
			iterate = FALSE;

			if (PDQ_DEBUG) {
				sprintf(s1, "Updating queues of \"%s\"", jobname);
				PRINTF("\n");
				debug(p, s1);
				resets(s1);
			}

			for (k = 0; k < nodes; k++) {
				switch (should_be_class) {
					case TERM:
						node[k].qsize[c] = job[c].term->sys->thruput * node[k].resit[c];
						break;
					case BATCH:
						node[k].qsize[c] = job[c].batch->sys->thruput * node[k].resit[c];
						break;
					default:
                        switch (should_be_class) {
                            case TRANS:
                                sprintf(s1, "Unknown should_be_class: %s", "TRANS");
                                errmsg(p, s1);
                                break;
                            case TERM:
                                sprintf(s1, "Unknown should_be_class: %s", "TERM");
                                errmsg(p, s1);
                                break;
                            case BATCH:
                                sprintf(s1, "Unknown should_be_class: %s", "BATCH");
                                errmsg(p, s1);
                                break;
                            default:
                                break;
                        }
						break;
				}

				/* check convergence */

				delta = fabs((double) (last[k].qsize[c] - node[k].qsize[c]));

				if (delta > tolerance)	/* for any node */
					iterate = TRUE;	/* but complete all queue updates */

				last[k].qsize[c] = node[k].qsize[c];

				if (PDQ_DEBUG) {
					sprintf(s2, "Que[%s][%s]: %3.4f (D=%1.5f)",
						node[k].devname,
						jobname,
						node[k].qsize[c],
						delta);
					debug(p, s2);
					resets(s2);
				}
			}			/* over k */

			resets(jobname);
		}				/* over c */

		if (PDQ_DEBUG)
			debug(p, "Update complete");
	} while (iterate);

	/* cleanup */

	if (last) {
	  PDQ_FREE(last); 
	  last = NULL; 
	}

	if (PDQ_DEBUG)
		debug(p, "Exiting");
}  /* approx */

//-------------------------------------------------------------------------

double sumQ(int k, int skip)
{
	extern int        streams;
	extern NODE_TYPE *node;

	int               c;
	double            sum = 0.0;

	for (c = 0; c < streams; c++) {
		if (c == skip)
			continue;
		sum += node[k].qsize[c];
	}

	return (sum);
}  /* sumQ */

//-------------------------------------------------------------------------


