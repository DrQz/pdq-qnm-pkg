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

# timetz.pl

use Time::Local; 
use POSIX qw(tzset);

my @dayofweek = (qw(Sunday Monday Tuesday Wednesday Thursday Friday 
    Saturday)); 
my @monthnames = (qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)); 
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday); 

%zone = (Melbourne => 0, Paris => 1, SanFrancisco => 2);
$zonelocal = $zone{Melbourne};
$zoneremote = $zone{SanFrancisco};

# Get the local time first ...
$now = localtime();

# Set the remote time zone ...
if ($zoneremote == $zone{Melbourne}) {
        $ENV{TZ} = ':/usr/share/zoneinfo/Australia/Melbourne'; 
        $rplace = "Melbourne";
}
if ($zoneremote == $zone{Paris}) {
        $ENV{TZ} = ':/usr/share/zoneinfo/Europe/Paris'; 
        $rplace = "Paris";
}
if ($zoneremote == $zone{SanFrancisco}) {
        $ENV{TZ} = ':/usr/share/zoneinfo/US/Pacific'; 
        $rplace = "San Francisco";
}
tzset();

# Get the remote time 
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday) = localtime(); 
$year += 1900; 

if ($zonelocal == $zone{Melbourne}) {
        $lplace = "Melbourne";
}
if ($zonelocal == $zone{Paris}) {
        $lplace = "Paris";
}
if ($zonelocal == $zone{SanFrancisco}) {
        $lplace = "San Francisco";
}

print "Local   position: $lplace\n";
print "Local   time is $now\n";
print "Remote  position: $rplace\n";
print "Remote  time is $hour:$min:$sec\n"; 
print "Remote  date is $dayofweek[$wday], $monthnames[$mon] $mday, 
    $year\n"; 
