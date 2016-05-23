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
 * closed1.c
 * 
 * Illustrates PDQ solver for closed uni-server queue. Compare with repair.c
 *
 *  $Id$
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"


int main()
{
   
   //----- Model-specific variables
   double           pop   = 100.0;
   double           think = 300.0;
   double           servt = 0.63;

   //----- Initialize the model
   PDQ_Init("Time Share Computer");
   PDQ_SetComment("This is a M/M/1/N/N/FCFS queue.");

   // Define the workload and circuit type
   PDQ_CreateClosed("compile", TERM, pop, think);

   // Define the queueing center
   PDQ_CreateNode("CPU", CEN, FCFS);

   // Define service demand
   PDQ_SetDemand("CPU", "compile", servt);

   //----- Solve the model and generate report
   PDQ_Solve(EXACT);
   PDQ_Report();
   
}


