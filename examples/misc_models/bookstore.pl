#! /usr/bin/perl
#
###############################################################################
#  Copyright (C) 1994 - 2017, Performance Dynamics Company                    #
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

# bookstore.pl
#
#	Created by NJG on Wed, Apr 4, 2007                 --genesis in C
#   Updated by Paul Puglia on Wed Aug 1, 2012          --ported to R
#   Updated by Mohit Chawla on Monday, January 2, 2017 --ported to perl
#
#	PDQ model using 2 MSQ multi-server nodes in tandem.
#   Here, prototype MSQ node is replaced by documented CreateMultiNode function.
#   See http://www.perfdynamics.com/Tools/PDQman.html#tth_sEc3.2
#
#	Book stores allow customers to enter, browse, drink coffee, etc., and finally
#	pay at the checkout area. The checkout facility usually consists of a single
#	waiting line serviced by multiple cashiers. A book store can modelled in two
#   parts or phases: browsing, modeled as an infinite server and payment, modeled
#   as an M/M/m queue. By definition, the infinite server has no waiting line. In
#   practice, the M/M/inf queue a finite but large enough number of servers to
#   ensure no significant waiting line length.
#
#	The PDQ model parameters are taken from Example 4.1 (p.170) in Gross and Harris,
#   "Fundamentals of Queueing Theory," 3rd edn. (1998) for a grocery store with a
#   "lounge". (???)
#
#   Input parameters:
#       Arrival rate = 40 per hr
#       Lounge time  = 3/4 hr
#       Service time = 4 mins
#
#	The capacity planning questions are:
#		Currently, only 3 employees are paid to act as cashiers.
#		If the store mgr pays a 4th cashier, what happens to the:
#		1. waiting time at the checkout? (G&H: 1.14 mins)
#		2. number of people at the checkout? (G&H: 3.44 cust)
#		3. mean number of people in the store (G&H: 30 + 3.44 = 33.44 cust)
#
#	The only only parameter that might be made more realistic for the
#	bookstore example is the browsing time, e.g., increase to 65 mins.

use pdq;
use POSIX;

# Timebase in minutes
$arrivalRate = 40.0 / 60;
$browseTime  = 0.75 * 60;
$buyingTime  = 4.0;
$cashiers    = 4;

pdq::Init("Big Book Store Model");
pdq::CreateOpen("Customers", $arrivalRate);
pdq::CreateMultiNode((ceil($arrivalRate * $browseTime) * 100), "Browsing", $pdq::CEN, $pdq::FCFS);
pdq::CreateMultiNode($cashiers, "Checkout", $pdq::CEN, $pdq::FCFS);

# Set service times
pdq::SetDemand("Browsing", "Customers", $browseTime);
pdq::SetDemand("Checkout", "Customers", $buyingTime);

# Change units in Report
pdq::SetWUnit("Cust");
pdq::SetTUnit("Min");

pdq::Solve($pdq::CANON);
pdq::Report();
