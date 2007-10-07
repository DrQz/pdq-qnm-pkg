#!/usr/bin/perl
#
#  VMWare scalability model for Ch. 7 in GCaP book.
# 
#  Created by Neil Gunther on Sat, May 20, 2006
#
# $Id$

use pdq;

$VMguests   = 2;
$nCPUs      = 4;       # Number of physical processors
$VMperCPU   = 1;       # Number of VMMs per physical CPU
$VMthink    = 1e-6;    # Assume CPU-bound
$VMservice  = 1/16.5;  # from benchmark data
@VMMX       = (1);     # A list of thruputs

# Call the submodel first ...
VM_Monitor($VMguests, $nCPUs, $VMservice);



#-----------------------------------------------------------
#  Top-level performance model
#-----------------------------------------------------------
my $j;

$pq[0][0] = 1.0;

for ($n = 1; $n <= $VMguests; $n++) {
    $R = 0.0; #  reset

    for ($j = 1; $j <= $n; $j++) {
        $R += ($j / $VMMX[$j]) * $pq[$j - 1][$n - 1];
    }
    $X = $n / ($VMMthink + $R);
    $Q = $X * $R;

    for ($j = 1; $j <= $n; $j++) {
        $pq[$j][$n] = ($X / $VMMX[$j]) * $pq[$j - 1][$n - 1];
    }

    $pq[0][$n] = 1.0;
    for ($j = 1; $j <= $n; $j++) {
        $pq[0][$n] -= $pq[$j][$n];
    }
}

$U = $X * $VMservice; 
Print_Results();




#-----------------------------------------------------------
# Subroutines 
#-----------------------------------------------------------

sub VM_Monitor
{
    my ($vmmg, $cpus, $stime) = @_;

    for ($i = 1; $i <= $vmmg; $i++) {
        if ($i <= $cpus) {
            push(@VMMX, $i / $stime);
        } else {
            push(@VMMX, $cpus / $stime);
        }
    }
}


sub Print_Results
{
    printf("\n");
    printf("     VM Scalability Model  \n");
    printf("  -----------------------------\n");
    printf("  Number  of VMs:      %3d\n", $VMguests);
    printf("  Number  of CPUs:     %3d\n", $nCPUs);
    printf("  Think time:          %8.4lf\n", $VMthink);
    printf("  Service time:        %8.4lf\n", $VMservice);
    printf("  -----------------------------\n");
    printf("  Total utilization:   %8.4lf\n", $U);
    printf("  Utilization/CPU:     %8.4lf\n", $U / $nCPUs);
    printf("  Requests in system:  %8.4lf\n", $Q);
    printf("  Requests in service: %8.4lf\n", $U);
    printf("  Requests waiting:    %8.4lf\n", $Q - $U);
    printf("  Avg. waiting time:   %8.4lf\n", $R - $VMservice);
    printf("  Mean thruput (SPH):  %8.4lf\n", $X);
    printf("  Response time (Sec): %8.4lf\n", $R);
    printf("  Stretch factor:      %8.4lf\n", $R / $VMservice);
    printf("  \n");
} 
