#! /usr/bin/perl
# timrez.pl

use Time::HiRes; 

  $t_start = [Time::HiRes::gettimeofday];
  
  # Do some work ...
  system("ls");

  $t_end = [Time::HiRes::gettimeofday];
  $elaps = Time::HiRes::tv_interval ($t_start, $t_end);
  $msecs = int($elapsed*1000);

print "\nElapsed time is $elaps seconds\n";
