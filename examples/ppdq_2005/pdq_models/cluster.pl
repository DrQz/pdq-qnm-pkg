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

#cluster.pl
use pdq;
$think = 10.0;
$users = 800;
$Sfep  = 0.10;
$Sbep  = 0.60;
$Sdsu  = 1.20;
$Nfep  = 15;
$Nbep  = 50;
$Ndsu  = 100;

pdq::Init("Query Cluster");

# Create parallel centers
for ($k = 0; $k < $Nfep; $k++) {
      $name = sprintf "FEP%d", $k;
      $nodes = pdq::CreateNode($name, $pdq::CEN, $pdq::FCFS);
}
for ($k = 0; $k < $Nbep; $k++) {
      $name = sprintf "BEP%d", $k;
      $nodes = pdq::CreateNode($name, $pdq::CEN, $pdq::FCFS);
}
for ($k = 0; $k < $Ndsu; $k++) {
      $name = sprintf "DSU%d", $k;
      $nodes = pdq::CreateNode($name, $pdq::CEN, $pdq::FCFS);
}

# Create the workload
$streams = pdq::CreateClosed("query", $pdq::TERM, $users, $think);

# Set service demands using visits to parallel nodes
for ($k = 0; $k < $Nfep; $k++) {
      $name = sprintf "FEP%d", $k;
      pdq::SetVisits($name, "query", 1 / $Nfep, $Sfep);
}
for ($k = 0; $k < $Nbep; $k++) {
      $name = sprintf "BEP%d", $k;
      pdq::SetVisits($name, "query", 1 / $Nbep, $Sbep);
}
for ($k = 0; $k < $Ndsu; $k++) {
      $name = sprintf "DSU%d", $k;
      pdq::SetVisits($name, "query", 1 / $Ndsu, $Sdsu);
}

pdq::Solve($pdq::APPROX);
pdq::Report();
