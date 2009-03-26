#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
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
#  Based on closed.c
#  
#  Illustrate use of PDQ solver for a closed circuit queue.
#  
#  $Id$
#
#-------------------------------------------------------------------------------

use pdq;


#---- Model specific variables -------------------------------------------------

$population   = 3.0;
$thinktime    = 0.1;


#---- Initialize the model -----------------------------------------------------
# Give model a name and initialize internal PDQ variables

pdq::Init("Closed Queue");

#printf "**** %s ****:\n", $solve_as == $pdq::EXACT ? "EXACT" : "APPROX";


#--- Define the workload and circuit type ---------------------------------------

$noStreams = pdq::CreateClosed("w1", $pdq::TERM, 1.0 * $population, $thinktime);


#--- Define the queueing center -------------------------------------------------

$noNodes   = pdq::CreateNode("node", $pdq::CEN, $pdq::FCFS);


#---- Define service demand -----------------------------------------------------

pdq::SetDemand("node", "w1", 0.10);

pdq::Solve($pdq::APPROX);

pdq::Report();

