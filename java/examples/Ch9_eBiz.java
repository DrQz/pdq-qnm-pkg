/*
 * Created by NJG: Wed May  8 22:29:36  2002
 * Created by NJG: Fri Aug  2 08:57:31  2002
 *
 * Based on D. Buch and V. Pentkovski, "Experience of Characterization of
 * Typical Multi-tier e-Business Systems Using Operational Analysis,"
 * CMG Conference, Anaheim, California, pp. 671-681, Dec 2002.
 *
 * Measurements use Microsoft WAS (Web Application Stress) tool.
 * Could also use Merc-Interactive LoadRunner.
 * Only a single class of eBiz transaction e.g., login, or page_view, etc.
 * is measured.  Transaction details are not specified in the paper.
 *
 * Thinktime Z should be zero by virtue of N = XR assumption in paper.
 * We find that a Z~27 mSecs is needed to calibrate thruputs and utilizations.
 *
 *  Ported to Java by: plh@pha.com.au on 21/02/2004
 *
 *  $Id$
 *
 */

import com.perfdynamics.pdq.*;
import com.braju.format.*;          // Used for fprintf/sprintf!

//-------------------------------------------------------------------------

/**
 * @author njg@perfdynamics.com
 * 
 */
public class Ch9_eBiz {

	public static int             MAXUSERS = 20;

	public static String          model = "Middleware I";
	public static String          work = "eBiz-tx";
	public static String          node1 = "WebServer";
	public static String          node2 = "AppServer";
	public static String          node3 = "DBMServer";

	public static double           think = 0.0 * 1e-3;  // treated as free param

	// Added dummy servers for calibration

	public static String          node4 = "DummySvr";

	// User loads employed in WAS tool ...

	public static int              noNodes;
	public static int              noStreams;
	public static int              users;

	public static double[]  u1dat = null;
	public static double[]  u2dat = null;
	public static double[]  u3dat = null;
	public static double[]  u1pdq = null;
	public static double[]  u2pdq = null;
	public static double[]  u3pdq = null;
	public static double[]  u1err = null;
	public static double[]  u2err = null;
	public static double[]  u3err = null;

	public static void main(String[] args) {
                PDQ pdq = new PDQ();
		Parameters p = new Parameters();

		// Utilization data from the paper ...

		u1dat = new double[]{
			0.0, 21.0, 41.0, 0.0, 74.0, 0.0, 0.0, 95.0, 0.0, 0.0, 96.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 96.0 
		};

		u2dat =  new double[]{
			0.0, 8.0, 13.0, 0.0, 20.0, 0.0, 0.0, 23.0, 0.0, 0.0, 22.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 22.0
		};

		u3dat = new double[]{
			0.0, 4.0, 5.0, 0.0, 5.0, 0.0, 0.0, 5.0, 0.0, 0.0, 6.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0
		};

		u1err = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
		};

		u2err = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
		};

		u3err = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
		};

		u1pdq = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
		};

		u2pdq = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
		};

		u3pdq = new double[]{
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 
		};

		// Output header ...

		System.out.printf("\n");
		System.out.printf("(Tx: \"%s\" for \"%s\")\n\n", work, model);
		System.out.printf("Client delay Z=%5.2f mSec. (Assumed)\n\n", think * 1e3);
		System.out.printf(" N      X       R      %%Uws    %%Uas    %%Udb\n");
		System.out.printf("---  ------  ------   ------  ------  ------\n");

		for (int users = 1; users <= MAXUSERS; users++) {

			pdq.Init(model);

			noStreams = pdq.CreateClosed(work, Job.TERM, (float) users, think);

			noNodes = pdq.CreateNode(node1, Node.CEN, QDiscipline.FCFS);
			noNodes = pdq.CreateNode(node2, Node.CEN, QDiscipline.FCFS);
			noNodes = pdq.CreateNode(node3, Node.CEN, QDiscipline.FCFS);

			noNodes = pdq.CreateNode(node4, Node.CEN, QDiscipline.FCFS);
			//noNodes = pdq.CreateNode(node5, Node.CEN, QDiscipline.FCFS);
			//noNodes = pdq.CreateNode(node6, Node.CEN, QDiscipline.FCFS);

			// NOTE: timebase is seconds

			pdq.SetDemand(node1, work, 9.8 * 1e-3);
			pdq.SetDemand(node2, work, 2.5 * 1e-3);
			pdq.SetDemand(node3, work, 0.72 * 1e-3);

			// dummy (network) nodes ...

			pdq.SetDemand(node4, work, 9.8 * 1e-3);

			pdq.Solve(Methods.EXACT);

			// set up for error analysis of utilzations

			u1pdq[users] = pdq.GetUtilization(node1, work, Job.TERM) * 100;
			u2pdq[users] = pdq.GetUtilization(node2, work, Job.TERM) * 100;
			u3pdq[users] = pdq.GetUtilization(node3, work, Job.TERM) * 100;

			u1err[users] = 100 * (u1pdq[users] - u1dat[users]) / u1dat[users];
			u2err[users] = 100 * (u2pdq[users] - u2dat[users]) / u2dat[users];
			u3err[users] = 100 * (u3pdq[users] - u3dat[users]) / u3dat[users];

			System.out.printf("%3d  %6.2f  %6.2f   %6.2f  %6.2f  %6.2f\n",
				   users,
				   pdq.GetThruput(Job.TERM, work),  // http GETs-per-Second
				   pdq.GetResponse(Job.TERM, work) * 1e3,   // milliseconds
				   u1pdq[users],
				   u2pdq[users],
				   u3pdq[users]
				);
		}

		System.out.printf("\nError Analysis of Utilizations\n\n");
		System.out.printf("                  WS                      AS                      DB\n");
		System.out.printf("        ----------------------  ----------------------  ----------------------\n");
		System.out.printf(" N      %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr\n");
		System.out.printf("---     -----   -----   -----   -----   -----   -----   -----   -----   -----\n");


		for (users = 1; users <= MAXUSERS; users++) {
			switch (users) {
				case 1:
				case 2:
				case 4:
				case 7:
				case 10:
				case 20:
					System.out.printf("%3d    %6.2f  %6.2f  %6.2f",
					   	users,
					   	u1dat[users],
					   	u1pdq[users],
					   	u1err[users]);
					System.out.printf("  %6.2f  %6.2f  %6.2f",
					   	u2dat[users],
					   	u2pdq[users],
					   	u2err[users]);
					System.out.printf("  %6.2f  %6.2f  %6.2f\n",
					   	u3dat[users],
					   	u3pdq[users],
					   	u3err[users]);
					break;
				default:
					break;
			}
		}

		System.out.printf("\n");

		// Uncomment the following line for a standard PDQ summary.

		pdq.Report();
	}
}

//-------------------------------------------------------------------------


