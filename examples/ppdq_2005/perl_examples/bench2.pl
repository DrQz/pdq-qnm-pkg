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

# bench2.pl

use Time::Local;
use Benchmark qw(cmpthese); # explicit import required

# The routine that is measured
print "Benchmark started.\n";
cmpthese( -4, { 
    alpha_task => "++\$i", 
    beta_task => "\$i *= 2",
    gamma_task => "\$i <<= 2",
    delta_task => "\$i **= 2",
    } 
);

# Benchmark the benchmark code ...
print "===============\n";
print "CPU time for Benchmark module to execute:\n";
my ($user, $system, $cuser, $csystem) = times();
printf("%4.2f (usr) %4.2f (sys)\n", $user, $system);
printf("%4.2f (usr) %4.2f (sys)\n", $cuser, $csystem);
print "===============\n";
