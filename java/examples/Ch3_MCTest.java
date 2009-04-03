/*
 * Created on 20/02/2004
 *
 *  By: plh@pha.com.au
 *
 *  $Id$
 *
 */

import com.perfdynamics.pdq.*;

public class Ch3_MCTest {
	private int noStreams;

	private int noNodes;

	public static void main(String[] args) {
		int noNodes;
		int noStreams;

		PDQ pdq = new PDQ();

		pdq.Init("Multiclass Test");

		// ---- Define the workload and circuit type
		// -------------------------------------

		noStreams = pdq.CreateClosed("term1", Job.TERM, 5.0, 20.0);
		noStreams = pdq.CreateClosed("term2", Job.TERM, 15.0, 30.0);
		noStreams = pdq.CreateClosed("batch", Job.BATCH, 5.0, 0.0);

		// ---- Define the queueing center
		// -----------------------------------------------

		noNodes = pdq.CreateNode("node1", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("node2", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("node3", Node.CEN, QDiscipline.FCFS);

		// ---- Define service demand
		// ----------------------------------------------------

		pdq.SetDemand("node1", "term1", 0.50);
		pdq.SetDemand("node1", "term2", 0.04);
		pdq.SetDemand("node1", "batch", 0.06);

		pdq.SetDemand("node2", "term1", 0.40);
		pdq.SetDemand("node2", "term2", 0.20);
		pdq.SetDemand("node2", "batch", 0.30);

		pdq.SetDemand("node3", "term1", 1.20);
		pdq.SetDemand("node3", "term2", 0.05);
		pdq.SetDemand("node3", "batch", 0.06);

		// ---- Solve it
		// -----------------------------------------------------------------

		pdq.Solve(Methods.EXACT);

		pdq.Report();
	}	// main
	
}	// Ch3_MCTest
