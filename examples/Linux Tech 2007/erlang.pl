#! /usr/bin/perl
#
# erlang.pl

## Input parameters 
$servers = 8;
$erlangs = 4;

if($erlangs > $servers) {
    print "Error: Erlangs exceeds servers\n";
    exit;
}

$rho     = $erlangs / $servers;
$erlangB = $erlangs / (1 + $erlangs);
for ($m  = 2; $m <= $servers; $m++) {
    $eb  = $erlangB;
    $erlangB = $eb * $erlangs / ($m + ($eb * $erlangs));
}

## Output results 
$erlangC  = $erlangB / (1 - $rho + ($rho * $erlangB));
$normdwtE = $erlangC / ($servers * (1 - $rho));
$normdrtE = 1 + $normdwtE;              # Exact
$normdrtA = 1 / (1 - $rho**$servers);   # Approx

printf("%10s\t%10s\t%10s\n", "Wait time", "RT exact", "RT approx");
printf("%10.2f\t%10.2f\t%10.2f\n", $normdwtE, $normdrtE, $normdrtA);

