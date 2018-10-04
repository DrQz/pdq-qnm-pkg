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

# servtime.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
    2.22, 2.83);

# Compute the aggregate busy time
foreach $busy (@busyData) {
    $B_server += $busy;
}

$C_server = @busyData;              # Completions
$S_time = $B_server / $C_server;    # Service time (min)
printf("Number of completions (C): %6d \n", $C_server);
printf("Aggregate busy time   (B): %6.2f min\n", $B_server);
printf("Mean Service time     (S): %6.2f min\n", $S_time);

# Output ...
# Number of completions (C):     10
# Aggregate busy time   (B):  22.93 min
# Mean Service time     (S):   2.29 min
