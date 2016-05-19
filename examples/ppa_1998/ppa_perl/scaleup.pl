#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2001, Performance Dynamics Company                    #
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

# 
#  scaleup.c - corrected Client/server model
# 
#  Grow the number of PC/Users by 2x and look for bottlenecks.
# 
#  Updated by njgunther@perfdynamics.com Thu Nov 15 09:24:33  2001
#  Revised by njgunther@perfdynamics.com Sun Nov 25 07:21:34  2001
# 
#   $Id$
#

use pdq;

# ***************************************************
#      Model Parameters
# ***************************************************

#  Name of this model ...

$scenario = "C/S Scaleup";


#  Useful multipliers ...

$K                  =  1024;
$MIPS               =   1E6;
$Mbps               =   1E6;

#  Model parameters ...

$USERS              =   250;
$FS_DISKS           =     1;
$MF_DISKS           =     4;
$PC_MIPS            =   (27 * $MIPS);
$FS_MIPS            =   (41 * $MIPS);
$GW_MIPS            =   (10 * $MIPS);
$MF_MIPS            =   (21 * $MIPS);
$TR_Mbps            =    (4 * $Mbps);
$TR_fact            =     4;

$MAXPROC            =    20;
$MAXDEV             =    50;

#  Computing Device IDs

$PC                 =    0;
$FS                 =    1;
$GW                 =    2;
$MF                 =    3;
$TR                 =    4;
$FDA                =   10;
$MDA                =   20;

#  Transaction IDs

$CD                 =    0;  #  Category Display;
$RQ                 =    1;  #  Remote Query;
$SU                 =    2;  #  Status Update;

#  Process IDs  from 1993 paper

$CD_Req             =    1;
$CD_Rpy             =   15;
$RQ_Req             =    2;
$RQ_Rpy             =   16;
$SU_Req             =    3;
$SU_Rpy             =   17;
$Req_CD             =    4;
$Req_RQ             =    5;
$Req_SU             =    6;
$CD_Msg             =   12;
$RQ_Msg             =   13;
$SU_Msg             =   14;
$GT_Snd             =    7;
$GT_Rcv             =   11;
$MF_CD              =    8;
$MF_RQ              =    9;
$MF_SU              =   10;
$LAN_Tx             =   18;

#  This should go into pdq::Lib.h ...
#  typedef struct {
#      int             id;
#      char            label[MAXCHARS];
#  }               devarray_type;
#  
#  main()
#  {
#  
#      extern int      $noNodes,
#                      $noStreams;
#      extern job_type *$job;
#      extern node_type *$node;
#      extern          $DEBUG;
#      extern char     s1[];
#  
#  
#      char            $txCD[MAXCHARS],
#                      $txRQ[MAXCHARS],
#                      $txSU[MAXCHARS];
#      double          $demand[$MAXPROC][$MAXDEV],
#                      $util[$MAXDEV],
#                      $X;
#      double          $ulan,
#                      $ufs,
#                      $udsk[$MAXDEV],
#                      $uws,
#                      $ugw,
#                      $umf,
#                      $udasd[$MAXDEV];
#      int             $work,
#                      $dev,
#                      $i,
#                      $j;
#  
#      #  This should go into pdq::Build.c ...
#      devarray_type  *$FDarray;
#      devarray_type  *$MDarray;
#  
#      if (($FDarray = (devarray_type *) calloc(sizeof(devarray_type), 10)) == NULL)
#          errmsg("", "$FDarray allocation failed!\n");
#      if (($MDarray = (devarray_type *) calloc(sizeof(devarray_type), 10)) == NULL)
#          errmsg("", "$MDarray allocation failed!\n");

%FDarray = {};
%MDarray = {};

for ($i = 0; $i < $FS_DISKS; $i++) {
   $FDarray[$i]->{id}    = $FDA + $i;
   $FDarray[$i]->{label} = sprintf("FD%d", $i);
}

for ($i = 0; $i < $MF_DISKS; $i++) {
   $MDarray[$i]->{id}    = $MDA + $i;
   $MDarray[$i]->{label} = sprintf("MD%d", $i);
}

#  CPU service times are calculated from $MIPS Instruction counts in
#  tables presented in original 1993 CMG paper.

%demand  = {};

$demand[$CD_Req][$PC] = 200 * $K / $PC_MIPS;
$demand[$CD_Rpy][$PC] = 100 * $K / $PC_MIPS;
$demand[$RQ_Req][$PC] = 150 * $K / $PC_MIPS;
$demand[$RQ_Rpy][$PC] = 200 * $K / $PC_MIPS;
$demand[$SU_Req][$PC] = 300 * $K / $PC_MIPS;
$demand[$SU_Rpy][$PC] = 300 * $K / $PC_MIPS;

$demand[$Req_CD][$FS] =  50 * $K / $FS_MIPS;
$demand[$Req_RQ][$FS] =  70 * $K / $FS_MIPS;
$demand[$Req_SU][$FS] =  10 * $K / $FS_MIPS;
$demand[$CD_Msg][$FS] =  35 * $K / $FS_MIPS;
$demand[$RQ_Msg][$FS] =  35 * $K / $FS_MIPS;
$demand[$SU_Msg][$FS] =  35 * $K / $FS_MIPS;

$demand[$GT_Snd][$GW] =  50 * $K / $GW_MIPS;
$demand[$GT_Rcv][$GW] =  50 * $K / $GW_MIPS;

$demand[$MF_CD][$MF]  =  50 * $K / $MF_MIPS;
$demand[$MF_RQ][$MF]  = 150 * $K / $MF_MIPS;
$demand[$MF_SU][$MF]  =  20 * $K / $MF_MIPS;

#  packets generated at each of the following sources ...

$demand[$LAN_Tx][$PC] = 2 * $K * $TR_fact / $TR_Mbps;
$demand[$LAN_Tx][$FS] = 2 * $K * $TR_fact / $TR_Mbps;
$demand[$LAN_Tx][$GW] = 2 * $K * $TR_fact / $TR_Mbps;

#  File server Disk I/Os = #accesses x caching / (max IOs/Sec)

for ($i = 0; $i < $FS_DISKS; $i++) {
   $demand[$Req_CD][$FDarray[$i]->{id}] = (1.0 * 0.5 / 128.9) / $FS_DISKS;
   $demand[$Req_RQ][$FDarray[$i]->{id}] = (1.5 * 0.5 / 128.9) / $FS_DISKS;
   $demand[$Req_SU][$FDarray[$i]->{id}] = (0.2 * 0.5 / 128.9) / $FS_DISKS;
   $demand[$CD_Msg][$FDarray[$i]->{id}] = (1.0 * 0.5 / 128.9) / $FS_DISKS;
   $demand[$RQ_Msg][$FDarray[$i]->{id}] = (1.5 * 0.5 / 128.9) / $FS_DISKS;
   $demand[$SU_Msg][$FDarray[$i]->{id}] = (0.5 * 0.5 / 128.9) / $FS_DISKS;
}

#  Mainframe DASD I/Os = (#accesses / (max IOs/Sec)) / #disks

for ($i = 0; $i < $MF_DISKS; $i++) {
   $demand[$MF_CD][$MDarray[$i]->{id}] = (2.0 / 60.24) / $MF_DISKS;
   $demand[$MF_RQ][$MDarray[$i]->{id}] = (4.0 / 60.24) / $MF_DISKS;
   $demand[$MF_SU][$MDarray[$i]->{id}] = (1.0 / 60.24) / $MF_DISKS;
}


#  Start building the PDQ model  ...

pdq::Init(scenario);

#  Define physical resources as queues ...

$noNodes = pdq::CreateNode("$PC", $pdq::CEN, $pdq::FCFS);
$noNodes = pdq::CreateNode("$FS", $pdq::CEN, $pdq::FCFS);

for ($i = 0; $i < $FS_DISKS; $i++) {
   $noNodes = pdq::CreateNode($FDarray[$i]->{label}, $pdq::CEN, $pdq::FCFS);
}

$noNodes = pdq::CreateNode("$GW", $pdq::CEN, $pdq::FCFS);
$noNodes = pdq::CreateNode("$MF", $pdq::CEN, $pdq::FCFS);

for ($i = 0; $i < $MF_DISKS; $i++) {
   $noNodes = pdq::CreateNode($MDarray[$i]->{label}, $pdq::CEN, $pdq::FCFS);
}

$noNodes = pdq::CreateNode("$TR", $pdq::CEN, $pdq::FCFS);

#  NOTE: Althought the Token Ring LAN is a passive computational device,
#  it is treated as a separate $node so as to agree to the results
#  presented in the original CMG'93 paper.

#  Assign transaction names ...

$txCD = "CatDsply";
$txRQ = "RemQuote";
$txSU = "StatusUp";

#  Define an OPEN circuit aggregate workload ...

$noStreams = pdq::CreateOpen($txCD, $USERS * 4.0 / 60.0);
$noStreams = pdq::CreateOpen($txRQ, $USERS * 8.0 / 60.0);
$noStreams = pdq::CreateOpen($txSU, $USERS * 1.0 / 60.0);


#  Define the service demands on each physical resource ...

#  $CD request + reply chain  from workflow diagram

pdq::SetDemand("$PC", $txCD, $demand[$CD_Req][$PC] + (5 * $demand[$CD_Rpy][$PC]));
pdq::SetDemand("$FS", $txCD, $demand[$Req_CD][$FS] + (5 * $demand[$CD_Msg][$FS]));

for ($i = 0; $i < $FS_DISKS; $i++) {
   pdq::SetDemand($FDarray[$i]->{label}, $txCD, $demand[$Req_CD][$FDarray[$i]->{id}] +
                (5 * $demand[$CD_Msg][$FDarray[$i]->{id}]));
}

pdq::SetDemand("$GW", $txCD, $demand[$GT_Snd][$GW] + (5 * $demand[$GT_Rcv][$GW]));
pdq::SetDemand("$MF", $txCD, $demand[$MF_CD][$MF]);

for ($i = 0; $i < $MF_DISKS; $i++) {
   pdq::SetDemand($MDarray[$i]->{label}, $txCD,
                $demand[$MF_CD][$MDarray[$i]->{id}]);
}

#  NOTE: Synchronous process execution causes data for the $CD
#  transaction to cross the LAN 12 times as depicted in the following
#  parameterization of pdq::SetDemand.

pdq::SetDemand("$TR", $txCD,
            (1 * $demand[$LAN_Tx][$PC]) +
            (1 * $demand[$LAN_Tx][$FS]) +
            (5 * $demand[$LAN_Tx][$GW]) +
            (5 * $demand[$LAN_Tx][$FS])
   );


#  RQ request + reply chain ...

pdq::SetDemand("$PC", $txRQ, $demand[$RQ_Req][$PC] + (3 * $demand[$RQ_Rpy][$PC]));
pdq::SetDemand("$FS", $txRQ, $demand[$Req_RQ][$FS] + (3 * $demand[$RQ_Msg][$FS]));

for ($i = 0; $i < $FS_DISKS; $i++) {
   pdq::SetDemand($FDarray[$i]->{label}, $txRQ,
                $demand[$Req_RQ][$FDarray[$i]->{id}] +
                (3 * $demand[$RQ_Msg][$FDarray[$i]->{id}]));
}

pdq::SetDemand("$GW", $txRQ, $demand[$GT_Snd][$GW] + (3 * $demand[$GT_Rcv][$GW]));
pdq::SetDemand("$MF", $txRQ, $demand[$MF_RQ][$MF]);

for ($i = 0; $i < $MF_DISKS; $i++) {
   pdq::SetDemand($MDarray[$i]->{label}, $txRQ,
                $demand[$MF_RQ][$MDarray[$i]->{id}]);
}

pdq::SetDemand("$TR", $txRQ,
            (1 * $demand[$LAN_Tx][$PC]) +
            (1 * $demand[$LAN_Tx][$FS]) +
            (3 * $demand[$LAN_Tx][$GW]) +
            (3 * $demand[$LAN_Tx][$FS]));


#  SU request + reply chain  ...

pdq::SetDemand("$PC", $txSU, $demand[$SU_Req][$PC] + $demand[$SU_Rpy][$PC]);
pdq::SetDemand("$TR", $txSU, $demand[$LAN_Tx][$PC]);
pdq::SetDemand("$FS", $txSU, $demand[$Req_SU][$FS] + $demand[$SU_Msg][$FS]);

for ($i = 0; $i < $FS_DISKS; $i++) {
   pdq::SetDemand($FDarray[$i]->{label}, $txSU,
                $demand[$Req_SU][$FDarray[$i]->{id}] +
                $demand[$SU_Msg][$FDarray[$i]->{id}]);
}

pdq::SetDemand("$TR", $txSU, $demand[$LAN_Tx][$FS]);
pdq::SetDemand("$GW", $txSU, $demand[$GT_Snd][$GW] + $demand[$GT_Rcv][$GW]);
pdq::SetDemand("$MF", $txSU, $demand[$MF_SU][$MF]);

for ($i = 0; $i < $MF_DISKS; $i++) {
   pdq::SetDemand($MDarray[$i]->{label}, $txSU,
                $demand[$MF_SU][$MDarray[$i]->{id}]);
}

pdq::SetDemand("$TR", $txSU,
            (1 * $demand[$LAN_Tx][$PC]) +
            (1 * $demand[$LAN_Tx][$FS]) +
            (1 * $demand[$LAN_Tx][$GW]) +
            (1 * $demand[$LAN_Tx][$FS]));

$DEBUG = 0;

pdq::Solve($pdq::CANON);
pdq::Report();

#  Break out Tx response times and device utilizations ...

printf("*** PDQ Breakout \"%s\" (%d clients) ***\n\n", $scenario, $USERS);

for ($dev = 0; $dev < $noNodes; $dev++) {
   $util[$dev] = 0.0;#  reset array

   for ($work = 0; $work < $noStreams; $work++) {
      $util[$dev] += 100 * pdq::GetUtilization(
                                $node[$dev].devname,
                                $job[$work].trans->name,
                                $pdq::TRANS);
   }
}

#  Order of print out follows that in 1993 CMG paper.

printf("Transaction  \tLatency(Secs)\n");
printf("-----------  \t-----------\n");

for ($work = 0; $work < $noStreams; $work++) {
   printf("%s\t%7.4f\n",
          $job[$work].trans->name, $job[$work].trans->sys->response);
}

printf("\n\n");

for ($dev = 0; $dev < $noNodes; $dev++) {
   if ($node[$dev].devname eq "$PC") {
      $uws += $util[$dev];
   }

   if ($node[$dev].devname eq "$GW") {
      $ugw += $util[$dev];
   }

   if ($node[$dev].devname eq "$FS") {
      $ufs += $util[$dev];
   }

   for ($i = 0; $i < $FS_DISKS; $i++) {
      if ($node[$dev].devname eq $FDarray[$i]->{label}) {
          $udsk[$i] += $util[$dev];
      }
   }

   if ($node[$dev].devname eq "$MF") {
      $umf += $util[$dev];
   }

   for ($i = 0; $i < $MF_DISKS; $i++) {
      if ($node[$dev].devname eq $MDarray[$i]->{label}) {
         $udasd[$i] += $util[$dev];
      }
   }

   if ($node[$dev].devname eq "$TR") {
      $ulan += $util[$dev];
   }
}

printf("Node      \t%% Utilization\n");
printf("----      \t--------------\n");
printf("%s\t%7.4f\n", "Token Ring ", $ulan);
printf("%s\t%7.4f\n", "Desktop $PC ", $uws / $USERS);
printf("%s\t%7.4f\n", "FileServer ", $ufs);

for ($i = 0; $i < $FS_DISKS; $i++) {
   printf("%s%d\t%7.4f\n", "$FS Disk", $FDarray[$i]->{id}, $udsk[$i]);
}

printf("%s\t%7.4f\n", "Gateway SNA", $ugw);
printf("%s\t%7.4f\n", "Mainframe  ", $umf);

for ($i = 0; $i < $MF_DISKS; $i++) {
   printf("%s%d\t%7.4f\n", "MFrame DASD", $MDarray[$i]->{id}, $udasd[$i]);
}

