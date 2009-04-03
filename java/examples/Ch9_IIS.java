/*
 * Created on 21/02/2004
 *
 *  By: plh@pha.com.au
 *
 *  $Id$
 *
 *  Based on Microsoft WAS measurements of IIS.
 * 
 *  CMG 2001 paper.
 *
 *
 */

import com.perfdynamics.pdq.*;
import com.braju.format.*; // Used for fprintf/sprintf!

/**
 * @author plh
 * 
 */
public class Ch9_IIS {
	public static int              noNodes;
	public static int              noStreams;
	public static int              users;
	public static int              delta;
	public static String           model = "IIS Server";
	public static String           work = "http GET 20KB";
	public static String           node1 = "CPU";
	public static String           node2 = "DSK";
	public static String           node3 = "NET";
	public static String           node4 = "Dummy";
	public static double           think = 1.5 * 1e-3;
	public static double[]         u1pdq = null;
	public static double[]         u2pdq = null;
	public static double[]         u3pdq = null;
	public static double[]         u1err = null;
	public static double[]         u2err = null;
	public static double[]         u3err = null;
	public static double           u2demand = 0.10 * 1e-3;

	public static void main(String[] args) {
		PDQ pdq = new PDQ();
		Parameters p = new Parameters();

		// Utilization data from the paper ...

		double[] u1dat = new double[]{
			0.0, 9.0, 14.0, 17.0, 21.0, 24.0, 26.0, 0.0, 0.0, 0.0, 26.0
		};

		double[] u2dat = new double[]{
			0.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, 2.0
		};

		double[] u3dat = new double[]{
			0.0, 26.0, 46.0, 61.0, 74.0, 86.0, 92.0, 0.0, 0.0, 0.0, 94.0
		};

		double[] u1err = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
		};

		double[] u2err = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
		};

		double[] u3err = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
		};

		double[] u1pdq = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
		};

		double[] u2pdq = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
		};

		double[] u3pdq = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
		};

		// Output main header ...

		System.out.printf("\n");
		System.out.printf("(Tx: \"%s\" for \"%s\")\n\n", work, model);
		System.out.printf("Client delay Z=%5.2f mSec. (Assumed)\n\n", think * 1e3);
		System.out.printf(" N      X       R      %%Ucpu   %%Udsk   %%Unet\n");
		System.out.printf("---  ------  ------   ------  ------  ------\n");

		for (int users = 1; users <= 10; users++) {
			pdq.Init(model);

			noStreams = pdq.CreateClosed(work, Job.TERM, (float) users, think);

			noNodes = pdq.CreateNode(node1, Node.CEN, QDiscipline.FCFS);
			noNodes = pdq.CreateNode(node2, Node.CEN, QDiscipline.FCFS);
			noNodes = pdq.CreateNode(node3, Node.CEN, QDiscipline.FCFS);
			noNodes = pdq.CreateNode(node4, Node.CEN, QDiscipline.FCFS);

			// NOTE: timebase is seconds

			pdq.SetDemand(node1, work, 0.44 * 1e-3);
			pdq.SetDemand(node2, work, u2demand); /* make load-indept */
			pdq.SetDemand(node3, work, 1.45 * 1e-3);
			pdq.SetDemand(node4, work, 1.6 * 1e-3);

			pdq.Solve(Methods.EXACT);

			// set up for error analysis of utilzations

			u1pdq[users] = pdq.GetUtilization(node1, work, Job.TERM) * 100;
			u2pdq[users] = pdq.GetUtilization(node2, work, Job.TERM) * 100;
			u3pdq[users] = pdq.GetUtilization(node3, work, Job.TERM) * 100;

			u1err[users] = 100 * (u1pdq[users] - u1dat[users]) / u1dat[users];
			u2err[users] = 100 * (u2pdq[users] - u2dat[users]) / u2dat[users];
			u3err[users] = 100 * (u3pdq[users] - u3dat[users]) / u3dat[users];

			u2demand = 0.015 / pdq.GetThruput(Job.TERM, work);

			System.out.printf("%3d  %6.2f  %6.2f   %6.2f  %6.2f  %6.2f\n",
			   users, 
			   pdq.GetThruput(Job.TERM, work),  // http GETs-per-second
			   pdq.GetResponse(Job.TERM, work) * 1e3,   // milliseconds
			   u1pdq[users],
			   u2pdq[users],
			   u3pdq[users]
			);

		}

		System.out.printf("\nError Analysis of Utilizations\n\n");


		System.out.printf("                 CPU                     DSK                     NET\n");
		System.out.printf("        ----------------------  ----------------------  ----------------------\n");
		System.out.printf(" N      %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr\n");
		System.out.printf("---     -----   -----   -----   -----   -----   -----   -----   -----   -----\n");

		for (int users = 1; users <= 10; users++) {
			if (users <= 6 || users == 10) {
				System.out.printf("%3d    %6.2f  %6.2f  %6.2f",
			       		users,
			       		u1dat[users],
			       		u1pdq[users],
			       		u1err[users]
				);
			    
				System.out.printf("  %6.2f  %6.2f  %6.2f",
			       		u2dat[users],
			       		u2pdq[users],
			       		u2err[users]
	   			);

				System.out.printf("  %6.2f  %6.2f  %6.2f\n",
			       		u3dat[users],
			       		u3pdq[users],
			       		u3err[users]
		   		);
			}
		}

		System.out.printf("\n");

	}	// main
	
}	// Ch9_IIS

