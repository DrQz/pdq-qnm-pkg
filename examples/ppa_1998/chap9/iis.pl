#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################


use pdq;

# 
#  iis.c
# 
#  Based on Microsoft WAS measurements of IIS.
#  
#  CMG 2001 paper.
# 
#   $Id$
#
#--------------------------------------------------------------------------

$model = "IIS Server";
$work = "http GET 20KB";
$node1 = "CPU";
$node2 = "DSK";
$node3 = "NET";
$node4 = "Dummy";
$think = 1.5 * 1e-3;

@u1pdq   = ();
@u2pdq   = ();
@u3pdq   = ();
@u1err   = ();
@u2err   = ();
@u3err   = ();

$u2demand = 0.10 * 1e-3;

#  Utilization data from the paper ...

@u1dat = (
   0.0, 9.0, 14.0, 17.0, 21.0, 24.0, 26.0, 0.0, 0.0, 0.0, 26.0
);

@u2dat = (
   0.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, 2.0
);

@u3dat = (
   0.0, 26.0, 46.0, 61.0, 74.0, 86.0, 92.0, 0.0, 0.0, 0.0, 94.0
);

#--------------------------------------------------------------------------

sub list_dat()
{
   for ($noUsers = 1; $noUsers <= 10; $noUsers++) {
      printf("%6.2f  %6.2f  %6.2f\n",
         $u1dat[$noUsers],
         $u2dat{$noUsers},
         $u3dat{$noUsers})
   }
}

#--------------------------------------------------------------------------
#  Output main header ...

printf("\n");
printf("(Tx: \"%s\" for \"%s\")\n\n", $work, $model);
printf("Client delay Z=%5.2f mSec. (Assumed)\n\n", $think * 1e3);
printf(" N      X       R      %%Ucpu   %%Udsk   %%Unet\n");
printf("---  ------  ------   ------  ------  ------\n");

#--------------------------------------------------------------------------

for ($noUsers = 1; $noUsers <= 10; $noUsers++) {
   pdq::Init($model);

   $noStreams = pdq::CreateClosed($work, $pdq::TERM, $noUsers, $think);

   $noNodes = pdq::CreateNode($node1, $pdq::CEN, $pdq::FCFS);
   $noNodes = pdq::CreateNode($node2, $pdq::CEN, $pdq::FCFS);
   $noNodes = pdq::CreateNode($node3, $pdq::CEN, $pdq::FCFS);
   $noNodes = pdq::CreateNode($node4, $pdq::CEN, $pdq::FCFS);

   #  NOTE: timebase is seconds

   pdq::SetDemand($node1, $work, 0.44 * 1e-3);
   pdq::SetDemand($node2, $work, $u2demand);#  make load-indept
   pdq::SetDemand($node3, $work, 1.45 * 1e-3);
   pdq::SetDemand($node4, $work, 1.6 * 1e-3);

   pdq::Solve($pdq::EXACT);

   #  set up for error analysis of utilzations

   $u1pdq[$noUsers] = pdq::GetUtilization($node1, $work, $pdq::TERM) * 100;
   $u2pdq[$noUsers] = pdq::GetUtilization($node2, $work, $pdq::TERM) * 100;
   $u3pdq[$noUsers] = pdq::GetUtilization($node3, $work, $pdq::TERM) * 100;

   if ($u1dat[$noUsers] gt 0) {
      $u1err[$noUsers] = 100 * ($u1pdq[$noUsers] - $u1dat[$noUsers]) / $u1dat[$noUsers];
   } else {
      $u1err[$noUsers] = 0;
   }

   if ($u2dat[$noUsers] gt 0) {
      $u2err[$noUsers] = 100 * ($u2pdq[$noUsers] - $u2dat[$noUsers]) / $u2dat[$noUsers];
   } else {
      $u2err[$noUsers] = 0;
   }

   if ($u3dat[$noUsers] gt 0) {
      $u3err[$noUsers] = 100 * ($u3pdq[$noUsers] - $u3dat[$noUsers]) / $u3dat[$noUsers];
   } else {
      $u3err[$noUsers] = 0;
   }

   $u2demand = 0.015 / pdq::GetThruput($pdq::TERM, $work);

   printf("%3d  %6.2f  %6.2f   %6.2f  %6.2f  %6.2f\n",
         $noUsers, 
         pdq::GetThruput($pdq::TERM, $work),          #  http GETs-per-second
         pdq::GetResponse($pdq::TERM, $work) * 1e3,   #  milliseconds
         $u1pdq[$noUsers],
         $u2pdq[$noUsers],
         $u3pdq[$noUsers]
   );
}

#--------------------------------------------------------------------------

printf("\nError Analysis of Utilizations\n\n");
printf("                 CPU                     DSK                     NET\n");
printf("        ----------------------  ----------------------  ----------------------\n");
printf(" N      %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr\n");
printf("---     -----   -----   -----   -----   -----   -----   -----   -----   -----\n");

for ($noUsers = 1; $noUsers <= 10; $noUsers++) {
   if ($noUsers <= 6 || $noUsers == 10) {
      printf("%3d    %6.2f  %6.2f  %6.2f",
         $noUsers,
         $u1dat[$noUsers],
         $u1pdq[$noUsers],
         $u1err[$noUsers]
      );

      printf("  %6.2f  %6.2f  %6.2f",
         $u2dat[$noUsers],
         $u2pdq[$noUsers],
         $u2err[$noUsers]
      );

      printf("  %6.2f  %6.2f  %6.2f\n",
         $u3dat[$noUsers],
         $u3pdq[$noUsers],
         $u3err[$noUsers]
      );
   }
}

printf("\n");

#--------------------------------------------------------------------------

