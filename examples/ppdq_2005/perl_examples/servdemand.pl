#! /usr/bin/perl

$B_server = 917;                    # Busy time
$C_server = 2500;                   # Server completions
$S_server = $B_server / $C_server;  # Service time
$S_visits = 2;
$D = $S_server * $S_visits;
printf("Service demand (D): %6.2f s\n", $D);

# Output ...
# Service demand (D):   0.73 s
