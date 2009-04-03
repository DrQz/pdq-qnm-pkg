/*******************************************************************************/
/*  Copyright (C) 1994, Performance Dynamics Company                           */
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
 * shadowcpu.c
 *
 * Created by NJG: Fri May  3 18:41:04  2002
 *
 * Taken from p.254 of "Capacity Planning and Performance Modeling," 
 * by Menasce, Almeida, and Dowdy, Prentice-Hall, 1994. 
 * 
 * $Id$
 */

//-------------------------------------------------------------------------

#include <stdio.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

#define PRIORITY TRUE // Turn priority on or off here

//-------------------------------------------------------------------------

int main()
{
   int              noNodes;
   int              noStreams;

   char *noPri = "CPU Scheduler - No Pri";
   char *priOn = "CPU Scheduler - Pri On";

   float Ucpu_prod;
   float GetProdU();

   if (PRIORITY) { 
   	Ucpu_prod = GetProdU();
   }

   PDQ_Init(PRIORITY ? priOn : noPri);

   // workloads ...

   noStreams = PDQ_CreateClosed("Production", TERM, 20.0, 20.0);
   noStreams = PDQ_CreateClosed("Developmnt", TERM, 15.0, 15.0);

   // queueing noNodes ...

   noNodes = PDQ_CreateNode("CPU", CEN, FCFS);

   if (PRIORITY) { 
   	noNodes = PDQ_CreateNode("shadCPU", CEN, FCFS);
   }

   noNodes = PDQ_CreateNode("DK1", CEN, FCFS);
   noNodes = PDQ_CreateNode("DK2", CEN, FCFS);

   // service demands at each node ...

   PDQ_SetDemand("CPU", "Production", 0.30);

   if (PRIORITY) { 
   	PDQ_SetDemand("shadCPU", "Developmnt", 1.00/(1 - Ucpu_prod));
   } else { 
   	PDQ_SetDemand("CPU", "Developmnt", 1.00);
   }

   PDQ_SetDemand("DK1", "Production", 0.08);
   PDQ_SetDemand("DK1", "Developmnt", 0.05);

   PDQ_SetDemand("DK2", "Production", 0.10);
   PDQ_SetDemand("DK2", "Developmnt", 0.06);

   // We use APPROX rather than EXACT to match the numbers in the book

   PDQ_Solve(APPROX); 

   PDQ_Report();

   return(0);
}  // main

//-------------------------------------------------------------------------

float GetProdU(void) {
   int              noNodes;
   int              noStreams;

   PDQ_Init("");

   noStreams = PDQ_CreateClosed("Production", TERM, 20.0, 20.0);
   noNodes = PDQ_CreateNode("CPU", CEN, FCFS);
   noNodes = PDQ_CreateNode("DK1", CEN, FCFS);
   noNodes = PDQ_CreateNode("DK2", CEN, FCFS);

   PDQ_SetDemand("CPU", "Production", 0.30);
   PDQ_SetDemand("DK1", "Production", 0.08);
   PDQ_SetDemand("DK2", "Production", 0.10);

   PDQ_Solve(APPROX); 

   return(PDQ_GetUtilization("CPU", "Production", TERM));
}  // GetProdU

//-------------------------------------------------------------------------


