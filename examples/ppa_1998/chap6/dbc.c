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
#include "../lib/PDQ_Lib.h"

//-------------------------------------------------------------------------

int main(int argc, char *argv[])
{
   extern int       nodes;
   extern int       streams;
   extern JOB_TYPE *job;

   int              k;
   int              sol_mode = APPROX;
   char            *sol_name = "APPROX";
   char             name[16];
   char             nstr[5];
   void             nullit();
   void             itoa();

   /* input parameters */

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

   /* Create parallel centers */

   for (k = 0; k < Nifp; k++) {
      // itoa(k, nstr);
      // strcpy(name, "IFP");
      // strcat(name, nstr);
      sprintf(name, "IFP%d", k);
      nodes = PDQ_CreateNode(name, CEN, FCFS);
      // nullit(name);
      // nullit(nstr);
   }

   for (k = 0; k < Namp; k++) {
      // itoa(k, nstr);
      // strcpy(name, "AMP");
      // strcat(name, nstr);
      sprintf(name, "AMP%d", k);
      nodes = PDQ_CreateNode(name, CEN, FCFS);
      // nullit(name);
      // nullit(nstr);
   }

   for (k = 0; k < Ndsu; k++) {
      // itoa(k, nstr);
      // strcpy(name, "DSU");
      // strcat(name, nstr);
      sprintf(name, "DSU%d", k);
      nodes = PDQ_CreateNode(name, CEN, FCFS);
      // nullit(name);
      // nullit(nstr);
   }

   streams = PDQ_CreateClosed("query", TERM, (double) users, think);

   /*PDQ_SetGraph("query", 100); - unsupported call */

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
      // itoa(k, nstr);
      // strcpy(name, "AMP");
      // strcat(name, nstr);
      sprintf(name, "AMP%d", k);
      PDQ_SetDemand(name, "query", Samp / Namp);
      // nullit(name);
      // nullit(nstr);
   }

   for (k = 0; k < Ndsu; k++) {
      // itoa(k, nstr);
      // strcpy(name, "DSU");
      // strcat(name, nstr);
      sprintf(name, "DSU%d", k);
      PDQ_SetDemand(name, "query", Sdsu / Ndsu);
      // nullit(name);
      // nullit(nstr);
   }

   /* 300 nodes takes about a minute to solve on a PowerMac */

   fprintf(stdout, "Solving %s... ", sol_name);
   fflush(stdout);

   PDQ_Solve(sol_mode);

   printf("Done.\n");

   /* PDQ_PrintXLS(); */

   PDQ_Report();

   return 0;
}  /* main */

//-------------------------------------------------------------------------

void nullit(char *s)
{
   s[0] = '\0';
}  /* nullit */

//-------------------------------------------------------------------------

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
}  /* itoa */

//-------------------------------------------------------------------------

