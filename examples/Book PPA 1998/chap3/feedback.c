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
 * feedback.c
 * 
 * $Id$
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//--------------------------------------------------------------------

int main()
{
   //---- Model specific variables -----
   double           rx_prob = 0.30;
   double           inter_arriv_rate = 0.5;
   double           service_time = 0.75;
   double           mean_visits = 1.0 / (1.0 - rx_prob);

	//----- Initialize the model -----
   // Give model a name */
   PDQ_Init("Open Feedback");

   // Define the queueing center
   PDQ_CreateNode("channel", CEN, FCFS);

   // Define the workload and circuit type
   PDQ_CreateOpen("message", inter_arriv_rate);

   // Define service demand due to workload on the queueing center
   PDQ_SetVisits("channel", "message", mean_visits, service_time);

   //----- Solve the model -----
   // Must use the CANONical method for an open circuit
   PDQ_Solve(CANON);

   // Generate a report
   PDQ_Report();

  return(0);
  
}


