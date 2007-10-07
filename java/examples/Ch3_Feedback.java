/*
 * Created on 20/02/2004
 *
 * Based on open_feedback
 *
 *  $Id$
 */

import com.perfdynamics.pdq.*;

// import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * @author plh@pha.com.au
 * 
 */
public class Ch3_Feedback {

	public static void main(String[] args) {
		double rx_prob = 0.30;
		double inter_arriv_rate = 0.5;
		double service_time = 0.75;
		double mean_visits = 1.0 / (1.0 - rx_prob);

		// ----- Initialize the model
		// ----------------------------------------------------

		PDQ pdq = new PDQ();

		pdq.Init("Open Feedback");

		// ---- Define the queueing center
		// -----------------------------------------------

		int noNodes = pdq.CreateNode("channel", Node.CEN, QDiscipline.FCFS);

		// ---- Define the workload and circuit type
		// -------------------------------------

		int noStreams = pdq.CreateOpen("message", inter_arriv_rate);

		// ---- Define service demand due to workload on the queueing center
		// -------------

		pdq.SetVisits("channel", "message", mean_visits, service_time);

		// ---- Must use the CANONical method for an open circuit
		// ------------------------

		pdq.Solve(Methods.CANON);

		pdq.Report();
	}	// main
	
}	// Ch3_Feedback

