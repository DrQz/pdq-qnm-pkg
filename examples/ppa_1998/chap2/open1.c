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
   

   //----- Define the queueing center -----

   nodes = PDQ_CreateNode("server", CEN, FCFS);

   //----- Define the workload and circuit type -----

   streams = PDQ_CreateOpen("work", arrivRate);

   //----- Define service demand due to workload on the queueing center ------

   PDQ_SetDemand("server", "work", service_time);
   
   //----- Change unit labels -----

   PDQ_SetWUnit("Customers");
   PDQ_SetTUnit("Seconds");


   //----- Solve the model -----
   //  Must use the CANONical method for an open circuit

   PDQ_Solve(CANON);

   //----- Generate a report -----

   PDQ_Report();
}  // main

//----------------------------------------------------------------------------

