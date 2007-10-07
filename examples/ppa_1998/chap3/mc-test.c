/*
 * multiclass-test.c
 * 
 * Test PDQ_Exact.c lib
 * 
 * From A.Allen Example 6.3.4, p.413
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

   /************************
    * PDQ global variables *
    ************************/

   int              noNodes;
   int              noStreams;

   /************************
    * Initialize the model *
    ************************/

   /* Give model a name */

   PDQ_Init("Multiclass Test");

   /* Define the workload and circuit type */

   noStreams = PDQ_CreateClosed("term1", TERM, 5.0, 20.0);
   noStreams = PDQ_CreateClosed("term2", TERM, 15.0, 30.0);
   noStreams = PDQ_CreateClosed("batch", BATCH, 5.0, 0.0);

   /* Define the queueing center */

   noNodes = PDQ_CreateNode("node1", CEN, FCFS);
   noNodes = PDQ_CreateNode("node2", CEN, FCFS);
   noNodes = PDQ_CreateNode("node3", CEN, FCFS);

   /* Define service demand */

   PDQ_SetDemand("node1", "term1", 0.50);
   PDQ_SetDemand("node1", "term2", 0.04);
   PDQ_SetDemand("node1", "batch", 0.06);

   PDQ_SetDemand("node2", "term1", 0.40);
   PDQ_SetDemand("node2", "term2", 0.20);
   PDQ_SetDemand("node2", "batch", 0.30);

   PDQ_SetDemand("node3", "term1", 1.20);
   PDQ_SetDemand("node3", "term2", 0.05);
   PDQ_SetDemand("node3", "batch", 0.06);

   /*******************
    * Solve the model *
    *******************/

   PDQ_Solve(EXACT);

   PDQ_Report();

   return(0);
}  /* main */

//-------------------------------------------------------------------------

