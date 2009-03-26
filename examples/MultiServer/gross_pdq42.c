/*******************************************************************************/
/*  Copyright (C) 1994 - 2009, Performance Dynamics Company                    */
/*                                                                             */
/*  This software is licensed as described in the file COPYING, which          */
/*  you should have received as part of this distribution. The terms           */
/*  are also available at http://www.perfdynamics.com/Tools/copyright.html.    */
/*                                                                             */
/*  You may opt to use, copy, modify, merge, publish, distribute and/or sell   */
/*  copies of the Software, and permit persons to whom the Software is         */
/*  furnished to do so, under the terms of the COPYING file.                   */
/*                                                                             */
/*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  */
/*  KIND, either express or implied.                                           */
/*******************************************************************************/

/*
	 
	 gross_pdq42.c
	 
	 Created by NJG on Fri, Apr  6, 2007
	 Updated by NJG on Wed, Feb 25, 2009 for PDQ v5.0
	  
	 Example 4.2 in Gross and Harris (p. 181, 3rd edn).
	 
	 Circuit contains 3 nodes:
		1. M/M/1 with service time 30 sec 
		2. M/M/3 with service time  6 mins
		3. M/M/7 with service time 20 mins
		
	 Node 1 routes calls to node 2 55% of the time
	 Node 1 routes calls to node 3 45% of the time
	 
	 2% of node 2 completions also go to node 3
	 1% of node 3 completions also go to node 2
	 
	 Using L for lambda, the incoming call rate at node1, the traffic eqn
	 for node 2 is:
	 L2 = 0.55 * L + 0.01 * L3 ... (a)
	
	 The traffic eqn for node 3 is:
	 L3 = 0.45 * L + 0.02 * L2 ... (b)
	 
	 Substituting (b) into (a) produces:
	 L2 * (1 - 0.01 * 0.02) = (0.55 + 0.01 * 0.45) * L
	 
	 Since we know L, we can solve for L2 and substitute into (b) to get L3
	 
	 For PDQ, we need the visit ratios:
	 v1 = L/L
	 v2 = L2/L
	 v3 = L3/L
	 
	 since these values act as weights for the service times which parameterize
	 PDQ_SetDemand(node_k, ..., v_k * S_k).
	 
	 
	 $Id$
 
 */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "PDQ_Lib.h"

int main(void) {

	int              nodes;
	int              streams;
	
	// Mean service times from G&H
	double           stimeSelect 		=  0.5; 	// mins 
	double           stimeClaims 		=  6.0; 	// mins 
	double           stimePolicy 		= 20.0; 	// mins 

	double           callRateIncoming 	=  35.0/60;	// per min 	
	double           callRateClaim;		// compute from traffic eqns below
	double           callRatePolicy; 	// compute from traffic eqns below
	
	// Routing probabilities from G&H
	double           routeSelectClaim 	= 0.55;
	double           routeSelectPolicy 	= 0.45;
	double           routePolicyClaim 	= 0.01;
	double           routeClaimPolicy 	= 0.02;
	
	// Visit ratios: lambda_k / lambda 
	double           vSelect;   	// no branching
	double           vClaims;		// compute from traffic eqns below
	double           vPolicy;		// compute from traffic eqns below


	/*** Solve the traffic equations first ***/
	
	callRateClaim	= 
		(routeSelectClaim + routePolicyClaim * routeSelectPolicy) * callRateIncoming / 
		(1 - routePolicyClaim * routeSelectPolicy);
	
	callRatePolicy	= routeSelectPolicy * callRateIncoming + 
		routeClaimPolicy * callRateClaim;
	
	vSelect = 1.0;	// no branching
	vClaims = callRateClaim / callRateIncoming;
	vPolicy = callRatePolicy / callRateIncoming;


	/*** Now setup and solve the PDQ model using these visit ratios ***/	
	
	PDQ_Init("G&H Example 4.2");
	
	streams = PDQ_CreateOpen("Customers", callRateIncoming);	
	PDQ_SetWUnit("Calls");
	PDQ_SetTUnit("Mins");	// timebase for PDQ report
	

	// Use a standard PDQ node as a test case
	nodes = PDQ_CreateNode("Select", CEN, FCFS); 
	
	// Multiserver nodes
	nodes = PDQ_CreateMultiNode(3, "Claims", CEN, FCFS); 
	nodes = PDQ_CreateMultiNode(7, "Policy", CEN, FCFS);
	
	// In PDQ the computed visit ratios multiply the service times
	PDQ_SetDemand("Select", "Customers", vSelect * stimeSelect);
	PDQ_SetDemand("Claims", "Customers", vClaims * stimeClaims); 
	PDQ_SetDemand("Policy", "Customers", vPolicy * stimePolicy); 

	PDQ_Solve(CANON);
	PDQ_Report();
   
}  // main


