/*
 * open_feedback.c
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

   int              noNodes;
   int              noStreams;

   double           rx_prob = 0.30;
   double           inter_arriv_rate = 0.5;
   double           service_time = 0.75;
   double           mean_visits = 1.0 / (1.0 - rx_prob);

	//----- Initialize the model -----
   // Give model a name */

   PDQ_Init("Open Feedback");

   // Define the queueing center

   noNodes = PDQ_CreateNode("channel", CEN, FCFS);

   // Define the workload and circuit type

   noStreams = PDQ_CreateOpen("message", inter_arriv_rate);

   // Define service demand due to workload on the queueing center

   PDQ_SetVisits("channel", "message", mean_visits, service_time);

   //----- Solve the model -----
   // Must use the CANONical method for an open circuit

   PDQ_Solve(CANON);

   // Generate a report

   PDQ_Report();

  return(0);
}  // main

//--------------------------------------------------------------------

