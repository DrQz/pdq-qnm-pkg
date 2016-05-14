/*******************************************************************************/
/*  Copyright (C) 1994 - 2007, Performance Dynamics Company                    */
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
 * passport2.c
 * 
 * Jackson network with feedback.
 * Same as model in PPA book Example 3-3 on p. 96 ff.
 * 
 * Updated by NJG on Fri, Apr 6, 2007
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

   int              numStreams;
   int              numNodes;

   // 16 applications per hour
   double           arrivals = 15.36/3600; 


   // Branching probabilities and weights 
   double           p12 = 0.30;
   double           p13 = 0.70;
   double           p23 = 0.20;
   double           p32 = 0.10;

   // Visit ratios
   double           v3 = (p13 + p23 * p12) / (1 - p23 * p32);
   double           v2 = p12 + p32 * v3;

   // Initialize and solve the model 
   PDQ_Init("Passport Office");

   numStreams = PDQ_CreateOpen("Applicant", arrivals);

   numNodes = PDQ_CreateNode("Window1", CEN, FCFS);
   numNodes = PDQ_CreateNode("Window2", CEN, FCFS);
   numNodes = PDQ_CreateNode("Window3", CEN, FCFS);
   numNodes = PDQ_CreateNode("Window4", CEN, FCFS);

   PDQ_SetDemand("Window1", "Applicant", 20.0);
   PDQ_SetDemand("Window2", "Applicant", 600.0 * v2);
   PDQ_SetDemand("Window3", "Applicant", 300.0 * v3);
   PDQ_SetDemand("Window4", "Applicant", 60.0);

   PDQ_Solve(CANON);

   PDQ_Report();

   return(0);
   
}  // main
