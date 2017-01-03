#*******************************************************************************
#*  Copyright (C) 2007 - 2017, Performance Dynamics Company                    *
#*                                                                             *
#*  This software is licensed as described in the file COPYING, which          *
#*  you should have received as part of this distribution. The terms           *
#*  are also available at http://www.perfdynamics.com/Tools/copyright.html.    *
#*                                                                             *
#*  You may opt to use, copy, modify, merge, publish, distribute and/or sell   *
#*  copies of the Software, and permit persons to whom the Software is         *
#*  furnished to do so, under the terms of the COPYING file.                   *
#*                                                                             *
#*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  *
#*  KIND, either express or implied.                                           *
#*******************************************************************************
#
#	bookstore.R
#	
#	Created by NJG on Wed, Apr 4, 2007
#   Ported to R by Paul Puglia on Wed Aug 1, 2012
#	Updated by NJG on Monday, November 12, 2012
#	Updated by NJG on Sunday, January 1, 2017    --Added missing 'library(pdq)'
#	Updated by NJG on Monday, January 2, 2017    --m=4 cashiers to match G&H Ex
#
#	PDQ model using 2 MSQ multi-server nodes in tandem.
#   Here, prototype MSQ node is replaced by documented CreateMultiNode function.
#   See http://www.perfdynamics.com/Tools/PDQman.html#tth_sEc3.2
#	
#	Big book stores like Barnes & Noble or Borders allow customers to
#	enter, browse and read books, have coffee, eat, listen to CDs and
#	finally head to the checkout area. The checkout consists of a single
#	waiting line serviced by multiple cashiers. Such a big book store can
#	be modeled as M/M/inf (browsing) and M/M/m (checkout).
#
#	The PDQ model parameters are taken from Example 4.1 (p.170) in Gross and Harris,
#   "Fundamentals of Queueing Theory," 3rd edn. (1998) for a grocery store with a
#   "lounge". (???)
#
#   Input parameters:
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
#	bookstore example is the browsing time, e.g., increase to 65 mins.
#		
#	$Id: bookstore.R,v 1.3 2012/11/13 05:41:43 earl-lang Exp $


library(pdq)


# cust per mins
arrivalRate <- 40.0 / 60.0
# times in mins
browseTime  <- 0.75 * 60
buyingTime  <-  4.0	
cashiers    <-  4
		
Init("Big Book Store Model")
		
CreateOpen("Customers", arrivalRate);
	
# M/M/inf queue defined as 100 times the number of Erlangs = lambda * S
CreateMultiNode(as.integer(ceiling(arrivalRate * browseTime) * 100), "Browsing", CEN, FCFS)
	
# M/M/m where m is the number of cashiers	
CreateMultiNode(cashiers, "Checkout", CEN, FCFS) 
	
# Set service times
SetDemand("Browsing", "Customers", browseTime)
SetDemand("Checkout", "Customers", buyingTime)

# Change units in Report
SetWUnit("Cust")
SetTUnit("Min")	
		
Solve(CANON)
Report()
