#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2018, Performance Dynamics Company                    #
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

# cs_baseline.pl
#
# Updated by NJG on Saturday, Apr 8, 2006      --- per erratum p.324
# Updated by NJG on Thursday, October 04, 2018 --- removed local nodes and streams

use pdq;

#----------------------------------------------------
# PDQ model parameters
#----------------------------------------------------
$scenario           = "Client/Server Baseline";

#  Useful constants
$K                  =  1000;
$MIPS               =   1E6;

$USERS              =   100;
$WEB_SERVS          =     2;
$DB_DISKS           =     4;
$PC_MIPS            =  499 * $MIPS;
$AS_MIPS            =  792 * $MIPS;
$LB_MIPS            =  499 * $MIPS;
$DB_MIPS            =  479 * $MIPS;
$LAN_RATE           =  100 * 1E6;
$LAN_INST           =     4;     
$WEB_OPS            =   400;     
$DB_IOS             =   250;     

$MAXPROC            =    20;
$MAXDEV             =    50;

$PC                 =     0;    # PC drivers
$FS                 =     1;    # Application cluster
$GW                 =     2;    # Load balancer
$MF                 =     3;    # Database server
$TR                 =     4;    # Network
$FDA                =    10;    # Web servers
$MDA                =    20;    # Database disks

##  Process PIDs 
$CD_Req             =     1;
$CD_Rpy             =    15;
$RQ_Req             =     2;
$RQ_Rpy             =    16;
$SU_Req             =     3;
$SU_Rpy             =    17;
$Req_CD             =     4;
$Req_RQ             =     5;
$Req_SU             =     6;
$CD_Msg             =    12;
$RQ_Msg             =    13;
$SU_Msg             =    14;
$GT_Snd             =     7;
$GT_Rcv             =    11;
$MF_CD              =     8;
$MF_RQ              =     9;
$MF_SU              =    10;
$LAN_Tx             =    18;

# Initialize array data structures
for ($i = 0; $i < $WEB_SERVS; $i++) {
   $FDarray[$i]->{id}    = $FDA + $i;
   $FDarray[$i]->{label} = sprintf("WebSvr%d", $i);
}
for ($i = 0; $i < $DB_DISKS; $i++) {
   $MDarray[$i]->{id}    = $MDA + $i;
   $MDarray[$i]->{label} = sprintf("SCSI%d", $i);
}

$demand[$CD_Req][$PC] = 200 * $K / $PC_MIPS;
$demand[$CD_Rpy][$PC] = 100 * $K / $PC_MIPS;
$demand[$RQ_Req][$PC] = 150 * $K / $PC_MIPS;
$demand[$RQ_Rpy][$PC] = 200 * $K / $PC_MIPS;
$demand[$SU_Req][$PC] = 300 * $K / $PC_MIPS;
$demand[$SU_Rpy][$PC] = 300 * $K / $PC_MIPS;

$demand[$Req_CD][$FS] =  500 * $K / $AS_MIPS;
$demand[$Req_RQ][$FS] =  700 * $K / $AS_MIPS;
$demand[$Req_SU][$FS] =  100 * $K / $AS_MIPS;
$demand[$CD_Msg][$FS] =  350 * $K / $AS_MIPS;
$demand[$RQ_Msg][$FS] =  350 * $K / $AS_MIPS;
$demand[$SU_Msg][$FS] =  350 * $K / $AS_MIPS;

$demand[$GT_Snd][$GW] =  500 * $K / $LB_MIPS;
$demand[$GT_Rcv][$GW] =  500 * $K / $LB_MIPS;

$demand[$MF_CD][$MF]  =  5000 * $K / $DB_MIPS;
$demand[$MF_RQ][$MF]  =  1500 * $K / $DB_MIPS;
$demand[$MF_SU][$MF]  =  2000 * $K / $DB_MIPS;

#  Packets generated at each of the following sources 
$demand[$LAN_Tx][$PC] = 2 * $K * $LAN_INST / $LAN_RATE;
$demand[$LAN_Tx][$FS] = 2 * $K * $LAN_INST / $LAN_RATE;
$demand[$LAN_Tx][$GW] = 2 * $K * $LAN_INST / $LAN_RATE;

# Parallel web servers
for ($i = 0; $i < $WEB_SERVS; $i++) {
   $demand[$Req_CD][$FDarray[$i]->{id}] = (1.0 * 0.5 / 
        $WEB_OPS) / $WEB_SERVS;
   $demand[$Req_RQ][$FDarray[$i]->{id}] = (1.5 * 0.5 / 
        $WEB_OPS) / $WEB_SERVS;
   $demand[$Req_SU][$FDarray[$i]->{id}] = (0.2 * 0.5 / 
        $WEB_OPS) / $WEB_SERVS;
   $demand[$CD_Msg][$FDarray[$i]->{id}] = (1.0 * 0.5 / 
        $WEB_OPS) / $WEB_SERVS;
   $demand[$RQ_Msg][$FDarray[$i]->{id}] = (1.5 * 0.5 / 
        $WEB_OPS) / $WEB_SERVS;
   $demand[$SU_Msg][$FDarray[$i]->{id}] = (0.5 * 0.5 / 
        $WEB_OPS) / $WEB_SERVS;
}

# RDBMS disk arrays
for ($i = 0; $i < $DB_DISKS; $i++) {
   $demand[$MF_CD][$MDarray[$i]->{id}] = (2.0 / $DB_IOS) / 
        $DB_DISKS;
   $demand[$MF_RQ][$MDarray[$i]->{id}] = (4.0 / $DB_IOS) / 
        $DB_DISKS;
   $demand[$MF_SU][$MDarray[$i]->{id}] = (1.0 / $DB_IOS) / 
        $DB_DISKS;
}

#  Start building the PDQ model
pdq::Init($scenario);

#  Define physical resources as queues
pdq::CreateNode("PC", $pdq::CEN, $pdq::FCFS);
pdq::CreateNode("LB", $pdq::CEN, $pdq::FCFS);
for ($i = 0; $i < $WEB_SERVS; $i++) {
   pdq::CreateNode($FDarray[$i]->{label}, 
        $pdq::CEN, $pdq::FCFS);
}

pdq::CreateNode("AS", $pdq::CEN, $pdq::FCFS);
pdq::CreateNode("DB", $pdq::CEN, $pdq::FCFS);
for ($i = 0; $i < $DB_DISKS; $i++) {
   pdq::CreateNode($MDarray[$i]->{label}, $pdq::CEN, 
        $pdq::FCFS);
}

pdq::CreateNode("LAN", $pdq::CEN, $pdq::FCFS);

#  Assign transaction names 
$txCD =  "CatDsply";
$txRQ =  "RemQuote";
$txSU =  "StatusUp";
$dumCD  = "CDbkgnd ";
$dumRQ  = "RQbkgnd ";
$dumSU  = "SUbkgnd ";

#  Define focal PC load generator
pdq::CreateOpen($txCD, 1 * 4.0 / 60.0);
pdq::CreateOpen($txRQ, 1 * 8.0 / 60.0);
pdq::CreateOpen($txSU, 1 * 1.0 / 60.0);


#  Define the aggregate background workload 
pdq::CreateOpen($dumCD, ($USERS - 1) * 4.0 / 60.0);
pdq::CreateOpen($dumRQ, ($USERS - 1) * 8.0 / 60.0);
pdq::CreateOpen($dumSU, ($USERS - 1) * 1.0 / 60.0);

#----------------------------------------------------
# CategoryDisplay request + reply chain  from workflow diagram
#----------------------------------------------------
pdq::SetDemand("PC", $txCD, 
    $demand[$CD_Req][$PC] + (5 * $demand[$CD_Rpy][$PC]));
pdq::SetDemand("AS", $txCD, 
    $demand[$Req_CD][$FS] + (5 * $demand[$CD_Msg][$FS]));
pdq::SetDemand("AS", $dumCD, 
    $demand[$Req_CD][$FS] + (5 * $demand[$CD_Msg][$FS]));
for ($i = 0; $i < $WEB_SERVS; $i++) {
   pdq::SetDemand($FDarray[$i]->{label}, $txCD, 
       $demand[$Req_CD][$FDarray[$i]->{id}] + 
       (5 * $demand[$CD_Msg][$FDarray[$i]->{id}]));
   pdq::SetDemand($FDarray[$i]->{label}, $dumCD, 
       $demand[$Req_CD][$FDarray[$i]->{id}] + 
       (5 * $demand[$CD_Msg][$FDarray[$i]->{id}]));
}
pdq::SetDemand("LB", $txCD, $demand[$GT_Snd][$GW] + 
    (5 * $demand[$GT_Rcv][$GW]));
pdq::SetDemand("LB", $dumCD, $demand[$GT_Snd][$GW] + 
    (5 * $demand[$GT_Rcv][$GW]));
pdq::SetDemand("DB", $txCD, $demand[$MF_CD][$MF]);
pdq::SetDemand("DB", $dumCD, $demand[$MF_CD][$MF]);
for ($i = 0; $i < $DB_DISKS; $i++) {
   pdq::SetDemand($MDarray[$i]->{label}, $txCD, 
       $demand[$MF_CD][$MDarray[$i]->{id}]);
   pdq::SetDemand($MDarray[$i]->{label}, $dumCD, 
       $demand[$MF_CD][$MDarray[$i]->{id}]);
}
#  NOTE: Synchronous process execution causes data for the CD
#  transaction to cross the LAN 12 times as depicted in the 
#  following parameterization of pdq::SetDemand.
pdq::SetDemand("LAN", $txCD,
      (1 * $demand[$LAN_Tx][$PC]) + (1 * $demand[$LAN_Tx][$FS])
    + (5 * $demand[$LAN_Tx][$GW]) + (5 * $demand[$LAN_Tx][$FS]));
pdq::SetDemand("LAN", $dumCD,
      (1 * $demand[$LAN_Tx][$PC]) + (1 * $demand[$LAN_Tx][$FS])
    + (5 * $demand[$LAN_Tx][$GW]) + (5 * $demand[$LAN_Tx][$FS]));


#----------------------------------------------------
# RemoteQuote request + reply chain ...
#----------------------------------------------------
pdq::SetDemand("PC", $txRQ, 
    $demand[$RQ_Req][$PC] + (3 * $demand[$RQ_Rpy][$PC]));
pdq::SetDemand("AS", $txRQ, 
    $demand[$Req_RQ][$FS] + (3 * $demand[$RQ_Msg][$FS]));
pdq::SetDemand("AS", $dumRQ, 
    $demand[$Req_RQ][$FS] + (3 * $demand[$RQ_Msg][$FS]));
for ($i = 0; $i < $WEB_SERVS; $i++) {
   pdq::SetDemand($FDarray[$i]->{label}, $txRQ,
         $demand[$Req_RQ][$FDarray[$i]->{id}] + 
     (3 * $demand[$RQ_Msg][$FDarray[$i]->{id}]));
   pdq::SetDemand($FDarray[$i]->{label}, $dumRQ,
         $demand[$Req_RQ][$FDarray[$i]->{id}] + 
     (3 * $demand[$RQ_Msg][$FDarray[$i]->{id}]));
}
pdq::SetDemand("LB", $txRQ, $demand[$GT_Snd][$GW] + 
    (3 * $demand[$GT_Rcv][$GW]));
pdq::SetDemand("LB", $dumRQ, $demand[$GT_Snd][$GW] + 
    (3 * $demand[$GT_Rcv][$GW]));
pdq::SetDemand("DB", $txRQ, $demand[$MF_RQ][$MF]);
pdq::SetDemand("DB", $dumRQ, $demand[$MF_RQ][$MF]);
for ($i = 0; $i < $DB_DISKS; $i++) {
   pdq::SetDemand($MDarray[$i]->{label}, $txRQ, 
       $demand[$MF_RQ][$MDarray[$i]->{id}]);
   pdq::SetDemand($MDarray[$i]->{label}, $dumRQ, 
       $demand[$MF_RQ][$MDarray[$i]->{id}]);
}
pdq::SetDemand("LAN", $txRQ,
     (1 * $demand[$LAN_Tx][$PC]) + (1 * $demand[$LAN_Tx][$FS])
   + (3 * $demand[$LAN_Tx][$GW]) + (3 * $demand[$LAN_Tx][$FS]));
pdq::SetDemand("LAN", $dumRQ,
     (1 * $demand[$LAN_Tx][$PC]) + (1 * $demand[$LAN_Tx][$FS])
   + (3 * $demand[$LAN_Tx][$GW]) + (3 * $demand[$LAN_Tx][$FS]));

#----------------------------------------------------
# StatusUpdate request + reply chain  ...
#----------------------------------------------------
pdq::SetDemand("PC", $txSU, $demand[$SU_Req][$PC] + 
    $demand[$SU_Rpy][$PC]);
pdq::SetDemand("AS",  $txSU, $demand[$Req_SU][$FS] + 
    $demand[$SU_Msg][$FS]);
pdq::SetDemand("AS",  $dumSU, $demand[$Req_SU][$FS] + 
    $demand[$SU_Msg][$FS]);
for ($i = 0; $i < $WEB_SERVS; $i++) {
   pdq::SetDemand($FDarray[$i]->{label}, $txSU, 
       $demand[$Req_SU][$FDarray[$i]->{id}] +
                      $demand[$SU_Msg][$FDarray[$i]->{id}]);
   pdq::SetDemand($FDarray[$i]->{label}, $dumSU, 
       $demand[$Req_SU][$FDarray[$i]->{id}] +
                      $demand[$SU_Msg][$FDarray[$i]->{id}]);
}
pdq::SetDemand("LB", $txSU, $demand[$GT_Snd][$GW] + 
    $demand[$GT_Rcv][$GW]);
pdq::SetDemand("LB", $dumSU, $demand[$GT_Snd][$GW] + 
    $demand[$GT_Rcv][$GW]);
pdq::SetDemand("DB", $txSU, $demand[$MF_SU][$MF]);
pdq::SetDemand("DB", $dumSU, $demand[$MF_SU][$MF]);
for ($i = 0; $i < $DB_DISKS; $i++) {
   pdq::SetDemand($MDarray[$i]->{label}, $txSU, 
       $demand[$MF_SU][$MDarray[$i]->{id}]);
   pdq::SetDemand($MDarray[$i]->{label}, $dumSU, 
       $demand[$MF_SU][$MDarray[$i]->{id}]);
}
pdq::SetDemand("LAN", $txSU,
      (1 * $demand[$LAN_Tx][$PC]) + (1 * $demand[$LAN_Tx][$FS])
    + (1 * $demand[$LAN_Tx][$GW]) + (1 * $demand[$LAN_Tx][$FS]));
pdq::SetDemand("LAN", $dumSU,
      (1 * $demand[$LAN_Tx][$PC]) + (1 * $demand[$LAN_Tx][$FS])
    + (1 * $demand[$LAN_Tx][$GW]) + (1 * $demand[$LAN_Tx][$FS]));
pdq::SetWUnit("Trans");

pdq::Solve($pdq::CANON);
pdq::Report();
