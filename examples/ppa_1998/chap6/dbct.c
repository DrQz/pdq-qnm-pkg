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

main()
{
   extern int       nodes, streams;
   extern JOB_TYPE *job;

   int              k;
   char             name[10];
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

   PDQ_Init("Teradata DBC-10/12");

   /* Create parallel centers */

   for (k = 0; k < Nifp; k++) {
      itoa(k, nstr);
      strcpy(name, "IFP");
      strcat(name, nstr);
      nodes = PDQ_CreateNode(name, CEN, FCFS);
      nullit(name);
      nullit(nstr);
   }

   for (k = 0; k < Namp; k++) {
      itoa(k, nstr);
      strcpy(name, "AMP");
      strcat(name, nstr);
      nodes = PDQ_CreateNode(name, CEN, FCFS);
      nullit(name);
      nullit(nstr);
   }

   for (k = 0; k < Ndsu; k++) {
      itoa(k, nstr);
      strcpy(name, "DSU");
      strcat(name, nstr);
      nodes = PDQ_CreateNode(name, CEN, FCFS);
      nullit(name);
      nullit(nstr);
   }

   streams = PDQ_CreateClosed("query", TERM, (double) users, think);

   /*PDQ_SetGraph("query", 100); - unsupported call */

   for (k = 0; k < Nifp; k++) {
      itoa(k, nstr);
      strcpy(name, "IFP");
      strcat(name, nstr);
      PDQ_SetDemand(name, "query", Sifp / Nifp);
      nullit(name);
      nullit(nstr);
   }

   for (k = 0; k < Namp; k++) {
      itoa(k, nstr);
      strcpy(name, "AMP");
      strcat(name, nstr);
      PDQ_SetDemand(name, "query", Samp / Namp);
      nullit(name);
      nullit(nstr);
   }

   for (k = 0; k < Ndsu; k++) {
      itoa(k, nstr);
      strcpy(name, "DSU");
      strcat(name, nstr);
      PDQ_SetDemand(name, "query", Sdsu / Ndsu);
      nullit(name);
      nullit(nstr);
   }

   /* 300 nodes takes about a minute to solve on a PowerMac */

   printf("Solving ... ");
   fflush(NULL);

   PDQ_Solve(APPROX);

   printf("Done.\n");

   /* PDQ_PrintXLS(); */

   PDQ_Report();
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

