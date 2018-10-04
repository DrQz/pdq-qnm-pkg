#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company                    #
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
#
#  $Id$

# mm1.pl
# Updated by NJG on Sat, Apr 8, 2006 per erratum for p. 220
# Updated by NJG on Monday, February 18, 2013  Correct p.269 PPDQ 2nd edn.

use pdq;

## PDQ INPUTS ##
# Measured parameters
$MeasurePeriod = 3600; # seconds
$ArrivalCount = 1800;
$ServiceVisits = 10;

# Derived parameters
$ArrivalRate = $ArrivalCount / $MeasurePeriod;
$ServiceTime = 0.10; # seconds
$ServiceDemand = $ServiceVisits * $ServiceTime; # seconds

# Check the queue meets stability condition
$ServiceCap = 1 / $ServiceDemand;
if($ArrivalRate >= $ServiceCap) {
    print "Error: Arrival rate $ArrivalRate ";
    print "exceeds service capacity ServiceCap !!\n";
    exit;
}

$NodeName = "FIFO";
$WorkName = "Work";

# Initialize PDQ internal variables
pdq::Init("M/M/1 on p.269 PDQ Book");

# Define the queueing circuit type and workload 
pdq::CreateOpen($WorkName, $ArrivalRate);

# Define the FIFO queue 
pdq::CreateNode($NodeName, $pdq::CEN, $pdq::FCFS);
# Define service demand due to the workload at FIFO 
pdq::SetDemand($NodeName, $WorkName, $ServiceDemand);

# Change the units used by PDQ::Report()
pdq::SetWUnit("Requests");
pdq::SetTUnit("Seconds");

# Solve the PDQ model 
# NOTE: Must use CANON-ical method since this is an open circuit
pdq::Solve($pdq::CANON);

## PDQ OUTPUTS ##
# Generate a report 
pdq::Report();
