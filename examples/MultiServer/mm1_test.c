/*
 * mm1_test.c
 * 
 * Check MSQ with m = 1 against standard node.
 * 
 * Created by NJG on Wed, Apr 4, 2007
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

   double           arrivRate   = 0.75;
   double           servTime	= 1.00;

   PDQ_Init("M/M/1 Test Cases");

   streams = PDQ_CreateOpen("work", arrivRate);

   nodes = PDQ_CreateNode("Standard", CEN, FCFS);
   nodes = PDQ_CreateNode("Multinode", 1, MSQ);


   PDQ_SetDemand("Standard", "work", servTime);
   PDQ_SetDemand("Multinode", "work", servTime);

   PDQ_Solve(CANON);

   PDQ_Report();

}  // main


