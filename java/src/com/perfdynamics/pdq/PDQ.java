/*
 * Created on 17/02/2004
 *
 */
package com.perfdynamics.pdq;


import java.util.*;
import java.text.*;

import com.braju.format.*;

/**
 * @author plh
 *
 */
public class PDQ {
	public static final String VERSION = "1.0";
	private Parameters p = null;

	private MVA mva = null;
	private Utils utils = null;

	private boolean DEBUG = false;
	private boolean prev_init = false;
	private String prevproc;

	private String modelName = null;
	private int method = 0;
	private int iterations = 0;
	private double sumD;
	private double tolerance = 0.001;
	private int serviceDemand = 0;
	private String wUnit = null;
	private String tUnit = null;
	private String comment = null;

	public Job[] job = null;
	public int noStreams = 0;
	public int jobNo = 0;

	public Node[] node = null;
	public int noNodes = 0;
	public int nodeNo = 0;

	//----- Used by reporting methods -----

	private boolean nodhdr = false;
	private boolean jobhdr = false;
	private boolean syshdr = false;
	private boolean devhdr = false;
	private boolean trmhdr = false;
	private boolean bathdr = false;
	private boolean trxhdr = false;


	//---------------------------------------------------------------------

	public PDQ() {
		DEBUG = false;
		utils = new Utils(this);
		p = new Parameters();
	}

	//---------------------------------------------------------------------

	/**
	 * Return name of model.
	 */
	public String getModelName()
	{
		return modelName;
	}  // getModelName
	
	//---------------------------------------------------------------------

	/**
	 *  initializes all internal PDQ
	 * variables.Must be called prior
	 * to any other PDQ function.
	 */
	public void Init(String name) {
		String fn = "Init()";

		if (DEBUG)
			utils.debug(fn, "Entering");

		if (prev_init) {
			for (int jobNo = 0; jobNo < Job.MAXSTREAMS; jobNo++) {
				if (job[jobNo].term != null) {
					if (job[jobNo].term.sys != null) {
						job[jobNo].term.sys = null;
						job[jobNo].batch.sys = null;
						job[jobNo].trans.sys = null;
					}
					job[jobNo].term = null;
				}

				if (job[jobNo].batch != null) {
					if (job[jobNo].batch.sys != null) {
						job[jobNo].term.sys = null;
						job[jobNo].batch.sys = null;
						job[jobNo].trans.sys = null;
					}
					job[jobNo].batch = null;
				}

				if (job[jobNo].trans != null) {
					if (job[jobNo].trans.sys != null) {
						job[jobNo].term.sys = null;
						job[jobNo].batch.sys = null;
						job[jobNo].trans.sys = null;
					}

					job[jobNo].trans = null;
				}
			}  // Over jobNo

			if (job != null) {
				job = null;
			}

			if (node != null) {
				node = null;
			}
			modelName = null;
			wUnit = null;
			tUnit = null;
		}

		modelName = name;

		//  Set default units

		wUnit = "Job";
		tUnit = "Sec";

		serviceDemand = defs.VOID;
		tolerance = defs.TOL;
		method = defs.VOID;

		// Reset circuit counters
		
		noNodes = noStreams = nodeNo = jobNo = 0;

		allocate_nodes(Node.MAXNODES, Job.MAXSTREAMS);
		allocate_jobs(Job.MAXSTREAMS);

		for (int idxJob = 0; idxJob < Job.MAXSTREAMS; idxJob++) {
			for (int idxNode = 0; idxNode < Node.MAXNODES; idxNode++) {
				node[idxNode].devtype = defs.VOID;
				node[idxNode].sched = defs.VOID;
				node[idxNode].demand[idxJob] = 0.0;
				node[idxNode].resit[idxJob] = 0.0;
				node[idxNode].qsize[idxJob] = 0.0;
			}
			job[idxJob].should_be_class = defs.VOID;
			job[idxJob].network = defs.VOID;
		}

		prev_init = true;

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // Init

	//---------------------------------------------------------------------

	/**
	 * The solution method must be
	 * passed as an argument.
	 */
	public void Solve(int method) {
		String fn = "solve()";
		int nodeNo;
		int jobNo;
		int should_be_class;
		double demand;
		double maxD = 0.0;

		if (DEBUG)
			utils.debug(fn, "Entering");

		/* There'd better be a job[0] or you're in trouble !!!  */

		this.method = method;

		switch (method) {
			case Methods.EXACT :
				if (job[0].network != NETWORK.CLOSED) { // bail
					String s = com.braju.format.Format.sprintf(
					   "Network should_be_class \"%s\" is incompatible with \"%s\" method",
						 p.add(typetostr(job[0].network))
						 .add(typetostr(method)));
					utils.errmsg(fn, s);
				}
				switch (job[0].should_be_class) {
					case Job.TERM :
					case Job.BATCH :
						mva = new MVA(this);
						mva.exact();
						break;
					default :
						break;
				}
				break;

			case Methods.APPROX :
				if (job[0].network != NETWORK.CLOSED) {  // bail
					String s = com.braju.format.Format.sprintf(
						"Network should_be_class \"%s\" is incompatible with \"%s\" method",
						p.add(typetostr(job[0].network))
						.add(typetostr(method)));
					utils.errmsg(fn, s);
				}

				switch (job[0].should_be_class) {
					case Job.TERM :
					case Job.BATCH :
						mva = new MVA(this);
						mva.approx();
						break;
					default :
						break;
				}
				break;
			case Methods.CANON :
				if (job[0].network != NETWORK.OPEN) {  // Bail out
					String s = com.braju.format.Format.sprintf(
						"Network should_be_class \"%s\" is incompatible with \"%s\" method",
						p.add(typetostr(job[0].network))
						.add(typetostr(method)));
					utils.errmsg(fn, s);
				}
				mva = new MVA(this);
				mva.canonical();
				break;
			default :
				utils.errmsg(fn, com.braju.format.Format.sprintf("Unknown  method \"%s\"", p.add(typetostr(method))));
				break;
		};

		// Now compute bounds

		for (jobNo = 0; jobNo < noStreams; jobNo++) {
			sumD = maxD = 0.0;

			should_be_class = job[jobNo].should_be_class;

			for (nodeNo = 0; nodeNo < noNodes; nodeNo++) {
				demand = node[nodeNo].demand[jobNo];

				if (node[nodeNo].sched == QDiscipline.ISRV
					&& job[jobNo].network == NETWORK.CLOSED)
					demand /= (should_be_class == Job.TERM)
						? job[jobNo].term.population
						: job[jobNo].batch.population;

				if (maxD < demand)
					maxD = demand;

				sumD += node[nodeNo].demand[jobNo];
			} /* over nodeNo */

			switch (should_be_class) {
				case Job.TERM :
					job[jobNo].term.sys.maxN =
						(sumD + job[jobNo].term.think) / maxD;
					job[jobNo].term.sys.maxTP = 1.0 / maxD;
					job[jobNo].term.sys.minRT = sumD;

					if (sumD == 0) {
						utils.errmsg(fn, com.braju.format.Format.sprintf("Sum of demands is zero for workload \"%s\"", p.add(getjob_name(jobNo))));
					}
					break;

				case Job.BATCH :
					job[jobNo].batch.sys.maxN = sumD / maxD;
					job[jobNo].batch.sys.maxTP = 1.0 / maxD;
					job[jobNo].batch.sys.minRT = sumD;

					if (sumD == 0) {
						utils.errmsg(fn, com.braju.format.Format.sprintf("Sum of demands is zero for workload \"%s\"", p.add(getjob_name(jobNo))));
					}
					break;

				case Job.TRANS :
					job[jobNo].trans.sys.maxTP = 1.0 / maxD;
					job[jobNo].trans.sys.minRT = sumD;

					if (sumD == 0) {
						utils.errmsg(fn, com.braju.format.Format.sprintf("Sum of demands is zero for workload \"%s\"", p.add(getjob_name(jobNo))));
					}
					break;

				default :
					break;
			}
		}  // Over jobNo

		if (DEBUG)
			utils.debug(fn, "Exiting");
	}  // Solve

	//---------------------------------------------------------------------

	/**
	 * generates a formatted report containing
	 * system, and node level performance
	 * measures.
	 */
	public void Report() {
		String fn = "Report()";
		String pc;
		String tstamp;
		String pad = "                       ";
		int prevclass;
		int fillbase = 24;
		int fill;
		double allusers = 0.0;

		if (DEBUG)
			utils.debug(fn, "Entering");

		syshdr = false;
		jobhdr = false;
		nodhdr = false;
		devhdr = false;

		Date today;
		String s;
		String pattern;
		SimpleDateFormat formatter;
		Locale locale = new Locale("en", "AU");
		today = new Date();
		pattern = "yyyy-MM-dd HH:mm:ss z";
		formatter = new SimpleDateFormat(pattern, locale);
		tstamp = formatter.format(today);

		/*
		      clock = System.currentTimeMillis();
		      
				if ((clock = time(0)) == -1)
					utils.errmsg(fn, "Failed to get date");
		
				tstamp = (char *) ctime(& clock); // 24 chars + \n\0
				strncpy(s1, tstamp, fillbase);
		
				fill = fillbase - strlen(model);
				strcpy(s2, model);
				strncat(s2, pad, fill);
		
				fill = fillbase - strlen(version);
				strcpy(s3, version);
				strncat(s3, pad, fill);
		*/


		com.braju.format.Format.printf("\n\n");

		banner_stars();

		banner_chars(" Pretty Damn Quick REPORT");

		banner_stars();

		com.braju.format.Format.printf("                ***  of : %-24s  ***\n", p.add(tstamp));
		com.braju.format.Format.printf("                ***  for: %-24s  ***\n", p.add(modelName));
		com.braju.format.Format.printf("                ***  Ver: %-24s  ***\n", p.add(VERSION));

		banner_stars();
		banner_stars();

		com.braju.format.Format.printf("\n");

		/****   append comments file ****/

		if (comment != null) {
			System.out.printf("\n\n");
			banner_chars("        Comments");
			System.out.printf("\n        %s\n", comment);
		}

		System.out.printf("\n\n");
		banner_stars();
		banner_chars("    PDQ Model INPUTS");
		banner_stars();
		com.braju.format.Format.printf("\n\n");
		print_nodes();

		/* OUTPUT Statistics */

		for (int jobNo = 0; jobNo < noStreams; jobNo++) {
			switch (job[jobNo].should_be_class) {
				case Job.TERM :
					allusers += job[jobNo].term.population;
					break;
				case Job.BATCH :
					allusers += job[jobNo].batch.population;
					break;
				case Job.TRANS :
					allusers = 0.0;
					break;
				default :
					utils.errmsg(fn, "Unknown job should_be_class: "
							+ Integer.toString(job[jobNo].should_be_class));
					break;
			}
		} /* loop over jobNo */

		com.braju.format.Format.printf("\nQueueing Circuit Totals:\n\n");

		for (int jobNo = 0; jobNo < noStreams; jobNo++) {
			switch (job[jobNo].should_be_class) {
				case Job.TERM :
				com.braju.format.Format.printf("        Clients:    %3.2f\n", p.add(job[jobNo].term.population));
					break;
				case Job.BATCH :
				com.braju.format.Format.printf("        Jobs:       %3.2f\n", p.add(job[jobNo].batch.population));
					break;
				default :
					break;
			}
		}
		
		com.braju.format.Format.printf("        Streams:    %3d\n", p.add(noStreams));
		com.braju.format.Format.printf("        Nodes:      %3d\n", p.add(noNodes));
		com.braju.format.Format.printf("\n");

		com.braju.format.Format.printf("\n\nWORKLOAD Parameters\n\n");

		for (int jobNo = 0; jobNo < noStreams; jobNo++) {
			switch (job[jobNo].should_be_class) {
				case Job.TERM :
					print_job(jobNo, Job.TERM);
					break;
				case Job.BATCH :
					print_job(jobNo, Job.BATCH);
					break;
				case Job.TRANS :
					print_job(jobNo, Job.TRANS);
					break;
				default :
					utils.errmsg(fn, "Unknown job should_be_class: "
							+ typetostr(job[jobNo].should_be_class));
					break;
			}
		} /* loop over jobNo */

		com.braju.format.Format.printf("\n");

		for (int jobNo = 0; jobNo < noStreams; jobNo++) {
			switch (job[jobNo].should_be_class) {
				case Job.TERM :
					print_system_stats(jobNo, Job.TERM);
					break;
				case Job.BATCH :
					print_system_stats(jobNo, Job.BATCH);
					break;
				case Job.TRANS :
					print_system_stats(jobNo, Job.TRANS);
					break;
				default :
					utils.errmsg(fn, "Unknown job should_be_class: "
							+ typetostr(job[jobNo].should_be_class));
					break;
			}
		} /* loop over jobNo */

		com.braju.format.Format.printf("\n");

		for (int jobNo = 0; jobNo < noStreams; jobNo++) {
			switch (job[jobNo].should_be_class) {
				case Job.TERM :
					print_node_stats(jobNo, Job.TERM);
					break;
				case Job.BATCH :
					print_node_stats(jobNo, Job.BATCH);
					break;
				case Job.TRANS :
					print_node_stats(jobNo, Job.TRANS);
					break;
				default :
					utils.errmsg(fn, "Unknown job should_be_class: " + typetostr(job[jobNo].should_be_class));
					break;
			}
		} /* over jobNo */

		com.braju.format.Format.printf("\n");

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // Report

	//---------------------------------------------------------------------

	/**
	 * defines the characteristics of a workload in a closed - circuit
	 * queueing model.
	 */
	public int CreateClosed( String name, int should_be_class, double population, double think) {
		String fn = "CreateClosed()";

/*
		FILE * out_fd;

		if (DEBUG) {
			utils.debug(fn, "Entering");
			out_fd = fopen("PDQ.out", "a");
			com.braju.format.Format.printf(
				out_fd,
				"name : %s  should_be_class : %d  population : %f  think : %f\n",
				name,
				should_be_class,
				* population,
				* think);
			close(out_fd);
		}
*/

		if (jobNo > Job.MAXSTREAMS) {
			System.err.println("jobNo = " + Integer.toString(jobNo));
			utils.errmsg(fn, "Allocating \""
					+ name
					+ "\" exceeds "
					+ Integer.toString(Job.MAXSTREAMS)
					+ " max streams");
		}

		switch (should_be_class) {
			case Job.TERM :
				if (population == 0.0)
					utils.errmsg(fn, "Stream: \"" + name + "\", has zero population");
				create_term_stream(jobNo, NETWORK.CLOSED, name, population, think);
				break;
			case Job.BATCH :
				if (population == 0.0)
					utils.errmsg(fn, "Stream: \"" + name + "\", has zero population");
				create_batch_stream(jobNo, NETWORK.CLOSED, name, population);
				break;
			default :
				utils.errmsg(fn, "Unknown stream: " + Integer.toString(should_be_class));
				break;
		}

		if (DEBUG)
			utils.debug(fn, "Exiting");

		jobNo =  ++noStreams;
		
		return jobNo;
	} // CreateClosed

	//---------------------------------------------------------------------

	/**
	 * Defines the characteristics of a workload in an open - circuit queueing
	 * model.
	 */
	public int CreateOpen(String name, double lambda) {
		String fn = "CreateOpen()";

/*
		if (DEBUG) {
			FILE * out_fd;
			out_fd = fopen("PDQ.out", "a");
			com.bruja.format.FormatFormat.printf(out_fd, "name : %s  lambda : %f\n", name, * lambda);
			close(out_fd);
		}
*/

		create_transaction(noStreams, NETWORK.OPEN, name, lambda);
		
		jobNo =  ++noStreams;
		
		return jobNo;
	} // CreateOpen

	//---------------------------------------------------------------------

	/**
	 * Defines a single queueing - center in either a closed or open circuit
	 * queueing model.
	 */
	public int CreateNode(String name, int device, int sched) {
		/*
			extern node_type *node;
			extern char     s1[], s2[];
			extern int      DEBUG;
		*/

		String fn = "CreateNode";
		
/*
		if (DEBUG) {
			FILE *out_fd;
			utils.debug(fn, "Entering");
			out_fd = fopen("PDQ.out", "a");
			Format.printf(
				out_fd,
				"name : %s  device : %d  sched : %d\n",
				name,
				device,
				sched);
			close(out_fd);
		}
*/

		if (nodeNo > Node.MAXNODES) {
			com.braju.format.Format.printf("Allocating \"%s\" exceeds %d max nodes",
				p.add(name).add(Node.MAXNODES));
			utils.errmsg(fn, "Allocating \"" + name + "\" exceeds "+ Integer.toString(Node.MAXNODES) +" max nodes");
		}

		node[nodeNo].devname = name;
		node[nodeNo].devtype = device;
		node[nodeNo].sched = sched;

		// System.err.println(fn + "Allocating node " + Integer.toString(nodeNo));
	
		if (DEBUG) {
			utils.debug(
				fn,
				"        Node["
					+ Integer.toString(nodeNo)
					+ "]: "
					+ typetostr(node[nodeNo].devtype)
					+ " "
					+ typetostr(node[nodeNo].sched)
					+ " \""
					+ node[nodeNo].devname
					+ "\"");
		}

		if (DEBUG)
			utils.debug(fn, ": Exiting");

		nodeNo =  ++noNodes;
		
		return nodeNo;
	} // CreateNode

	//---------------------------------------------------------------------

	/**
	 * Returns the system response time for the specified workload.
	 */
	public double GetResponse(int should_be_class, String wname) {
		String fn = "GetResponse()";
		double r = 0.0;

		switch (should_be_class) {
			case Job.TERM :
				r = job[getjob_index(wname)].term.sys.response;
				break;
			case Job.BATCH :
				r = job[getjob_index(wname)].batch.sys.response;
				break;
			case Job.TRANS :
				r = job[getjob_index(wname)].trans.sys.response;
				break;
			default :
				System.err.println(fn + ":  Unknown should_be_class");
				break;
		}

		return r;
	} // GetResponse

	//---------------------------------------------------------------------

	/**
	 * Returns the system throughput for the specified workload.
	 */
	public double GetThruput(int should_be_class, String wname) {
		String fn = "GetThruput()";
		double x = 0.0;

		int jobIdx = getjob_index(wname);
		
		if (jobIdx >= 0) {
			switch (should_be_class) {
				case Job.TERM :
					x = job[jobIdx].term.sys.thruput;
					break;
				case Job.BATCH :
					x = job[jobIdx].batch.sys.thruput;
					break;
				case Job.TRANS :
					x = job[jobIdx].trans.sys.thruput;
					break;
				default :
					System.err.println(fn + ":  Unknown should_be_class");
					break;
			}
		} else
			x = 0.0;

		return x;
	} // GetThruput

	//---------------------------------------------------------------------

	/**
	 * Returns the utilization of the designated queueing node by the
	 * specified workload.
	 */
	public double GetUtilization(String device, String work, int should_be_class) {
		String fn = "GetUtilization()";
		double x;
		double u = 0.0;
		int jobNo;
		int nodeNo;

		jobNo = getjob_index(work);

		// System.err.println(fn + ": device \"" + device + "\"  work \"" + work + "\"  Job type " + Integer.toString(jobNo));
		
		x = GetThruput(should_be_class, work);

		if (jobNo >= 0) {
			if (node != null) {
				for (nodeNo = 0; nodeNo < noNodes; nodeNo++) {
					if (node[nodeNo] != null) {
						if (device.equals(node[nodeNo].devname)) {
							u = node[nodeNo].demand[jobNo] * x;
							return u;
						}
					}
				}
			}
		}

		System.err.println(fn + ":  Unknown device " + device);

		return u;
	} // GetUtilization

	//---------------------------------------------------------------------

	/**
	 * Returns the queue length at the designated queueing node due to the
	 * specified workload.
	 */
	public double GetQueueLength(String device, String work, int should_be_class) {
		String fn = "GetQueueLength()";
		double q;
		double x;
		int jobNo;
		int nodeNo;

		jobNo = getjob_index(work);
		x = GetThruput(should_be_class, work);

		if (node != null) {
			for (nodeNo = 0; nodeNo < noNodes; nodeNo++) {
				if (node[nodeNo] != null) {
					if (node[nodeNo].devname == device) {
						q = node[nodeNo].resit[jobNo] * x;
						return q;
					}
				}
			}
		}

		System.err.println(fn + ":  Unknown device " + device);

		return 0.0;
	} // GetQueueLength

	//---------------------------------------------------------------------

	/** enables diagnostic printout of
	 * PDQ internal variables.
	 */
	public void SetDebug(boolean flag) {
		DEBUG = flag;

		if (DEBUG) {
			System.err.println("SetDebug:  debug on\n");
		} else {
			System.err.println("SetDebug:  debug off\n");
		}
	} // SetDebug

	//---------------------------------------------------------------------

	/** Expose DEBUG state.
	 */
	public boolean GetDebug() {
		return DEBUG;
	} // GetDebug

	//---------------------------------------------------------------------

	/**
	 * defines the service demand of a specific workload at a specified node.
	 */
	public void SetDemand(String nodename, String workname, double time) {
		String fn = "SetDemand()";
		int nodeIdx = -1;
		int jobIdx = -1;

/*
		if (DEBUG) {
			FILE *out_fd;
			debug(fn, "Entering");
			out_fd = fopen("PDQ.out", "a");
			fFormat.printf(
				out_fd,
				"nodename : %s  workname : %s  time : %f\n",
				nodename,
				workname,
				* time);
			close(out_fd);
		}
*/

		// That demand type is being used consistently per model

		if (serviceDemand == defs.VOID || serviceDemand == defs.DEMAND) {
			// System.err.println(fn + ": ServiceDemand = " + Integer.toString(serviceDemand));
			nodeIdx = getnode_index(nodename);
			jobIdx = getjob_index(workname);
			node[nodeIdx].demand[jobIdx] = time;
			serviceDemand = defs.DEMAND;
		} else
			utils.errmsg(fn, "Extension conflict");

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // SetDemand

	//---------------------------------------------------------------------

	/**
	 * defines the service demand in terms of the service time and visit
	 * count.
	 */
	public void SetVisits(
		String nodename,
		String workname,
		double visits,
		double service) {
		if (DEBUG) {
			// Format.printf("nodename : %s  workname : %s  visits : %f  service : %f\n", nodename, workname, *visits, *service);
		}

		if (serviceDemand == defs.VOID || serviceDemand == defs.VISITS) {
			node[getnode_index(nodename)].visits[getjob_index(workname)] =
				visits;
			node[getnode_index(nodename)].service[getjob_index(workname)] =
				service;
			node[getnode_index(nodename)].demand[getjob_index(workname)] =
				visits * service;
			serviceDemand = defs.VISITS;
		} else
			System.err.println("SetVisits():  Extension conflict");
	} // SetVisits

	//---------------------------------------------------------------------

	/**
	 * 
	 */
	public void SetWUnit(String unitName) {
		wUnit = unitName;
	} // SetWUnit

	//---------------------------------------------------------------------

	/**
	 * 
	 */
	public void SetTUnit(String unitName) {
		tUnit = unitName;
	} // SetTUnit

	//---------------------------------------------------------------------

	/************************************
	 *         Public Utilities         *
	 ************************************/


	String[] typetable =
		{
			"VOID",
			"OPEN",
			"CLOSED",
			"MEM",
			"CEN",
			"DLY",
			"MSQ",
			"ISRV",
			"FCFS",
			"PSHR",
			"LCFS",
			"TERM",
			"TRANS",
			"BATCH",
			"EXACT",
			"APPROX",
			"CANON",
			"VISITS",
			"DEMAND",
			"SP",
			"MP",
			};

	//---------------------------------------------------------------------

	public String typetostr(int type) {
		if (type < typetable.length) {
			if ((type >= -1) && (type <= typetable.length)) {
				return typetable[type+1];
			} else {
				System.err.println("[typetostr]  Type = " + Integer.toString(type));
				return "*BAD*";
			}
		}

		System.err.println(
			"typetostr:  Unknown type id for \""
				+ Integer.toString(type)
				+ "\"");

		return "None";
	} // typetostr

	//---------------------------------------------------------------------

	public int strtotype(String str) {
		int i;

		for (i = 0; i <= typetable.length; i++) {
			if (typetable[i] == str) {
				return i-1;
			}
		}

		System.err.println("strtotype:  Unknown type name \"" + str + "\"");

		return -2;
	} // strtotype

	//---------------------------------------------------------------------

	double GetThruMax(int should_be_class, String wname) {
		String fn = "GetThruMax()";
		double x = 0.0;

		int jobIdx = getjob_index(wname);
		
		switch (should_be_class) {
			case Job.TERM :
				x = job[jobIdx].term.sys.maxTP;
				break;
			case Job.BATCH :
				x = job[jobIdx].batch.sys.maxTP;
				break;
			case Job.TRANS :
				x = job[jobIdx].trans.sys.maxTP;
				break;
			default :
				System.err.println(fn + ":  Unknown should_be_class");
				break;
		}

		return x;
	} // GetThruMax

	//---------------------------------------------------------------------

	public double GetLoadOpt(int should_be_class, String wname) {
		String fn = "GetLoadOpt()";
		double Dmax = 0.0;
		double Dsum = 0.0;
		double Nopt = 0.0;
		double Z = 0.0;

		int jobIdx = getjob_index(wname);
		
		switch (should_be_class) {
			case Job.TERM :
				Dsum = job[jobIdx].term.sys.minRT;
				Dmax = 1.0 / job[jobIdx].term.sys.maxTP;
				Z = job[jobIdx].term.think;
				break;
			case Job.BATCH :
				Dsum = job[jobIdx].batch.sys.minRT;
				Dmax = 1.0 / job[jobIdx].batch.sys.maxTP;
				Z = 0.0;
				break;
			case Job.TRANS :
				System.err.println(
					fn + ":  Cannot calculate max Load for TRANS class");
				break;
			default :
				System.err.println(fn + ":  Unknown should_be_class");
				break;
		}

		Nopt = (Dsum + Z) / Dmax;

		return Math.floor(Nopt); // Return lower bound as integral value
	} // GetLoadOpt

	//---------------------------------------------------------------------

	public double GetResidenceTime(String device, String work, int should_be_class) {
		String fn = "GetResidenceTime()";
		double r;
		int idxJob;

		idxJob = getjob_index(work);

		if (node != null) {
			for (int idxNode = 0; idxNode < noNodes; idxNode++) {
				if (node[idxNode] != null) {
					if (device.equals(node[idxNode].devname)) {
						r = node[idxNode].resit[idxJob];
						return r;
					}
				}
			}
		}

		System.err.println(fn + ":  Unknown device " + device);

		return 0.0;
	} // GetResidenceTime

	//---------------------------------------------------------------------

	public void SetComment(String s) {
		comment = s;
	} // SetComment

	//---------------------------------------------------------------------

	public String GetComment() {
		return comment;
	} // GetComment

	//---------------------------------------------------------------------

	public void allocate_nodes(int no_nodes, int no_streams) {
		String fn = "allocate_nodes";

		node = new Node[no_nodes];
		noNodes = 0;
		nodeNo = 0;
		
		for (int idx = 0; idx < no_nodes; idx++) {
			node[idx] = new Node(no_streams);
		}
	} // allocate_nodes

	//---------------------------------------------------------------------

	public void allocate_jobs(int no_streams) {
		int jobNo;
		String fn = "allocate_jobs()";

		job = new Job[no_streams];

		noStreams = 0;
		jobNo = 0;
		
		for (int idx = 0; idx < no_streams; idx++) {
			job[idx] = new Job();
			job[idx].term = new Terminal();
			job[idx].batch = new Batch();
			job[idx].trans = new Transaction();
			job[idx].term.sys =
				job[idx].batch.sys = job[idx].trans.sys = new Systat();
			job[idx].should_be_class = 0;
			job[idx].network = 0;
		}
	} // allocate_jobs */

	//---------------------------------------------------------------------

	public int getjob_index(String wname) {
		String fn = "getjob_index()";
		
		if (DEBUG)
			utils.debug(fn, "Entering");

		for (int idx = 0; idx < noStreams; idx++) {
			if (false)
				com.braju.format.Format.printf(
					"[%s]  wname \"%s\" %d:  Term %s  Batch %s  Trans %s\n",
					p.add(fn).add(wname).add(idx)
					.add(job[idx].term.name)
					.add(job[idx].batch.name)
					.add(job[idx].trans.name));
			if (wname.equals(job[idx].term.name)
				|| wname.equals(job[idx].batch.name)
				|| wname.equals(job[idx].trans.name)) {
				if (DEBUG) {
					com.braju.format.Format.printf(
						"[%s]  stream:\"%s\"  index: %d\n",
						p.add(fn).add(wname).add(idx));
					utils.debug(fn, "Exiting");
				}
				return idx;
			}
		}

		if (DEBUG)
			utils.debug(fn, "Exiting");

		return -1;
	} // getjob_index

	//---------------------------------------------------------------------

	public int getnode_index(String name) {
		String fn = "getnode_index()";

		if (DEBUG)
			utils.debug(fn, "Entering");

		// System.err.println(fn + ":  Searching " + Integer.toString(noNodes) + " Nodes\n");

		for (int idx = 0; idx < noNodes; idx++) {
			// com.braju.format.Format.printf(" %s  %s\n", p.add(name).add(node[idx].devname));
			
			if (name.equals(node[idx].devname)) {
				if (DEBUG) {
					System.err.println(
						fn
							+ ":  node:\""
							+ name
							+ "\"  index: "
							+ Integer.toString(idx));
					System.err.println(fn + ":  Exiting");
				}
				return idx;
			}
		}

		// If you are here, you're in deep yoghurt!

		System.err.println(fn + ":  Node \"" + name + "\" not found");

		return -1;
	} // getnode_index */

	//---------------------------------------------------------------------

	public String getjob_name(int jobNo) {
		String fn = "getjob_name()";
		String name = null;

		if (DEBUG)
			utils.debug(fn, ":  Entering ");

		switch (job[jobNo].should_be_class) {
			case Job.TERM :
				name = job[jobNo].term.name;
				break;
			case Job.BATCH :
				name = job[jobNo].batch.name;
				break;
			case Job.TRANS :
				name = job[jobNo].trans.name;
				break;
			default :
				System.err.println(fn + ":  Invalid class " +  Integer.toString(job[jobNo].should_be_class));
				name = "*NOT*FOUND*";
				break;
		}

		if (DEBUG)
			utils.debug(fn, ":  Exiting ");

		return name;
	} // getjob_name

	//---------------------------------------------------------------------

	public double getjob_population(int jobNo) {
		//	   extern char     s1[], s2[];
		//	   extern int      DEBUG;

		String fn = "getjob_population()";
		double population;

		if (DEBUG)
			System.err.println(fn + ":  Entering");

		switch (job[jobNo].should_be_class) {
			case Job.TERM :
				population = job[jobNo].term.population;
				break;
			case Job.BATCH :
				population = job[jobNo].batch.population;
				break;
			default : // Error
				population = -1.0;
				utils.debug(fn, "Stream " + typetostr(job[jobNo].should_be_class)	+ ".  Unknown job type!");
				break;
		}

		if (DEBUG)
			utils.debug(fn, ":  Exiting");

		return population;
	} // getjob_population

	//----- internal functions --------------------------------------------

	private void create_term_stream(
		int idx,
		int circuit,
		String label,
		double population,
		double think) {
		String fn = "create_term_stream()";

		if (DEBUG)
			System.err.println(fn + ":  Entering");

		job[idx].term.name = label;
		job[idx].should_be_class = Job.TERM;
		job[idx].network = circuit;
		job[idx].term.think = think;
		job[idx].term.population = population;

		if (DEBUG) {
			/*
			typetostr(s1, job[jobNo].should_be_class);
			Format.printf("        Stream[%d]: %s \"%s\"; N: %3.1f, Z: %3.2f\n",
				 jobNo, s1,
				 job[jobNo].term.name,
				 job[jobNo].term.population,
				 job[jobNo].term.think
			);
			resets(s1);
			*/
		}
		if (DEBUG)
			System.err.println(fn + ":  Exiting");

	} /* create_term_stream */

	//---------------------------------------------------------------------

	private void create_batch_stream(
		int idx,
		int net,
		String label,
		double number) {
		String fn = "create_batch_stream()";

		if (DEBUG)
			System.err.println(fn + ":  Entering");

		/***** using global value of n *****/

		job[idx].batch.name = label;
		job[idx].should_be_class = Job.BATCH;
		job[idx].network = net;
		job[idx].batch.population = number;

		if (DEBUG) {
			/*
			typetostr(s1, job[jobNo].should_be_class);
			Format.printf("        Stream[%d]: %s \"%s\"; N: %3.1f\n",
				 jobNo, s1, job[jobNo].batch.name, job[jobNo].batch.population);
			resets(s1);
			*/
		}
		if (DEBUG)
			System.err.println(fn + ":  Exiting");
	} /* create_batch_stream */

	//---------------------------------------------------------------------

	private void create_transaction(
		int idx,
		int net,
		String label,
		double lambda) {
		job[idx].trans.name = label;
		job[idx].should_be_class = Job.TRANS;
		job[idx].network = net;
		job[idx].trans.arrival_rate = lambda;
		if (DEBUG) {
			/*
			typetostr(s1, job[jobNo].should_be_class);
			Format.printf("        Stream[%d]:  %s    \"%s\";   Lambda: %3.1f\n",
				 jobNo, s1, job[jobNo].trans.name, job[jobNo].trans.arrival_rate);
			resets(s1);
			*/
		}
	} /* create_transaction */

	//---------------------------------------------------------------------

	private void writetmp(int fp, String s) {
		/*
		fFormat.printf(fp, "%s", s);
		Format.printf("%s", s);
		*/
	} /* writetmp */

	//----- Reporting functions -------------------------------------------

	void PDQ_Report_null() {
		com.braju.format.Format.printf("foo!\n");
	}

	//---------------------------------------------------------------------

	private void print_node_head() {
		/*
			   extern int      serviceDemandType, DEBUG;
			   extern char     model[];
			   extern char     s1[];
			   extern job_type *job;
		*/
		String fn = "print_node_head";

		String dmdfmt = "%-4s %-5s %-10s %-10s %-5s %10s\n";
		String visfmt = "%-4s %-5s %-10s %-10s %-5s %10s %10s %10s\n";

		if (DEBUG) {
			utils.debug(
				fn,
				" Network: \""
					+ typetostr(job[0].network)
					+ " Model: "
					+ modelName);
		}

		switch (serviceDemand) {
			case defs.DEMAND :
				com.braju.format.Format.printf(dmdfmt,
					p.add("Node")
					.add("Sched")
					.add("Resource")
					.add("Workload")
					.add("Class")
					.add("Demand"));
				com.braju.format.Format.printf(dmdfmt,
					p.add("----")
					.add("-----")
					.add("--------")
					.add("--------")
					.add("-----")
					.add("------"));
				break;
			case defs.VISITS :
				com.braju.format.Format.printf(visfmt,
					p.add("Node")
					.add("Sched")
					.add("Resource")
					.add("Workload")
					.add("Class")
					.add("Visits")
					.add("Service")
					.add("Demand"));
				com.braju.format.Format.printf(visfmt,
					p.add("----")
					.add("-----")
					.add("--------")
					.add("--------")
					.add("-----")
					.add("------")
					.add("-------")
					.add("------"));
				break;
			default :
				utils.errmsg(fn, "Unknown file type");
				break;
		}

		nodhdr = true;
	} // print_node_head

	//---------------------------------------------------------------------

	private void print_nodes() {
		String fn = "print_nodes()";

		int idxNode;
		int idxJob;

		if (DEBUG)
			utils.debug(fn, "Entering");

		if (!nodhdr)
			print_node_head();

		String devtype;
		String sched;
		String jobName;
		String jobClass;

		for (idxJob = 0; idxJob < noStreams; idxJob++) {
			for (idxNode = 0; idxNode < noNodes; idxNode++) {
				devtype = typetostr(node[idxNode].devtype);
				sched = typetostr(node[idxNode].sched);
				jobName = getjob_name(idxJob);

				switch (job[idxJob].should_be_class) {
					case Job.TERM :
						jobClass = "TERML";
						break;
					case Job.BATCH :
						jobClass = "BATCH";
						break;
					case Job.TRANS :
						jobClass = "TRANS";
						break;
					default :
						jobClass = "*BAD*";
						break;
				}

				switch (serviceDemand) {
					case defs.DEMAND :
						com.braju.format.Format.printf(
							"%-4s %-5s %-10s %-10s %-5s %10.4f\n",
							p.add(devtype)
							.add(sched)
							.add(node[idxNode].devname)
							.add(jobName)
							.add(jobClass)
							.add(node[idxNode].demand[idxJob]));
						break;
					case defs.VISITS :
						com.braju.format.Format.printf(
							"%-4s %-4s %-10s %-10s %-5s %10.4f %10.4f %10.4f\n",
							p.add(devtype)
							.add(sched)
							.add(node[idxNode].devname)
							.add(jobName)
							.add(jobClass)
							.add(node[idxNode].visits[idxJob])
							.add(node[idxNode].service[idxJob])
							.add(node[idxNode].demand[idxJob]));
						break;
					default :
						utils.errmsg("print_nodes()", "Unknown file type");
						break;
				} // switch
			} // over nodeNo

			com.braju.format.Format.printf("\n");
		} // over jobNo

		com.braju.format.Format.printf("\n");

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // print_nodes

	//---------------------------------------------------------------------

	private void print_job(int jobNo, int should_be_class) {
		String fn = "print_job()";

		if (DEBUG)
			utils.debug(fn, "Entering");

		switch (should_be_class) {
			case Job.TERM :
				print_job_head(Job.TERM);
				com.braju.format.Format.printf(
					"%-10s   %6.2f    %10.4f   %6.2f\n",
					p.add(job[jobNo].term.name)
					.add(job[jobNo].term.population)
					.add(job[jobNo].term.sys.minRT)
					.add(job[jobNo].term.think));
				break;
			case Job.BATCH :
				print_job_head(Job.BATCH);
				com.braju.format.Format.printf(
					"%-10s   %6.2f    %10.4f\n",
					p.add(job[jobNo].batch.name)
					.add(job[jobNo].batch.population)
					.add(job[jobNo].batch.sys.minRT));
				break;
			case Job.TRANS :
				print_job_head(Job.TRANS);
				com.braju.format.Format.printf(
					"%-10s     %4.4f    %10.4f\n",
					p.add(job[jobNo].trans.name)
					.add(job[jobNo].trans.arrival_rate)
					.add(job[jobNo].trans.sys.minRT));
				break;
			default :
				break;
		}

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // print_job

	//---------------------------------------------------------------------

	private void print_sys_head() {
		String fn = "print_sys_head()";

		if (DEBUG)
			utils.debug(fn, "Entering");

		com.braju.format.Format.printf("\n\n\n\n");

		banner_stars();
		banner_chars("   PDQ Model OUTPUTS");
		banner_stars();

		com.braju.format.Format.printf("\n\n");
		
		com.braju.format.Format.printf("Solution Method: " + typetostr(method));

		if (method == Methods.APPROX)
				com.braju.format.Format.printf(
				"        (Iterations: %d; Accuracy: %6.4f%%)",
				p.add(mva.iterations)
				.add(tolerance * 100.0));

		com.braju.format.Format.printf("\n\n");

		banner_chars("   SYSTEM Performance");

		com.braju.format.Format.printf("\n\n");

		com.braju.format.Format.printf("Metric                     Value    Unit\n");
		com.braju.format.Format.printf("------                     -----    ----\n");

		syshdr = true;

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // print_sys_head

	//---------------------------------------------------------------------

	private void print_job_head(int should_be_class) {
		switch (should_be_class) {
			case Job.TERM :
				if (!trmhdr) {
					com.braju.format.Format.printf("\n");
					com.braju.format.Format.printf("Client       Number        Demand   Thinktime\n");
					com.braju.format.Format.printf("------       ------        ------   ---------\n");
					trmhdr = true;
					bathdr = trxhdr = false;
				}
				break;
			case Job.BATCH :
				if (!bathdr) {
					com.braju.format.Format.printf("\n");
					com.braju.format.Format.printf("Job             MPL        Demand\n");
					com.braju.format.Format.printf("---             ---        ------\n");
					bathdr = true;
					trmhdr = trxhdr = false;
				}
				break;
			case Job.TRANS :
				if (!trxhdr) {
					com.braju.format.Format.printf("Source        per Sec        Demand\n");
					com.braju.format.Format.printf("------        -------        ------\n");
					trxhdr = true;
					trmhdr = bathdr = false;
				}
				break;
			default :
				break;
		}
	} // print_job_head

	//---------------------------------------------------------------------

	private void print_dev_head() {
		banner_chars("   RESOURCE Performance");
		com.braju.format.Format.printf("\n\n");
		com.braju.format.Format.printf("Metric          Resource     Work              Value   Unit\n");
		com.braju.format.Format.printf("------          --------     ----              -----   ----\n");
		devhdr = true;
	} // print_dev_head

	//---------------------------------------------------------------------

	private void print_system_stats(int jobNo, int should_be_class) {
		String fn = "print_system_stats()";

		if (DEBUG)
			utils.debug(fn, "Entering");

		Parameters p = new Parameters();

		if (!syshdr)
			print_sys_head();

		switch (should_be_class) {
			case Job.TERM :
				if (job[jobNo].term.sys.thruput == 0) {
					String s = com.braju.format.Format.sprintf(
						"X = %10.4f for stream = %d\n",
						p.add(job[jobNo].term.sys.thruput));
					System.err.println(s);
					utils.errmsg(fn, s);
				}
				com.braju.format.Format.printf("Workload: \"%s\"\n", p.add(job[jobNo].term.name));
				com.braju.format.Format.printf(
					"Mean Throughput       %10.4f    %s/%s\n",
					p.add(job[jobNo].term.sys.thruput)
					.add(wUnit)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Response Time         %10.4f    %s\n",
					p.add(job[jobNo].term.sys.response)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Mean Concurrency      %10.4f    %s\n",
					p.add(job[jobNo].term.sys.residency)
					.add(wUnit));
				com.braju.format.Format.printf(
					"Stretch Factor        %10.4f\n",
					p.add(job[jobNo].term.sys.response / job[jobNo].term.sys.minRT));
				break;

			case Job.BATCH :
				if (job[jobNo].batch.sys.thruput == 0) {
					String s = com.braju.format.Format.sprintf(
						"X = %10.4f at N = %d\n",
						p.add(job[jobNo].batch.sys.thruput)
						.add(jobNo));
					System.err.println(s);
					utils.errmsg(fn, s);
				}
				com.braju.format.Format.printf("Workload: \"%s\"\n", p.add(job[jobNo].batch.name));
				com.braju.format.Format.printf(
					"Mean Throughput       %10.4f    %s/%s\n",
					p.add(job[jobNo].batch.sys.thruput)
					.add(wUnit)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Response Time         %10.4f    %s\n",
					p.add(job[jobNo].batch.sys.response)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Mean Concurrency      %10.4f    %s\n",
					p.add(job[jobNo].batch.sys.residency)
					.add(wUnit));
				com.braju.format.Format.printf(
					"Stretch Factor        %10.4f\n",
					p.add(job[jobNo].batch.sys.response / job[jobNo].batch.sys.minRT));
				break;

			case Job.TRANS :
				if (job[jobNo].trans.sys.thruput == 0) {
					String s = com.braju.format.Format.sprintf(
						"X = %10.4f for N = %d",
						p.add(job[jobNo].trans.sys.thruput)
						.add(jobNo));
					System.err.println(s);
					utils.errmsg(fn, s);
				}
				com.braju.format.Format.printf("Workload: \"%s\"\n", p.add(job[jobNo].trans.name));
				com.braju.format.Format.printf(
					"Mean Throughput       %10.4f    %s/%s\n",
					p.add(job[jobNo].trans.sys.thruput)
					.add(wUnit)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Response Time         %10.4f    %s\n",
					p.add(job[jobNo].trans.sys.response)
					.add(tUnit));
				break;

			default :
				break;
		}

		com.braju.format.Format.printf("\nBounds Analysis:\n");

		switch (should_be_class) {
			case Job.TERM :
				if (job[jobNo].term.sys.thruput == 0) {
					com.braju.format.Format.printf(
						"X = %10.4f at N = %d",
						p.add(job[jobNo].term.sys.thruput)
						.add(jobNo));
					// *EXIT*  utils.errmsg(fn, s1);
				}
				com.braju.format.Format.printf(
					"Max Throughput        %10.4f    %s/%s\n",
					p.add(job[jobNo].term.sys.maxTP)
					.add(wUnit)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Min Response          %10.4f    %s\n",
					p.add(job[jobNo].term.sys.minRT)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Max Demand            %10.4f    %s\n",
					p.add(1 / job[jobNo].term.sys.maxTP)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Tot Demand            %10.4f    %s\n",
					p.add(job[jobNo].term.sys.minRT)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Think time            %10.4f    %s\n",
					p.add(job[jobNo].term.think)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Optimal Clients       %10.4f    %s\n",
					p.add((job[jobNo].term.think + job[jobNo].term.sys.minRT)
								* job[jobNo].term.sys.maxTP)
					.add("Clients"));
				break;

			case Job.BATCH :
				if (job[jobNo].batch.sys.thruput == 0) {
					com.braju.format.Format.printf(
						"X = %10.4f at N = %d",
						p.add(job[jobNo].batch.sys.thruput)
						.add(jobNo));
					// *EXIT*  utils.errmsg(fn, s1);
				}
				com.braju.format.Format.printf(
					"Max Throughput        %10.4f    %s/%s\n",
					p.add(job[jobNo].batch.sys.maxTP)
					.add(wUnit)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Min Response          %10.4f    %s\n",
					p.add(job[jobNo].batch.sys.minRT)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Max Demand            %10.4f    %s\n",
					p.add(1 / job[jobNo].batch.sys.maxTP)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Tot Demand            %10.4f    %s\n",
					p.add(job[jobNo].batch.sys.minRT)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Optimal Jobs          %10.4f    %s\n",
					p.add(job[jobNo].batch.sys.minRT * job[jobNo].batch.sys.maxTP)
					.add("Jobs"));
				break;

			case Job.TRANS :
				com.braju.format.Format.printf(
					"Max Demand            %10.4f    %s/%s\n",
					p.add(job[jobNo].trans.sys.maxTP)
					.add(wUnit)
					.add(tUnit));
				com.braju.format.Format.printf(
					"Max Throughput        %10.4f    %s/%s\n",
					p.add(job[jobNo].trans.sys.maxTP)
					.add(wUnit)
					.add(tUnit));
				break;

			default :
				break;
		}

		com.braju.format.Format.printf("\n");

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // print_system_stats

	//---------------------------------------------------------------------

	private void print_node_stats(int jobNo, int should_be_class) {
		String fn = "print_node_stats()";

		double X;
		double devR;
		double servT;
		String jobName;
		String serviceDemandType;
		
		if (DEBUG)
			utils.debug(fn, "Entering");

		if (!devhdr)
			print_dev_head();

		jobName = getjob_name(jobNo);

		switch (should_be_class) {
			case Job.TERM :
				X = job[jobNo].term.sys.thruput;
				break;
			case Job.BATCH :
				X = job[jobNo].batch.sys.thruput;
				break;
			case Job.TRANS :
				X = job[jobNo].trans.arrival_rate;
				break;
			default :
				X = 0.0;
				break;
		}

		for (int idx = 0; idx < noNodes; idx++) {
			if (node[idx].demand[jobNo] == 0)
				continue;

			if (serviceDemand == defs.VISITS) {
				serviceDemandType = "Visits/" + tUnit;
			} else {
				serviceDemandType = wUnit + "/" + tUnit;
			}

			com.braju.format.Format.printf(
				"%-14s  %-10s   %-10s   %10.4f   %s\n",
				p.add("Throughput")
				.add(node[idx].devname)
				.add(jobName)
				.add((serviceDemand == defs.VISITS)
						? node[idx].visits[jobNo] * X
						: X)
				.add(serviceDemandType));

			// calculate other stats

			com.braju.format.Format.printf(
				"%-14s  %-10s   %-10s   %10.4f   %s\n",
				p.add("Utilization")
				.add(node[idx].devname)
				.add(jobName)
				.add((node[idx].sched == QDiscipline.ISRV)
					? 100
					: node[idx].demand[jobNo] * X * 100)
				.add("Percent"));

			com.braju.format.Format.printf(
				"%-14s  %-10s   %-10s   %10.4f   %s\n",
				p.add("Queue Length")
				.add(node[idx].devname)
				.add(jobName)
				.add((node[idx].sched == QDiscipline.ISRV)
						? 0
						: node[idx].resit[jobNo] * X)
				.add(wUnit));

			com.braju.format.Format.printf(
				"%-14s  %-10s   %-10s   %10.4f   %s\n",
				p.add("Residence Time")
				.add(node[idx].devname)
				.add(jobName)
				.add((node[idx].sched == QDiscipline.ISRV)
						? node[idx].demand[jobNo]
						: node[idx].resit[jobNo])
				.add(tUnit));

			if (serviceDemand == defs.VISITS) {
				// Don't do this if service-time is unspecified

				servT = node[idx].service[jobNo];
				devR = node[idx].resit[jobNo] / node[idx].visits[jobNo];

				com.braju.format.Format.printf(
					"%-14s  %-10s   %-10s   %10.4f   %s\n",
					p.add("Waiting Time")
					.add(node[idx].devname)
					.add(jobName)
					.add((node[idx].sched == QDiscipline.ISRV)
							? node[idx].demand[jobNo]
							: devR - servT)
					.add(tUnit));
			}
			com.braju.format.Format.printf("\n");
		}

		if (DEBUG)
			utils.debug(fn, "Exiting");
	} // print_node_stats

	//---------------------------------------------------------------------

	private void banner_stars() {
		com.braju.format.Format.printf("                ***************************************\n");
	} // banner_stars

	//---------------------------------------------------------------------

	private void banner_chars(String s) {
		com.braju.format.Format.printf("                ******%-26s*******\n", p.add(s));
	} // banner_chars

	//---------------------------------------------------------------------

	/**
	 * 
	 */
	public static void main(String[] args) {
	} // main

	//---------------------------------------------------------------------

} // Class PDQ

