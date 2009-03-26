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
 * passpt_office.c
 * 
 * Illustration of an open queueing circuit with feedback.
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
   extern JOB_TYPE *job;
   extern NODE_TYPE *node;

	int              noNodes;
   int              noStreams;

   double           arrivals = 16.0 / 3600;	/* 16 applications per
						 * hour */

   /* Branching probabilities and weights */

   double           p12 = 0.30;
   double           p13 = 0.70;
   double           p23 = 0.20;
   double           p32 = 0.10;

   double           w3 = (p13 + p23 * p12) / (1 - p23 * p32);
   double           w2 = p12 + p32 * w3;

   /* Initialize and solve the model */

   PDQ_Init("Passport Office");

   noStreams = PDQ_CreateOpen("Applicant", 0.00427);

   noNodes = PDQ_CreateNode("Window1", CEN, FCFS);
   noNodes = PDQ_CreateNode("Window2", CEN, FCFS);
   noNodes = PDQ_CreateNode("Window3", CEN, FCFS);
   noNodes = PDQ_CreateNode("Window4", CEN, FCFS);

   PDQ_SetDemand("Window1", "Applicant", 20.0);
   PDQ_SetDemand("Window2", "Applicant", 600.0 * w2);
   PDQ_SetDemand("Window3", "Applicant", 300.0 * w3);
   PDQ_SetDemand("Window4", "Applicant", 60.0);

   PDQ_Solve(CANON);

   PDQ_Report();

   return(0);
}  // main

//-------------------------------------------------------------------------

