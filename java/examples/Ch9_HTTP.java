/*
 * HTTP daemon performance model
 *
 * Ported by: plh@pha.com.au on 21/02/2004
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
public class Ch9_HTTP {
	public static Boolean PREFORK = true;

	public static int STRESS = 0;
	public static int HOMEPG = 1;

	public static int              noNodes = 0;
	public static int              noStreams = 0;
	public static int              servers = 2;

	public static void main(String[] args) {
		Parameters p = new Parameters();

		PDQ pdq = new PDQ();

		String[] work = new String[]{
			"stress",
			"homepg"
		};

		double[] time = new double[]{
			0.0044,  // stress
			0.0300   // homepg
		};

		String[] slave = new String[]{
			"slave0",
			"slave1",
			"slave2",
			"slave3",
			"slave4",
			"slave5",
			"slave6",
			"slave7",
			"slave8",
			"slave9",
			"slave10",
			"slave11",
			"slave12",
			"slave13",
			"slave14",
			"slave15"
		};

		int w = HOMEPG;  // or STRESS!

		if (PREFORK) {
			System.out.printf("Pre-Fork Model under \"%s\" Load (m = %d)\n",
				w == STRESS ? work[STRESS] : work[HOMEPG], servers);
		} else {
			System.out.printf("Forking  Model under \"%s\" Load \n",
				w == STRESS ? work[STRESS] : work[HOMEPG]);
		}

		System.out.printf("\n  N        X         R\n");

		for (int pop = 1; pop <= 10; pop++) {

			pdq.Init("Httpd_Server");

			noStreams = pdq.CreateClosed(work[w], Job.TERM, 1.0 * pop, 0.0);
			noNodes = pdq.CreateNode("master", Node.CEN, QDiscipline.FCFS);

			if (PREFORK)  {
				for (int s = 0; s < servers; s++) {
					noNodes = pdq.CreateNode(slave[s], Node.CEN, QDiscipline.FCFS);
				}

				pdq.SetDemand("master", work[w], 0.0109);

				for (int s = 0; s < servers; s++) {
					pdq.SetDemand(slave[s], work[w], time[w] / servers);
				}
			} else {  // FORKING
				noNodes = pdq.CreateNode("forks", Node.CEN, QDiscipline.ISRV);

				pdq.SetDemand("master", work[w], 0.0165);
				pdq.SetDemand("forks", work[w], time[w]);
			}

			pdq.Solve(Methods.EXACT);

			System.out.printf("%2d.00   %8.4f  %8.4f\n",
			 	//pdq.getjob_pop(pdq.getjob_index(work[w])),
				pop,
			 	pdq.GetThruput(Job.TERM, work[w]),
			 	pdq.GetResponse(Job.TERM, work[w]));
		}
	}	// main

}  // Ch9_HTTP

//-------------------------------------------------------------------------


