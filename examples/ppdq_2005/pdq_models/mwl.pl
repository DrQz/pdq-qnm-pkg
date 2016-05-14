#!/usr/bin/perl
###############################################################################
#  Copyright (C) 1994 - 2013, Performance Dynamics Company                    #
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
#  $Id$

# mwl.pl
# Updated by NJG on Sun, Feb 19, 2006 - Added missing disk to "Agg UPGRADE" model
# Edited by NJG on Sunday, February 24, 2013

use pdq;

# ****************************************
#  Parameters from workload measurements *
# ****************************************
$maxBatJobs     = 10;
$maxIntJobs     = 25;
$intThink       = 30;
$batThink       = 0.0;
$cpuBatBusy     = 600.0;
$dskBatBusy     = 54.0;
$cpuIntBusy     = 47.6;
$dskIntBusy     = 428.4;
$batchCompletes = 600;
$interCompletes = 476; 
$cpuSpeedup     = 5; # CPU upgrade in relative units

$totCpuBusy = $cpuBatBusy + $cpuIntBusy;
$totDskBusy = $dskBatBusy + $dskIntBusy;
$totalCompletes = $batchCompletes + $interCompletes;
$maxAggJobs = $maxBatJobs + $maxIntJobs;
$aggThink = ($interCompletes / $totalCompletes) * $intThink;
$aggCpuDemand = $totCpuBusy / $totalCompletes;
$aggDskDemand = $totDskBusy / $totalCompletes;


# ************************************************************
#  Create and analyze models based on the aggregate workload *
# ************************************************************
pdq::Init("Aggregate BASELINE");

pdq::CreateNode("cpu", $pdq::CEN, $pdq::FCFS);
pdq::CreateNode("dsk", $pdq::CEN, $pdq::FCFS);
pdq::CreateClosed("aggwork", $pdq::TERM, $maxAggJobs, $aggThink);

pdq::SetDemand("cpu", "aggwork", $aggCpuDemand);
pdq::SetDemand("dsk", "aggwork", $aggDskDemand);

pdq::Solve($pdq::EXACT);
pdq::Report();


pdq::Init("Aggregate UPGRADE");
pdq::CreateClosed("aggwork", $pdq::TERM, $maxAggJobs, $aggThink);

pdq::CreateNode("cpu", $pdq::CEN, $pdq::FCFS);
pdq::CreateNode("dsk", $pdq::CEN, $pdq::FCFS);
pdq::SetDemand("cpu", "aggwork", $aggCpuDemand / $cpuSpeedup);
pdq::SetDemand("dsk", "aggwork", $aggDskDemand); # Added missing disk

pdq::Solve($pdq::EXACT);
pdq::Report();


# ******************************************************
#  Now analyze models based on the component workloads *
# ******************************************************
pdq::Init("Component BASELINE");
pdq::CreateClosed("batch", $pdq::BATCH, $maxBatJobs, $batThink);

pdq::CreateNode("cpu", $pdq::CEN, $pdq::FCFS);
pdq::CreateNode("dsk", $pdq::CEN, $pdq::FCFS);
pdq::SetDemand("cpu", "batch", $cpuBatBusy / $batchCompletes);
pdq::SetDemand("dsk", "batch", $dskBatBusy / $batchCompletes);

pdq::CreateClosed("online", $pdq::TERM, $maxIntJobs, $intThink);
pdq::SetDemand("cpu", "online", $cpuIntBusy / $interCompletes);
pdq::SetDemand("dsk", "online", $dskIntBusy / $interCompletes);

pdq::Solve($pdq::EXACT);
pdq::Report();


pdq::Init("Component UPGRADE");

pdq::CreateNode("cpu", $pdq::CEN, $pdq::FCFS);
pdq::CreateNode("dsk", $pdq::CEN, $pdq::FCFS);

pdq::CreateClosed("batch", $pdq::BATCH, $maxBatJobs, $batThink);
pdq::SetDemand("cpu", "batch", 
    ($cpuBatBusy / $batchCompletes) / $cpuSpeedup);
pdq::SetDemand("dsk", "batch", $dskBatBusy / $batchCompletes);

pdq::CreateClosed("online", $pdq::TERM, $maxIntJobs, $intThink);
pdq::SetDemand("cpu", "online", 
    ($cpuIntBusy / $interCompletes) / $cpuSpeedup);
pdq::SetDemand("dsk", "online", $dskIntBusy / $interCompletes);

pdq::Solve($pdq::EXACT);
pdq::Report();
