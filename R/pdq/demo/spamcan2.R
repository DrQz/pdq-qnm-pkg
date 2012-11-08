###############################################################################
#  Copyright (C) 1994 - 2007, Performance Dynamics Company		      #
#									      #
#  This software is licensed as described in the file COPYING, which	      #
#  you should have received as part of this distribution. The terms	      #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#									      #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is	      #
#  furnished to do so, under the terms of the COPYING file.		      #
#									      #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.					      #
###############################################################################
require(pdq)
#
# Created by NJG on Wed, Apr 18, 2007
# Ported to R by PJP on Thru, Aug 8, 2012
# Queueing model of an email-spam analyzer system comprising a
# battery of SMP servers essentially running in batch mode.
# Each node was a 4-way SMP server.
# The performance metric of interest was the mean queue length.
#
# This simple M/M/4 model gave results that were in surprisingly
# good agreement with monitored queue lengths.
#
# $Id$


# Measured performance parameters
cpusPerServer <- 4
emailThruput  <- 678   # emails per hour
scannerTime   <- 12.0  # seconds per email

Init("Spam Farm Model")
# Timebase is SECONDS ...
nstreams <- CreateOpen("Email", emailThruput/3600)
nnodes	 <- CreateNode("spamCan", cpusPerServer, MSQ)
SetDemand("spamCan", "Email", scannerTime)
Solve(CANON)
Report()
