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
 * @author plh@pha.com.au
 * 
 */
public class Ch3_Closed {

	public static void main(String[] args) {
		// -------------------------------------------------------------

		Parameters p = new Parameters();

		// ---- Model specific variables -------------------------------

		double population = 3.0;
		double thinkTime = 0.1;

		// ---- Initialize the model giving it a name ------------------
		// Give model a name and initialize internal PDQ variables

		PDQ pdq = new PDQ();

		pdq.Init("Closed Queue");

		// ---- Define the workload and circuit type -------------------

		int noStreams = pdq.CreateClosed("w1", Job.TERM, 1.0 * population,
				thinkTime);

		// System.out.printf("%d jobs\n", p.add(noStreams));

		// ---- Define the queueing center -----------------------------

		int noNodes = pdq.CreateNode("node", Node.CEN, QDiscipline.FCFS);

		// System.out.printf("%d nodes\n", p.add(noNodes));

		// ---- Define service demand ----------------------------------

		pdq.SetDemand("node", "w1", 0.10);

		// ---- Solve the model ----------------------------------------

		// Format.printf "**** %s ****:\n", p.add((solve_as == Methods.EXACT) ?
		// "EXACT" : "APPROX"));

		pdq.Solve(Methods.APPROX);

		// ---- Generate a report --------------------------------------

		pdq.Report();

		// -------------------------------------------------------------
	}	// main
	
	// ---------------------------------------------------------------------

}	// Ch3_Closed

