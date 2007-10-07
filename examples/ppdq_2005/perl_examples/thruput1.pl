#! /usr/bin/perl
# thruput1.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
    2.22, 2.83);

$T_period = 30;                   # Measurement period (min)
$C_count = @busyData;             # Completion count
$X =  $C_count / $T_period;       # System throughput
printf("Completion count  (C): %6d \n", $C_count);
printf("System throughput (X): %6.2f Cust/min\n", $X);
printf("Normalized throughput: %6d Cust every %4.2f min\n", 1, 1/$X);

# Output ...
# Completion count  (C):     10
# System throughput (X):   0.33 Cust/min
# Normalized throughput:      1 Cust every 3.00 min
