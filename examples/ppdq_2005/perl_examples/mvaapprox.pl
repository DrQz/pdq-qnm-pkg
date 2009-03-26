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

#
#  mvaapprox.pl
#
# Updated by NJG on Tue, Feb 14, 2006
# Completely revised Perl code for Schweitzer algorithm

use constant TESTING => 1; # Boolean

########################################
# Mainline code takes keyboard input...#
########################################

printf STDOUT   "Enter no. queues (K): ";
$input = <STDIN>;
chop($input);
if (length($input) == 0 or $input > 3) {
    last;
} else {
    $K = $input;
}

for ($k = 1; $k <= $K; $k++) {
    printf STDOUT "Enter  demand  D[%d]: ", $k;
    $input = <STDIN>;
    chop($input);
    $D[$k] = $input;
}

printf STDOUT   "Enter think time (Z): ";
$input = <STDIN>;
chop($input);
$Z = $input;

printf STDOUT   "Enter no.  users (N): ";
$input = <STDIN>;
chop($input);
if (length($input) == 0) {
    last;
} else {
    $N = $input;
    approx();
    report();
    example() if (TESTING);
}

########################################
#              Subroutines             #
########################################

sub approx
{
   # Schweitzer algorithm
   for ($k = 1; $k <= $K; $k++) {
      $Q[$k] = $N / $K; # equi-partition queues initially
   }

   do {
      for ($k = 1; $k <= $K; $k++) {
         $Qprev[$k] = $Q[$k];
         $R[$k] = $D[$k] * (1.0 + $Q[$k] * ($N - 1) / $N);
      }
      
      $rtt = $Z;
      for ($k = 1; $k <= $K; $k++) {
         $rtt += $R[$k];
      }
      $X = $N / $rtt;

      for ($k = 1; $k <= $K; $k++) {
         $Q[$k] = $X * $R[$k];
      }
   }  while (converging())
}

sub converging {
    my $k, $threshold = 0.001; # stopping criterion
   
    # Equivalent of Max_i[|(Qnew_i - Qold_i)/Qnew_i|] pseudo-code 
    # seen in various textbooks
    for ($k = 1; $k <= $K; $k++) {
        $delta = abs($Q[$k] - $Qprev[$k]) / $Q[$k];
        return(1) if($delta > $threshold);
    }
    
    return(0); # must've converged below threshold
}

sub report
{
    printf("Report for N = %d, Z = %6.2f \n", $N, $Z);
    printf("%2s\t%8s\t%8s\t%8s\n", "k", "   R_k", "     Q_k", "     U_k");
    for ($k = 1; $k <= $K; $k++) {
      printf("%2d\t%8.4f\t%8.4f\t%8.4f\n", $k, $R[$k], $Q[$k], $X * $D[$k]);
    }
    print "------------------------------------------\n";
    printf("X = %8.4f, R = %8.4f\n", $X, ($N / $X) - $Z);
    
    print "------------------------------------------\n";
}

sub example
{
    # From Lazowska et al., "QSP" Table on p. 119
    my $N = 3.0; 
    my $Z = 15.0; 
    my $X = 0.1510;
    my @D = (0, 0.605, 2.1, 1.35);
    my @Q = (0, 0.0973, 0.4021, 0.2359);
    
    printf("Expected for N = %d, Z = %6.2f\n", $N, $Z);
    printf("%2s\t%8s\t%8s\t%8s\n", "k", "   R_k", "     Q_k", "     U_k");
    for ($k = 1; $k <= $K; $k++) {
      printf("%2d\t%8.4f\t%8.4f\t%8.4f\n", $k, $R[$k], $Q[$k], $X * $D[$k]);
    }
    print "------------------------------------------\n";
    printf("X = %8.4f, R = %8.4f\n", $X, ($N / $X) - $Z);
    
    print "------------------------------------------\n";
}
