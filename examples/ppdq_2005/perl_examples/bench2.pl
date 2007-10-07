#! /usr/bin/perl
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
