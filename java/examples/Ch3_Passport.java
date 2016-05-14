/*
 * Created on 21/02/2004
 *
 *  By: plh@pha.com.au
 *
 * Based on passpt_office.c
 *
 * Illustration of an open queueing circuit with feedback.
 *  
 *  $Id$
 */

import com.perfdynamics.pdq.*;
import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * @author plh
 * 
 */
public class Ch3_Passport {

	public static void main(String[] args) {
		int noNodes;
		int noStreams;

		Parameters p = new Parameters();

		double arrivals = 16.0 / 3600; // // 16 applications per hour

		// ---- Branching probabilities and weights
		// --------------------------------------

		double p12 = 0.30;
		double p13 = 0.70;
		double p23 = 0.20;
		double p32 = 0.10;

		double w3 = (p13 + p23 * p12) / (1 - p23 * p32);
		double w2 = p12 + p32 * w3;

		// ---- Initialize and solve the model
		// -------------------------------------------

		PDQ pdq = new PDQ();

		pdq.Init("Passport Office");

		noStreams = pdq.CreateOpen("Applicant", 0.00427);

		noNodes = pdq.CreateNode("Window1", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("Window2", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("Window3", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("Window4", Node.CEN, QDiscipline.FCFS);

		pdq.SetDemand("Window1", "Applicant", 20.0);
		pdq.SetDemand("Window2", "Applicant", 600.0 * w2);
		pdq.SetDemand("Window3", "Applicant", 300.0 * w3);
		pdq.SetDemand("Window4", "Applicant", 60.0);

		pdq.Solve(Methods.CANON);

		pdq.Report();
	}	// main
	
}	// Ch3_Passport
