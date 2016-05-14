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
 * dbc.pl - Teradata DBC-10/12 performance model
 * 
 * PDQ calculation of optimal parallel configuration.
 * 
 * $Id$
 */
public class Ch6_DBC {

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// ------------------------------------------------------------------

		double thinkTime = 10.0;
		int noUsers = 300;

		double Sifp = 0.10;
		double Samp = 0.60;
		double Sdsu = 1.20;
		int Nifp = 15;
		int Namp = 50;
		int Ndsu = 100;

		int noNodes;
		int noStreams;

		String name = null;

		// ------------------------------------------------------------------

		PDQ pdq = new PDQ();

		pdq.Init("Teradata DBC-10/12");

		// ------------------------------------------------------------------
		// Create parallel centers

		for (int k = 0; k < Nifp; k++) {
			name = Format.sprintf("IFP%d", p.add(k));
			noNodes = pdq.CreateNode(name, Node.CEN, QDiscipline.FCFS);
		}

		for (int k = 0; k < Namp; k++) {
			name = Format.sprintf("AMP%d", p.add(k));
			noNodes = pdq.CreateNode(name, Node.CEN, QDiscipline.FCFS);
		}

		for (int k = 0; k < Ndsu; k++) {
			name = Format.sprintf("DSU%d", p.add(k));
			noNodes = pdq.CreateNode(name, Node.CEN, QDiscipline.FCFS);
		}

		noStreams = pdq.CreateClosed("query", Job.TERM, noUsers, thinkTime);

		for (int k = 0; k < Nifp; k++) {
			name = Format.sprintf("IFP%d", p.add(k));
			pdq.SetDemand(name, "query", Sifp / Nifp);
		}

		for (int k = 0; k < Namp; k++) {
			name = Format.sprintf("AMP%d", p.add(k));
			pdq.SetDemand(name, "query", Samp / Namp);
		}

		for (int k = 0; k < Ndsu; k++) {
			name = Format.sprintf("DSU%d", p.add(k));
			pdq.SetDemand(name, "query", Sdsu / Ndsu);
		}

		System.out.printf("Solving APPROX... ");

		pdq.Solve(Methods.APPROX);

		System.out.printf("Done.\n");

		pdq.Report();
	}	// main
	
}	// Ch6_DBC

