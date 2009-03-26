#!/usr/bin/perl
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

# fesc.pl
#
# Created by NJG on Fri, Dec 26, 2003
# Updated by NJG on Sat, Apr  8, 2006

use pdq;

# Model globals
$USERS    = 15;
$max_pgm  = 3;
$think    = 60.0;
$pq[0][0] = 1.0; # joint probability dsn.
@sm_x     = (1); # thruput of memory submodel


#-----------    Call the submodel first  -----------
mem_model($USERS, $max_pgm); 



#-----------   Composite (FESC) Model  -----------
for ($n = 1; $n <= $USERS; $n++) {
   $R = 0.0;  # reset
   # Response time at the FESC
   for ($j = 1; $j <= $n; $j++) {
      $R += ($j / ($sm_x[$j]) * 
        $pq[$j - 1][$n - 1]);
   }
   # Thruput and queue-length at the FESC
   $xn = $n / ($think + $R);
   $qlength = $xn * $R;
   
   # Compute queue-length distribution at the FESC
   for ($j = 1; $j <= $n; $j++) {
      $pq[$j][$n] = ($xn / $sm_x[$j]) * 
        $pq[$j - 1][$n - 1];
   }
   $pq[0][$n] = 1.0;
   
   for ($j = 1; $j <= $n; $j++) {
      $pq[0][$n] -= $pq[$j][$n];
   }
}

# Report selected FESC metrics
printf("\n");
printf("Max Tasks: %10d\n", $USERS);
printf("X at FESC: %10.4f\n", $xn);
printf("R at FESC: %10.4f\n", $R);
printf("Q at FESC: %10.4f\n\n", $qlength);

# Joint Probability Distribution
printf("QLength\t\t    Pr(j | n)\n");
printf("-------\t\t    --------\n");

for ($n = 0; $n <= $USERS; $n++) {
   printf(" %2d\t\tp(%2d|%2d): %3.4f\n", 
    $n, $n, $USERS, $pq[$n][$USERS]);
}

printf("\n\n");



#-----------  Memory-limited Submodel  -----------
sub mem_model
{
   my ($n, $m) = @_;
   my $x = 0.0;

   for ($i = 1; $i <= $n; $i++) {
      if ($i <= $m) {
         pdq::Init("");

         $pdq::nodes   = pdq::CreateNode("CPU", $pdq::CEN, $pdq::FCFS);
         $pdq::nodes   = pdq::CreateNode("DK1", $pdq::CEN, $pdq::FCFS);
         $pdq::nodes   = pdq::CreateNode("DK2", $pdq::CEN, $pdq::FCFS);
         $pdq::streams = pdq::CreateClosed("work", $pdq::BATCH, $i, $i);

         pdq::SetDemand("CPU", "work", 3.0);
         pdq::SetDemand("DK1", "work", 4.0);
         pdq::SetDemand("DK2", "work", 2.0);

         pdq::Solve($pdq::EXACT);

         $x = pdq::GetThruput($pdq::TERM, "work");

         push(@sm_x, $x); # use current value
      } else {
         push(@sm_x, $x); # use previous value
      }
   }
} 
