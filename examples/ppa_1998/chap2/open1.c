/*
 * open_center.c
 * 
 * Illustrate use of PDQ solver for open uni-server queue.
 * 
 *
 *  $Id$
 */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"


//----------------------------------------------------------------------------

main()
{
   //----- Model specific variables -----

   int              nodes;
   int              streams;

   double           arrivRate    = 0.75;
   double           service_time = 1.0;

   //----- Initialize the model & Give it a name ------

   PDQ_Init("OpenCenter");
   PDQ_SetComment("This is just a simple M/M/1 queue.");
   
   //----- Change unit labels -----

   PDQ_SetWUnit("Customers");
   PDQ_SetTUnit("Seconds");

   //----- Define the queueing center -----

   nodes = PDQ_CreateNode("server", CEN, FCFS);

   //----- Define the workload and circuit type -----

   streams = PDQ_CreateOpen("work", arrivRate);

   //----- Define service demand due to workload on the queueing center ------

   PDQ_SetDemand("server", "work", service_time);

   //----- Solve the model -----
   //  Must use the CANONical method for an open circuit

   PDQ_Solve(CANON);

   //----- Generate a report -----

   PDQ_Report();
}  // main

//----------------------------------------------------------------------------

