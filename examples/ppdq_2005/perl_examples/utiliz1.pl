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

# utiliz1.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
    2.22, 2.83);

# Compute the aggregate busy time
foreach $busy (@busyData) {
    $B_server += $busy;
}

$T_period = 30;                  # Measurement period (min)
$rho = $B_server / $T_period;    # Utilization
printf("Busy time   (B): %6.2f min\n", $B_server);
printf("Utilization (U): %6.2f or %4.2f%%\n", $rho, 100 * $rho);

# Output ...
# Busy time   (B):  22.93 min
# Utilization (U):   0.76 or 76.43%
