#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company                    #
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

# feedforward.pl
use pdq;

$ArrivalRate = 0.10;
$WorkName = "Requests";
$NodeName1 = "Queue1";
$NodeName2 = "Queue2";
$NodeName3 = "Queue3";

pdq::Init("Feedforward Circuit");
$pdq::streams = pdq::CreateOpen($WorkName, $ArrivalRate);
$pdq::nodes = pdq::CreateNode($NodeName1, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($NodeName2, $pdq::CEN, $pdq::FCFS);
$pdq::nodes = pdq::CreateNode($NodeName3, $pdq::CEN, $pdq::FCFS);
pdq::SetDemand($NodeName1, $WorkName, 1.0);
pdq::SetDemand($NodeName2, $WorkName, 2.0);
pdq::SetDemand($NodeName3, $WorkName, 3.0);
pdq::Solve($pdq::CANON);
pdq::Report();
