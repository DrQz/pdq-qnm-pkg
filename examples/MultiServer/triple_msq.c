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
 * triple_msq.c
 * 
 * Test case for 3 M/M/m queues in tandem
 *
 * Created by NJG on Mon, Apr 2, 2007
 *
 *
 */
 
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"


int main(void)
{

   extern int      nodes, streams;

   double   arrivalRate  	= 75.0;
   double   servTime1 		= 0.100;
   double   servTime2 		= 0.200;
   int   	nthreadsA 		= 15;
   int   	nthreadsB 		= 30;
   int   	nthreadsC 		= 15;

   PDQ_Init("Triple MSQ Test");
   
   nodes = PDQ_CreateNode("mServerA", nthreadsA, MSQ);
   nodes = PDQ_CreateNode("mServerB", nthreadsB, MSQ);
   nodes = PDQ_CreateNode("mServerC", nthreadsC, MSQ);

   streams = PDQ_CreateOpen("Workflow", arrivalRate);

   PDQ_SetDemand("mServerA", "Workflow", servTime1);
   PDQ_SetDemand("mServerB", "Workflow", servTime2);
   PDQ_SetDemand("mServerC", "Workflow", servTime1);

   PDQ_Solve(CANON);
   PDQ_Report();

}  // main


