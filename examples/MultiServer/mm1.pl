#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2006, Performance Dynamics Company                    #
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

# mm1.pl
# Updated by NJG on Sat, Apr 8, 2006  (per PPDQ erratum for p. 220)

use pdq;

$ArrivalRate 	= 0.75;
$ServiceDemand 	= 1.00;

$NodeName = "FIFO";
$WorkName = "Work";

# Initialize PDQ internal variables
pdq::Init("FIFO Example");
  


# Define the queueing circuit type and workload 
$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);

# Change the units used by PDQ::Report()
pdq::SetWUnit("Requests");
pdq::SetTUnit("Seconds");

# Define the FIFO queue 
$pdq::nodes = pdq::CreateNode($NodeName, $pdq::CEN, $pdq::FCFS);

# Define service demand due to the workload  
pdq::SetDemand($NodeName, $WorkName, $ServiceDemand);

# Solve the PDQ model 
pdq::Solve($pdq::CANON);

# Generate a report 
pdq::Report(); 
