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
 * Based on closed_center.c
 * 
 * Illustrates the use of PDQ solver for multiclass workload.
 * 
 * $Id$
 */
public class Ch3_MultiClass {

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// ---- Model specific variables -------------------------------

		double thinkTime = 0.0;

		// ---- Initialize the model -----------------------------------

		int technique = Methods.APPROX;

		Format.printf("**** %s Solution ****:\n\n", p
				.add((technique == Methods.EXACT) ? "EXACT" : "APPROX"));
		Format.printf("  N      R (w1)    R (w2)\n");

		for (int population = 1; population < 10; population++) {
			PDQ pdq = new PDQ();

			pdq.Init("Test_Exact_calc");

			// ---- Define the workload and circuit type -----------

			int noStreams = pdq.CreateClosed("w1", Job.TERM, 1.0 * population,
					thinkTime);
			noStreams = pdq.CreateClosed("w2", Job.TERM, 1.0 * population,
					thinkTime);

			// ---- Define the queueing center ---------------------

			int noNodes = pdq.CreateNode("node", Node.CEN, QDiscipline.FCFS);

			// ---- service demand ---------------------------------

			pdq.SetDemand("node", "w1", 1.0);
			pdq.SetDemand("node", "w2", 0.5);

			// ---- Solve the model --------------------------------

			pdq.Solve(technique);

			System.out.printf("%3d     %7.4f   %7.4f\n",
				population,
				pdq.GetResponse(Job.TERM, "w1"),
				pdq.GetResponse(Job.TERM, "w2"));
				// p.add(pdq.GetResponse(Job.TERM, "w1")),
				// p.add(pdq.GetResponse(Job.TERM, "w2")));
		}
	}	// main
	
}	// Ch3_MultiClass
