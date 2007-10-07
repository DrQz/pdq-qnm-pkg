/*
 * time_share.c
 * 
 * Illustrates PDQ solver for closed uni-server queue. Compare with repair.c
 *
 *  $Id$
 */

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

main()
{
   //----- Model specific variables ---------------------------------------

   int              nodes;
   int              streams;

   double           pop   = 100.0;
   double           think = 300.0;
   double           servt = 0.63;

   //----- Initialize the model -------------------------------------------

   PDQ_Init("Time Share Computer");
   PDQ_SetComment("This is just a simple M/M/1 queue.");

   // Define the workload and circuit type

   streams = PDQ_CreateClosed("compile", TERM, pop, think);

   // Define the queueing center

   nodes = PDQ_CreateNode("CPU", CEN, FCFS);

   // Define service demand

   PDQ_SetDemand("CPU", "compile", servt);

   //----- Solve the model and generate report ----------------------------

   PDQ_Solve(EXACT);

   PDQ_Report();
}  // main

//-------------------------------------------------------------------------

