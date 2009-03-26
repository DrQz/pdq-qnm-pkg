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
#  httpd.c
#  
#  HTTP daemon performance model
#  
#   $Id$
# /

#--------------------------------------------------------------------------
#  Model specific variables *
# **************************

$servers = 2;

$STRESS            =   0;
$HOMEPG            =   1;


@work = (
	"stress",
	"homepg"
);

@time = (
   0.0044,  #  stress
   0.0300   #  homepg
);

@slave = (
	"slave0",
	"slave1",
	"slave2",
	"slave3",
	"slave4",
	"slave5",
	"slave6",
	"slave7",
	"slave8",
	"slave9",
	"slave10",
	"slave11",
	"slave12",
	"slave13",
	"slave14",
	"slave15"
);

#--------------------------------------------------------------------------

$PREFORK = 1;

$w       = $HOMEPG;

if ($PREFORK eq 1) {
   printf("Pre-Fork Model under \"%s\" Load (m = %d)\n",
     $w == $STRESS ? $work[$STRESS] : $work[$HOMEPG], $servers);
} else {
   printf("Forking  Model under \"%s\" Load \n",
     $w == $STRESS ? $work[$STRESS] : $work[$HOMEPG]);
}

printf("\n  N        X         R\n");

#--------------------------------------------------------------------------

for ($pop = 1; $pop <= 10; $pop++) {
	pdq::Init("HTTPd_Server");

	$noStreams = pdq::CreateClosed($work[$w], $pdq::TERM, 1.0 * $pop, 0.0);
	$noNodes = pdq::CreateNode("master", $pdq::CEN, $pdq::FCFS);

	if ($PREFORK eq 1) {
		for ($s = 0; $s < $servers; $s++) {
			$noNodes = pdq::CreateNode($slave[$s], $pdq::CEN, $pdq::FCFS);
		}

		pdq::SetDemand("master", $work[$w], 0.0109);

		for ($s = 0; $s < $servers; $s++) {
			pdq::SetDemand($slave[$s], $work[$w], $time[$w] / $servers);
		}
	} else {  # FORKING
		$noNodes = pdq::CreateNode("forks", $pdq::CEN, ISRV);

		pdq::SetDemand("master", $work[$w], 0.0165);
		pdq::SetDemand("forks", $work[$w], $time[$w]);
	}

	pdq::Solve($pdq::EXACT);

	printf("%5.2f   %8.4f  %8.4f\n",
		$pop,  # getjob_pop(getjob_index($work[$w])),
		pdq::GetThruput($pdq::TERM, $work[$w]),
		pdq::GetResponse($pdq::TERM, $work[$w]));
}

#--------------------------------------------------------------------------

