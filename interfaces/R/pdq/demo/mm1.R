###########################################################################
#  Copyright (C) 1994--2021, Performance Dynamics Company
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
#
# Updated by NJG on Sun Dec 10 10:35:01 2017
# Updated by NJG on Wed Nov 18 20:13:17 2020 for PDQ 7.0

library(pdq)

# Based on the M/M/1 queue in the Perl PDQ book
# http://www.perfdynamics.com/books.html
# Section 4.6.1 Single Cashier Queue
# Section 8.5.2 M/M/1 in PDQ

arrivalRate <- 75  # must be less than serviceRate
serviceRate <- 100 # must be greater than arrivalRate
serviceTime <- 1 / serviceRate

# Initialize PDQ and add an optional comment
pdq::Init("Open Grox Store Model")
pdq::SetComment("The simplest M/M/1 queue in R.")

# Create the workflow type (open or closed)
pdq::CreateOpen("Customers", arrivalRate)

# Create the queueing center 
pdq::CreateNode("Cashier", CEN, FCFS)

# Define the average time to service each request in that queue
pdq::SetDemand("Cashier", "Customers", serviceTime)

# Optionally change thw Customers units and time units that will appear 
# in a PDQ Report
pdq::SetWUnit("Cust") # Customer units
pdq::SetTUnit("Min")  # Minutes timebase

# Solve this queueing model (CANONical method for an open queue)
# Use alternative STREAMING as of PDQ 7.0
pdq::Solve(STREAMING) # was CANON in 6.2 (NJG on Sat Nov 21, 2020)

# Generate a report with all the queueing perf metrics
pdq::Report()


