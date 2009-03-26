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
#  fesc.pl -- Flow Equivalent Service Center model
#
#  Composite system is a closed circuit comprising N USERS
#  and a FESC submodel with a single-class workload.
#
#  This model is discussed on p.112 ff. of the book that accompanies
#  PDQ entitled: "The Practical Performance Analyst," by N.J.Gunther
#  and matches the results presented in the book: "Quantitative System
#  Performance," by Lazowska, Zahorjan, Graham, and Sevcik, Prentice-Hall
#  1984.
#
#  $Id$
#
#-------------------------------------------------------------------------------

use pdq;

#----- Global variables ----------------------------------------------

$USERS = 15;
$sm_x  = [];   # [USERS + 1] -  submodel throughput characteristic

#*********************************************************************
#  Model specific variables
#*********************************************************************
#    int             j;
#    int             n;
#    int             max_pgm = 3;
#    float           think = 60.0;
#    float           xn;
#    float           qlength;
#    float           R;
#    float           pq[USERS + 1][USERS + 1];
#    void            mem_model();
#
#
#*********************************************************************
#  Memory-limited Submodel
#*********************************************************************

$max_pgm = 3;
$think   = 60.0;
$pq      = [];
$sm_x    = [];

#---------------------------------------------------------------------

sub mem_model
{
   my ($n, $m) = @_;

   $x = 0.0;

   for ($i = 1; $i <= $n; $i++) {
      if ($i <= $m) {
         pdq::Init("");

         $noNodes = pdq::CreateNode("CPU", $pdq::CEN, $pdq::FCFS);
         $noNodes = pdq::CreateNode("DK1", $pdq::CEN, $pdq::FCFS);
         $noNodes = pdq::CreateNode("DK2", $pdq::CEN, $pdq::FCFS);

         $noStreams = pdq::CreateClosed("work", $pdq::TERM, $i, 0.0);

         pdq::SetDemand("CPU", "work", 3.0);
         pdq::SetDemand("DK1", "work", 4.0);
         pdq::SetDemand("DK2", "work", 2.0);

         pdq::Solve($pdq::EXACT);

         $x = pdq::GetThruput($pdq::TERM, "work");

         $sm_x[$i] = $x;
      } else {
         $sm_x[$i] = $x; # last computed value
      }
   }
}  # mem_model #

#*********************************************************************
#  Composite Model
#*********************************************************************

mem_model($USERS, $max_pgm);

$pq[0][0] = 1.0;

for ($n = 1; $n <= $USERS; $n++) {
   $R = 0.0;  # reset

   # Response time at the FESC

   for ($j = 1; $j <= $n; $j++) {
      #printf "sm_x[%d] = %f  n = =%d\n",  $j, $sm_x[$j], $n;
      $R += ($j / ($sm_x[$j]) * $pq[$j - 1][$n - 1]);
   }
   
   # Thruput and queue-length at the FESC

   $xn = $n / ($think + $R);
   $qlength = $xn * $R;
   
   # Compute queue-length distribution at the FESC


   for ($j = 1; $j <= $n; $j++) {
      #printf "j = %d  n = %d\n", $j, $n;
      #printf "> %f\n", $pq[$j][$n];
      $pq[$j][$n] = ($xn / $sm_x[$j]) * $pq[$j - 1][$n - 1];
      #printf "pq[%d][%d] %f\n", $j, $n, $pq[$j][$n];
   }
   
   $pq[0][$n] = 1.0;
   
   for ($j = 1; $j <= $n; $j++) {
      $pq[0][$n] -= $pq[$j][$n];
      #printf "pq[%d][%d] %f\n", $j, $n, $pq[$j][$n];
   }
}


#*********************************************************************
#  Report FESC Measures
#*********************************************************************

printf("\n");
printf("Max Users: %2d\n", $USERS);
printf("X at FESC: %3.4f\n", $xn);
printf("R at FESC: %3.2f\n", $R);
printf("Q at FESC: %3.2f\n\n", $qlength);

# Joint Probability Distribution
printf("QLength\t\tP(j | n)\n");
printf("-------\t\t--------\n");

for ($n = 0; $n <= $USERS; $n++) {
   printf(" %2d\t\tp(%2d|%2d): %3.4f\n", $n, $n, $USERS, $pq[$n][$USERS]);
}

