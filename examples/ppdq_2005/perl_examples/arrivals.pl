#! /usr/bin/perl
# arrivals.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
    2.22, 2.83);

$T_period = 30;                 # Measurement period (min)
$A_count = @busyData;           # Steady-state assumption
$A_rate = $A_count / $T_period; # Arrival rate

printf("Arrival count     (A): %6d \n", $A_count);
printf("Arrival rate (lambda): %6.2f Cust/min\n", $A_rate);

# Output ...
# Arrival count     (A):     10
# Arrival rate (lambda):   0.33 Cust/min
