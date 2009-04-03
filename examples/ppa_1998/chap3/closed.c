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
 * closed.c
 * 
 * Illustrate use of PDQ solver for a closed circuit queue.
 * 
 * $Id$
 */

//-------------------------------------------------------------------------

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

int main()
{
   /************************
    * PDQ global variables *
    ************************/

   extern JOB_TYPE *job;
   extern double    getjob_pop();
   extern int       getjob_index();
   extern double    PDQ_GetResponse();
   extern double    PDQ_GetThruput();
   extern double    PDQ_GetUtilization();

   /****************************
    * Model specific variables *
    ****************************/
   int              noNodes;
	int              noStreams;
   int              solve_as;
   int              pop = 3.0;
   double           think = 0.1;

   /************************
    * Initialize the model *
    ************************/

   /* Give model a name and initialize internal PDQ variables */

   PDQ_Init("Closed Queue");

   solve_as = APPROX;

   // printf("**** %s ****:\n", solve_as == EXACT ? "EXACT" : "APPROX");


	/* Define the workload and circuit type */

	noStreams = PDQ_CreateClosed("w1", TERM, 1.0 * pop, think);

	/* Define the queueing center */

	noNodes = PDQ_CreateNode("node", CEN, FCFS);

	/* Define service demand */

	PDQ_SetDemand("node", "w1", 0.10);

	/*******************
	* Solve the model *
	*******************/

	PDQ_Solve(solve_as);

	PDQ_Report();

   return(0);
}	// main

//-------------------------------------------------------------------------

