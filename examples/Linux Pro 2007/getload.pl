\begin{verbatim}
#! /usr/bin/perl -w
$sample_interval = 5; # seconds

# Fire up background cpu-intensive tasks ... 
system("./burncpu &");
system("./burncpu &");

# Perpetually monitor the load average via uptime
# and emit it as tab-separated fields for possible
# use in a spreadsheet program.
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
\end{verbatim}