/*******************************************************************************/
/*  Copyright (C) 1994 - 1996, Performance Dynamics Company                    */
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
 * multibus.c
 * 
 * Created by NJG: 13:03:53  07-19-96 Updated by NJG: 19:31:12  07-31-96
 * 
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "PDQ_Lib.h"


//-------------------------------------------------------------------------
/* System parameters */

#define BUSES	9
#define CPUS	64
#define STIME	1.0
#define COMPT	10.0

//-------------------------------------------------------------------------
/* submodel throughput characteristic */

double           sm_x[CPUS + 1];

//-------------------------------------------------------------------------

void multiserver(int m, double stime);

//-------------------------------------------------------------------------

int main()
{
	int             j, n;
	double          xn, qlength, R;
	double          pq[CPUS + 1][CPUS + 1];

	int             i;

	/*cecho2file("multibus.out", 0, stdout);*/

	/* Multibus submodel   */

	// fprintf(stderr, "[main] started\n");

	multiserver(BUSES, STIME);

	/* Composite model   */

	pq[0][0] = 1.0;

	for (n = 1; n <= CPUS; n++) {
		R = 0.0;			/* reset */

		for (j = 1; j <= n; j++)
	 		R += (j / sm_x[j]) * pq[j - 1][n - 1];

		xn = n / (COMPT + R);

		// printf("%3.2f\n", xn * COMPT);

		qlength = xn * R;

		for (j = 1; j <= n; j++) {
	 		pq[j][n] = (xn / sm_x[j]) * pq[j - 1][n - 1];
		}

		pq[0][n] = 1.0;

		for (j = 1; j <= n; j++) {
	 		pq[0][n] -= pq[j][n];
		}
	}

	/************************
	 *   Processing Power   *
	 ************************/

	 printf("Buses:%2d, CPUs:%2d\n", BUSES, CPUS);
    printf("Load %3.4f\n", STIME / COMPT);
    printf("X at FESC: %3.4f\n", xn);
	 printf("P %3.4f\n", xn * COMPT);

   return 0;
}  /* main */

//-------------------------------------------------------------------------

void multiserver(int m, double stime)
{
	int              i;
	int              nodes;
	int              streams;
	double           x;
	char            *work = "reqs";
	char            *node = "bus";

	for (i = 1; i <= CPUS; i++) {
		//fprintf(stderr, "[multiserver] i -> %d, m -> %d, stime -> %f\n", i, m, stime);

		if (i <= m) {
	 		PDQ_Init("multibus");
	 		streams = PDQ_CreateClosed(work, TERM, (double) i, 0.0);
	 		nodes = PDQ_CreateNode(node, CEN, ISRV);
	 		PDQ_SetDemand(node, work, stime);
	 		PDQ_Solve(EXACT);
	 		x = PDQ_GetThruput(TERM, work);
	 		sm_x[i] = x;
		} else {
	 		sm_x[i] = x;
		}
	}
}  /* multiserver */

//-------------------------------------------------------------------------

