#! /bin/perl
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

# timely.pl

use Time::Local;
($sec,$min,$hrs,$mdy,$mon,$Dyr,$wdy,$ydy,$DST) = localtime(time);

print "\n======   Representations of Time ======\n";
print "The fields in struct tm: \n";
print "struct tm {\n";
print "\ttm_sec $sec\n";
print "\ttm_min $min\n";
print "\ttm_hrs $hrs\n";
print "\ttm_mdy $mdy\n";
print "\ttm_mon $mon\n";
print "\ttm_Dyr $Dyr (years since 1900)\n";
print "\ttm_wdy $wdy\n";
print "\ttm_ydy $ydy\n";
print "}\n";

print "\n";
print "Equivalent of UNIX ctime() formatting: \n";
$now = localtime;
print "$now\n";
print "\n";
print "Equivalent GMT time: \n";
$now = gmtime;
print "$now\n";
print "\n";
print "Integer representation from timelocal(): \n";
$uint = timelocal($sec,$min,$hrs,$mdy,$mon,$Dyr);
printf( "%u or %e Seconds since 1/1/1900\n", $uint, $uint);
