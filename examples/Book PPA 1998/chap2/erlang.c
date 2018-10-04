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
 * erlang.c
 * 
 * Iterative computation of Erlang B and C functions.
 * 
 * Created by NJG: 15:06:09  06-27-96
 *
 *  $Id$
 * 
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

//--------------------------------------------------------------------

int main(int argc, char *argv[])
{

   double          erlangB;
   double          erlangC;
   double          traffic;
   double          eb;
   double          rho;
   double          nrt;
   double          ql;

   long            m;
   long            servers;

   /* inputs */

   if (argc < 3) {
      printf("Usage: %s servers traffic\n", argv[0]);
      printf("NOTE:Per server load = traffic/servers\n");
      exit(1);
   }

   /* initialize variables */

   servers = atol(*++argv);
   traffic = atof(*++argv);
   rho     = traffic / servers;
   erlangB = traffic / (1 + traffic);

   /* Jagerman's algorithm */

   for (m = 2; m <= servers; m++) {
      eb      = erlangB;
      erlangB = eb * traffic / (m + eb * traffic);
   }

   erlangC = erlangB / (1 - rho + rho * erlangB);
   nrt     = 1 + erlangC / (servers * (1 - rho));
   ql      = traffic * nrt;

   /* outputs */

   printf("  %ld Server System\n", servers);
   printf("  -----------------\n");
   printf("  Traffic intensity:  %5.5lf\n", traffic);
   printf("  Server utilization: %5.5lf\n", rho);
   printf("  \n");
   printf("  Erlang B  (loss  prob): %5.5lf\n", erlangB);
   printf("  Erlang C  (queue prob): %5.5lf\n", erlangC);
   printf("  M/M/m    Normalized RT: %5.5lf\n", nrt);
   printf("  M/M/m    No. in System: %5.5lf\n", ql);

} // main

//--------------------------------------------------------------------

