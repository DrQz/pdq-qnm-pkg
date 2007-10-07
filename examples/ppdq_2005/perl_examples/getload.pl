#! /usr/bin/perl
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
