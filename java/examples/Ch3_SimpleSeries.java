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
 * @author plh Based on simple_series_circuit.c
 * 
 * An open queueing circuit with 3 centers.
 * 
 * $Id$
 */
public class Ch3_SimpleSeries {

	public static void main(String[] args) {
		Parameters p = new Parameters();

		PDQ pdq = new PDQ();

		double arrivals_per_second = 0.10;

		pdq.Init("Simple Series Circuit");

		int noStreams = pdq.CreateOpen("Work", arrivals_per_second);

		int noNodes = pdq.CreateNode("Center1", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("Center2", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("Center3", Node.CEN, QDiscipline.FCFS);

		pdq.SetDemand("Center1", "Work", 1.0);
		pdq.SetDemand("Center2", "Work", 2.0);
		pdq.SetDemand("Center3", "Work", 3.0);

		pdq.Solve(Methods.CANON);

		pdq.Report();
	}	// main
	
}	// Ch3_SimpleSeries

