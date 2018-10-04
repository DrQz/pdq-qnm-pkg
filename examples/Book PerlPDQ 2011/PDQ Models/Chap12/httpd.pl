#!/usr/bin/perl
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

# httpd.pl

use pdq;

$clients = 5; 
$smaster = 0.0109; #seconds
$sdemon  = 0.0044; #seconds
$work    = "homepage";
@slave   = ("slave1", "slave2", "slave3", "slave4", "slave5",
"slave6", "slave7", "slave8", "slave9", "slave10",
"slave11", "slave12", "slave13", "slave14", "slave15",
"slave16");

pdq::Init("HTTPd Prefork");

pdq::CreateClosed($work, $pdq::TERM, $clients, 0.0);
pdq::CreateNode("master", $pdq::CEN, $pdq::FCFS);
pdq::SetDemand("master", $work, $smaster);

$nslaves = @slave;
foreach $sname (@slave) {
   pdq::CreateNode($sname, $pdq::CEN, $pdq::FCFS);
   pdq::SetDemand($sname, $work, $sdemon / $nslaves);
}

pdq::Solve($pdq::EXACT);
pdq::Report();
