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
 * multibus.pl
 * 
 * Created by NJG: 13:03:53 07-19-96 Updated by NJG: 19:31:12 07-31-96
 * 
 * $Id$
 */
public class Ch7_Multibus {
	// System parameters

	public static int BUSES = 9;

	public static int CPUS = 64;

	public static double STIME = 1.0;

	public static double COMPT = 10.0;

	// Submodel throughput characteristic

	public static double[] sm_x = null;

	public static double[][] pq = null;

	// ------------------------------------------------------------------

	public static void multiserver(int m, double stime) {
		String work = "reqs";
		String node = "bus";

		Parameters p = new Parameters();

		double x = 0.0;

		for (int i = 1; i <= CPUS; i++) {
			if (i <= m) {
				PDQ pdq = new PDQ();

				pdq.Init("multibus");

				int noStreams = pdq.CreateClosed(work, Job.TERM, i, 0.0);
				int noNodes = pdq.CreateNode(node, Node.CEN, QDiscipline.ISRV);

				pdq.SetDemand(node, work, stime);
				pdq.Solve(Methods.EXACT);

				x = pdq.GetThruput(Job.TERM, work);

				sm_x[i] = x;
			} else {
				sm_x[i] = x;
			}
			Format.printf("*>> %f\n", p.add(x));
		}
	} // multiserver

	// ---------------------------------------------------------------------

	public static void main(String[] args) {
		Parameters p = new Parameters();

		// ------------------------------------------------------------------

		Format.printf("multibus.out\n");

		// ----- Multibus submodel ------------------------------------------

		sm_x = new double[CPUS + 1];
		pq = new double[CPUS + 1][CPUS + 1];

		multiserver(BUSES, STIME);

		// ----- Composite model --------------------------------------------

		pq[0][0] = 1.0;

		double R = 0.0;
		double h = 0.0;
		double xn = 0.0;
		double qlength = 0.0;

		for (int n = 1; n <= CPUS; n++) {
			R = 0.0; // reset

			for (int j = 1; j <= n; j++) {
				h = (j / sm_x[j]) * pq[j - 1][n - 1];
				R += h;
				// Format.printf("%2d sm_x[%02d] %f pq[%02d][%02d] %f h %f R
				// %f\n",
				// p.add(j).add(sm_x[j]).add(j).add(n).add(pq[j - 1][n -
				// 1]).add(h).add(R));
			}

			xn = n / (COMPT + R);

			// Format.printf("xn %f n %d COMPT+R %f\n",
			// p.add(xn).add(n).add((COMPT + R)));

			qlength = xn * R;

			// Format.printf("qlngth %f\n", p.add(qlength));

			for (int j = 1; j <= n; j++) {
				pq[j][n] = (xn / sm_x[j]) * pq[j - 1][n - 1];
				// Format.printf("pq[%d][%d] %f\n",
				// p.add(j).add(n).add(pq[j][n]);
			}

			pq[0][n] = 1.0;

			for (int j = 1; j <= n; j++) {
				pq[0][n] -= pq[j][n];
				// Format.printf("%2d %2d pq[00][%02d] %f pq[%02d][%02d] %f\n",
				// p.add(j).add(n).add(n).add(pq[0][n]).add(j).add(pq[j][n]);
			}
		}

		// ----- Processing Power ----------------------------------------------

		Format.printf("Buses:%2d, CPUs:%2d\n", p.add(BUSES).add(CPUS));
		Format.printf("Load %3.4f\n", p.add(STIME / COMPT));
		Format.printf("X at FESC: %3.4f\n", p.add(xn));
		Format.printf("P %3.4f\n", p.add(xn * COMPT));

		// ---------------------------------------------------------------------
	}	// main
	
}	// Ch7_Multibus


