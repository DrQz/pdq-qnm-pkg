/*
 * Created on 20/02/2004
 *
 *  By: plh@pha.com.au
 *
 *  $Id$
 *
 */

import com.perfdynamics.pdq.*;
import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * Illustrates PDQ solver for closed uni-server queue. Compare with repair.c
 * Based on time_share.c
 * 
 */
public class Ch2_Closed {

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// ---- Model specific variables ---------------------------

		double population = 100.0;
		double thinkTime = 300.0;
		double serviceTime = 0.63;

		// ---- Initialize the model giving it a name --------------

		PDQ pdq = new PDQ();

		pdq.Init("Time Share Computer");
		pdq.SetComment("This is just a simple M/M/1 queue.");

		// ---- Define the workload and circuit type ---------------

		int noStreams = pdq.CreateClosed("compile", Job.TERM, population,
				thinkTime);

		// System.out.printf("%d jobs\n", p.add(noStreams));

		// ---- Define the queueing center -------------------------

		int noNodes = pdq.CreateNode("CPU", Node.CEN, QDiscipline.FCFS);

		// System.out.printf("%d nodes\n", p.add(noNodes));

		// ---- Define service demand ------------------------------

		pdq.SetDemand("CPU", "compile", serviceTime);

		// ---- Solve the model ------------------------------------

		pdq.Solve(Methods.EXACT);

		// ---- Generate a report ----------------------------------

		pdq.Report();
	}	// main

	// -----------------------------------------------------------------
	
}	// Ch2_Closed}

