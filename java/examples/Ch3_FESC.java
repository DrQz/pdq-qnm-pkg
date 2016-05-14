/*
 * Created on 20/02/2004
 *
 *  FESC.java -- Flow Equivalent Service Center model
 *
 *  Composite system is a closed circuit comprising N USERS
 *  and a FESC submodel with a single-class workload.
 *
 *  This model is discussed on p.112 ff. of the book that accompanies
 *  PDQ entitled: "The Practical Performance Analyst," by N.J.Gunther
 *  and matches the results presented in the book: "Quantitative System
 *  Performance," by Lazowska, Zahorjan, Graham, and Sevcik, Prentice-Hall
 *  1984.
 *
 *  $Id$
 */

import com.perfdynamics.pdq.*;

import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * @author plh
 * 
 */
public class Ch3_FESC {
	// ----- Global variables ----------------------------------------------

	private static final int USERS = 15;

	// ---------------------------------------------------------------------
	// Model specific variables
	// ---------------------------------------------------------------------

	private static int max_pgm = 3;
	private static double think = 60.0;
	private double xn;
	private double qlength;
	private double R;
	private double[][] pq = null;
	private double[] sm_x = null;

	// [USERS + 1] - submodel throughput characteristic
	private int noNodes;
	private int noStreams;

	// ---------------------------------------------------------------------

	public void mem_model(int n, int m) {
		double x = 0.0;

		sm_x = new double[n + 1];

		for (int i = 1; i <= n; i++) {
			if (i <= m) {
				PDQ pdq = new PDQ();

				pdq.Init("");

				noNodes = pdq.CreateNode("CPU", Node.CEN, QDiscipline.FCFS);
				noNodes = pdq.CreateNode("DK1", Node.CEN, QDiscipline.FCFS);
				noNodes = pdq.CreateNode("DK2", Node.CEN, QDiscipline.FCFS);

				noStreams = pdq.CreateClosed("work", Job.TERM, i, 0.0);

				pdq.SetDemand("CPU", "work", 3.0);
				pdq.SetDemand("DK1", "work", 4.0);
				pdq.SetDemand("DK2", "work", 2.0);

				pdq.Solve(Methods.EXACT);

				x = pdq.GetThruput(Job.TERM, "work");

				// System.err.println("mem_model::i -> X\n" +
				// Integer.toString(i));

				sm_x[i] = x;
			} else {
				// System.err.println("mem_model::i -> LAST\n" +
				// Integer.toString(i));
				sm_x[i] = x; // last computed value
			}
		}
	} // mem_model

	// ---------------------------------------------------------------------

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// ---------------------------------------------------------------------
		// Memory-limited Submodel
		// ---------------------------------------------------------------------

		Ch3_FESC f = new Ch3_FESC();

		int max_pgm = 3;
		double think = 60.0;

		f.pq = new double[USERS + 1][USERS + 1];

		// ---------------------------------------------------------------------
		// Composite Model
		// ---------------------------------------------------------------------

		f.mem_model(USERS, max_pgm);

		f.pq[0][0] = 1.0;

		for (int n = 1; n <= USERS; n++) {
			f.R = 0.0; // Reset

			// Response time at the FESC

			for (int j = 1; j <= n; j++) {
				// Format.printf "sm_x[%d] = %f n = %d\n", j, sm_x[j], n;
				f.R += (j / (f.sm_x[j]) * f.pq[j - 1][n - 1]);
			}

			// Thruput and queue-length at the FESC

			f.xn = n / (think + f.R);
			f.qlength = f.xn * f.R;

			// Compute queue-length distribution at the FESC

			for (int j = 1; j <= n; j++) {
				// Format.printf "j = %d n = %d\n", j, n;
				// Format.printf "> %f\n", pq[j][n];
				f.pq[j][n] = (f.xn / f.sm_x[j]) * f.pq[j - 1][n - 1];
				// Format.printf "pq[%d][%d] %f\n", j, n, f.pq[j][n];
			}

			f.pq[0][n] = 1.0;

			for (int j = 1; j <= n; j++) {
				f.pq[0][n] -= f.pq[j][n];
				// Format.printf "pq[%d][%d] %f\n",
				// p.add(j).add(n).add(f.pq[j][n]));
			}
		}

		// *********************************************************************
		// Report FESC Measures
		// *********************************************************************

		Format.printf("\n");
		Format.printf("Max Users: %2d\n", p.add(USERS));
		Format.printf("X at FESC: %3.4f\n", p.add(f.xn));
		Format.printf("R at FESC: %3.2f\n", p.add(f.R));
		Format.printf("Q at FESC: %3.2f\n\n", p.add(f.qlength));

		// Joint Probability Distribution

		Format.printf("QLength\t\tP(j | n)\n");
		Format.printf("-------\t\t--------\n");

		for (int n = 0; n <= USERS; n++) {
			Format.printf(" %2d\t\tp(%2d|%2d): %3.4f\n", p.add(n).add(n).add(
					USERS).add(f.pq[n][USERS]));
		}
	}	// main
	
}	// Ch3_FESC
