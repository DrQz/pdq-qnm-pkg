###########################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company
#  
#  This software is licensed as described in the file COPYING, which
#  you should have received as part of this distribution. The terms
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.
#
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell 
#  copies of the Software, and permit persons to whom the Software is
#  furnished to do so, under the terms of the COPYING file.
#
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF 
# ANY KIND, either express or implied.
###########################################################################

#	Created by NJG on Wed, Apr 4, 2007
# Ported to R by PPuglia on Wed Aug 1, 2012
#	$Id: bookstore.R,v 1.3 2012/11/13 05:41:43 earl-lang Exp $
# Updated by NJG on Sun Dec 10 11:28:27 2017
#
#	This PDQ model uses TWO multiserver nodess in tandem:
# 1. A delay center tp represent browsing time without queueing
# 2. A checkout center that has a waiting line.
#	
#	The parameters are taken from Example 4.1 (p.170) in Gross and Harris,
# "Fundamentals of Queueing Theory," 3rd edn. (1998) 
#       Arrival rate = 40 per hr
#       Lounge time  = 3/4 hr
#       Service time = 4 mins
#
#	The capacity planning questions are:
#		Currently, only 3 employees are paid to act as cashiers.
#		If the store mgr pays a 4th cashier, what happens to the:
#		1. waiting time at the checkout? (G&H: 1.14 mins)
#		2. number of people at the checkout? (G&H: 3.44 cust)
#		3. mean number of people in the store (G&H: 30 + 3.44 = 33.44 cust)
#
#	The only only parameter that might be made more realistic for this
#	bookstore example is the browsing time, e.g., increase it to 65 mins.

library(pdq)

# Customers per minute
arrivalRate <- 40.0 / 60.0
# times in mins
browseTime  <- 0.75 * 60
buyingTime  <-  4.0	
cashiers    <-  4
		
pdq::Init("Big Book Store Model")
		
pdq::CreateOpen("Customers", arrivalRate);
	
# Delay center defined as 100 times the number of Erlangs = lambda * S
pdq::CreateMultiNode(as.integer(ceiling(arrivalRate * browseTime) * 100), "Browsing", CEN, FCFS)
	
# M/M/m where m is the number of cashiers	
pdq::CreateMultiNode(cashiers, "Checkout", CEN, FCFS) 
	
# Set the service times
pdq::SetDemand("Browsing", "Customers", browseTime)
pdq::SetDemand("Checkout", "Customers", buyingTime)

# Change units in Report
pdq::SetWUnit("Cust")
pdq::SetTUnit("Min")	
		
pdq::Solve(CANON)
pdq::Report()
