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

# Updated by NJG on Sun Dec 10 10:36:01 2017

library(pdq)

# M/M/m queue in PDQ. See PPDQ book
# http://www.perfdynamics.com/books.html
# Section 4.7 Multiserver Queue

arrivalRate <- 2.0
serviceTime <- 1.0

# Initialize PDQ
pdq::Init("M/M/m model")

# Create the workflow type (open or closed)
pdq::CreateOpen("work", arrivalRate)

# Create the multi-server queueing center with 3 servers
pdq::CreateMultiNode(3, "server", MSO, FCFS)

# Define the average time at each server
pdq::SetDemand("server", "work", serviceTime)

# Optionally change thw Customers units and time units that will appear 
# in a PDQ Report
pdq::SetWUnit("Cust")
pdq::SetTUnit("Min")

# Solve this queueing model (CANONical method for an open queue)
pdq::Solve(CANON)

# Generate a report
pdq::Report()

