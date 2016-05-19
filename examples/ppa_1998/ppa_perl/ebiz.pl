#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2002, Performance Dynamics Company                    #
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

#--------------------------------------------------------------------------
#  ebiz.c
# 
#  Created by NJG: Wed May  8 22:29:36  2002
#  Created by NJG: Fri Aug  2 08:57:31  2002
# 
#  Based on D. Buch and V. Pentkovski, "Experience of Characterization of
#  Typical Multi-tier e-Business Systems Using Operational Analysis,"
#  CMG Conference, Anaheim, California, pp. 671-681, Dec 2002.
# 
#  Measurements use Microsoft WAS (Web Application Stress) tool.
#  Could also use Merc-Interactive LoadRunner.
#  Only a single class of eBiz transaction e.g., login, or page_view, etc.
#  is measured.  Transaction details are not specified in the paper.
# 
#  Thinktime Z should be zero by virtue of N = XR assumption in paper.
#  We find that a Z~27 mSecs is needed to calibrate thruputs and utilizations.
# 
#   $Id$
#
#--------------------------------------------------------------------------

$MAXUSERS =  20;

$model    = "Middleware I";
$work     = "eBiz-tx";
$node1    = "WebServer";
$node2    = "AppServer";
$node3    = "DBMServer";
$think    = 0.0 * 1e-3;  # treated as free param

# printf "Think %9.7f\n", $think;

#  Added dummy servers for calibration ...

$node4 = "DummySvr";

#  User loads employed in WAS tool ...

$u1pdq = ();
$u2pdq = ();
$u3pdq = ();
$u1err = ();
$u2err = ();
$u3err = ();

#  Utilization data from the paper ...

@u1dat = (
   0.0, 21.0, 41.0, 0.0, 74.0, 0.0, 0.0, 95.0, 0.0, 0.0, 96.0, 
   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 96.0 
);

@u2dat = (
   0.0, 8.0, 13.0, 0.0, 20.0, 0.0, 0.0, 23.0, 0.0, 0.0, 22.0, 
   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 22.0
);

@u3dat = (
   0.0, 4.0, 5.0, 0.0, 5.0, 0.0, 0.0, 5.0, 0.0, 0.0, 6.0, 
   0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0
);

#--------------------------------------------------------------------------
#  Output header ...

printf("\n");
printf("(Tx: \"%s\" for \"%s\")\n\n", $work, $model);
printf("Client delay Z=%5.2f mSec. (Assumed)\n\n", $think * 1e3);
printf("%3s  %6s  %6s  %6s  %6s  %6s\n",
         " N ", "  X  ", "  R  ", "%Uws", "%Uas", "%Udb");
printf("%3s  %6s  %6s   %6s  %6s  %6s\n",
         "---", "------", "------", "------", "------", "------");

for ($users = 1; $users <= $MAXUSERS; $users++) {
   pdq::Init($model);

   $noStreams = pdq::CreateClosed($work, $pdq::TERM, $users, $think);

   $noNodes = pdq::CreateNode($node1, $pdq::CEN, $pdq::FCFS);
   $noNodes = pdq::CreateNode($node2, $pdq::CEN, $pdq::FCFS);
   $noNodes = pdq::CreateNode($node3, $pdq::CEN, $pdq::FCFS);
   $noNodes = pdq::CreateNode($node4, $pdq::CEN, $pdq::FCFS);
   # $noNodes = pdq::CreateNode($node5, $pdq::CEN, $pdq::FCFS);
   # $noNodes = pdq::CreateNode($node6, $pdq::CEN, $pdq::FCFS);

   #  NOTE: timebase is seconds

   pdq::SetDemand($node1, $work, 9.8 * 1e-3);
   pdq::SetDemand($node2, $work, 2.5 * 1e-3);
   pdq::SetDemand($node3, $work, 0.72 * 1e-3);

   #  dummy (network) nodes ...

   pdq::SetDemand($node4, $work, 9.8 * 1e-3);

   pdq::Solve($pdq::EXACT);

   #  set up for error analysis of utilzations

   $u1pdq[$users] = pdq::GetUtilization($node1, $work, $pdq::TERM) * 100;
   $u2pdq[$users] = pdq::GetUtilization($node2, $work, $pdq::TERM) * 100;
   $u3pdq[$users] = pdq::GetUtilization($node3, $work, $pdq::TERM) * 100;

   if ($u1dat[$users] gt 0) {
      $u1err[$users] = 100 * ($u1pdq[$users] - $u1dat[$users]) / $u1dat[$users];
   } else {
      $u1err[$users] = 0;
   }

   if ($u2dat[$users] gt 0) {
      $u2err[$users] = 100 * ($u2pdq[$users] - $u2dat[$users]) / $u2dat[$users];
   } else {
      $u2err[$users] = 0;
   }

   if ($u3dat[$users] gt 0) {
      $u3err[$users] = 100 * ($u3pdq[$users] - $u3dat[$users]) / $u3dat[$users];
   } else {
      $u3err[$users] = 0;
   }

   printf("%3d  %6.2f  %6.2f   %6.2f  %6.2f  %6.2f\n",
         $users,
         pdq::GetThruput($pdq::TERM, $work),          # http GETs-per-Second
         pdq::GetResponse($pdq::TERM, $work) * 1e3,   # milliseconds
         $u1pdq[$users],
         $u2pdq[$users],
         $u3pdq[$users]
   );
}

#--------------------------------------------------------------------------

printf("\nError Analysis of Utilizations\n\n");
printf("                  WS                      AS                      DB\n");
printf("        ----------------------  ----------------------  ----------------------\n");
printf(" N      %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr   %%Udat   %%Updq   %%Uerr\n");
printf("---     -----   -----   -----   -----   -----   -----   -----   -----   -----\n");

@flg     = [];

for ($idx = 1; $idx <= $MAXUSERS; $idx++) {
   $flg[idx] = 0;
}

$flg[1]  = 1;
$flg[2]  = 1;
$flg[4]  = 1;
$flg[7]  = 1;
$flg[10] = 1;
$flg[20] = 1;

#--------------------------------------------------------------------------

for ($users = 1; $users <= $MAXUSERS; $users++) {
   if ($flg[$users] == 1) {
      printf("%3d    %6.2f  %6.2f  %6.2f",
             $users,
             $u1dat[$users],
             $u1pdq[$users],
             $u1err[$users]);
      printf("  %6.2f  %6.2f  %6.2f",
             $u2dat[$users],
             $u2pdq[$users],
             $u2err[$users]);
      printf("  %6.2f  %6.2f  %6.2f\n",
             $u3dat[$users],
             $u3pdq[$users],
             $u3err[$users]);
   }
}

#--------------------------------------------------------------------------

printf("\n");

# Uncomment the following line for a standard PDQ summary.

pdq::Report();

#--------------------------------------------------------------------------

