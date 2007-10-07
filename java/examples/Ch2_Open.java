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
 * @author plh
 * 
 */
public class Ch2_Open {

	public static void main(String[] args) {
		// ---- Model specific variables
		// ------------------------------------------------
		Parameters p = new Parameters();
		// Format.printf("%s = %d", p.add("test").add(12));

		double arrivalRate = 0.75;
		double serviceTime = 1.0;

		// ---- Initialize the model giving it a name
		// -----------------------------------

		PDQ pdq = new PDQ();

		pdq.Init("OpenCenter");
		pdq.SetComment("This is just a simple M/M/1 queue.");

		pdq.SetWUnit("Customers");
		pdq.SetTUnit("Seconds");

		// ---- Define the queueing center
		// ----------------------------------------------

		int noNodes = pdq.CreateNode("server", Node.CEN, QDiscipline.FCFS);

		// Format.printf("%d nodes\n", p.add(noNodes));

		// ---- Define the workload and circuit type
		// ------------------------------------

		int noStreams = pdq.CreateOpen("work", arrivalRate);

		// Format.printf("%d jobs\n", p.add(noStreams));

		// ---- Define service demand
		// ---------------------------------------------------

		pdq.SetDemand("server", "work", serviceTime);

		// ---- Solve the model
		// ---------------------------------------------------------
		// Must use the CANONical method for an open circuit

		pdq.Solve(Methods.CANON);

		// ---- Generate a report ------------------------------------------

		pdq.Report();
	}	// main
	
}	// Ch2_Open
