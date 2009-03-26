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

# thruput1.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
    2.22, 2.83);

$T_period = 30;                   # Measurement period (min)
$C_count = @busyData;             # Completion count
$X =  $C_count / $T_period;       # System throughput
printf("Completion count  (C): %6d \n", $C_count);
printf("System throughput (X): %6.2f Cust/min\n", $X);
printf("Normalized throughput: %6d Cust every %4.2f min\n", 1, 1/$X);

# Output ...
# Completion count  (C):     10
# System throughput (X):   0.33 Cust/min
# Normalized throughput:      1 Cust every 3.00 min
