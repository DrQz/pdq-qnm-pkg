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

# Updated by NJG on Sun Dec 10 10:35:01 2017

library(pdq)

# M/M/1 queue in PDQ. See PPDQ book
# http://www.perfdynamics.com/books.html
# Section 4.6.1 Single Cashier Queue
# Section 8.5.2 M/M/1 in PDQ

arrivalRate <- 75
serviceRate <- 100
serviceTime <- 1/serviceRate

# Initialize PDQ and add an optional comment
pdq::Init("Open Queue")
pdq::SetComment("The simplest M/M/1 queue in R. ")

# Create the workflow type (open or closed)
pdq::CreateOpen("Customers", arrivalRate)

# Create the queueing center 
pdq::CreateNode("Cashier", CEN, FCFS)

# Define the average time to service each request in that queue
pdq::SetDemand("Cashier", "Customers", serviceTime)

# Optionally change thw Customers units and time units that will appear 
# in a PDQ Report
pdq::SetWUnit("Cust")
pdq::SetTUnit("Min")

# Solve this queueing model (CANONical method for an open queue)
pdq::Solve(CANON)

# Generate a report
pdq::Report()


