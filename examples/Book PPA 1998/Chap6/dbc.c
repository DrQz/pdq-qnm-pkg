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
 * dbc.c - Teradata DBC-10/12 performance model
 * 
 * PDQ calculation of optimal parallel configuration.
 * 
 *  $Id$
 */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

int main(int argc, char *argv[])
{
   extern JOB_TYPE *job;

   int              k;
   int              sol_mode = APPROX;
   char            *sol_name = "APPROX";
   char             name[16];
   char             nstr[5];
   void             nullit();
   void             itoa();

   // input parameters
   double           think = 10.0;
   /*int             users = 800;*/
   int              users = 300;

   double           Sifp = 0.10;
   double           Samp = 0.60;
   double           Sdsu = 1.20;

   int              Nifp = 15;
   int              Namp = 50;
   int              Ndsu = 100;

   if (argc == 2) {
       if (!strcmp(argv[1], "APPROX")) {
          sol_name = argv[1];
          sol_mode = APPROX;
       } else if (!strcmp(argv[1], "EXACT")) {
          sol_name = argv[1];
          sol_mode = EXACT;
       }
   }

   PDQ_Init("Teradata DBC-10/12");

   //Create parallel centers
   for (k = 0; k < Nifp; k++) {
      // itoa(k, nstr);
      // strcpy(name, "IFP");
      // strcat(name, nstr);
      sprintf(name, "IFP%d", k);
      PDQ_CreateNode(name, CEN, FCFS);
      // nullit(name);
      // nullit(nstr);
   }

   for (k = 0; k < Namp; k++) {
      // itoa(k, nstr);
      // strcpy(name, "AMP");
      // strcat(name, nstr);
      sprintf(name, "AMP%d", k);
      PDQ_CreateNode(name, CEN, FCFS);
      // nullit(name);
      // nullit(nstr);
   }

   for (k = 0; k < Ndsu; k++) {
      // itoa(k, nstr);
      // strcpy(name, "DSU");
      // strcat(name, nstr);
      sprintf(name, "DSU%d", k);
      PDQ_CreateNode(name, CEN, FCFS);
      // nullit(name);
      // nullit(nstr);
   }

   PDQ_CreateClosed("query", TERM, (double) users, think);

   for (k = 0; k < Nifp; k++) {
      // itoa(k, nstr);
      // strcpy(name, "IFP");
      // strcat(name, nstr);
      sprintf(name, "IFP%d", k);
      PDQ_SetDemand(name, "query", Sifp / Nifp);
      nullit(name);
      nullit(nstr);
   }

   for (k = 0; k < Namp; k++) {
      sprintf(name, "AMP%d", k);
      PDQ_SetDemand(name, "query", Samp / Namp);
   }

   for (k = 0; k < Ndsu; k++) {
      sprintf(name, "DSU%d", k);
      PDQ_SetDemand(name, "query", Sdsu / Ndsu);
   }

   // 300 nodes takes about a minute to solve on a PowerMac

   fprintf(stdout, "Solving %s... ", sol_name);
   fflush(stdout);

   PDQ_Solve(sol_mode);
   printf("Done.\n");
   PDQ_Report();   
}  


void nullit(char *s)
{
   s[0] = '\0';
}


void itoa(int n, char s[])
{
   int             c, i, j, sign;

   if ((sign = n) < 0)
      n = -n;
   i = 0;
   do {				/* generate digits in reverse order */
      s[i++] = '0' + (n % 10);
   } while ((n /= 10) > 0);
   if (sign < 0)
      s[i++] = '-';
   s[i] = '\0';

   /* reverse */
   for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
      c = s[i];
      s[i] = s[j];
      s[j] = c;
   }
}


