/*
 * Created on 21/02/2004
 *
 *  By: plh@pha.com.au
 *
 *  $Id$
 *
 */

import com.perfdynamics.pdq.*;
import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * @author plh
 * 
 * baseline.c - corrected Client/server model
 */
public class Ch8_Baseline {

	static class Device {
		int id;

		String label;
	};

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// ****************************************************
		// Model Parameters
		// ****************************************************/

		// Name of this model ...

		String scenario = "C/S Baseline";

		// Useful multipliers ...

		int K = 1024;
		double MIPS = 1E6;
		double Mbps = 1E6;

		// Model parameters ...

		int USERS = 125;
		int FS_DISKS = 1;
		int MF_DISKS = 4;
		double PC_MIPS = (27 * MIPS);
		double FS_MIPS = (41 * MIPS);
		double GW_MIPS = (10 * MIPS);
		double MF_MIPS = (21 * MIPS);
		double TR_Mbps = (4 * Mbps);
		double TR_fact = (2.5); // fudge factor

		int MAXPROC = 20;
		int MAXDEV = 50;

		// Computing Device IDs

		int PC = 0;
		int FS = 1;
		int GW = 2;
		int MF = 3;
		int TR = 4;

		int FDA = 10;
		int MDA = 20;

		// Transaction IDs

		int CD = 0; // Category Display
		int RQ = 1; // Remote Query
		int SU = 2; // Status Update

		// Process IDs from 1993 paper

		int CD_Req = 1;
		int CD_Rpy = 15;
		int RQ_Req = 2;
		int RQ_Rpy = 16;
		int SU_Req = 3;
		int SU_Rpy = 17;
		int Req_CD = 4;
		int Req_RQ = 5;
		int Req_SU = 6;
		int CD_Msg = 12;
		int RQ_Msg = 13;
		int SU_Msg = 14;
		int GT_Snd = 7;
		int GT_Rcv = 11;
		int MF_CD = 8;
		int MF_RQ = 9;
		int MF_SU = 10;
		int LAN_Tx = 18;

		int noNodes;
		int noStreams;

		double[][] demand = new double[20][30];

		// This should go into pdq.Lib.h ...
		// typedef struct {
		// int id
		// char label[MAXCHARS]
		// } devarray_type

		// Variable we plan to import...
		// txCD[MAXCHARS],
		// txRQ[MAXCHARS],
		// txSU[MAXCHARS]
		// demand[MAXPROC][MAXDEV],
		// util[MAXDEV],
		// X
		// ulan,
		// ufs,
		// udsk[MAXDEV],
		// uws,
		// ugw,
		// umf,
		// udasd[MAXDEV]
		// work,
		// dev,
		// i,
		// j
		//  
		// // This should go into pdq.Build.c ...
		// devarray_type *FDarray
		// devarray_type *MDarray

		// if ((FDarray = (devarray_type *) calloc(sizeof(devarray_type), 10))
		// == NULL)
		// errmsg("", "FDarray allocation failed!\n")
		// if ((MDarray = (devarray_type *) calloc(sizeof(devarray_type), 10))
		// == NULL)
		// errmsg("", "MDarray allocation failed!\n")

		Device[] FDarray = new Device[FS_DISKS];
		Device[] MDarray = new Device[MF_DISKS];

		for (int i = 0; i < FS_DISKS; i++) {
			FDarray[i] = new Device();
			FDarray[i].id = FDA + i;
			FDarray[i].label = Format.sprintf("FD%d", p.add(i));
		}

		for (int i = 0; i < MF_DISKS; i++) {
			MDarray[i] = new Device();
			MDarray[i].id = MDA + i;
			MDarray[i].label = Format.sprintf("MD%d", p.add(i));
		}

		// CPU service times are calculated from MIPS Instruction counts in
		// tables presented in original 1993 CMG paper.

		demand[CD_Req][PC] = 200 * K / PC_MIPS;
		demand[CD_Rpy][PC] = 100 * K / PC_MIPS;
		demand[RQ_Req][PC] = 150 * K / PC_MIPS;
		demand[RQ_Rpy][PC] = 200 * K / PC_MIPS;
		demand[SU_Req][PC] = 300 * K / PC_MIPS;
		demand[SU_Rpy][PC] = 300 * K / PC_MIPS;

		demand[Req_CD][FS] = 50 * K / FS_MIPS;
		demand[Req_RQ][FS] = 70 * K / FS_MIPS;
		demand[Req_SU][FS] = 10 * K / FS_MIPS;
		demand[CD_Msg][FS] = 35 * K / FS_MIPS;
		demand[RQ_Msg][FS] = 35 * K / FS_MIPS;
		demand[SU_Msg][FS] = 35 * K / FS_MIPS;

		demand[GT_Snd][GW] = 50 * K / GW_MIPS;
		demand[GT_Rcv][GW] = 50 * K / GW_MIPS;

		demand[MF_CD][MF] = 50 * K / MF_MIPS;
		demand[MF_RQ][MF] = 150 * K / MF_MIPS;
		demand[MF_SU][MF] = 20 * K / MF_MIPS;

		// packets generated at each of the following sources ...

		demand[LAN_Tx][PC] = 2 * K * TR_fact / TR_Mbps;
		demand[LAN_Tx][FS] = 2 * K * TR_fact / TR_Mbps;
		demand[LAN_Tx][GW] = 2 * K * TR_fact / TR_Mbps;

		// File server Disk I/Os = //accesses x caching / (max IOs/Sec)

		for (int i = 0; i < FS_DISKS; i++) {
			demand[Req_CD][FDarray[i].id] = (1.0 * 0.5 / 128.9) / FS_DISKS;
			demand[Req_RQ][FDarray[i].id] = (1.5 * 0.5 / 128.9) / FS_DISKS;
			demand[Req_SU][FDarray[i].id] = (0.2 * 0.5 / 128.9) / FS_DISKS;
			demand[CD_Msg][FDarray[i].id] = (1.0 * 0.5 / 128.9) / FS_DISKS;
			demand[RQ_Msg][FDarray[i].id] = (1.5 * 0.5 / 128.9) / FS_DISKS;
			demand[SU_Msg][FDarray[i].id] = (0.5 * 0.5 / 128.9) / FS_DISKS;
		}

		// Mainframe DASD I/Os = (//accesses / (max IOs/Sec)) / //disks

		for (int i = 0; i < MF_DISKS; i++) {
			demand[MF_CD][MDarray[i].id] = (2.0 / 60.24) / MF_DISKS;
			demand[MF_RQ][MDarray[i].id] = (4.0 / 60.24) / MF_DISKS;
			demand[MF_SU][MDarray[i].id] = (1.0 / 60.24) / MF_DISKS;
		}

		// Start building the PDQ model ...

		PDQ pdq = new PDQ();

		pdq.Init(scenario);

		// Define physical resources as queues ...

		noNodes = pdq.CreateNode("PC", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("FS", Node.CEN, QDiscipline.FCFS);

		for (int i = 0; i < FS_DISKS; i++) {
			noNodes = pdq.CreateNode(FDarray[i].label, Node.CEN,
					QDiscipline.FCFS);
		}

		noNodes = pdq.CreateNode("GW", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("MF", Node.CEN, QDiscipline.FCFS);

		for (int i = 0; i < MF_DISKS; i++) {
			noNodes = pdq.CreateNode(MDarray[i].label, Node.CEN,
					QDiscipline.FCFS);
		}

		noNodes = pdq.CreateNode("TR", Node.CEN, QDiscipline.FCFS);

		// NOTE: Althought the Token Ring LAN is a passive computational device,
		// it is treated as a separate node so as to agree to the results
		// presented in the original CMG'93 paper.

		// Assign transaction names ...

		String txCD = "CatDsply";
		String txRQ = "RemQuote";
		String txSU = "StatusUp";

		// Define an OPEN circuit aggregate workload ...

		noStreams = pdq.CreateOpen(txCD, USERS * 4.0 / 60.0);
		noStreams = pdq.CreateOpen(txRQ, USERS * 8.0 / 60.0);
		noStreams = pdq.CreateOpen(txSU, USERS * 1.0 / 60.0);

		// Define the service demands on each physical resource ...

		// CD request + reply chain from workflow diagram

		pdq
				.SetDemand("PC", txCD, demand[CD_Req][PC]
						+ (5 * demand[CD_Rpy][PC]));
		pdq
				.SetDemand("FS", txCD, demand[Req_CD][FS]
						+ (5 * demand[CD_Msg][FS]));

		for (int i = 0; i < FS_DISKS; i++) {
			pdq.SetDemand(FDarray[i].label, txCD, demand[Req_CD][FDarray[i].id]
					+ (5 * demand[CD_Msg][FDarray[i].id]));
		}

		pdq
				.SetDemand("GW", txCD, demand[GT_Snd][GW]
						+ (5 * demand[GT_Rcv][GW]));
		pdq.SetDemand("MF", txCD, demand[MF_CD][MF]);

		for (int i = 0; i < MF_DISKS; i++) {
			pdq.SetDemand(MDarray[i].label, txCD, demand[MF_CD][MDarray[i].id]);
		}

		// NOTE: Synchronous process execution caimports data for the CD
		// transaction to cross the LAN 12 times as depicted in the following
		// parameterization of pdq.SetDemand.

		pdq.SetDemand("TR", txCD, (1 * demand[LAN_Tx][PC])
				+ (1 * demand[LAN_Tx][FS]) + (5 * demand[LAN_Tx][GW])
				+ (5 * demand[LAN_Tx][FS]));

		// RQ request + reply chain ...

		pdq
				.SetDemand("PC", txRQ, demand[RQ_Req][PC]
						+ (3 * demand[RQ_Rpy][PC]));
		pdq
				.SetDemand("FS", txRQ, demand[Req_RQ][FS]
						+ (3 * demand[RQ_Msg][FS]));

		for (int i = 0; i < FS_DISKS; i++) {
			pdq.SetDemand(FDarray[i].label, txRQ, demand[Req_RQ][FDarray[i].id]
					+ (3 * demand[RQ_Msg][FDarray[i].id]));
		}

		pdq
				.SetDemand("GW", txRQ, demand[GT_Snd][GW]
						+ (3 * demand[GT_Rcv][GW]));
		pdq.SetDemand("MF", txRQ, demand[MF_RQ][MF]);

		for (int i = 0; i < MF_DISKS; i++) {
			pdq.SetDemand(MDarray[i].label, txRQ, demand[MF_RQ][MDarray[i].id]);
		}

		pdq.SetDemand("TR", txRQ, (1 * demand[LAN_Tx][PC])
				+ (1 * demand[LAN_Tx][FS]) + (3 * demand[LAN_Tx][GW])
				+ (3 * demand[LAN_Tx][FS]));

		// SU request + reply chain ...

		pdq.SetDemand("PC", txSU, demand[SU_Req][PC] + demand[SU_Rpy][PC]);
		pdq.SetDemand("TR", txSU, demand[LAN_Tx][PC]);
		pdq.SetDemand("FS", txSU, demand[Req_SU][FS] + demand[SU_Msg][FS]);

		for (int i = 0; i < FS_DISKS; i++) {
			pdq.SetDemand(FDarray[i].label, txSU, demand[Req_SU][FDarray[i].id]
					+ demand[SU_Msg][FDarray[i].id]);
		}

		pdq.SetDemand("TR", txSU, demand[LAN_Tx][FS]);
		pdq.SetDemand("GW", txSU, demand[GT_Snd][GW] + demand[GT_Rcv][GW]);
		pdq.SetDemand("MF", txSU, demand[MF_SU][MF]);

		for (int i = 0; i < MF_DISKS; i++) {
			pdq.SetDemand(MDarray[i].label, txSU, demand[MF_SU][MDarray[i].id]);
		}

		pdq.SetDemand("TR", txSU, (1 * demand[LAN_Tx][PC])
				+ (1 * demand[LAN_Tx][FS]) + (1 * demand[LAN_Tx][GW])
				+ (1 * demand[LAN_Tx][FS]));

		boolean DEBUG = false;

		pdq.Solve(Methods.CANON);

		// pdq.Report();

		// Break out Tx response times and device utilizations ...

		Format.printf("*** PDQ Breakout \"%s\" (%d clients) ***\n\n", p.add(
				scenario).add(USERS));

		double[] util = new double[noNodes];

		for (int dev = 0; dev < noNodes; dev++) {
			util[dev] = 0.0; // reset array
			for (int work = 0; work < noStreams; work++) {
				util[dev] += 100 * pdq.GetUtilization(pdq.node[dev].devname,
						pdq.job[work].trans.name, Job.TRANS);
			}
		}

		// Order of print out follows that in 1993 CMG paper.

		Format.printf("Transaction  \tLatency(Secs)\n");
		Format.printf("-----------  \t-----------\n");

		for (int work = 0; work < noStreams; work++) {
			Format.printf("%s\t%7.4f\n", p.add(pdq.job[work].trans.name).add(
					pdq.job[work].trans.sys.response));
		}

		Format.printf("\n\n");

		double uws = 0.0;
		double ugw = 0.0;
		double ufs = 0.0;
		double umf = 0.0;
		double ulan = 0.0;
		double[] udsk = new double[FS_DISKS];
		double[] udasd = new double[MF_DISKS];

		for (int dev = 0; dev < noNodes; dev++) {
			if (pdq.node[dev].devname.equals("PC")) {
				uws += util[dev];
			}
			if (pdq.node[dev].devname.equals("GW")) {
				ugw += util[dev];
			}
			if (pdq.node[dev].devname.equals("FS")) {
				ufs += util[dev];
			}

			for (int i = 0; i < FS_DISKS; i++) {
				if (pdq.node[dev].devname.equals(FDarray[i].label)) {
					udsk[i] += util[dev];
				}
			}

			if (pdq.node[dev].devname.equals("MF")) {
				umf += util[dev];
			}

			for (int i = 0; i < MF_DISKS; i++) {
				if (pdq.node[dev].devname.equals(MDarray[i].label)) {
					udasd[i] += util[dev];
				}
			}

			if (pdq.node[dev].devname.equals("TR")) {
				ulan += util[dev];
			}
		}

		Format.printf("Node      \t%% Utilization\n");
		Format.printf("----      \t--------------\n");
		Format.printf("%s\t%7.4f\n", p.add("Token Ring ").add(ulan));
		Format.printf("%s\t%7.4f\n", p.add("Desktop PC ").add(uws / USERS));
		Format.printf("%s\t%7.4f\n", p.add("FileServer ").add(ufs));

		for (int i = 0; i < FS_DISKS; i++) {
			Format.printf("%s%d\t%7.4f\n", p.add("FS Disk").add(FDarray[i].id)
					.add(udsk[i]));
		}

		Format.printf("%s\t%7.4f\n", p.add("Gateway SNA").add(ugw));
		Format.printf("%s\t%7.4f\n", p.add("Mainframe  ").add(umf));

		for (int i = 0; i < MF_DISKS; i++) {
			Format.printf("%s%d\t%7.4f\n", p.add("MFrame DASD").add(
					MDarray[i].id).add(udasd[i]));
		}
	}	// main
	
}	// Ch8_Baseline


