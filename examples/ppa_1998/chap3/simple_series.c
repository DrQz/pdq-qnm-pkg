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
 * simple_series_circuit.c
 * 
 * An open queueing circuit with 3 centers.
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
   extern JOB_TYPE  *job;
   extern NODE_TYPE *node;

   int              noNodes;
   int              noStreams;

   double           arrivals_per_second = 0.10;

   /* Initialize and solve the model */

   PDQ_Init("Simple Series Circuit");

   noStreams = PDQ_CreateOpen("Work", arrivals_per_second);

   noNodes = PDQ_CreateNode("Center1", CEN, FCFS);
   noNodes = PDQ_CreateNode("Center2", CEN, FCFS);
   noNodes = PDQ_CreateNode("Center3", CEN, FCFS);

   PDQ_SetDemand("Center1", "Work", 1.0);
   PDQ_SetDemand("Center2", "Work", 2.0);
   PDQ_SetDemand("Center3", "Work", 3.0);

   PDQ_Solve(CANON);

   PDQ_Report();

   return(0);
}  /* main */

//-------------------------------------------------------------------------

