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

# bench1.pl

use Time::Local;
use Benchmark;
$t_start = new Benchmark;

# The routine that is measured
print "Benchmark started.\n";
open(OUT, ">dev/null");
for ($i = 0; $i < int(1e+7); $i++) {
    print OUT ".";
}

$t_end = new Benchmark;
$td = timediff($t_end, $t_start);
print "\nWorkload time:",timestr($td),"\n";
