/*
 * Created on 20/02/2004
 *
 */

package com.perfdynamics.pdq;

import com.braju.format.*;  // Used for fprintf/sprintf!

/**
 * @author plh@pha.com.au
 *
 */
public class Test {
	
	public static void main(String[] args) {
		Parameters p = new Parameters();

		double arrivalRate = 0.75;
		double serviceTime = 1.0;

		//---- Initialize --------------------------------------------------

		PDQ pdq = new PDQ();
		
		pdq.Init("OpenCenter");
   
		pdq.SetWUnit("Customers");
		pdq.SetTUnit("Seconds");

		//---- Define the queueing center ---------------------------------

		int noNodes = pdq.CreateNode("server", Node.CEN, QDiscipline.FCFS);

		Format.printf("%d nodes\n", p.add(noNodes));

		//---- Define the workload and circuit type -----------------------

		int noStreams = pdq.CreateOpen("work", arrivalRate);

		Format.printf("%d jobs\n", p.add(noStreams));

		//---- Define service demand due to workload on the queueing center

		pdq.SetDemand("server", "work", serviceTime);

		//---- Solve the model --------------------------------------------
		//  Must use the CANONical method for an open circuit

		pdq.Solve(Methods.CANON);

		//---- Generate a report ------------------------------------------

		pdq.Report();
	}
}
