/*******************************************************************************/
/*  Copyright (C) 1994 - 2015, Performance Dynamics Company                    */
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
 * closed_center.c
 * 
 * Illustrate use of PDQ solver for multiclass workload.
 * 
 * $Id$
 */

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

   int              tech;
   int              pop;
   double           think = 0.0;

   /************************
    * Initialize the model *
    ************************/

   /* Give model a name */
   /*PDQ_Init("Test_Exact_Calc");*/

   tech = APPROX;
   printf("**** %s Solution ****:\n\n", tech == EXACT ? "EXACT" : "APPROX");
   printf("  N      R (w1)    R (w2)\n");

   for (pop = 1; pop < 10; pop++) {
      PDQ_Init("Test_Exact_calc");

      /* Define the workload and circuit type */
      PDQ_CreateClosed("w1", TERM, 1.0 * pop, think);
      PDQ_CreateClosed("w2", TERM, 1.0 * pop, think);

      /* Define the queueing center */
      PDQ_CreateNode("node", CEN, FCFS);

      /* Define service demand */
      PDQ_SetDemand("node", "w1", 1.0);
      PDQ_SetDemand("node", "w2", 0.5);

      /*******************
       * Solve the model *
       *******************/
      PDQ_Solve(tech);

/*
      printf("N\tR\n%8.4f  %8.4f\n",
	     getjob_pop(getjob_index("w1")),
	     PDQ_GetResponse(TERM, "w1"));

      printf("N\tR\n%8.4f  %8.4f\n",
	     getjob_pop(getjob_index("w2")),
	     PDQ_GetResponse(TERM, "w2"));
*/
      printf("%3d    %8.4f  %8.4f\n",
	     pop, PDQ_GetResponse(TERM, "w1"),
	     PDQ_GetResponse(TERM, "w2"));
   }

   return(0);
   
}
