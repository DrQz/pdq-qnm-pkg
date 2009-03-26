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

#  multibus.pl
use pdq;

# System parameters
$BUSES  =     9;
$CPUS   =    64;
$STIME  =   1.0;
$COMPT  =  10.0;
printf("multibus.out\n");

# Compute the submodel first
multiserver($BUSES, $STIME);
# Now, compute the composite model
$pq[0][0] = 1.0;

for ($n = 1; $n <= $CPUS; $n++) {
   $R = 0.0;         # reset
   for ($j = 1; $j <= $n; $j++) {
      $h  = ($j / $sm_x[$j]) * $pq[$j - 1][$n - 1];
      $R += $h;
   }
   $xn = $n / ($COMPT + $R);
   $qlength = $xn * $R;

   for ($j = 1; $j <= $n; $j++) {
      $pq[$j][$n] = ($xn / $sm_x[$j]) * $pq[$j - 1][$n - 1];
   }
   $pq[0][$n] = 1.0;

   for ($j = 1; $j <= $n; $j++) {
      $pq[0][$n] -= $pq[$j][$n];
   }
}

# Processing Power
printf("Buses:%2d, CPUs:%2d\n", $BUSES, $CPUS);
printf("Load %3.4f\n", ($STIME / $COMPT));
printf("X at FESC: %3.4f\n", $xn);
printf("P %3.4f\n", $xn * $COMPT);

sub multiserver {
   my  ($m, $stime) = @_;
   $work = "reqs";
   $node = "bus";
   $x = 0.0;

   for ($i = 1; $i <= $CPUS; $i++) {
      if ($i <= $m) {
         pdq::Init("multibus");
         $streams = pdq::CreateClosed($work, $pdq::TERM, $i, 0.0);
         $nodes   = pdq::CreateNode($node, $pdq::CEN, $pdq::ISRV);
         pdq::SetDemand($node, $work, $stime);
         pdq::Solve($pdq::EXACT);
         $x = pdq::GetThruput($pdq::TERM, $work);
         $sm_x[$i] = $x;
      } else {
         $sm_x[$i] = $x;
      }
   }
}  # end of multiserver

