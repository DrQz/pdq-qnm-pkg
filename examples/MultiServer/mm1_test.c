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


