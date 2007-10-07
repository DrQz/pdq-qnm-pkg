#! /usr/bin/perl
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
