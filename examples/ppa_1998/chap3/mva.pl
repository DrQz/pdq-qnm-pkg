#!/usr/bin/perl
#
#  mva.pl - Mean Value Analysis algorithm for single class workload
# 
#  $Id$
#
#  Example:
#
#
#---------------------------------------------------------------------

$MAXK = 6;  # max. service centers + 1   

# double          D[MAXK];        // service demand at center k
# double          R[MAXK];        // residence time at center k
# double          Q[MAXK];        // no. customers at center k
# double          Z;              // think time (0 for batch system)
# int             K;              // no. of queueing centers 
# int             N;              // no. of customers

#---------------------------------------------------------------------

@D = ();
$K = 0;
$N = 0;
$Z = 0;

#---------------------------------------------------------------------

sub mva
{
   @R = ();
   @Q = ();

   for ($k = 1; $k <= $K; $k++) {
      $Q[$k] = 0.0;
   }

   for ($n = 1; $n <= $N; $n++) {
      for ($k = 1; $k <= $K; $k++) {
         $R[$k] = $D[$k] * (1.0 + $Q[$k]);
      }

      $s = $Z;

      for ($k = 1; $k <= $K; $k++) {
         $s += $R[$k];
      }

      $X = ($n / $s);

      for ($k = 1; $k <= $K; $k++) {
         $Q[$k] = $X * $R[$k];
      }
   }

   printf " k    Rk     Qk    Uk\n";


   for ($k = 1; $k <= $K; $k++) {
      printf "%2d%9.3f%7.3f%7.3f\n", $k, $R[$k], $Q[$k], $X * $D[$k];
   }

   printf "N %d  X %f  Z %f\n", $N, $X, $Z;
   printf "\nX = %7.4f, R = %9.3f\n", $X, (($N / $X) - $Z);
}

#---------------------------------------------------------------------

while (1) {                
   printf STDOUT "\n(Hit RETURN to exit)\n\n";
   printf STDOUT "Enter no. of centers (K): ";

   $input = <STDIN>;

   chop($input);

   if (length($input) == 0) {
      last;
   } else {
      $K = $input;
   }

   for ($k = 1; $k <= $K; $k++) {
      printf STDOUT "Enter demand at center %d (D[%d]): ", $k, $k;

      $input = <STDIN>;

      chop($input);

      $D[$k] = $input;
   }

   printf STDOUT "Enter think time (Z):";

   $input = <STDIN>;

   chop($input);

   $Z = $input;

   while (1) {
      printf STDOUT "\n(Hit RETURN to stop)\n";
      printf STDOUT "Enter no. of terminals (N): ";

      $input = <STDIN>;

      chop($input);

      printf "[%d]\n",  length($input);

      if (length($input) == 0) {
         last;
      } else {
         $N = $input;
         mva();
      }
   }
}

