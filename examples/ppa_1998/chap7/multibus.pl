#!/usr/bin/perl
# 
#  multibus.pl
#  
#  Created by NJG: 13:03:53  07-19-96 Updated by NJG: 19:31:12  07-31-96
#  
#   $Id$
#
#---------------------------------------------------------------------

use pdq;

#---------------------------------------------------------------------

# System parameters

$BUSES  =   9;
$CPUS   =  64;
$STIME  =   1.0;
$COMPT  =  10.0;

# submodel throughput characteristic

@sm_x = ();
@pq   = ();

#---------------------------------------------------------------------

sub multiserver
{
   my  ($m, $stime) = @_;

   $work = "reqs";
   $node = "bus";

   $x = 0.0;

   for ($i = 1; $i <= $CPUS; $i++) {
      if ($i <= $m) {
         pdq::Init("multibus");

         $streams = pdq::CreateClosed($work, $pdq::TERM, $i, 0.0);
         $nodes   = pdq::CreateNode($node, $pdq::CEN, $pdq::ISRV);

         pdq::SetDemand($node, $work, $stime);
         pdq::Solve($pdq::EXACT);

         $x = pdq::GetThruput($pdq::TERM, $work);


         $sm_x[$i] = $x;
      } else {
         $sm_x[$i] = $x;
      }
      # printf "*>> %f\n",  $x;
   }
}  # multiserver #

#----- Multibus submodel ---------------------------------------------

multiserver($BUSES, $STIME);

#----- Composite model -----------------------------------------------

$pq[0][0] = 1.0;

for ($n = 1; $n <= $CPUS; $n++) {
   $R = 0.0;         # reset

   for ($j = 1; $j <= $n; $j++) {
      $h  = ($j / $sm_x[$j]) * $pq[$j - 1][$n - 1];
      $R += $h;
      # printf "%2d  sm_x[%02d] %f  pq[%02d][%02d] %f  h %f  R %f\n",
      #    $j, $sm_x[$j], $j, $n, $pq[$j - 1][$n - 1], $h, $R;
   }

   $xn = $n / ($COMPT + $R);

   # printf("xn %f  n %d  COMPT+R %f\n", $xn, $n, ($COMPT + $R));

   $qlength = $xn * $R;

   # printf("qlngth %f\n", $qlength);

   for ($j = 1; $j <= $n; $j++) {
      $pq[$j][$n] = ($xn / $sm_x[$j]) * $pq[$j - 1][$n - 1];
      # printf("pq[%d][%d] %f\n", $j, $n, $pq[$j][$n]);
   }

   $pq[0][$n] = 1.0;

   for ($j = 1; $j <= $n; $j++) {
      $pq[0][$n] -= $pq[$j][$n];
      # printf("%2d %2d  pq[00][%02d] %f  pq[%02d][%02d] %f\n", $j, $n, $n, $pq[0][$n], $j, $n, $pq[$j][$n]);
   }
}

#----- Processing Power ----------------------------------------------

printf("Buses:%2d, CPUs:%2d\n", $BUSES, $CPUS);
printf("Load %3.4f\n", ($STIME / $COMPT));
printf("X at FESC: %3.4f\n", $xn);
printf("P %3.4f\n", $xn * $COMPT);

#---------------------------------------------------------------------

