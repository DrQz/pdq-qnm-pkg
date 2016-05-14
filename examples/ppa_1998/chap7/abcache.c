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
 * abcache.c  -  Cache protocol scaling
 * 
 * Created by NJG: 13:03:53  07-19-96 
 * Revised by NJG: 18:58:44  04-02-99
 * 
 *  $Id$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

//-------------------------------------------------------------------------
/* Main memory update policy */

#define	WBACK		TRUE

/* Globals */

#define MAXCPU		15
#define ZX			2.5

/* Cache parameters */

#define RD		0.85
#define WR		(1 - RD)

#define HT		0.95
#define WUMD	0.0526
#define MD		0.35

/* Bus and L2 cache ids */

#define L2C		"L2C"
#define BUS		"MBus"

/* Aggregate cache traffic */

#define RWHT	"RWhit"
#define gen		1.0

/* Bus Ops */

#define RDOP	"Read"
#define WROP	"Write"
#define INVL	"Inval"

//-------------------------------------------------------------------------

char            s1[MAXBUF];
char            s2[MAXBUF];

//-------------------------------------------------------------------------

int intwt(double N, double *W);

//-------------------------------------------------------------------------

int main()
{
   void            namex();
   int             intwt();
   void            itoa();

   char            cname[10];	/* cache id */
   char            wname[10];	/* workload */
   int             i;

   /* per CPU intruction stream intensity */

   double          Prhit = (RD * HT);
   double          Pwhit = (WR * HT * (1 - WUMD)) + (WR * (1 - HT) * (1 - MD));
   double          Prdop = RD * (1 - HT);
   double          Pwbop = WR * (1 - HT) * MD;
   double          Pwthr = WR;
   double          Pinvl = WR * HT * WUMD;

   double          Nrwht = 0.8075 * MAXCPU;
   double          Nrdop = 0.0850 * MAXCPU;
   double          Nwthr = 0.15 * MAXCPU;

   double          Nwbop = 0.0003 * MAXCPU * 100;
   double          Ninvl = 0.015 * MAXCPU;

   double          Srdop = (20.0);
   double          Swthr = (25.0);
   double          Swbop = (20.0);

   double          Wrwht;
   double          Wrdop;
   double          Wwthr;
   double          Wwbop;
   double          Winvl;

   double          Zrwht = ZX;
   double          Zrdop = ZX;
   double          Zwbop = ZX;
   double          Zinvl = ZX;
   double          Zwthr = ZX;

   double          Xcpu = 0.0;
   double          Pcpu = 0.0;
   double          Ubrd = 0.0;
   double          Ubwr = 0.0;
   double          Ubin = 0.0;
   double          Ucht = 0.0;
   double          Ucrd = 0.0;
   double          Ucwr = 0.0;
   double          Ucin = 0.0;

	int             nodes;
	int             streams;

   char            *model = "ABC Model";

   PDQ_Init(model);

   /* create single bus queueing center */

   nodes = PDQ_CreateNode(BUS, CEN, FCFS);

   /* create per CPU cache queueing centers */

   for (i = 0; i < MAXCPU; i++) {
      namex(i, L2C, cname);
      nodes = PDQ_CreateNode(cname, CEN, FCFS);
   }

   /* create CPU nodes, workloads, and demands */

   for (i = 0; i < intwt(Nrwht, &Wrwht); i++) {
      namex(i, RWHT, wname);
      streams = PDQ_CreateClosed(wname, TERM, Nrwht, Zrwht);
      namex(i, L2C, cname);
      PDQ_SetDemand(cname, wname, 1.0);
      PDQ_SetDemand(BUS, wname, 0.0);	/* no bus activity */
   }

   for (i = 0; i < intwt(Nrdop, &Wrdop); i++) {
      namex(i, RDOP, wname);
      streams = PDQ_CreateClosed(wname, TERM, Nrdop, Zrdop);
      namex(i, L2C, cname);
      PDQ_SetDemand(cname, wname, gen);	/* generate bus request */
      PDQ_SetDemand(BUS, wname, Srdop);	/* req + async data return */
   }

   if (WBACK) {
      for (i = 0; i < intwt(Nwbop, &Wwbop); i++) {
	 		namex(i, WROP, wname);
	 		streams = PDQ_CreateClosed(wname, TERM, Nwbop, Zwbop);
	 		namex(i, L2C, cname);
	 		PDQ_SetDemand(cname, wname, gen);
	 		PDQ_SetDemand(BUS, wname, Swbop);	/* asych write to memory ? */
      }
   } else {			/* write-thru */
      for (i = 0; i < intwt(Nwthr, &Wwthr); i++) {
	 		namex(i, WROP, wname);
	 		streams = PDQ_CreateClosed(wname, TERM, Nwthr, Zwthr);
	 		namex(i, L2C, cname);
	 		PDQ_SetDemand(cname, wname, gen);
	 		PDQ_SetDemand(BUS, wname, Swthr);
      }
   }

   if (WBACK) {
      for (i = 0; i < intwt(Ninvl, &Winvl); i++) {
	 		namex(i, INVL, wname);
	 		streams = PDQ_CreateClosed(wname, TERM, Ninvl, Zinvl);
	 		namex(i, L2C, cname);
	 		PDQ_SetDemand(cname, wname, gen);	/* gen + intervene */
	 		PDQ_SetDemand(BUS, wname, 1.0);
      }
   }
   
   
   PDQ_SetWUnit("Reqs");
   PDQ_SetTUnit("Cycs");

   PDQ_Solve(APPROX);

   /* bus utilizations */

   for (i = 0; i < intwt(Nrdop, &Wrdop); i++) {
      namex(i, RDOP, wname);
      Ubrd += PDQ_GetUtilization(BUS, wname, TERM);
   }
   Ubrd *= Wrdop;

   if (WBACK) {
      for (i = 0; i < intwt(Nwbop, &Wwbop); i++) {
	 		namex(i, WROP, wname);
	 		Ubwr += PDQ_GetUtilization(BUS, wname, TERM);
      }
      Ubwr *= Wwbop;

      for (i = 0; i < intwt(Ninvl, &Winvl); i++) {
	 		namex(i, INVL, wname);
	 		Ubin += PDQ_GetUtilization(BUS, wname, TERM);
      }
      Ubin *= Winvl;

   } else {			/* write-thru */
      for (i = 0; i < intwt(Nwthr, &Wwthr); i++) {
	 		namex(i, WROP, wname);
	 		Ubwr += PDQ_GetUtilization(BUS, wname, TERM);
      }
      Ubwr *= Wwthr;
   }

   /* cache measures at CPU[0] only */

   i = 0;
   namex(i, L2C, cname);

   namex(i, RWHT, wname);
   Xcpu = PDQ_GetThruput(TERM, wname) * Wrwht;
   Pcpu += Xcpu * Zrwht;
   Ucht = PDQ_GetUtilization(cname, wname, TERM) * Wrwht;

   namex(i, RDOP, wname);
   Xcpu = PDQ_GetThruput(TERM, wname) * Wrdop;
   Pcpu += Xcpu * Zrdop;
   Ucrd = PDQ_GetUtilization(cname, wname, TERM) * Wrdop;

   Pcpu *= 1.88;

   if (WBACK) {
      namex(i, WROP, wname);
      Ucwr = PDQ_GetUtilization(cname, wname, TERM) * Wwbop;
      namex(i, INVL, wname);
      Ucin = PDQ_GetUtilization(cname, wname, TERM) * Winvl;
   } else {			/* write-thru */
      namex(i, WROP, wname);
      Ucwr = PDQ_GetUtilization(cname, wname, TERM) * Wwthr;
   }

   printf("\n**** %s Results ****\n", model);
   printf("PDQ nodes: %d  PDQ streams: %d\n", nodes, streams);
   printf("Memory Mode: %s\n", WBACK ? "WriteBack" : "WriteThru");
   printf("Ncpu:  %2d\n", MAXCPU);
   printf("Nrwht: %5.2f (N:%2d  W:%5.2f)\n",
	  Nrwht, intwt(Nrwht, &Wrwht), Wrwht);
   printf("Nrdop: %5.2f (N:%2d  W:%5.2f)\n",
	  Nrdop, intwt(Nrdop, &Wrdop), Wrdop);

   if (WBACK) {
      printf("Nwbop: %5.2f (N:%2d  W:%5.2f)\n",
	     Nwbop, intwt(Nwbop, &Wwbop), Wwbop);
      printf("Ninvl: %5.2f (N:%2d  W:%5.2f)\n",
	     Ninvl, intwt(Ninvl, &Winvl), Winvl);
   } else {
      printf("Nwthr: %5.2f (N:%2d  W:%5.2f)\n",
	     Nwthr, intwt(Nwthr, &Wwthr), Wwthr);
   }

   printf("\n");
   printf("Hit Ratio:   %5.2f %%\n", HT * 100.0);
   printf("Read Miss:   %5.2f %%\n", RD * (1 - HT) * 100.0);
   printf("WriteMiss:   %5.2f %%\n", WR * (1 - HT) * 100.0);
   printf("Ucpu:        %5.2f %%\n", Pcpu * 100.0 / MAXCPU);
   printf("Pcpu:        %5.2f\n", Pcpu);
   printf("\n");
   printf("Ubus[reads]: %5.2f %%\n", Ubrd * 100.0);
   printf("Ubus[write]: %5.2f %%\n", Ubwr * 100.0);
   printf("Ubus[inval]: %5.2f %%\n", Ubin * 100.0);
   printf("Ubus[total]: %5.2f %%\n", (Ubrd + Ubwr + Ubin) * 100.0);
   printf("\n");
   printf("Uca%d[hits]:  %5.2f %%\n", i, Ucht * 100.0);
   printf("Uca%d[reads]: %5.2f %%\n", i, Ucrd * 100.0);
   printf("Uca%d[write]: %5.2f %%\n", i, Ucwr * 100.0);
   printf("Uca%d[inval]: %5.2f %%\n", i, Ucin * 100.0);
   printf("Uca%d[total]: %5.2f %%\n", i, (Ucht + Ucrd + Ucwr + Ucin) * 100.0);

   return 0;
} 


void itoa(int n, char *s)
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


void namex(int i, char *s, char *r)
/* append index i to string s and return it in r */
{
   extern char     s1[], s2[];
   extern void     resets();

   resets(r);
   resets(s1);
   resets(s2);
   strcpy(s1, s);
   itoa(i, s2);
   strcat(s1, s2);
   strcpy(r, s1);
}


int intwt(double N, double *W)
{
   int             i;

   if (N < 1.0) {
      i = 1;
      *W = N;
   }
   if (N >= 1.0) {
      i = N;
      *W = 1.0;
   }
   return (i);
}


