#! /usr/bin/perl
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

#  abcache.pl

use pdq;
# Main memory update policy
# The main-memory update policy is selected to be write-through here.
$WBACK   =  1;
# Globals
$MAXCPU  =   15;
$ZX      =  2.5;

# Cache parameters
$RD      =  0.85;
$WR      =  (1 - $RD);
$HT      =  0.95;
$WUMD    =  0.0526;
$MD      =  0.35;

# Bus and L2 cache ids
$L2C     = "L2C";
$BUS     = "MBus";

# Aggregate cache traffic
$RWHT    = "RWhit";
$gen     =  1.0;

# Bus Ops
$RDOP    = "Read";
$WROP    = "Write";
$INVL    = "Inval";

# per CPU intruction stream intensity
# The following variables are used to assign the per CPU intruction stream
# intensity for write-through.

$Prhit = ($RD * $HT);
$Pwhit = ($WR * $HT * (1 - $WUMD)) + ($WR * (1 - $HT) * (1 - $MD));
$Prdop = $RD * (1 - $HT);
$Pwbop = $WR * (1 - $HT) * $MD;
$Pwthr = $WR;
$Pinvl = $WR * $HT * $WUMD;

$Nrwht = 0.8075 * $MAXCPU;
$Nrdop = 0.0850 * $MAXCPU;
$Nwthr = 0.15 * $MAXCPU;

$Nwbop = 0.0003 * $MAXCPU * 100;
$Ninvl = 0.015 * $MAXCPU;

$Srdop = (20.0);
$Swthr = (25.0);
$Swbop = (20.0);

$Wrwht = 0.0;
$Wrdop = 0.0;
$Wwthr = 0.0;
$Wwbop = 0.0;
$Winvl = 0.0;

$Zrwht = $ZX;
$Zrdop = $ZX;
$Zwbop = $ZX;
$Zinvl = $ZX;
$Zwthr = $ZX;

$Xcpu  = 0.0;
$Pcpu  = 0.0;
$Ubrd  = 0.0;
$Ubwr  = 0.0;
$Ubin  = 0.0;
$Ucht  = 0.0;
$Ucrd  = 0.0;
$Ucwr  = 0.0;
$Ucin  = 0.0;


pdq::Init("ABC Model");

## Create single bus queueing center 
$nodes = pdq::CreateNode($BUS, $pdq::CEN, $pdq::FCFS);

## Create per CPU cache queueing centers 
for ($i = 0; $i < $MAXCPU; $i++) {
   $cname = sprintf "%s%d", $L2C, $i;
   $nodes = pdq::CreateNode($cname, $pdq::CEN, $pdq::FCFS);
   #printf "i %2d  cname %10s  nodes %d\n", $i, $cname, $nodes;
}

## Create CPU nodes, workloads, and demands
# In this PDQ model the proportion of each workload (read-write hits,
# reads, writes, invalidates) is partitioned amongst the total number of
# processors by a call to intwt().  In the event that the number of CPUs
# belonging to a workload is less than one, the number of CPUs is taken to
# be one with a weight factor assigned to its throughput and utilization.

printf "       Nrwht %s, Zrwht %s\n", $Nrwht, $Zrwht;
$no = intwt($Nrwht, \$Wrwht);
printf "no %d %f  Nrwht %d, Zrwht %d\n", $no, $no, $Nrwht, $Zrwht;
for ($i = 0; $i < $no; $i++) {
   $wname   = sprintf "%s%d", $RWHT, $i;
   #printf "wname %s  Nrwht %d, Zrwht %d\n", $wname, $Nrwht, $Zrwht;
   $streams = pdq::CreateClosed($wname, $pdq::TERM, $Nrwht, $Zrwht);
   $cname   = sprintf "%s%d", $L2C, $i;
   #printf "cname %s\n", $cname;
   pdq::SetDemand($cname, $wname, 1.0);
   pdq::SetDemand($BUS, $wname, 0.0);       # no bus activity
   printf "i %2d  cname %10s  nodes %2d  streams %d\n", $i, $cname, 
      $nodes, $streams;
}

$no = intwt($Nrdop, \$Wrdop);
printf "no %d  Nrdop %d, Zrdop %d\n", $no, $Nrdop, $Zrdop;
for ($i = 0; $i < $no; $i++) {
   $wname   = sprintf "%s%d", $RDOP, $i;
   $streams = pdq::CreateClosed($wname, $pdq::TERM, $Nrdop, $Zrdop);
   $cname   = sprintf "%s%d", $L2C, $i;
   pdq::SetDemand($cname, $wname, $gen);    # generate bus request
   pdq::SetDemand($BUS, $wname, $Srdop);    # req + async data return
   printf "i %2d  cname %10s  nodes %2d  streams %d\n", $i, $cname, 
      $nodes, $streams;
}

if (WBACK) {
   $no = intwt($Nwbop, \$Wwbop);
   printf "no %d  Nwbop %d, Zwbop %d\n", $no, $Nwbop, $Zwbop;
   
   for ($i = 0; $i < $no; $i++) {
      $wname   = sprintf "%s%d", $WROP, $i;
      $streams = pdq::CreateClosed($wname, $pdq::TERM, $Nwbop, $Zwbop);
      $cname   = sprintf "%s%d", $L2C, $i;
      pdq::SetDemand($cname, $wname, $gen);
      pdq::SetDemand($BUS, $wname, $Swbop);      # asych write to memory ?
      printf "w %2d  cname %10s  nodes %2d  streams %d\n", $i, $cname, 
         $nodes, $streams;
   }
} else {  # write-thru
   $no = intwt($Nwthr, \$Wwthr);
   printf "no %d  Nwthr %d, Zwthr %d\n", $no, $Nwthr, $Zwthr;
  
   for ($i = 0; $i < $no; $i++) {
      $wname   = sprintf "%s%d", $WROP, $i;
      $streams = pdq::CreateClosed($wname, $pdq::TERM, $Nwthr, $Zwthr);
      $cname   = sprintf "%s%d", $L2C, $i;
      pdq::SetDemand($cname, $wname, $gen);
      pdq::SetDemand($BUS, $wname, $Swthr);
      printf "i %2d  cname %10s  nodes %2d  streams %d\n", $i, $cname, 
         $nodes, $streams;
   }
}

if (WBACK) {
   $no = intwt($Ninvl, \$Winvl);
   printf "no %d  Ninvl %d, Zinvl %d\n", $no, $Ninvl, $Zinvl;

   for ($i = 0; $i < $no; $i++) {
      $wname   = sprintf "%s%d", $INVL, $i;
      $streams = pdq::CreateClosed($wname, $pdq::TERM, $Ninvl, $Zinvl);
      $cname   = sprintf "%s%d", $L2C, $i;
      pdq::SetDemand($cname, $wname, $gen);   # gen + intervene
      pdq::SetDemand($BUS, $wname, 1.0);
      printf "w %2d  cname %10s  nodes %2d  streams %d\n", $i, $cname, 
         $nodes, $streams;
   }
}
pdq::Solve($pdq::APPROX);

## Calculate bus utilizations 
$no = intwt($Nrdop, \$Wrdop);
for ($i = 0; $i < $no; $i++) {
   $wname   = sprintf "%s%d", $RDOP, $i;
   $Ubrd += pdq::GetUtilization($BUS, $wname, $pdq::TERM);
}
$Ubrd *= $Wrdop;

if (WBACK) {
   $no = intwt($Nwbop, \$Wwbop);
   for ($i = 0; $i < $no; $i++) {
      $wname   = sprintf "%s%d", $WROP, $i;
      $Ubwr += pdq::GetUtilization($BUS, $wname, $pdq::TERM);
   }
   $Ubwr *= $Wwbop;
   $no = intwt($Ninvl, \$Winvl);

   for ($i = 0; $i < $no; $i++) {
      $wname   = sprintf "%s%d", $INVL, $i;
      $Ubin += pdq::GetUtilization($BUS, $wname, $pdq::TERM);
   }
   $Ubin *= $Winvl;
} else {  # write-thru
   $no = intwt($Nwthr, \$Wwthr);
   for ($i = 0; $i < $no; $i++) {
      $wname   = sprintf "%s%d", $WROP, $i;
      $Ubwr += pdq::GetUtilization($BUS, $wname, $pdq::TERM);
   }
   $Ubwr *= $Wwthr;
}

##  Cache measures at CPU[0] only
$i     = 0;
$cname = sprintf "%s%d", $L2C, $i;

$wname = sprintf "%s%d", $RWHT, $i;
$Xcpu  = pdq::GetThruput($pdq::TERM, $wname) * $Wrwht;
$Pcpu += $Xcpu * $Zrwht;
$Ucht  = pdq::GetUtilization($cname, $wname, $pdq::TERM) * $Wrwht;

$wname = sprintf "%s%d", $RDOP, $i;
$Xcpu  = pdq::GetThruput($pdq::TERM, $wname) * Wrdop;
$Pcpu += $Xcpu * $Zrdop;
$Ucrd  = pdq::GetUtilization($cname, $wname, $pdq::TERM) * $Wrdop;

$Pcpu *= 1.88;
if ($WBACK) {
   $wname = sprintf "%s%d", $WROP, $i;
   $Ucwr = pdq::GetUtilization($cname, $wname, $pdq::TERM) * $Wwbop;
   $wname = sprintf "%s%d", $INVL, $i;
   $Ucin = pdq::GetUtilization($cname, $wname, $pdq::TERM) * $Winvl;
} else {         # write-thru
   $wname = sprintf "%s%d", $WROP, $i;
   $Ucwr = pdq::GetUtilization($cname, $wname, $pdq::TERM) * $Wwthr;
}
printf "\n**** %s Results ****\n", $model;
printf "PDQ nodes: %d  PDQ streams: %d\n", $nodes, $streams;
printf "Memory Mode: %s\n", $WBACK ? "WriteBack" : "WriteThru";
printf "Ncpu:  %2d\n", $MAXCPU;

$no = intwt($Nrwht, \$Wrwht);
printf "Nrwht: %5.2f (N:%2d  W:%5.2f)\n", $Nrwht, $no, $Wrwht;
$no = intwt($Nrdop, \$Wrdop);
printf "Nrdop: %5.2f (N:%2d  W:%5.2f)\n", $Nrdop, $no, $Wrdop;

if (WBACK) {
   $no = intwt($Nwbop, \$Wwbop);
   printf "Nwbop: %5.2f (N:%2d  W:%5.2f)\n", $Nwbop, $no, $Wwbop;
   $no = intwt($Ninvl, \$Winvl);
   printf "Ninvl: %5.2f (N:%2d  W:%5.2f)\n", $Ninvl, $no, $Winvl;
} else {
   $no = intwt($Nwthr, \$Wwthr);
   printf "Nwthr: %5.2f (N:%2d  W:%5.2f)\n", $Nwthr, $no, $Wwthr;
}

printf "\n";
printf "Hit Ratio:   %5.2f %%\n",  $HT * 100.0;
printf "Read Miss:   %5.2f %%\n",  $RD * (1 - $HT) * 100.0;
printf "WriteMiss:   %5.2f %%\n",  $WR * (1 - $HT) * 100.0;
printf "Ucpu:        %5.2f %%\n",  ($Pcpu * 100.0) / $MAXCPU;
printf "Pcpu:        %5.2f\n",     $Pcpu;
printf "\n";
printf "Ubus[reads]: %5.2f %%\n",  $Ubrd * 100.0;
printf "Ubus[write]: %5.2f %%\n",  $Ubwr * 100.0;
printf "Ubus[inval]: %5.2f %%\n",  $Ubin * 100.0;
printf "Ubus[total]: %5.2f %%\n",  ($Ubrd + $Ubwr + $Ubin) * 100.0;
printf "\n";
printf "Uca%d[hits]:  %5.2f %%\n", $i, $Ucht * 100.0;
printf "Uca%d[reads]: %5.2f %%\n", $i, $Ucrd * 100.0;
printf "Uca%d[write]: %5.2f %%\n", $i, $Ucwr * 100.0;
printf "Uca%d[inval]: %5.2f %%\n", $i, $Ucin * 100.0;
printf "Uca%d[total]: %5.2f %%\n", $i, ($Ucht + $Ucrd + $Ucwr + $Ucin) 
   * 100.0;

sub itoa {
   my ($n, $s) = @_;
   if (($sign = $n) < 0) {
      $n = -$n;
   }
   $i = 0;

   do {  # generate digits in reverse order
      $s[$i++] = '0' + ($n % 10);
   } while (($n /= 10) > 0);
   if ($sign < 0) {
      $s[$i++] = '-';
   }
   $s[$i] = '\0';
   # reverse order of bytes
   for ($i = 0, $j = strlen($s) - 1; $i < $j; $i++, $j--) {
      $c = $s[$i];
      $s[$i] = $s[$j];
      $s[$j] = $c;
   }
}  

sub intwt {
   my ($N, $W) = @_;
   my($i);

   if ($N < 1.0) {
      $i = 1;
      $$W = $N;
   }
   if ($N >= 1.0) {
      $i = $N;
      $$W = 1.0;
   }
   return int($i);
}  
