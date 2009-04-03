/*******************************************************************************/
/*  Copyright (C) 1994 - 2006, Performance Dynamics Company                    */
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

upgrade2.c - Corrected client/server model for PPA Chap. 8

Upgrade scenario #2 (per the CMG93 paper) includes:
In addition to scenario #1
- Add another FS disk
- Upgrade the GW cpu to 16 MIPS
also
- upgrade the token ring from 4 to 16 Mbits
- Add 2 more DASD disks

Created by NJG on Sat Jul 23 08:11:23 PST 1994
Updated by NJG on Fri Dec 12 17:26:46 PST 2004
Updated by NJG on Fri May 12 11:56:10 PDT 2006

*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

/*
 * Code at the end of main() prints out selected performance metrics. Toggle
 * whether to prepend with a PDQ generic Report.
 */
#define PRINT_REPORT 0

/* Useful multipliers */
#define 	K		    1024
#define 	k			(1.0e3)
#define 	MIPS 		(1.0e6)
#define 	Kbps 		K
#define 	Mbps 		(Kbps * Kbps)
#define 	TPS 		(1/60.0)

/* Client-server Model Parameters */
char           *scenario = "CMG93 C/S upgrade2";

/*
 * The original model may have used a load-dependent server since the network
 * is a highly shared resource, but the information needed to replicate such
 * a queue in PDQ is not provided in their CMG paper. Hence, I resort to
 * using a fudge factor called TR_factor (AKA a wild-arsed guess) to calibrate
 * response times and utilizations.
 */
#define		USERS		250
#define		FS_DISKS	 2	/* upgrade from 1 to 2 disks */
#define		MF_DISKS	 6	/* upgrade from 4 to 6 DASDs */
#define		PC_MIPS		(27 * MIPS)
#define		FS_MIPS		(41 * MIPS)
#define		GW_MIPS		(16 * MIPS)	/* upgrade from 10 to 16 MIPS */
#define		MF_MIPS		(21 * MIPS)
#define		TR_Mbps	 	(16 * Mbps)	/* upgrade from 4 to 16 Mbps */
#define		TR_Bytes	(512 + 512) // different data frame size too


#define MAXPROC	20
#define MAXDEV	50


/* Computing resource IDs */
#define	PC	0
#define	FS	1
#define	GW	2
#define	MF	3
#define	TR	4
#define	FD	10
#define	MD	20

/* Process PIDs from 1993 CMG paper */
#define	CD_Req	1
#define	CD_Rpy	15
#define	RQ_Req	2
#define	RQ_Rpy	16
#define	SU_Req	3
#define	SU_Rpy	17
#define	Req_CD	4
#define	Req_RQ	5
#define	Req_SU	6
#define	CD_Msg	12
#define	RQ_Msg	13
#define	SU_Msg	14
#define	GT_Snd	7
#define	GT_Rcv	11
#define	MF_CD	8
#define	MF_RQ	9
#define	MF_SU	10
#define	LAN_TX	18


/* Global data structure should go into PDQ_Lib.h */
typedef struct {
   int             id;
   char            label[MAXCHARS];
}               devarray_type;




main()
{
   extern int      nodes, streams;
   extern JOB_TYPE *job;
   extern NODE_TYPE *node;
   extern char     s1[];
   char            transCD[MAXCHARS], transRQ[MAXCHARS], transSU[MAXCHARS];
   char            dummyCD[MAXCHARS], dummyRQ[MAXCHARS], dummySU[MAXCHARS];
   char            nodePC[MAXCHARS], nodeFS[MAXCHARS], nodeGW[MAXCHARS];
   char            nodeMF[MAXCHARS], nodeTR[MAXCHARS];
   double          demand[MAXPROC][MAXDEV], util[MAXDEV], udsk[MAXDEV], udasd[MAXDEV],
                   RTexpect[MAXPROC];
   double          fsd, RTmean, ulan, ufs, uws, ugw, umf;
   int             work, dev, i, j;

   /*
   Disk-array data structures probably should go into PDQ_Build.c one
   day.
   */

   devarray_type  *FDarray;
   devarray_type  *MDarray;

   if ((FDarray = (devarray_type *) calloc(sizeof(devarray_type), 10)) == NULL)
      errmsg("", "FDarray allocation failed!\n");

   if ((MDarray = (devarray_type *) calloc(sizeof(devarray_type), 10)) == NULL)
      errmsg("", "MDarray allocation failed!\n");

   for (i = 0; i < FS_DISKS; i++) {
      FDarray[i].id = FD + i;
      resets(s1);
      sprintf(s1, "FSDK%d", FD + i);
      strcpy(FDarray[i].label, s1);
   }

   for (i = 0; i < MF_DISKS; i++) {
      MDarray[i].id = MD + i;
      resets(s1);
      sprintf(s1, "MFDK%d", MD + i);
      strcpy(MDarray[i].label, s1);
   }

   /*
   CPU service times are calculated from instruction counts tabulated
   in original 1993 CMG paper.
   */

   demand[CD_Req][PC] = 200 * k / PC_MIPS;
   demand[CD_Rpy][PC] = 100 * k / PC_MIPS;
   demand[RQ_Req][PC] = 150 * k / PC_MIPS;
   demand[RQ_Rpy][PC] = 200 * k / PC_MIPS;
   demand[SU_Req][PC] = 300 * k / PC_MIPS;
   demand[SU_Rpy][PC] = 300 * k / PC_MIPS;
   demand[Req_CD][FS] = 50 * k / FS_MIPS;
   demand[Req_RQ][FS] = 70 * k / FS_MIPS;
   demand[Req_SU][FS] = 10 * k / FS_MIPS;
   demand[CD_Msg][FS] = 35 * k / FS_MIPS;
   demand[RQ_Msg][FS] = 35 * k / FS_MIPS;
   demand[SU_Msg][FS] = 35 * k / FS_MIPS;
   demand[GT_Snd][GW] = 50 * k / GW_MIPS;
   demand[GT_Rcv][GW] = 50 * k / GW_MIPS;
   demand[MF_CD][MF] = 50 * k / MF_MIPS;
   demand[MF_RQ][MF] = 150 * k / MF_MIPS;
   demand[MF_SU][MF] = 20 * k / MF_MIPS;

   /*
    Service time on the LAN to send and recv packets from any of the PC
    desktop, the file server or the SNA gateway.
    8 bits per Byte.
    */
   
   demand[LAN_TX][PC] = (double) TR_Bytes * 8 / TR_Mbps;
   demand[LAN_TX][FS] = (double) TR_Bytes * 8 / TR_Mbps;
   demand[LAN_TX][GW] = (double) TR_Bytes * 8 / TR_Mbps;

   /*
    * File server disk IOs = number of accesses x caching / (max IOs / Sec)
    */

   for (i = 0; i < FS_DISKS; i++) {
      demand[Req_CD][FDarray[i].id] = (1.0 * 0.5 / 128.9) / FS_DISKS;
      demand[Req_RQ][FDarray[i].id] = (1.5 * 0.5 / 128.9) / FS_DISKS;
      demand[Req_SU][FDarray[i].id] = (0.2 * 0.5 / 128.9) / FS_DISKS;
      demand[CD_Msg][FDarray[i].id] = (1.0 * 0.5 / 128.9) / FS_DISKS;
      demand[RQ_Msg][FDarray[i].id] = (1.5 * 0.5 / 128.9) / FS_DISKS;
      demand[SU_Msg][FDarray[i].id] = (0.5 * 0.5 / 128.9) / FS_DISKS;
   }


   /* Mainframe DASD IOs = (#accesses / (max IOs/Sec)) / #disks */
   for (i = 0; i < MF_DISKS; i++) {
      demand[MF_CD][MDarray[i].id] = (2.0 / 60.24) / MF_DISKS;
      demand[MF_RQ][MDarray[i].id] = (4.0 / 60.24) / MF_DISKS;
      demand[MF_SU][MDarray[i].id] = (1.0 / 60.24) / MF_DISKS;
   }

   /* Now, start building the PDQ model... */

   PDQ_Init(scenario);

   /* Define physical resources as PDQ queueing nodes. */
   strcpy(nodePC, "PCDESK");
   strcpy(nodeFS, "FSERVR");
   strcpy(nodeGW, "GATWAY");
   strcpy(nodeMF, "MFRAME");
   strcpy(nodeTR, "TRLAN");

   nodes = PDQ_CreateNode(nodePC, CEN, FCFS);
   nodes = PDQ_CreateNode(nodeFS, CEN, FCFS);
   nodes = PDQ_CreateNode(nodeGW, CEN, FCFS);
   nodes = PDQ_CreateNode(nodeMF, CEN, FCFS);

   for (i = 0; i < FS_DISKS; i++) {
      nodes = PDQ_CreateNode(FDarray[i].label, CEN, FCFS);
   }

   for (i = 0; i < MF_DISKS; i++) {
      nodes = PDQ_CreateNode(MDarray[i].label, CEN, FCFS);
   }

   /*
    * NOTE: Although the token ring LAN is a passive computational device, it
    * is treated as a separate node so as to agree with the results presented
    * in the original CMG 1993 paper.
    */

   nodes = PDQ_CreateNode(nodeTR, CEN, FCFS);

   /*
    * Because the desktop PCs are all of the same type and emitting the same
    * homogeneous transaction workload, the focus can be placed on the
    * response time performance of a single PC workstation and generalized to
    * the others. Rather than having N * 3 workload streams or classes, we
    * simply model 2 PC desktops: the "real" one of interest and a dummy PC
    * representing the remaining (N-1) * 3 streams.
    */

   strcpy(transCD, "CatDisplay");
   strcpy(transRQ, "RemotQuote");
   strcpy(transSU, "StatUpdate");

   /* Aggregate transactions */
   strcpy(dummyCD, "CatDispAgg");
   strcpy(dummyRQ, "RemQuotAgg");
   strcpy(dummySU, "StatUpdAgg");

   streams = PDQ_CreateOpen(transCD, 1 * 4.0 * TPS);
   streams = PDQ_CreateOpen(transRQ, 1 * 8.0 * TPS);
   streams = PDQ_CreateOpen(transSU, 1 * 1.0 * TPS);
   streams = PDQ_CreateOpen(dummyCD, (USERS - 1) * 4.0 * TPS);
   streams = PDQ_CreateOpen(dummyRQ, (USERS - 1) * 8.0 * TPS);
   streams = PDQ_CreateOpen(dummySU, (USERS - 1) * 1.0 * TPS);

   /*
   Define the service demands on each physical resource.
   CD request + reply chain from workflow diagram
   Note that only the "real" PC demand is defined, and the aggregated (N-1) PCs.
   */

   /******************* RQ request + reply chain ... *******************/
   PDQ_SetDemand(nodePC, transCD, demand[CD_Req][PC] + (5 * demand[CD_Rpy][PC]));
   PDQ_SetDemand(nodeFS, transCD, demand[Req_CD][FS] + (5 * demand[CD_Msg][FS]));
   PDQ_SetDemand(nodeFS, dummyCD, demand[Req_CD][FS] + (5 * demand[CD_Msg][FS]));
   PDQ_SetDemand(nodeGW, transCD, demand[GT_Snd][GW] + (5 * demand[GT_Rcv][GW]));
   PDQ_SetDemand(nodeGW, dummyCD, demand[GT_Snd][GW] + (5 * demand[GT_Rcv][GW]));
   PDQ_SetDemand(nodeMF, transCD, demand[MF_CD][MF]);
   PDQ_SetDemand(nodeMF, dummyCD, demand[MF_CD][MF]);
   
   for (i = 0; i < FS_DISKS; i++) {
      fsd = demand[Req_CD][FDarray[i].id] + (5 * demand[CD_Msg][FDarray[i].id]);
      PDQ_SetDemand(FDarray[i].label, transCD, fsd);
      PDQ_SetDemand(FDarray[i].label, dummyCD, fsd);
   }

   for (i = 0; i < MF_DISKS; i++) {
      PDQ_SetDemand(MDarray[i].label, transCD, demand[MF_CD][MDarray[i].id]);
      PDQ_SetDemand(MDarray[i].label, dummyCD, demand[MF_CD][MDarray[i].id]);
   }


   /*
   NOTE:Synchronous process execution causes data for the CD transaction to
   cross the LAN 12 times as depicted in the following parameterization of
   PDQ_SetDemand.
   */

   PDQ_SetDemand(nodeTR, transCD,
		 (1 * demand[LAN_TX][PC]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][GW]) +
		 (5 * demand[LAN_TX][GW]) +
		 (5 * demand[LAN_TX][FS]) +
		 (5 * demand[LAN_TX][PC]));

   PDQ_SetDemand(nodeTR, dummyCD,
		 (1 * demand[LAN_TX][PC]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][GW]) +
		 (5 * demand[LAN_TX][GW]) +
		 (5 * demand[LAN_TX][FS]) +
		 (5 * demand[LAN_TX][PC]));



   /******************* RQ request + reply chain ... *******************/
   PDQ_SetDemand(nodePC, transRQ, demand[RQ_Req][PC] + (3 * demand[RQ_Rpy][PC]));
   PDQ_SetDemand(nodeFS, transRQ, demand[Req_RQ][FS] + (3 * demand[RQ_Msg][FS]));
   PDQ_SetDemand(nodeFS, dummyRQ, demand[Req_RQ][FS] + (3 * demand[RQ_Msg][FS]));

   for (i = 0; i < FS_DISKS; i++) {
      PDQ_SetDemand(FDarray[i].label, transRQ,
		    demand[Req_RQ][FDarray[i].id] +
		    (3 * demand[RQ_Msg][FDarray[i].id]));
      PDQ_SetDemand(FDarray[i].label, dummyRQ,
		    demand[Req_RQ][FDarray[i].id] +
		    (3 * demand[RQ_Msg][FDarray[i].id]));
   }

   PDQ_SetDemand(nodeGW, transRQ, demand[GT_Snd][GW] + (3 * demand[GT_Rcv][GW]));
   PDQ_SetDemand(nodeGW, dummyRQ, demand[GT_Snd][GW] + (3 * demand[GT_Rcv][GW]));
   PDQ_SetDemand(nodeMF, transRQ, demand[MF_RQ][MF]);
   PDQ_SetDemand(nodeMF, dummyRQ, demand[MF_RQ][MF]);

   for (i = 0; i < MF_DISKS; i++) {
      PDQ_SetDemand(MDarray[i].label, transRQ,
		    demand[MF_RQ][MDarray[i].id]);
      PDQ_SetDemand(MDarray[i].label, dummyRQ,
		    demand[MF_RQ][MDarray[i].id]);
   }

   PDQ_SetDemand(nodeTR, transRQ,
		 (1 * demand[LAN_TX][PC]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][GW]) +
		 (3 * demand[LAN_TX][GW]) +
		 (3 * demand[LAN_TX][FS]) +
		 (3 * demand[LAN_TX][PC]));
   PDQ_SetDemand(nodeTR, dummyRQ,
		 (1 * demand[LAN_TX][PC]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][GW]) +
		 (3 * demand[LAN_TX][GW]) +
		 (3 * demand[LAN_TX][FS]) +
		 (3 * demand[LAN_TX][PC]));




   /******************* SU request + reply chain *******************/
   PDQ_SetDemand(nodePC, transSU, demand[SU_Req][PC] + demand[SU_Rpy][PC]);
   PDQ_SetDemand(nodeFS, transSU, demand[Req_SU][FS] + demand[SU_Msg][FS]);
   PDQ_SetDemand(nodeFS, dummySU, demand[Req_SU][FS] + demand[SU_Msg][FS]);

   for (i = 0; i < FS_DISKS; i++) {
      PDQ_SetDemand(FDarray[i].label, transSU,
		    demand[Req_SU][FDarray[i].id] +
		    demand[SU_Msg][FDarray[i].id]);
      PDQ_SetDemand(FDarray[i].label, dummySU,
		    demand[Req_SU][FDarray[i].id] +
		    demand[SU_Msg][FDarray[i].id]);
   }

   PDQ_SetDemand(nodeGW, transSU, demand[GT_Snd][GW] + demand[GT_Rcv][GW]);
   PDQ_SetDemand(nodeGW, dummySU, demand[GT_Snd][GW] + demand[GT_Rcv][GW]);
   PDQ_SetDemand(nodeMF, transSU, demand[MF_SU][MF]);
   PDQ_SetDemand(nodeMF, dummySU, demand[MF_SU][MF]);

   for (i = 0; i < MF_DISKS; i++) {
      PDQ_SetDemand(MDarray[i].label, transSU,
		    demand[MF_SU][MDarray[i].id]);
      PDQ_SetDemand(MDarray[i].label, dummySU,
		    demand[MF_SU][MDarray[i].id]);
   }

   PDQ_SetDemand(nodeTR, transSU,
		 (1 * demand[LAN_TX][PC]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][GW]) +
		 (1 * demand[LAN_TX][GW]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][PC]));
   PDQ_SetDemand(nodeTR, dummySU,
		 (1 * demand[LAN_TX][PC]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][GW]) +
		 (1 * demand[LAN_TX][GW]) +
		 (1 * demand[LAN_TX][FS]) +
		 (1 * demand[LAN_TX][PC]));

   PDQ_SetDebug(FALSE);
   PDQ_SetWUnit("Trans");
   PDQ_Solve(CANON);
   if (PRINT_REPORT) {
      PDQ_Report();
   }
   /*
    Break out each tx response time together with resource utilizations.
    The order of print out is the same as the 1993 CMG paper.
    */

   /* Mean response times reported in the CMG93 paper */
   RTexpect[0] = 0.2721;
   RTexpect[1] = 0.2668;
   RTexpect[2] = 0.1371;
   RTexpect[3] = 0.2674;
   RTexpect[4] = 0.2568;
   RTexpect[5] = 0.1266;

   printf("*** Metric breakout for \"%s\" with %d clients ***\n\n",
	  scenario, USERS);
   printf("Transaction\t    R (Sec)\t  CMG paper\n");
   printf("-----------\t    -------\t  ---------\n");

   for (work = 0; work < streams; work++) {
      resets(s1);
      strcpy(s1, job[work].trans->name);
      RTmean = PDQ_GetResponse(TRANS, s1);
      printf("%-15s\t%10.4f\t%10.4f\n", s1, RTmean, RTexpect[work]);
   }

   printf("\n\n");

   /*
    * Get node utilizations. This is a bit of a hack and should be written as
    * a subroutine.
    */
   for (dev = 0; dev < nodes; dev++) {
      util[dev] = 0.0;		/* reset array */
      for (work = 0; work < streams; work++) {
          util[dev] += 100 * PDQ_GetUtilization(node[dev].devname, job[work].trans->name, TRANS);
      }
   }

    for (dev = 0; dev < nodes; dev++) {
        if (strcmp(node[dev].devname, nodePC) == 0) {
            uws = util[dev];
        }
        if (strcmp(node[dev].devname, nodeGW) == 0) {
            ugw = util[dev];
        }
        if (strcmp(node[dev].devname, nodeFS) == 0) {
            ufs = util[dev];
        }
        if (strcmp(node[dev].devname, nodeMF) == 0) {
            umf = util[dev];
        }
        if (strcmp(node[dev].devname, nodeTR) == 0) {
            ulan = util[dev];
        }
        for (i = 0; i < FS_DISKS; i++) {
            if (strcmp(node[dev].devname, FDarray[i].label) == 0) {
                udsk[i] = util[dev];
            }
        }
        for (i = 0; i < MF_DISKS; i++) {
            if (strcmp(node[dev].devname, MDarray[i].label) == 0) {
                udasd[i] = util[dev];
            }
        }
    }

   printf("PDQ Node       \t    %% Busy\t  CMG paper\n");
   printf("--------       \t    -------\t  ---------\n");
   printf("%-15s\t%10.4f\t%10.4f\n", "Token ring", ulan, 39.6667);
   printf("%-15s\t%10.4f\t%10.4f\n", "PC Desktop", uws, 0.5802);
   printf("%-15s\t%10.4f\t%10.4f\n", "File server", ufs, 23.8313);
   printf("%-15s\t%10.4f\t%10.4f\n", "Gateway CPU", ugw, 75.5208);
   printf("%-15s\t%10.4f\t%10.4f\n", "Mainframe", umf, 28.1662);


   for (i = 0; i < FS_DISKS; i++) {
      printf("%s%d\t%10.4f\t%10.4f\n", "FS disks",
	     FDarray[i].id, udsk[i], 59.0028);
   }

   for (i = 0; i < MF_DISKS; i++) {
      printf("%s%d\t%10.4f\t%10.4f\n", "DASD disk",
	     MDarray[i].id, udasd[i], 47.3813);
   }

}				/* main */
