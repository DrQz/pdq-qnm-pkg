/*
 * Created on 17/02/2004
 *
 */
package com.perfdynamics.pdq;

/**
 * @author plh
 *
 */
public class Node {
	public static final int MAXNODES = 1000;  // Max no of queueing nodes (1000)

	// Node types

	public static final int MEM = 2;
	public static final int CEN = 3;  // Unspecified queueing center
	public static final int DLY = 4;  // Unspecified delay center
	public static final int MSQ = 5;  // Unspecified multi-server queue

	public int devtype; // CEN, ...
	public int sched; // FCFS, ...
	public String devname;
	public int NoStreams = 0;
	
	public double[] visits = null;
	public double[] service = null;
	public double[] demand = null;
	public double[] resit = null;
	public double[] utiliz = null; // computed node utilization
	public double[] qsize = null;
	public double[] avqsize = null;
	
	//----------------------------------------------------------------

	public Node(int no_streams)
	{
		NoStreams = no_streams;

		visits = new double[no_streams];
		service = new double[no_streams];
		demand = new double[no_streams];
		resit = new double[no_streams];
		utiliz = new double[no_streams];
		qsize = new double[no_streams];
		avqsize = new double[no_streams];
	}
	//----------------------------------------------------------------

	public static void main(String[] args) {
		System.out.println("Usage: " + "[md4|md5]");
	}
}
