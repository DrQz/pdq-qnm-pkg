/*******************************************************************************/
/*  Copyright (C) 1994 - 2002, Performance Dynamics Company                    */
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
 * ebiz.c
 *
 * Created by NJG: Wed May  8 22:29:36  2002
 * Created by NJG: Fri Aug  2 08:57:31  2002
 *
 * Based on D. Buch and V. Pentkovski, "Experience of Characterization of
 * Typical Multi-tier e-Business Systems Using Operational Analysis,"
 * CMG Conference, Anaheim, California, pp. 671-681, Dec 2002.
 *
 * Measurements use Microsoft WAS (Web Application Stress) tool.
 * Could also use Merc-Interactive LoadRunner.
 * Only a single class of eBiz transaction e.g., login, or page_view, etc.
 * is measured.  Transaction details are not specified in the paper.
 *
 * Thinktime Z should be zero by virtue of N = XR assumption in paper.
 * We find that a Z~27 mSecs is needed to calibrate thruputs and utilizations.
 *
 *  $Id$
 */

//-------------------------------------------------------------------------

#include <stdio.h>
#include <math.h>
#include "../lib/PDQ_Lib.h"

//-------------------------------------------------------------------------

int main()
{
	extern double    getjob_pop();
	extern int       getjob_index();
	extern double    PDQ_GetResponse();
	extern double    PDQ_GetThruput();
	extern double    PDQ_GetUtilization();
	extern JOB_TYPE *job;

#define MAXUSERS  20

	char            *model = "Middleware I";
	char            *work = "eBiz-tx";
	char            *node1 = "WebServer";
	char            *node2 = "AppServer";
	char            *node3 = "DBMServer";
	double           think = 0.0 * 1e-3;  // treated as free param

	// Added dummy servers for calibration

	char            *node4 = "DummySvr";

	// User loads employed in WAS tool ...

	int              noNodes;
	int              noStreams;
	int              users;

	double           u1pdq[MAXUSERS+1];
	double           u2pdq[MAXUSERS+1];
	double           u3pdq[MAXUSERS+1];
	double           u1err[MAXUSERS+1];
	double           u2err[MAXUSERS+1];
	double           u3err[MAXUSERS+1];

	// Utilization data from the paper ...

	double           u1dat[MAXUSERS+1] = {
		0.0, 21.0, 41.0, 0.0, 74.0, 0.0, 0.0, 95.0, 0.0, 0.0, 96.0, 
		0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 96.0 
	};

	double           u2dat[MAXUSERS+1] = {
		0.0, 8.0, 13.0, 0.0, 20.0, 0.0, 0.0, 23.0, 0.0, 0.0, 22.0, 
		0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 22.0
	};

	double           u3dat[MAXUSERS+1] = {
		0.0, 4.0, 5.0, 0.0, 5.0, 0.0, 0.0, 5.0, 0.0, 0.0, 6.0, 
		0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0
	};

	// Output header ...

	printf("\n");
	printf("(Tx: \"%s\" for \"%s\")\n\n", work, model);
	printf("Client delay Z=%5.2f mSec. (Assumed)\n\n", think * 1e3);
	printf(" N      X       R      %%Uws    %%Uas    %%Udb\n");
	printf("---  ------  ------   ------  ------  ------\n");

	for (users = 1; users <= MAXUSERS; users++) {

		PDQ_Init(model);

		noStreams = PDQ_CreateClosed(work, TERM, (float) users, think);

		noNodes = PDQ_CreateNode(node1, CEN, FCFS);
		noNodes = PDQ_CreateNode(node2, CEN, FCFS);
		noNodes = PDQ_CreateNode(node3, CEN, FCFS);

		noNodes = PDQ_CreateNode(node4, CEN, FCFS);
		//noNodes = PDQ_CreateNode(node5, CEN, FCFS);
		//noNodes = PDQ_CreateNode(node6, CEN, FCFS);

		// NOTE: timebase is seconds

		PDQ_SetDemand(node1, work, 9.8 * 1e-3);
		PDQ_SetDemand(node2, work, 2.5 * 1e-3);
		PDQ_SetDemand(node3, work, 0.72 * 1e-3);

		// dummy (network) nodes ...

		PDQ_SetDemand(node4, work, 9.8 * 1e-3);

		PDQ_Solve(EXACT);

		// set up for error analysis of utilzations

		u1pdq[users] = PDQ_GetUtilization(node1, work, TERM) * 100;
		u2pdq[users] = PDQ_GetUtilization(node2, work, TERM) * 100;
		u3pdq[users] = PDQ_GetUtilization(node3, work, TERM) * 100;

		u1err[users] = 100 * (u1pdq[users] - u1dat[users]) / u1dat[users];
		u2err[users] = 100 * (u2pdq[users] - u2dat[users]) / u2dat[users];
		u3err[users] = 100 * (u3pdq[users] - u3dat[users]) / u3dat[users];

		printf("%3d  %6.2f  %6.2f   %6.2f  %6.2f  %6.2f\n",
			   users,
			   PDQ_GetThruput(TERM, work),  // http GETs-per-Second
			   PDQ_GetResponse(TERM, work) * 1e3,   // milliseconds
			   u1pdq[users],
			   u2pdq[users],
			   u3pdq[users]
			);
	}

	printf("\nError Analysis of Utilizations\n\n");
	printf("                  WS                      AS                      DB\n");
	printf("        ----------------------  ----------------------  ----------------------\n");
	printf(" N      %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr\n");
	printf("---     -----   -----   -----   -----   -----   -----   -----   -----   -----\n");

	for (users = 1; users <= MAXUSERS; users++) {
		switch (users) {
			case 1:
			case 2:
			case 4:
			case 7:
			case 10:
			case 20:
				printf("%3d    %6.2f  %6.2f  %6.2f",
				   	users,
				   	u1dat[users],
				   	u1pdq[users],
				   	u1err[users]);
				printf("  %6.2f  %6.2f  %6.2f",
				   	u2dat[users],
				   	u2pdq[users],
				   	u2err[users]);
				printf("  %6.2f  %6.2f  %6.2f\n",
				   	u3dat[users],
				   	u3pdq[users],
				   	u3err[users]);
				break;
			default:
				break;
		}
	}

	printf("\n");

	// Uncomment the following line for a standard PDQ summary.

	PDQ_Report();

   return(0);
}  // main

//-------------------------------------------------------------------------

