#!/usr/bin/env python
#
###############################################################################
#  Copyright (C) 1994 - 2017, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

 # gross_pdq42.py
 #
 # Created by NJG on Friday, April  6, 2007
 # Updated by NJG on Wednesday, February 25, 2009 for PDQ 5.0
 # Updated by NJG on Thursday, October 04, 2018 for PDQ 6.2


# Background ....
#
# Example 4.2 in Gross and Harris (p. 181, 3rd edn).
# 
# Circuit contains 3 nodes:
# 1. M/M/1 with service time 30 sec 
# 2. M/M/3 with service time  6 mins
# 3. M/M/7 with service time 20 mins
# 
# Node 1 routes calls to node 2 55% of the time
# Node 1 routes calls to node 3 45% of the time
# 
# 2% of node 2 completions also go to node 3
# 1% of node 3 completions also go to node 2
# 
# Using L for lambda, the incoming call rate at node1, the traffic eqn
# for node 2 is:
# L2 = 0.55 * L + 0.01 * L3 ... (a)
# 
# The traffic eqn for node 3 is:
# L3 = 0.45 * L + 0.02 * L2 ... (b)
# 
# Substituting (b) into (a) produces:
# L2 * (1 - 0.01 * 0.02) = (0.55 + 0.01 * 0.45) * L
# 
# Since we know L, we can solve for L2 and substitute into (b) to get L3
# 
# For PDQ, we need the visit ratios:
# v1 = L/L
# v2 = L2/L
# v3 = L3/L
# 
# since these values act as weights for the service times which parameterize
# PDQ_SetDemand(node_k, ..., v_k * S_k).
# 

import pdq

# Mean service times from G&H
stimeSelect =  0.5;  # mins 
stimeClaims =  6.0;  # mins  
stimePolicy = 20.0;  # mins  

callRateIncoming = 35.0/60; # per min   
# Routing probabilities from G&H
routeSelectClaim  = 0.55;
routeSelectPolicy = 0.45;
routePolicyClaim  = 0.01;
routeClaimPolicy  = 0.02;


'''
 Solve the traffic equations first

'''

callRateClaim = (routeSelectClaim + routePolicyClaim * routeSelectPolicy) * callRateIncoming / (1 - routePolicyClaim * routeSelectPolicy);
callRatePolicy = routeSelectPolicy * callRateIncoming + routeClaimPolicy * callRateClaim;

# Visit ratios: lambda_k / lambda 
vSelect = 1.0;  # no branching
vClaims = callRateClaim / callRateIncoming;
vPolicy = callRatePolicy / callRateIncoming;


'''
Now setup and solve the PDQ model using these visit ratios

'''   

pdq.Init("G&H Example 4.2");

pdq.CreateOpen("Customers", callRateIncoming);    
pdq.SetWUnit("Calls");
pdq.SetTUnit("Mins");     # timebase for PDQ report


# Use a standard PDQ node as a test case
pdq.CreateNode("Select", pdq.CEN, pdq.FCFS); 

# Multiserver nodes
pdq.CreateMultiNode(3, "Claims", pdq.CEN, pdq.FCFS); 
pdq.CreateMultiNode(7, "Policy", pdq.CEN, pdq.FCFS);

# In PDQ the computed visit ratios multiply the service times
pdq.SetDemand("Select", "Customers", vSelect * stimeSelect);
pdq.SetDemand("Claims", "Customers", vClaims * stimeClaims); 
pdq.SetDemand("Policy", "Customers", vPolicy * stimePolicy); 

pdq.Solve(pdq.CANON);
pdq.Report();

