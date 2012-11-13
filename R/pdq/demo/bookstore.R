#*******************************************************************************
#*  Copyright (C) 1994 - 2007, Performance Dynamics Company                    *
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
#*
#	bookstore.R
#	
#	Created by NJG on Wed, Apr 4, 2007
#       Ported to R by Paul Puglia on Wed Aug 1, 2012
#
#	PDQ model using 2 MSQ nodes in tandem.
#	
#	Big book stores like Barnes & Noble or Borders allow customers to
#	enter, browse and read books, have coffee, eat, listen to CDs and
#	finally head to the checkout area. The checkout consists of a single
#	waiting line serviced by multiple cashiers. Such a big book store can
#	be modeled as M/M/inf (browsing) and M/M/m (checkout).
#
#	The PDQ model parameters are taken from Example 4.1 (p.170) in Gross
#	and Harris, "Fundamentals of Queueing Theory," 3rd edn. (1998) which
#	discusses a grocery store with a "lounge". (??)
#	
#	The capacity planning question is:
#		Currently, only 3 employees are paid to act as cashiers.
#		If the store mgr pays a 4th cashier, what happens to the:
#		1. waiting time at the checkout?
#		2. length of the waiting line?
#		3. mean number of people in the store 
#		
#	The only only parameter that might be made more realistic for this
#	bookstore example, is the browsing time, e.g., increase to 65 mins.
#		
#	$Id$
# 



#       cust per min	
	arrivalRate  <- 40.0/60.0	
#       mins
        browseTime  <- 45.0		
	buyingTime  <- 	 4.0		
	cashiers    <-  3.0
		
	Init("Big Book Store Model")
		
	streams <- CreateOpen("Customers", arrivalRate);
	
	SetWUnit("Cust");
	SetTUnit("Min");	
	

#	 M/M/inf queue defined as 100 times the number of Erlangs = lambda * S
	nodes <- CreateNode("Browsing", 
             as.integer(ceiling(arrivalRate * browseTime) * 100), MSQ);
	
#	 M/M/m where m is the number of cashiers	
	nodes <- CreateNode("Checkout", cashiers, MSQ) 
	
# Set service times ...
	SetDemand("Browsing", "Customers", browseTime);
	SetDemand("Checkout", "Customers", buyingTime);
	
	Solve(CANON);
	Report();
   


