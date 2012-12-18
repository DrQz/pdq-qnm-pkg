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

# timrez.pl

use Time::HiRes; 

  $t_start = [Time::HiRes::gettimeofday];
  
  # Do some work ...
  system("ls");

  $t_end = [Time::HiRes::gettimeofday];
  $elaps = Time::HiRes::tv_interval ($t_start, $t_end);
  $msecs = int($elapsed*1000);

print "\nElapsed time is $elaps seconds\n";
