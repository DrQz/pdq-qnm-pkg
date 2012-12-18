#! /usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company                    #
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

# getload.pl

$sample_interval = 5; # seconds

# Fire up 2 cpu-intensive tasks in the background 
system("./burncpu &");
system("./burncpu &");

# Perpetually monitor the load average via the uptime
# shell command and emit it as tab-separated fields.
while (1) {
    @uptime = split (/ /, `uptime`);
    foreach $up (@uptime) {
        # collect the timestamp
        if ($up =~ m/(\d\d:\d\d:\d\d)/) {
            print "$1\t";
        }
        # collect the three load metrics
        if ($up =~ m/(\d{1,}\.\d\d)/) {
            print "$1\t";
        }
    }    
    print "\n";
    sleep ($sample_interval);
}
