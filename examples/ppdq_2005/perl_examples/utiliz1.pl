#! /usr/bin/perl
# utiliz1.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
    2.22, 2.83);

# Compute the aggregate busy time
foreach $busy (@busyData) {
    $B_server += $busy;
}

$T_period = 30;                  # Measurement period (min)
$rho = $B_server / $T_period;    # Utilization
printf("Busy time   (B): %6.2f min\n", $B_server);
printf("Utilization (U): %6.2f or %4.2f%%\n", $rho, 100 * $rho);

# Output ...
# Busy time   (B):  22.93 min
# Utilization (U):   0.76 or 76.43%
