/*
 * Created on 17/02/2004
 *
 */
package com.perfdynamics.pdq;

import com.braju.format.*;

/**
 * @author plh
 *
 */
public class MVA {
	public static final String VERSION = "1.0";
	private Parameters p = null;
	private Utils utils = null;
	private PDQ pdq = null;

	public int iterations = 0;
	public int method = 0;

	private Job[] job = null;
	private int noStreams = 0;
	private Node[] node = null;
	private int noNodes = 0;
	
	public double tolerance = 0.001;

	public boolean DEBUG = false;

	//----------------------------------------------------------------

	public MVA(PDQ pdq) {
		this.pdq = pdq;
		job = pdq.job;
		noStreams = pdq.noStreams;
		node = pdq.node;
		noNodes = pdq.noNodes;
		DEBUG = pdq.GetDebug();
		utils = new Utils(pdq);
		p = new Parameters();
	}

	//----------------------------------------------------------------

	void approx() {
		String fn = "approx()";

		int nodeIdx;
		int jobIdx;
		int should_be_class;
		double sumR[] = null;
		double delta = 2 * defs.TOL;
		boolean iterate = true;
		String jobname = null;
		Node[] last = null;

		if (DEBUG)
			utils.debug(fn, "Entering");

		if (noNodes == 0 || noStreams == 0)
			utils.errmsg(fn, "Network nodes and streams not defined.");

		// Setup framwork to hold 'last' node data...

		last = new Node[noNodes];

      for (int i = 0; i < noNodes; i++ ) {
      	last[i] = new Node(noStreams);
      }

		sumR = new double[noStreams];
		
		iterations = 0;

		if (DEBUG) {
			utils.debug(fn, "\nIteration: " + Integer.toString(iterations));
		}

		// Initialize all queues
		
		for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
			should_be_class = job[jobIdx].should_be_class;

			for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
				switch (should_be_class) {
					case Job.TERM :
						last[nodeIdx].qsize[jobIdx] =
							node[nodeIdx].qsize[jobIdx] = job[jobIdx].term.population / noNodes;
						break;
					case Job.BATCH :
						last[nodeIdx].qsize[jobIdx] =
							node[nodeIdx].qsize[jobIdx] = job[jobIdx].batch.population / noNodes;
						break;
					default :
						break;
				}

				if (DEBUG) {
					jobname = pdq.getjob_name(jobIdx);
					System.err.println(
						"Que["
							+ node[nodeIdx].devname
							+ "]["
							+ jobname
							+ ": "
							+ Double.toString(node[nodeIdx].qsize[jobIdx])
							+ " (D="
							+ Double.toString(delta)
							+ ")");
				}
			} /* over nodeIdx */
		} /* over jobIdx */

		do {
			iterations++;

			if (DEBUG) {
				utils.debug(fn, "Iteration: " + Integer.toString(iterations));
			}

			for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
				jobname = pdq.getjob_name(jobIdx);

				sumR[jobIdx] = 0.0;

				if (DEBUG) {
					utils.debug(fn, "Stream: " + jobname);
				}

				should_be_class = job[jobIdx].should_be_class;

				for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
					if (DEBUG) {
						String s = Format.sprintf("Que[%s][%s]: %3.4f (D=%1.5f)",
															p.add(node[nodeIdx].devname)
															.add(jobname)
															.add(node[nodeIdx].qsize[jobIdx])
															.add(delta));
						utils.debug(fn, s);
					}

					// Approximate avg queue length

					double N;

					switch (should_be_class) {
						case Job.TERM :
							N = job[jobIdx].term.population;
							node[nodeIdx].avqsize[jobIdx] =
								sumQ(nodeIdx, jobIdx) + (node[nodeIdx].qsize[jobIdx] * (N - 1.0) / N);
							break;

						case Job.BATCH :
							N = job[jobIdx].batch.population;
							node[nodeIdx].avqsize[jobIdx] =
								sumQ(nodeIdx, jobIdx) + (node[nodeIdx].qsize[jobIdx] * (N - 1.0) / N);
							break;

						default :
							utils.errmsg(fn, Format.sprintf("Unknown should_be_class: %s", p.add(pdq.typetostr(should_be_class))));
							break;
					}

					if (DEBUG) {
						String s = Format.sprintf("<Q>[%s][%s]: %3.4f (D=%1.5f)",
														p.add(node[nodeIdx].devname)
														.add(jobname)
														.add(node[nodeIdx].avqsize[jobIdx])
														.add(delta));
						utils.debug(fn, s);
					}

					// Residence times

					switch (node[nodeIdx].sched) {
						case QDiscipline.FCFS :
						case QDiscipline.PSHR :
						case QDiscipline.LCFS :
							node[nodeIdx].resit[jobIdx] =
								node[nodeIdx].demand[jobIdx] * (node[nodeIdx].avqsize[jobIdx] + 1.0);
							break;
						case QDiscipline.ISRV :
							node[nodeIdx].resit[jobIdx] = node[nodeIdx].demand[jobIdx];
							break;
						default :
							String s = Format.sprintf("Unknown queue type: %s", p.add(pdq.typetostr(node[nodeIdx].sched)));
							utils.errmsg(fn, s);
							break;
					}

					sumR[jobIdx] += node[nodeIdx].resit[jobIdx];

					if (DEBUG) {
							System.out.printf("\tTot ResTime[%s] = %3.4f\n",
								p.add(jobname).add(sumR[jobIdx]));
						
							System.out.printf("\tnode[%s].qsize[%s] = %3.4f\n",
								p.add(node[nodeIdx].devname)
								.add(jobname)
								.add(node[nodeIdx].qsize[jobIdx]));
						
							System.out.printf("\tnode[%s].demand[%s] = %3.4f\n",
								p.add(node[nodeIdx].devname)
								.add(jobname)
								.add(node[nodeIdx].demand[jobIdx]));
						
							System.out.printf("\tnode[%s].resit[%s] = %3.4f\n",
								p.add(node[nodeIdx].devname)
								.add(jobname)
								.add(node[nodeIdx].resit[jobIdx]));
					}
				}  // Over nodeIdx

				// System throughput, residency & response-time

				switch (should_be_class) {
					case Job.TERM :
						job[jobIdx].term.sys.thruput =
							(job[jobIdx].term.population
								/ (sumR[jobIdx] + job[jobIdx].term.think));
						job[jobIdx].term.sys.response =
							(job[jobIdx].term.population / job[jobIdx].term.sys.thruput)
								- job[jobIdx].term.think;
						job[jobIdx].term.sys.residency =
							job[jobIdx].term.population
								- (job[jobIdx].term.sys.thruput * job[jobIdx].term.think);

						if (DEBUG) {
							String s = Format.sprintf("\tTERM<X>[%s]: %5.4f",
																p.add(jobname)
																.add(job[jobIdx].term.sys.thruput));
							utils.debug(fn, s);
							s = Format.sprintf("\tTERM<R>[%s]: %5.4f",
														p.add(jobname)
														.add(job[jobIdx].term.sys.response));
							utils.debug(fn, s);
						}
						break;

					case Job.BATCH :
						job[jobIdx].batch.sys.thruput =
							job[jobIdx].batch.population / sumR[jobIdx];
						job[jobIdx].batch.sys.response =
							(job[jobIdx].batch.population
								/ job[jobIdx].batch.sys.thruput);
						job[jobIdx].batch.sys.residency = job[jobIdx].batch.population;

						if (DEBUG) {
							String s = Format.sprintf("\t<X>[%s]: %3.4f",
																p.add(jobname)
																.add(job[jobIdx].batch.sys.thruput));
							utils.debug(fn, s);
							s = Format.sprintf("\t<R>[%s]: %3.4f",
														p.add(jobname)
														.add(job[jobIdx].batch.sys.response));
							utils.debug(fn, s);
						}
						break;

					default :
						utils.errmsg(fn, Format.sprintf("Unknown should_be_class: %s", p.add(should_be_class)));
						break;
				}
			} // Over jobIdx

			// Update queue sizes

			for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
				jobname = pdq.getjob_name(jobIdx);
				should_be_class = job[jobIdx].should_be_class;
				iterate = false;

				if (DEBUG) {
					String s = Format.sprintf("Updating queues of \"%s\"\n", p.add(jobname));
					utils.debug(fn, s);
				}

				for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
					switch (should_be_class) {
						case Job.TERM :
							node[nodeIdx].qsize[jobIdx] =
								job[jobIdx].term.sys.thruput * node[nodeIdx].resit[jobIdx];
							break;
						case Job.BATCH :
							node[nodeIdx].qsize[jobIdx] =
								job[jobIdx].batch.sys.thruput * node[nodeIdx].resit[jobIdx];
							break;
						default :
							utils.errmsg(fn, Format.sprintf("Unknown should_be_class: %s", p.add(should_be_class)));
							break;
					}

					// Check convergence

					delta =
						Math.abs(
							(double) (last[nodeIdx].qsize[jobIdx] - node[nodeIdx].qsize[jobIdx]));

					if (delta > tolerance)  // For any node
						iterate = true;  // But complete all queue updates

					last[nodeIdx].qsize[jobIdx] = node[nodeIdx].qsize[jobIdx];

					if (DEBUG) {
						String s = Format.sprintf("Que[%s][%s]: %3.4f (D=%1.5f)",
															p.add(node[nodeIdx].devname)
															.add(jobname)
															.add(node[nodeIdx].qsize[jobIdx])
															.add(delta));
						utils.debug(fn, s);
					}
				}  // Over nodeIdx
			}  // Over jobIdx

			if (DEBUG)
				utils.debug(fn, "Update complete");
		} while (iterate);

		if (DEBUG)
			utils.debug(fn, "Exiting");
	}  // approx

	//----------------------------------------------------------------

	double sumQ(int nodeIdx, int skipIdx) {
		double sum = 0.0;

		for (int jobIdx = 0; jobIdx < noStreams; jobIdx++) {
			if (jobIdx == skipIdx)
				continue;
			sum += node[nodeIdx].qsize[jobIdx];
		}

		return sum;
	}  // sumQ

	//----------------------------------------------------------------

	public void canonical() {
		String fn = "canonical()";

		int nodeIdx;
		int jobIdx;
		double X;
		double Xsat;
		double Dsat = 0.0;
		double[] sumR = null;
		double devU;

		if (DEBUG) {
			utils.debug(fn, "Entering");
		}

		sumR = new double[noStreams];
		
		for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
			sumR[jobIdx] = 0.0;
			X = job[jobIdx].trans.arrival_rate;

			// Find saturation device
			
			for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
				if (node[nodeIdx].demand[jobIdx] > Dsat)
					Dsat = node[nodeIdx].demand[jobIdx];
			}

			if (Dsat == 0)
				utils.errmsg("canonical()", "Dsat = " + Double.toString(Dsat));
			
			job[jobIdx].trans.saturation_rate = Xsat = 1.0 / Dsat;

			if (X > job[jobIdx].trans.saturation_rate) {
				System.err.println(
					"canonical()  Arrival rate "
						+ Double.toString(X)
						+ "  exceeds system saturation "
						+ Double.toString(Xsat)
						+ " = 1 / "
						+ Double.toString(Dsat));
			}

			for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
				node[nodeIdx].utiliz[jobIdx] = X * node[nodeIdx].demand[jobIdx];

				devU = sumU(nodeIdx);

				if (devU > 1.0) {
					System.err.println(
						"Total utilization of node "
							+ node[nodeIdx].devname
							+ " is "
							+ Double.toString(devU * 100.0)
							+ "% (>100%%)");
				}

				if (DEBUG) {
					System.err.println(
						"Tot Util: "
							+ Double.toString(devU)
							+ " for "
							+ node[nodeIdx].devname);
				}

				switch (node[nodeIdx].sched) {
					case QDiscipline.FCFS :
					case QDiscipline.PSHR :
					case QDiscipline.LCFS :
						node[nodeIdx].resit[jobIdx] = node[nodeIdx].demand[jobIdx] / (1.0 - devU);
						node[nodeIdx].qsize[jobIdx] = X * node[nodeIdx].resit[jobIdx];
						break;
					case QDiscipline.ISRV :
						node[nodeIdx].resit[jobIdx] = node[nodeIdx].demand[jobIdx];
						node[nodeIdx].qsize[jobIdx] = node[nodeIdx].utiliz[jobIdx];
						break;
					default :
						String s = Format.sprintf("Unknown queue type: %s", p.add(pdq.typetostr(node[nodeIdx].sched)));
						utils.errmsg("canonical()", s);
						break;
				}
				sumR[jobIdx] += node[nodeIdx].resit[jobIdx];
			}  // Loop over nodeIdx

			job[jobIdx].trans.sys.thruput = X;
			job[jobIdx].trans.sys.response = sumR[jobIdx];
			job[jobIdx].trans.sys.residency = X * sumR[jobIdx];

			if (DEBUG) {
				String jobname = pdq.getjob_name(jobIdx);
				System.out.printf("\tX[%s]: %3.4f\n", p.add(jobname).add(job[jobIdx].trans.sys.thruput));
				System.out.printf("\tR[%s]: %3.4f\n", p.add(jobname).add(job[jobIdx].trans.sys.response));
				System.out.printf("\tN[%s]: %3.4f\n", p.add(jobname).add(job[jobIdx].trans.sys.residency));
			}
		}  // Loop over jobIdx

		if (DEBUG) {
			utils.debug(fn, "Exiting");
		}
	} // canonical

	//----------------------------------------------------------------

	double sumU(int nodeIdx) {
		/*
			   extern int      DEBUG, streams, nodes;
			   extern job_type *job;
			   extern node_type *node;
		*/

		int jobIdx;
		double sum = 0.0;
		String fn = "sumU()";

		for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
			sum += (job[jobIdx].trans.arrival_rate * node[nodeIdx].demand[jobIdx]);
		}

		return sum;
	} // sumU

	//----------------------------------------------------------------

	private static final int MAXPOP1 = 100;
	private static final int MAXPOP2 = 100;
	private static final int MAXDEVS = 10;
	private static final int MAXCLASS = 3;

	public void exact() {
		String fn = "exact()";

		int jobIdx;
		int nodeIdx;
		int[] population = { 0, 0, 0 }; // population vector
		int[] N = { 0, 0, 0 }; // temp counters
		double[] sumR = { 0.0, 0.0, 0.0 };
		double[][][] qlen = new double[MAXPOP1][MAXPOP2][MAXDEVS];

		/* #define DMVA */

		if (noStreams > MAXCLASS) {
			// System.out.printf("Streams = %d", p.add(noStreams));
			String s = Format.sprintf("%d workload streams exceeds maximum of 3.\n(At workload: \"%s\" with population: %3.2f)\n",
												p.add(noStreams).add(pdq.getjob_population(noStreams - 1)));
			utils.errmsg(fn, s);
		}

		for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
			population[jobIdx] = (int) Math.ceil(pdq.getjob_population(jobIdx));

			//#ifdef DMVA
			// System.out.printf("population[%d]: %2d\n", p.add(jobIdx).add(population[jobIdx]));
			//#endif

			if (population[jobIdx] > MAXPOP1 || population[jobIdx] > MAXPOP2) {
				String s = Format.sprintf("Pop %d > allowed:\nmax1: %d\nmax2: %d\n",
														p.add(population[jobIdx])
														.add(MAXPOP1)
														.add(MAXPOP2));
				utils.errmsg(fn, s);
			}
		}

		// Initialize lowest queue configs on each device

		for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
			qlen[0][0][nodeIdx] = 0.0;
		}

		// MVA loop starts here ....
		
		for (int n0 = 0; n0 <= population[0]; n0++) {
			for (int n1 = 0; n1 <= population[1]; n1++) {
				for (int n2 = 0; n2 <= population[2]; n2++) {
					if (n0 + n1 + n2 == 0)
						continue;
					N[0] = n0;
					N[1] = n1;
					N[2] = n2;

					//#ifdef DMVA
					// System.out.printf("N[%d,%d,%d]\t", p.add(n0).add(n1).add(n2));
					//#endif

					for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
						sumR[jobIdx] = 0.0;

						if (N[jobIdx] == 0)
							continue;

						N[jobIdx] -= 1;

						for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
							//#ifdef DMVA
							// System.out.printf("Q[%d,%d,%d](jobIdx:%d)-->", p.add(n0).add(n1).add(n2).add(jobIdx));
							// System.out.printf("Q[%d,%d,%d]: %6.4f\t", p.add(N[1]).add(N[2]).add(nodeIdx).add(qlen[N[1]][N[2]][nodeIdx]));
							//#endif
							node[nodeIdx].qsize[jobIdx] = qlen[N[1]][N[2]][nodeIdx];
							node[nodeIdx].resit[jobIdx] =
								node[nodeIdx].demand[jobIdx] * (1.0 + node[nodeIdx].qsize[jobIdx]);
							sumR[jobIdx] += node[nodeIdx].resit[jobIdx];
							//#ifdef DMVA
							// System.out.printf("R(%d)=%4.2f\n", p.add(jobIdx).add(sumR[jobIdx]));
							//#endif
						}

						N[jobIdx] += 1;

						switch (job[jobIdx].should_be_class) {
							case Job.TERM :
								if (sumR[jobIdx] == 0)
									utils.errmsg(fn, "sumR is zero");
								job[jobIdx].term.sys.thruput =
									N[jobIdx] / (sumR[jobIdx] + job[jobIdx].term.think);
								//#ifdef DMVA
								// System.out.printf("X(%d)=%6.4f\n", p.add(jobIdx).add(job[jobIdx].term.sys.thruput));
								//#endif
								job[jobIdx].term.sys.response =
									(N[jobIdx] / job[jobIdx].term.sys.thruput)
										- job[jobIdx].term.think;
								job[jobIdx].term.sys.residency =
									N[jobIdx]
										- (job[jobIdx].term.sys.thruput
											* job[jobIdx].term.think);
								break;

							case Job.BATCH :
								if (sumR[jobIdx] == 0)
									utils.errmsg(fn, "sumR is zero");
								job[jobIdx].batch.sys.thruput = N[jobIdx] / sumR[jobIdx];
								job[jobIdx].batch.sys.response =
									N[jobIdx] / job[jobIdx].batch.sys.thruput;
								job[jobIdx].batch.sys.residency = N[jobIdx];
								break;

							default :
								break;
						}
					}

					for (nodeIdx = 0; nodeIdx < noNodes; nodeIdx++) {
						qlen[n1][n2][nodeIdx] = 0.0;
						for (jobIdx = 0; jobIdx < noStreams; jobIdx++) {
							if (N[jobIdx] == 0)
								continue;
							switch (job[jobIdx].should_be_class) {
								case Job.TERM :
									qlen[n1][n2][nodeIdx]
										+= (job[jobIdx].term.sys.thruput
											* node[nodeIdx].resit[jobIdx]);
									node[nodeIdx].qsize[jobIdx] = qlen[n1][n2][nodeIdx];

									//#ifdef DMVA
									// System.out.printf("Q(%d)=%6.4f\n", p.add(jobIdx).add(node[nodeIdx].qsize[jobIdx]));
									//#endif
									break;

								case Job.BATCH :
									qlen[n1][n2][nodeIdx]
										+= (job[jobIdx].batch.sys.thruput
											* node[nodeIdx].resit[jobIdx]);
									node[nodeIdx].qsize[jobIdx] = qlen[n1][n2][nodeIdx];
									break;

								default :
									break;
							}
						}
					}
				}  // Over n2
			}  // Over n1
		}  // Over n0
	}  // exact

	//----------------------------------------------------------------

	public static void main(String[] args) {
	}  // main

	//----------------------------------------------------------------

}
