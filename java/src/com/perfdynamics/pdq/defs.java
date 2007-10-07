/*
 * Created on 17/02/2004
 *
 */
package com.perfdynamics.pdq;

/**
 * @author plh
 *
 */
public class defs {
	public static final int MAXNODES = 1000; // Max no of queueing nodes
	public static final int MAXBUF = 25; // biggest buffer
	public static final int MAXSTREAMS = 30; // Max no of job streams 
	public static final int MAXCHARS = 30; // max chars in param fields

	public static final boolean DEBUG = true;
	
	// Queueing network type

	public static final int VOID = -1;
	public static final int OPEN = 0;
	public static final int CLOSED = 1;

	// Nodes

	public static final int MEM = 2;
	public static final int CEN = 3; /* unspecified queueing center */
	public static final int DLY = 4; /* unspecified delay center */
	public static final int MSQ = 5; /* unspecified multi-server queue */

	// Queueing disciplines

	public static final int ISRV = 6; /* infinite server */
	public static final int FCFS = 7; /* first-come first-serve */
	public static final int PSHR = 8; /* processor sharing */
	public static final int LCFS = 9; /* last-come first-serve */

	// Job types

	public static final int TERM  = 10;
	public static final int TRANS = 11;
	public static final int BATCH = 12;

	// solution methods

	public static final int EXACT = 13;
	public static final int APPROX = 14;
	public static final int CANON = 15;

	// service-demand types

	public static final int VISITS = 16;
	public static final int DEMAND = 17;

	// MP scalability

	public static final int PDQ_SP = 18; /* uniprocessor */
	public static final int PDQ_MP = 19; /* multiprocessor */

	public static final double TOL = 0.0010;

	public static void main(String[] args) {
		System.out.println("MAXNODES " + Integer.toString(MAXNODES));
		System.out.println("MAXSTREAMS " + Integer.toString(MAXSTREAMS));
	}
}
