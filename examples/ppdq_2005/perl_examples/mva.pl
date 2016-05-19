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

#  mva.pl

# Initialize some variables ...
@D = (); # service demand at queue k
$K = 0;  # total number of queues
$N = 0;  # total number of requests in the system
$Z = 0;  # average think time for a request

sub mva
{
   #########################################
   # This subroutine contains the MVA      #
   # algorithm for a single class workload #
   #########################################
   
   # Zero the queue lengths and response times
   @Q = (); # number of requests at queue k
   @R = (); # residence time at queue k

   ##for ($k = 1; $k <= $K; $k++) {
   ##   $Q[$k] = 0.0;
   ##}

   for ($n = 1; $n <= $N; $n++) {
      for ($k = 1; $k <= $K; $k++) {
         $R[$k] = $D[$k] * (1.0 + $Q[$k]);
      }
      
      $rtt = $Z;
      for ($k = 1; $k <= $K; $k++) {
         $rtt += $R[$k];
      }
      $X = ($n / $rtt);

      for ($k = 1; $k <= $K; $k++) {
         $Q[$k] = $X * $R[$k];
      }
   }
}

########################################
# Main program driver starts here .... #
########################################

while (1) {                
   quithow();
   printf STDOUT "Enter the number of queues (K): ";
   $input = <STDIN>;
   chop($input);
   if (length($input) == 0 or $input > 3) {
      last;
   } else {
      $K = $input;
   }

   for ($k = 1; $k <= $K; $k++) {
      printf STDOUT "Enter service time at center %d (D[%d]): ", $k, $k;
      $input = <STDIN>;
      chop($input);
      $D[$k] = $input;
   }
   
   printf STDOUT "Enter think time (Z):";
   $input = <STDIN>;
   chop($input);
   $Z = $input;

   while (1) {
      quithow();
      printf STDOUT "Enter number of users (N): ";
      $input = <STDIN>;
      chop($input);
      if (length($input) == 0) {
         last;
      } else {
         $N = $input;
         mva();	# call the subroutine
         report();
         last;
      }
   }
}

sub report
{
   print "\n";
   printf("---- Report for N = %d, Z = %6.2f ------\n", $N, $Z);
   printf("%2s\t%8s\t%8s\t%8s\n", "k", "      Rk", "     Qk", "     Uk");
   for ($k = 1; $k <= $K; $k++) {
      printf("%2d\t%8.2f\t%8.2f\t%8.2f\n", $k, $R[$k], $Q[$k], $X * $D[$k]);
   }
   print "------------------------------------------\n";
   printf("X = %6.4f, R = %8.2f\n", $X, (($N / $X) - $Z));
   print "------------------------------------------\n";
}

sub quithow
{
   printf STDOUT "(Type Cntl-C to quit.)\n";
}
