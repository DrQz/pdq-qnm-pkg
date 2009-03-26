/*******************************************************************************/
/*  Copyright (C) 1994 - 1998, Performance Dynamics Company                    */
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
 * iis.c
 *
 * Based on Microsoft WAS measurements of IIS.
 * 
 * CMG 2001 paper.
 *
 *  $Id$
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

int main()
{
	extern double    getjob_pop();
	extern int       getjob_index();
	extern double    PDQ_GetResponse();
	extern double    PDQ_GetThruput();
	extern double    PDQ_GetUtilization();
	extern JOB_TYPE *job;

	int              noNodes;
	int              noStreams;
	int              users;
	int              delta;
	char            *model = "IIS Server";
	char            *work = "http GET 20KB";
	char            *node1 = "CPU";
	char            *node2 = "DSK";
	char            *node3 = "NET";
	char            *node4 = "Dummy";
	double	         think = 1.5 * 1e-3;
	double           u1pdq[11];
	double           u2pdq[11];
	double           u3pdq[11];
	double           u1err[11];
	double           u2err[11];
	double           u3err[11];
	double	         u2demand = 0.10 * 1e-3;

	// Utilization data from the paper ...

	double           u1dat[11] = {
		0.0, 9.0, 14.0, 17.0, 21.0, 24.0, 26.0, 0.0, 0.0, 0.0, 26.0
	};

	double           u2dat[11] = {
		0.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, 2.0
	};

	double           u3dat[11] = {
		0.0, 26.0, 46.0, 61.0, 74.0, 86.0, 92.0, 0.0, 0.0, 0.0, 94.0
	};

	// Output main header ...

	printf("\n");
	printf("(Tx: \"%s\" for \"%s\")\n\n", work, model);
	printf("Client delay Z=%5.2f mSec. (Assumed)\n\n", think * 1e3);
	printf(" N      X       R      %%Ucpu   %%Udsk   %%Unet\n");
	printf("---  ------  ------   ------  ------  ------\n");

	for (users = 1; users <= 10; users++) {
		PDQ_Init(model);

		noStreams = PDQ_CreateClosed(work, TERM, (float) users, think);

		noNodes = PDQ_CreateNode(node1, CEN, FCFS);
		noNodes = PDQ_CreateNode(node2, CEN, FCFS);
		noNodes = PDQ_CreateNode(node3, CEN, FCFS);
		noNodes = PDQ_CreateNode(node4, CEN, FCFS);

		// NOTE: timebase is seconds

		PDQ_SetDemand(node1, work, 0.44 * 1e-3);
		PDQ_SetDemand(node2, work, u2demand); /* make load-indept */
		PDQ_SetDemand(node3, work, 1.45 * 1e-3);
		PDQ_SetDemand(node4, work, 1.6 * 1e-3);

		PDQ_Solve(EXACT);

		// set up for error analysis of utilzations

		u1pdq[users] = PDQ_GetUtilization(node1, work, TERM) * 100;
		u2pdq[users] = PDQ_GetUtilization(node2, work, TERM) * 100;
		u3pdq[users] = PDQ_GetUtilization(node3, work, TERM) * 100;

		u1err[users] = 100 * (u1pdq[users] - u1dat[users]) / u1dat[users];
		u2err[users] = 100 * (u2pdq[users] - u2dat[users]) / u2dat[users];
		u3err[users] = 100 * (u3pdq[users] - u3dat[users]) / u3dat[users];

		u2demand = 0.015 / PDQ_GetThruput(TERM, work);

		printf("%3d  %6.2f  %6.2f   %6.2f  %6.2f  %6.2f\n",
			   users, 
			   PDQ_GetThruput(TERM, work),  // http GETs-per-second
			   PDQ_GetResponse(TERM, work) * 1e3,   // milliseconds
			   u1pdq[users],
			   u2pdq[users],
			   u3pdq[users]
			);

	}

	printf("\nError Analysis of Utilizations\n\n");
	printf("                 CPU                     DSK                     NET\n");
	printf("        ----------------------  ----------------------  ----------------------\n");
	printf(" N      %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr\n");
	printf("---     -----   -----   -----   -----   -----   -----   -----   -----   -----\n");

	for (users = 1; users <= 10; users++) {
		if (users <= 6 || users == 10) {
			printf("%3d    %6.2f  %6.2f  %6.2f",
			       users,
			       u1dat[users],
			       u1pdq[users],
			       u1err[users]
			);
			    
			printf("  %6.2f  %6.2f  %6.2f",
			       u2dat[users],
			       u2pdq[users],
			       u2err[users]
			);

			printf("  %6.2f  %6.2f  %6.2f\n",
			       u3dat[users],
			       u3pdq[users],
			       u3err[users]
			);
		}
	}

	printf("\n");

   return(0);
}  // main

//-------------------------------------------------------------------------

