/*
 * Created by NJG: Fri May  3 18:41:04  2002
 *  
 *  $Id$
 */

import com.perfdynamics.pdq.*;
import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * Based on shadowcpu.c
 * 
 * Taken from p.254 of "Capacity Planning and Performance Modeling," by Menasce,
 * Almeida, and Dowdy, Prentice-Hall, 1994.
 */
public class Ch3_ShadowCPU {

	public static double GetProdU() {
		int noNodes = 0;
		int noStreams = 0;

		PDQ pdq = new PDQ();

		pdq.Init("");

		noStreams = pdq.CreateClosed("Production", Job.TERM, 20.0, 20.0);

		noNodes = pdq.CreateNode("CPU", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("DK1", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("DK2", Node.CEN, QDiscipline.FCFS);

		pdq.SetDemand("CPU", "Production", 0.30);
		pdq.SetDemand("DK1", "Production", 0.08);
		pdq.SetDemand("DK2", "Production", 0.10);

		pdq.Solve(Methods.APPROX);

		return (pdq.GetUtilization("CPU", "Production", Job.TERM));
	}

	// -------------------------------------------------------------------------------

	public static void main(String[] args) {
		Parameters p = new Parameters();

		int noNodes = 0;
		int noStreams = 0;
		double Ucpu_prod = 0.0;

		boolean PRIORITY = true; // Turn priority on or off here

		String noPri = "CPU Scheduler - No Pri";
		String priOn = "CPU Scheduler - Pri On";

		// ----------------------------------------------------------------------------

		if (PRIORITY) {
			Ucpu_prod = GetProdU();
		}

		// ----------------------------------------------------------------------------

		PDQ pdq = new PDQ();

		pdq.Init(PRIORITY ? priOn : noPri);

		// ---- Workloads
		// -------------------------------------------------------------

		noStreams = pdq.CreateClosed("Production", Job.TERM, 20.0, 20.0);
		noStreams = pdq.CreateClosed("Developmnt", Job.TERM, 15.0, 15.0);

		// ---- Nodes
		// -----------------------------------------------------------------

		noNodes = pdq.CreateNode("CPU", Node.CEN, QDiscipline.FCFS);

		if (PRIORITY) {
			noNodes = pdq.CreateNode("shadCPU", Node.CEN, QDiscipline.FCFS);
		}

		noNodes = pdq.CreateNode("DK1", Node.CEN, QDiscipline.FCFS);
		noNodes = pdq.CreateNode("DK2", Node.CEN, QDiscipline.FCFS);

		// ---- Service demands at each node
		// ------------------------------------------

		pdq.SetDemand("CPU", "Production", 0.30);

		if (PRIORITY) {
			pdq.SetDemand("shadCPU", "Developmnt", 1.00 / (1 - Ucpu_prod));
		} else {
			pdq.SetDemand("CPU", "Developmnt", 1.00);
		}

		pdq.SetDemand("DK1", "Production", 0.08);
		pdq.SetDemand("DK1", "Developmnt", 0.05);

		pdq.SetDemand("DK2", "Production", 0.10);
		pdq.SetDemand("DK2", "Developmnt", 0.06);

		// ---- We use APPROX rather than EXACT to match the numbers in the book
		// ------

		pdq.Solve(Methods.APPROX);

		pdq.Report();
	}	// main
	
}	// Ch3_ShadowCPU

