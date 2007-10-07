#! /usr/bin/perl
# residence.pl

# Array of measured busy periods (min)
@busyData = (1.23, 2.01, 3.11, 1.02, 1.54, 2.69, 3.41, 2.87, 
	2.22, 2.83);

# Compute the aggregate busy time
foreach $busy (@busyData) {
	$B_server += $busy;
}
$T_period = 30;					 # Measurement period (min)
$C_server = @busyData;			 # Completions
$S_time = $B_server / $C_server; # Service time (min)
$rho = $B_server / $T_period;	 # Utilization
$R_time = $S_time / (1 - $rho);	 # Residence time (min)
$Q_length = $rho / (1 - $rho);	 # Queue length
$W_time = $Q_length * $S_time;	 # Waiting time (min)
printf("Service time   (S): %6.2f min\n", $S_time);
printf("Utilization	 (rho): %6.2f  \n", $rho);
printf("Residence time (R): %6.2f min\n", $R_time);
printf("Queue length   (Q): %6.2f \n", $Q_length);
printf("Waiting time   (W): %6.2f min\n", $W_time);

# Output ...
# Service time	 (S):	2.29 min
# Utilization  (rho):	0.76  
# Residence time (R):	9.73 min
# Queue length	 (Q):	3.24 
# Waiting time	 (W):	7.44 min
