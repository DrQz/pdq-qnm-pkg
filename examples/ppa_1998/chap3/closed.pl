#!/usr/bin/perl
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

