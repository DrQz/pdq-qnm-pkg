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
 * httpd.c
 * 
 *  $Id$
 *
 * HTTP daemon performance model
 * 
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

int main(void)
{
   extern           JOB_TYPE *job;
   extern double    getjob_pop();
   extern int       getjob_index();
   extern double    PDQ_GetResponse();
   extern double    PDQ_GetThruput();
   extern double    PDQ_GetUtilization();

   /****************************
	* Model specific variables *
	****************************/
   int              pop, servers = 2;
   int              s, w;

#define STRESS	0
#define HOMEPG 1

   static char    *work[] = {
	  "stress",
	  "homepg"
   };

   static double   time[] = {
	  0.0044,			/* stress */
	  0.0300			/* homepg */
   };

   static char    *slave[] = {
	  "slave0",
	  "slave1",
	  "slave2",
	  "slave3",
	  "slave4",
	  "slave5",
	  "slave6",
	  "slave7",
	  "slave8",
	  "slave9",
	  "slave10",
	  "slave11",
	  "slave12",
	  "slave13",
	  "slave14",
	  "slave15"
   };

#define	PREFORK 
	w = HOMEPG;

#ifdef PREFORK
	printf("Pre-Fork Model under \"%s\" Load (m = %d)\n",
		w == STRESS ? work[STRESS] : work[HOMEPG], servers);
#else
	printf("Forking  Model under \"%s\" Load \n",
		w == STRESS ? work[STRESS] : work[HOMEPG]);
#endif

	printf("\n  N        X         R\n");

	for (pop = 1; pop <= 10; pop++) {

		PDQ_Init("HTTPd_Server");

		PDQ_CreateClosed(work[w], TERM, 1.0 * pop, 0.0);
        
		PDQ_CreateNode("master", CEN, FCFS);

#ifdef PREFORK
		for (s = 0; s < servers; s++) {
			PDQ_CreateNode(slave[s], CEN, FCFS);
		}

		PDQ_SetDemand("master", work[w], 0.0109);

		for (s = 0; s < servers; s++) {
			PDQ_SetDemand(slave[s], work[w], time[w] / servers);
		}
#else				/* FORKING */
	PDQ_CreateNode("forks", CEN, ISRV);

	PDQ_SetDemand("master", work[w], 0.0165);
	PDQ_SetDemand("forks", work[w], time[w]);
#endif

	PDQ_Solve(EXACT);

	printf("%5.2f   %8.4f  %8.4f\n",
		 getjob_pop(getjob_index(work[w])),
		 PDQ_GetThruput(TERM, work[w]),
		 PDQ_GetResponse(TERM, work[w]));
   }
}



