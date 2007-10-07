#!/usr/bin/perl
# 
#  dbc.pl - Teradata DBC-10/12 performance model
#  
#  PDQ calculation of optimal parallel configuration.
#  
#   $Id$
#
#---------------------------------------------------------------------

use pdq;

#---------------------------------------------------------------------

$think = 10.0;
$users = 300;

$Sifp  = 0.10;
$Samp  = 0.60;
$Sdsu  = 1.20;
$Nifp  = 15;
$Namp  = 50;
$Ndsu  = 100;

#---------------------------------------------------------------------

pdq::Init("Teradata DBC-10/12");

# Create parallel centers

for ($k = 0; $k < $Nifp; $k++) {
      $name = sprintf "IFP%d", $k;
      $noNodes = pdq::CreateNode($name, $pdq::CEN, $pdq::FCFS);
}

for ($k = 0; $k < $Namp; $k++) {
      $name = sprintf "AMP%d", $k;
      $noNodes = pdq::CreateNode($name, $pdq::CEN, $pdq::FCFS);
}

for ($k = 0; $k < $Ndsu; $k++) {
      $name = sprintf "DSU%d", $k;
      $noNodes = pdq::CreateNode($name, $pdq::CEN, $pdq::FCFS);
}

#---------------------------------------------------------------------

$noStreams = pdq::CreateClosed("query", $pdq::TERM, $users, $think);


for ($k = 0; $k < $Nifp; $k++) {
      $name = sprintf "IFP%d", $k;
      pdq::SetDemand($name, "query", $Sifp / $Nifp);
}

for ($k = 0; $k < $Namp; $k++) {
      $name = sprintf "AMP%d", $k;
      pdq::SetDemand($name, "query", $Samp / $Namp);
}

for ($k = 0; $k < $Ndsu; $k++) {
      $name = sprintf "DSU%d", $k;
      pdq::SetDemand($name, "query", $Sdsu / $Ndsu);
}

#---------------------------------------------------------------------

printf("Solving APPROX... ");
pdq::Solve($pdq::APPROX);
printf("Done.\n");

#---------------------------------------------------------------------

pdq::Report();

#---------------------------------------------------------------------

exit 0;

#---------------------------------------------------------------------

