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
 * Ch7_Abcache.java - Cache protocol scaling
 * 
 * Created by NJG: 13:03:53 07-19-96 Revised by NJG: 18:58:44 04-02-99 Converted
 * to Java by Peter Harding (plh@pha.com.au) 2004-02-20
 * 
 * $Id$
 * 
 */
public class Ch7_Abcache {

	// ---------------------------------------------------------------------

	private static int intwt(double N, double W) {
		double weight = 0.0;

		if (N < 1.0) {
			weight = 1;
			W = N;
		}

		if (N >= 1.0) {
			weight = N;
			W = 1.0;
		}

		return (int) weight;
	} // intwt

	// ---------------------------------------------------------------------

	private static int xintwt(double[] x) {
		double weight = 0.0;

		if (x[0] < 1.0) {
			weight = 1;
			x[1] = x[0];
		} else {
			weight = x[0];
			x[1] = 1.0;
		}

		x[1] = 2.0;

		return (int) weight;
	} // intwt

	// ---------------------------------------------------------------------

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// Main memory update policy

		String model = "ABC Model";
		String cname = null;
		String wname = null;
		int no = 0;
		int noNodes = 0;
		int noStreams = 0;
		;

		boolean WBACK = true;

		double[] x;

		// Globals

		int MAXCPU = 15;
		double ZX = 2.5;

		// Cache parameters

		double RD = 0.85;
		double WR = (1 - RD);

		double HT = 0.95;
		double WUMD = 0.0526;
		double MD = 0.35;

		// Bus and L2 cache ids

		String L2C = "L2C";
		String BUS = "MBus";

		// Aggregate cache traffic

		String RWHT = "RWhit";
		double gen = 1.0;

		// Bus Ops

		String RDOP = "Read";
		String WROP = "Write";
		String INVL = "Inval";

		// per CPU intruction stream intensity

		double Prhit = (RD * HT);
		double Pwhit = (WR * HT * (1 - WUMD)) + (WR * (1 - HT) * (1 - MD));
		double Prdop = RD * (1 - HT);
		double Pwbop = WR * (1 - HT) * MD;
		double Pwthr = WR;
		double Pinvl = WR * HT * WUMD;

		double Nrwht = 0.8075 * MAXCPU;
		double Nrdop = 0.0850 * MAXCPU;
		double Nwthr = 0.15 * MAXCPU;

		double Nwbop = 0.0003 * MAXCPU * 100;
		double Ninvl = 0.015 * MAXCPU;

		double Srdop = (20.0);
		double Swthr = (25.0);
		double Swbop = (20.0);

		double Wrwht = 0.0;
		double Wrdop = 0.0;
		double Wwthr = 0.0;
		double Wwbop = 0.0;
		double Winvl = 0.0;

		double Zrwht = ZX;
		double Zrdop = ZX;
		double Zwbop = ZX;
		double Zinvl = ZX;
		double Zwthr = ZX;

		double Xcpu = 0.0;
		double Pcpu = 0.0;
		double Ubrd = 0.0;
		double Ubwr = 0.0;
		double Ubin = 0.0;
		double Ucht = 0.0;
		double Ucrd = 0.0;
		double Ucwr = 0.0;
		double Ucin = 0.0;

		// ---------------------------------------------------------------------

		PDQ pdq = new PDQ();

		pdq.Init("ABC Model");

		pdq.SetWUnit("Reqs");
		pdq.SetTUnit("Cycs");

		// ----- Create single bus queueing center -----------------------------

		noNodes = pdq.CreateNode(BUS, Node.CEN, QDiscipline.FCFS);

		// ----- Create per CPU cache queueing centers -------------------------

		for (int i = 0; i < MAXCPU; i++) {
			cname = Format.sprintf("%s%d", p.add(L2C).add(i));
			noNodes = pdq.CreateNode(cname, Node.CEN, QDiscipline.FCFS);
			// Format.printf("i %2d cname %10s nodes %d\n",
			// p.add(i).add(cname).add(noNodes));
		}

		// ----- Create CPU nodes, workloads, and demands ----------------------

		Format.printf("       Nrwht %s, Zrwht %s\n", p.add(Nrwht).add(Zrwht));

		Format.printf("Before:  Nrwht %f  Wrwht %f\n", p.add(Nrwht).add(Wrwht));

		no = (Nrwht < 1.0) ? (int) Nrwht : 1;
		Wrwht = (Nrwht < 1.0) ? Nrwht : 1.0;

		// no = intwt(Nrwht, Wrwht);

		Format.printf("After:  Nrwht %f  Wrwht %f\n", p.add(Nrwht).add(Wrwht));

		Format.printf("no %d %f  Nrwht %d, Zrwht %d\n", p.add(no).add(no).add(
				Nrwht).add(Zrwht));

		for (int i = 0; i < no; i++) {
			wname = Format.sprintf("%s%d", p.add(RWHT).add(i));

			// Format.printf("wname %s Nrwht %d, Zrwht %d\n",
			// p.add(wname).add(Nrwht).add(Zrwht));

			noStreams = pdq.CreateClosed(wname, Job.TERM, Nrwht, Zrwht);

			cname = Format.sprintf("%s%d", p.add(L2C).add(i));

			// Format.printf("cname %s\n", p.add(cname));

			pdq.SetDemand(cname, wname, 1.0);
			pdq.SetDemand(BUS, wname, 0.0); // no bus activity

			Format.printf("i %2d  cname %10s  nodes %2d  streams %d\n", p
					.add(i).add(cname).add(noNodes).add(noStreams));
		}

		// ---------------------------------------------------------------------

		// no = intwt(Nrdop, Wrdop);

		no = (Nrdop < 1.0) ? (int) Nrdop : 1;
		Wrdop = (Nrdop < 1.0) ? Nrdop : 1.0;

		Format.printf("no %d  Nrdop %d, Zrdop %d\n", p.add(no).add(Nrdop).add(
				Zrdop));

		for (int i = 0; i < no; i++) {
			wname = Format.sprintf("%s%d", p.add(RDOP).add(i));

			noStreams = pdq.CreateClosed(wname, Job.TERM, Nrdop, Zrdop);

			cname = Format.sprintf("%s%d", p.add(L2C).add(i));

			pdq.SetDemand(cname, wname, gen); // generate bus request
			pdq.SetDemand(BUS, wname, Srdop); // req + async data return

			Format.printf("i %2d  cname %10s  nodes %2d  streams %d\n", p
					.add(i).add(cname).add(noNodes).add(noStreams));
		}

		// ---------------------------------------------------------------------

		if (WBACK) {
			// no = intwt(Nwbop, Wwbop);

			no = (Nwbop < 1.0) ? (int) Nwbop : 1;
			Wwbop = (Nwbop < 1.0) ? Nwbop : 1.0;

			Format.printf("no %d  Nwbop %d, Zwbop %d\n", p.add(no).add(Nwbop)
					.add(Zwbop));

			for (int i = 0; i < no; i++) {
				wname = Format.sprintf("%s%d", p.add(WROP).add(i));

				noStreams = pdq.CreateClosed(wname, Job.TERM, Nwbop, Zwbop);

				cname = Format.sprintf("%s%d", p.add(L2C).add(i));

				pdq.SetDemand(cname, wname, gen);
				pdq.SetDemand(BUS, wname, Swbop); // asych write to memory ?

				Format.printf("w %2d  cname %10s  nodes %2d  streams %d\n", p
						.add(i).add(cname).add(noNodes).add(noStreams));
			}
		} else { // write-thru
			// no = intwt(Nwthr, Wwthr);

			no = (Nwthr < 1.0) ? (int) Nwthr : 1;
			Wwthr = (Nwthr < 1.0) ? Nwthr : 1.0;

			Format.printf("no %d  Nwthr %d, Zwthr %d\n", p.add(no).add(Nwthr)
					.add(Zwthr));

			for (int i = 0; i < no; i++) {
				wname = Format.sprintf("%s%d", p.add(WROP).add(i));

				noStreams = pdq.CreateClosed(wname, Job.TERM, Nwthr, Zwthr);

				cname = Format.sprintf("%s%d", p.add(L2C).add(i));

				pdq.SetDemand(cname, wname, gen);
				pdq.SetDemand(BUS, wname, Swthr);

				Format.printf("i %2d  cname %10s  nodes %2d  streams %d\n", p
						.add(i).add(cname).add(noNodes).add(noStreams));
			}
		}

		// ---------------------------------------------------------------------

		if (WBACK) {
			// no = intwt(Ninvl, Winvl);

			no = (Ninvl < 1.0) ? (int) Ninvl : 1;
			Winvl = (Ninvl < 1.0) ? Ninvl : 1.0;

			Format.printf("no %d  Ninvl %d, Zinvl %d\n", p.add(no).add(Ninvl)
					.add(Zinvl));

			for (int i = 0; i < no; i++) {
				wname = Format.sprintf("%s%d", p.add(INVL).add(i));

				noStreams = pdq.CreateClosed(wname, Job.TERM, Ninvl, Zinvl);

				cname = Format.sprintf("%s%d", p.add(L2C).add(i));

				pdq.SetDemand(cname, wname, gen); // gen + intervene
				pdq.SetDemand(BUS, wname, 1.0);

				Format.printf("w %2d  cname %10s  nodes %2d  streams %d\n", p
						.add(i).add(cname).add(noNodes).add(noStreams));
			}
		}

		pdq.Solve(Methods.APPROX);

		// ----- Bus utilizations ----------------------------------------------

		// no = intwt(Nrdop, Wrdop);

		no = (Nrdop < 1.0) ? (int) Nrdop : 1;
		Wrdop = (Nrdop < 1.0) ? Nrdop : 1.0;

		for (int i = 0; i < no; i++) {
			wname = Format.sprintf("%s%d", p.add(RDOP).add(i));

			Ubrd += pdq.GetUtilization(BUS, wname, Job.TERM);
		}

		Ubrd *= Wrdop;

		if (WBACK) {
			// no = intwt(Nwbop, Wwbop);

			no = (Nwbop < 1.0) ? (int) Nwbop : 1;
			Wwbop = (Nwbop < 1.0) ? Nwbop : 1.0;

			for (int i = 0; i < no; i++) {
				wname = Format.sprintf("%s%d", p.add(WROP).add(i));

				Ubwr += pdq.GetUtilization(BUS, wname, Job.TERM);
			}

			Ubwr *= Wwbop;

			// no = intwt(Ninvl, Winvl);

			no = (Ninvl < 1.0) ? (int) Ninvl : 1;
			Winvl = (Ninvl < 1.0) ? Ninvl : 1.0;

			for (int i = 0; i < no; i++) {
				wname = Format.sprintf("%s%d", p.add(INVL).add(i));

				Ubin += pdq.GetUtilization(BUS, wname, Job.TERM);
			}

			Ubin *= Winvl;
		} else { // write-thru
			// no = intwt(Nwthr, Wwthr);

			no = (Nwthr < 1.0) ? (int) Nwthr : 1;
			Wwthr = (Nwthr < 1.0) ? Nwthr : 1.0;

			for (int i = 0; i < no; i++) {
				wname = Format.sprintf("%s%d", p.add(WROP).add(i));

				Ubwr += pdq.GetUtilization(BUS, wname, Job.TERM);
			}

			Ubwr *= Wwthr;
		}

		// ---- Cache measures at CPU[0] only ----------------------------------

		int i = 0;
		cname = Format.sprintf("%s%d", p.add(L2C).add(i));

		wname = Format.sprintf("%s%d", p.add(RWHT).add(i));
		Xcpu = pdq.GetThruput(Job.TERM, wname) * Wrwht;
		Pcpu += Xcpu * Zrwht;
		Ucht = pdq.GetUtilization(cname, wname, Job.TERM) * Wrwht;

		wname = Format.sprintf("%s%d", p.add(RDOP).add(i));
		Xcpu = pdq.GetThruput(Job.TERM, wname) * Wrdop;
		Pcpu += Xcpu * Zrdop;
		Ucrd = pdq.GetUtilization(cname, wname, Job.TERM) * Wrdop;

		Pcpu *= 1.88;

		if (WBACK) {
			wname = Format.sprintf("%s%d", p.add(WROP).add(i));

			Ucwr = pdq.GetUtilization(cname, wname, Job.TERM) * Wwbop;

			wname = Format.sprintf("%s%d", p.add(INVL).add(i));

			Ucin = pdq.GetUtilization(cname, wname, Job.TERM) * Winvl;
		} else { // write-thru
			wname = Format.sprintf("%s%d", p.add(WROP).add(i));

			Ucwr = pdq.GetUtilization(cname, wname, Job.TERM) * Wwthr;
		}

		Format.printf("\n**** %s Results ****\n", p.add(model));
		Format.printf("PDQ nodes: %d  PDQ streams: %d\n", p.add(noNodes).add(
				noStreams));
		Format.printf("Memory Mode: %s\n", p.add(WBACK ? "WriteBack"
				: "WriteThru"));
		Format.printf("Ncpu:  %2d\n", p.add(MAXCPU));

		// no = intwt(Nrwht, Wrwht);

		no = (Nrwht < 1.0) ? (int) Nrwht : 1;
		Wrwht = (Nrwht < 1.0) ? Nrwht : 1.0;

		Format.printf("Nrwht: %5.2f (N:%2d  W:%5.2f)\n", p.add(Nrwht).add(no)
				.add(Wrwht));

		// no = intwt(Nrdop, Wrdop);

		no = (Nrdop < 1.0) ? (int) Nrdop : 1;
		Wrdop = (Nrdop < 1.0) ? Nrdop : 1.0;

		Format.printf("Nrdop: %5.2f (N:%2d  W:%5.2f)\n", p.add(Nrdop).add(no)
				.add(Wrdop));

		if (WBACK) {
			// no = intwt(Nwbop, Wwbop);

			no = (Nwbop < 1.0) ? (int) Nwbop : 1;
			Wwbop = (Nwbop < 1.0) ? Nwbop : 1.0;

			Format.printf("Nwbop: %5.2f (N:%2d  W:%5.2f)\n", p.add(Nwbop).add(
					no).add(Wwbop));

			// no = intwt(Ninvl, Winvl);

			no = (Ninvl < 1.0) ? (int) Ninvl : 1;
			Winvl = (Ninvl < 1.0) ? Ninvl : 1.0;

			Format.printf("Ninvl: %5.2f (N:%2d  W:%5.2f)\n", p.add(Ninvl).add(
					no).add(Winvl));
		} else {
			// no = intwt(Nwthr, Wwthr);

			no = (Nwthr < 1.0) ? (int) Nwthr : 1;
			Wwthr = (Nwthr < 1.0) ? Nwthr : 1.0;

			Format.printf("Nwthr: %5.2f (N:%2d  W:%5.2f)\n", p.add(Nwthr).add(
					no).add(Wwthr));
		}

		Format.printf("\n");
		Format.printf("Hit Ratio:   %5.2f %%\n", p.add(HT * 100.0));
		Format.printf("Read Miss:   %5.2f %%\n", p.add(RD * (1 - HT) * 100.0));
		Format.printf("WriteMiss:   %5.2f %%\n", p.add(WR * (1 - HT) * 100.0));
		Format
				.printf("Ucpu:        %5.2f %%\n", p.add((Pcpu * 100.0)
						/ MAXCPU));
		Format.printf("Pcpu:        %5.2f\n", p.add(Pcpu));
		Format.printf("\n");
		Format.printf("Ubus[reads]: %5.2f %%\n", p.add(Ubrd * 100.0));
		Format.printf("Ubus[write]: %5.2f %%\n", p.add(Ubwr * 100.0));
		Format.printf("Ubus[inval]: %5.2f %%\n", p.add(Ubin * 100.0));
		Format.printf("Ubus[total]: %5.2f %%\n", p
				.add((Ubrd + Ubwr + Ubin) * 100.0));
		Format.printf("\n");
		Format.printf("Uca%d[hits]:  %5.2f %%\n", p.add(i).add(Ucht * 100.0));
		Format.printf("Uca%d[reads]: %5.2f %%\n", p.add(i).add(Ucrd * 100.0));
		Format.printf("Uca%d[write]: %5.2f %%\n", p.add(i).add(Ucwr * 100.0));
		Format.printf("Uca%d[inval]: %5.2f %%\n", p.add(i).add(Ucin * 100.0));
		Format.printf("Uca%d[total]: %5.2f %%\n", p.add(i).add(
				(Ucht + Ucrd + Ucwr + Ucin) * 100.0));
	}	// main

	// ---------------------------------------------------------------------
	
}	// Ch7_Abcache


